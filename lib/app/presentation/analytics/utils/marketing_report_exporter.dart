import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:file_saver/file_saver.dart';
import 'package:optima_sync_v2/app/domain/entities/analytics_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/campaign_entity.dart';
import 'package:optima_sync_v2/app/domain/usecases/campaign_usecases.dart';

class MarketingReportExporter {
  final CampaignUsecases campaignUsecases;

  MarketingReportExporter({required this.campaignUsecases});

  static const _headers = [
    'Campaign Name',
    'Status',
    'Spent',
    'Connections',
    'Wins',
    'Win Rate',
    'Expected Content',
    'CPL',
    'ROI',
    'Effective',
  ];

  Future<void> export({
    required MarketingDashboardEntity dashboard,
    required List<EffectiveCampaignEntity> effectiveCampaigns,
  }) async {
    final result = await campaignUsecases.getCampaigns();
    final campaigns = result.fold<List<CampaignEntity>>(
      (_) => throw Exception('Could not load campaigns'),
      (list) => list,
    );

    final perCampaign = {
      for (final p in dashboard.perCampaign) p['id']?.toString(): p,
    };

    final effectiveIds = effectiveCampaigns
        .map((e) => e.id)
        .whereType<String>()
        .toSet();
    final effectiveNames = effectiveCampaigns.map((e) => e.name).toSet();

    final excel = Excel.createExcel();
    const sheetName = 'Marketing Report';
    excel.rename(excel.getDefaultSheet() ?? 'Sheet1', sheetName);
    final sheet = excel[sheetName];

    final headerStyle = CellStyle(
      bold: true,
      backgroundColorHex: ExcelColor.fromHexString('#E8EFFD'),
    );

    sheet.appendRow(_headers.map<CellValue?>((h) => TextCellValue(h)).toList());
    for (var col = 0; col < _headers.length; col++) {
      sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0))
              .cellStyle =
          headerStyle;
      sheet.setColumnWidth(col, col == 0 ? 28 : 16);
    }

    for (final c in campaigns) {
      final spent = c.spent ?? 0.0;
      final connections = c.connections ?? 0;
      final wins = c.wins ?? 0;
      final per = perCampaign[c.id] ?? const <String, dynamic>{};
      final winRate =
          _d(per['win_rate']) ??
          c.winRate ??
          (connections > 0 ? wins / connections * 100 : 0.0);
      final cpl =
          _d(per['cpl']) ??
          c.cpl ??
          (connections > 0 ? spent / connections : 0.0);
      final roi = _d(per['roi']) ?? c.roi;
      final isEffective =
          (c.id != null && effectiveIds.contains(c.id)) ||
          effectiveNames.contains(c.name);

      sheet.appendRow(<CellValue?>[
        TextCellValue(c.name),
        TextCellValue(c.status),
        TextCellValue('\$${spent.toStringAsFixed(2)}'),
        IntCellValue(connections),
        IntCellValue(wins),
        TextCellValue('${_trim(winRate)}%'),
        IntCellValue(c.estimatedContentCount ?? 0),
        TextCellValue('\$${cpl.toStringAsFixed(2)}'),
        TextCellValue(roi == null ? 'N/A' : '${_trim(roi)}%'),
        TextCellValue(isEffective ? 'Yes' : 'No'),
      ]);
    }

    final bytes = excel.encode();
    if (bytes == null) throw Exception('Could not generate the Excel file');

    await FileSaver.instance.saveFile(
      name: 'marketing_analytics_report',
      bytes: Uint8List.fromList(bytes),
      fileExtension: 'xlsx',
      mimeType: MimeType.microsoftExcel,
    );
  }

  static double? _d(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString().replaceAll('%', '').trim());
  }

  static String _trim(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);
}

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:optima_sync_v2/app/domain/entities/marketing/content_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/member_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/content/content_repo.dart';
import 'package:optima_sync_v2/app/domain/usecases/content_usecases.dart';
import 'package:optima_sync_v2/app/presentation/analytics/widgets/kpi_json_view.dart';
import 'package:optima_sync_v2/app/presentation/content/bloc/content_bloc.dart';
import 'package:optima_sync_v2/app/presentation/content/screen/content_kanban_screen.dart';
import 'package:optima_sync_v2/app/presentation/member/pages/member_list_item.dart';
import 'package:optima_sync_v2/app/presentation/city/pages/city_list_item.dart'
    as city;
import 'package:optima_sync_v2/app/presentation/channel/pages/channel_list_item.dart'
    as channel;
import 'package:optima_sync_v2/app/presentation/industry/pages/industry_list_item.dart'
    as industry;
import 'package:optima_sync_v2/core/constants/theme.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';
import 'package:optima_sync_v2/core/widgets/app_mobile_widgets.dart';

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  double width = 320,
  double scale = 1,
  double keyboard = 0,
}) async {
  await tester.binding.setSurfaceSize(Size(width, 720));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.lightModeTheme,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(scale),
          viewInsets: EdgeInsets.only(bottom: keyboard),
        ),
        child: child!,
      ),
      home: Scaffold(body: child),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Form fields stack on phones and stay paired on wide screens', (
    tester,
  ) async {
    const fields = Padding(
      padding: EdgeInsets.all(16),
      child: AppFieldRow(
        children: [
          TextField(
            key: Key('first'),
            decoration: InputDecoration(labelText: 'Start'),
          ),
          TextField(
            key: Key('second'),
            decoration: InputDecoration(labelText: 'End'),
          ),
        ],
      ),
    );
    await _pump(tester, fields);
    expect(
      tester.getTopLeft(find.byKey(const Key('second'))).dy,
      greaterThan(tester.getBottomLeft(find.byKey(const Key('first'))).dy),
    );
    expect(tester.takeException(), isNull);
    await _pump(tester, fields, width: 700);
    expect(
      tester.getTopLeft(find.byKey(const Key('second'))).dy,
      tester.getTopLeft(find.byKey(const Key('first'))).dy,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Large system text stacks fields even on a wider viewport', (
    tester,
  ) async {
    await _pump(
      tester,
      const Padding(
        padding: EdgeInsets.all(16),
        child: AppFieldRow(children: [Text('First'), Text('Second')]),
      ),
      width: 700,
      scale: 2,
    );
    expect(
      tester.getTopLeft(find.text('Second')).dy,
      greaterThan(tester.getTopLeft(find.text('First')).dy),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Metric cards accept long labels and values without fixed-height overflow',
    (tester) async {
      for (final scale in [1.0, 2.0]) {
        await _pump(
          tester,
          const SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: AppMetricGrid(
                children: [
                  AppMetricTile(
                    label: 'A long translated statistics label',
                    value: '1234567890123456',
                    caption: 'Additional information wraps onto several lines',
                    icon: Icons.layers_outlined,
                  ),
                  AppMetricTile(
                    label: 'Completed',
                    value: '100000',
                    icon: Icons.check_circle_outline,
                  ),
                ],
              ),
            ),
          ),
          scale: scale,
        );
        expect(find.text('1234567890123456'), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    },
  );

  testWidgets(
    'Nested analytics preserve values and remain scrollable at large text sizes',
    (tester) async {
      await _pump(
        tester,
        const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: KpiJsonView(
              data: {
                'overall_cost': 1234.567,
                'verified': true,
                'details': {
                  'long_name': 'A long analytics value spanning multiple lines',
                  'missing': null,
                },
              },
            ),
          ),
        ),
        scale: 2,
      );
      expect(find.text('1234.57'), findsOneWidget);
      expect(find.text('Yes'), findsOneWidget);
      await tester.ensureVisible(find.text('—'));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'A mobile form dialog can scroll its final field above the keyboard',
    (tester) async {
      await _pump(
        tester,
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) => AppMobileDialog(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 0; i < 10; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: TextField(
                            key: Key('field-$i'),
                            decoration: InputDecoration(labelText: 'Field $i'),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            child: const Text('Open form'),
          ),
        ),
        keyboard: 280,
      );
      await tester.tap(find.text('Open form'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const Key('field-9')));
      await tester.pumpAndSettle();
      expect(
        tester.getBottomRight(find.byKey(const Key('field-9'))).dy,
        lessThanOrEqualTo(440),
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Mobile member layout retains the original change-role action', (
    tester,
  ) async {
    var edits = 0;
    await _pump(
      tester,
      MemberListItem(
        member: MemberEntity(
          id: 'm-1',
          userId: 'u-1',
          role: 'admin',
          name: 'A very long member name',
          email: 'a-long-email@example.com',
        ),
        onChangeRole: () => edits++,
      ),
      scale: 2,
    );
    await tester.tap(find.byTooltip('Change role'));
    expect(edits, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Mobile status menu calls the existing content update with unchanged identifiers',
    (tester) async {
      final repo = _ContentFixture();
      final bloc = ContentBloc(usecases: ContentUsecases(repo: repo));
      addTearDown(bloc.close);
      await _pump(
        tester,
        BlocProvider.value(
          value: bloc,
          child: const ContentKanbanScreen(
            campaignId: 'campaign-1',
            campaignName: 'Test',
          ),
        ),
      );
      expect(find.text('Draft content'), findsOneWidget);
      expect(find.text('Approved content'), findsNothing);
      await tester.tap(find.text('Change status'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(PopupMenuItem<String>, 'Approved'));
      await tester.pumpAndSettle();
      expect(repo.updatedCampaign, 'campaign-1');
      expect(repo.updatedId, 'content-1');
      expect(repo.updated!.status, 'approved');
      expect(repo.updated!.title, 'Draft content');
      expect(repo.updated!.channelId, 'channel-1');
      final approvedChip = find.widgetWithText(ChoiceChip, 'Approved (2)');
      await tester.ensureVisible(approvedChip);
      await tester.tap(approvedChip);
      await tester.pumpAndSettle();
      expect(find.text('Draft content'), findsOneWidget);
      expect(find.text('Approved content'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  test(
    'Reference color choices retain their serialized values for API submissions',
    () {
      expect(city.cityColorToHex(city.presetCityColors.first), '#2563EB');
      expect(
        channel.channelColorToHex(channel.presetChannelColors.first),
        '#2563EB',
      );
      expect(
        industry.colorToHex(industry.presetIndustryColors.first),
        '#2563EB',
      );
      for (final color in industry.presetIndustryColors) {
        final hex = industry.colorToHex(color);
        expect(industry.colorToHex(industry.hexToColor(hex)), hex);
      }
    },
  );
}

class _ContentFixture implements ContentRepository {
  String? updatedCampaign;
  String? updatedId;
  ContentEntity? updated;
  final items = <ContentEntity>[
    const ContentEntity(
      id: 'content-1',
      campaignId: 'campaign-1',
      channelId: 'channel-1',
      title: 'Draft content',
      type: 'post',
      script: '',
    ),
    const ContentEntity(
      id: 'content-2',
      campaignId: 'campaign-1',
      channelId: 'channel-1',
      title: 'Approved content',
      type: 'post',
      script: '',
      status: 'approved',
    ),
  ];
  @override
  Future<Either<WhateverFailure, List<ContentEntity>>> getCampaignContents(
    String campaignId,
  ) async => Right(items);
  @override
  Future<Either<WhateverFailure, ContentEntity>> updateContent({
    required String campaignId,
    required String id,
    required ContentEntity content,
  }) async {
    updatedCampaign = campaignId;
    updatedId = id;
    updated = content;
    items[items.indexWhere((item) => item.id == id)] = content;
    return Right(content);
  }

  @override
  Future<Either<WhateverFailure, ContentEntity>> getContent({
    required String campaignId,
    required String id,
  }) async => Right(items.firstWhere((item) => item.id == id));
  @override
  Future<Either<WhateverFailure, ContentEntity>> createContent({
    required String campaignId,
    required ContentEntity content,
  }) =>
      throw UnimplementedError('This UI fixture only exercises status updates');
  @override
  Future<Either<WhateverFailure, void>> deleteContent({
    required String campaignId,
    required String id,
  }) =>
      throw UnimplementedError('This UI fixture only exercises status updates');
}

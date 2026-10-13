import 'package:flutter/material.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';

class AppTheme {
  static const inputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: AppPallete.cardBorder),
    borderRadius: BorderRadius.all(Radius.circular(AppPallete.inputRadius)),
  );
  static const focusedInputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: AppPallete.primary, width: 1.5),
    borderRadius: BorderRadius.all(Radius.circular(AppPallete.inputRadius)),
  );
  static final _shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppPallete.buttonRadius),
  );
  static const _border = inputBorder;

  static final lightModeTheme = ThemeData(
    useMaterial3: true,
    visualDensity: VisualDensity.standard,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    scaffoldBackgroundColor: AppPallete.pageBackground,
    colorScheme: ColorScheme.fromSeed(seedColor: AppPallete.primary).copyWith(
      primary: AppPallete.primary,
      onPrimary: Colors.white,
      primaryContainer: AppPallete.primarySoft,
      onPrimaryContainer: AppPallete.primary,
      secondary: AppPallete.primary,
      onSecondary: Colors.white,
      secondaryContainer: AppPallete.primarySoft,
      onSecondaryContainer: AppPallete.primary,
      surface: AppPallete.cardBackground,
      onSurface: AppPallete.textPrimary,
      onSurfaceVariant: AppPallete.textSecondary,
      surfaceContainerHighest: AppPallete.inputFill,
      outline: AppPallete.cardBorder,
      error: AppPallete.danger,
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppPallete.textPrimary),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppPallete.textPrimary),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppPallete.textPrimary),
      bodyLarge: TextStyle(fontSize: 16, height: 1.4, color: AppPallete.textPrimary),
      bodyMedium: TextStyle(fontSize: 14, height: 1.4, color: AppPallete.textPrimary),
      bodySmall: TextStyle(fontSize: 12, height: 1.35, color: AppPallete.textSecondary),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
    ),
    appBarTheme: const AppBarThemeData(
      backgroundColor: AppPallete.cardBackground,
      surfaceTintColor: Colors.transparent,
      foregroundColor: AppPallete.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleSpacing: 16,
      titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppPallete.textPrimary),
    ),
    cardTheme: CardThemeData(
      color: AppPallete.cardBackground,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppPallete.cardRadius),
        side: const BorderSide(color: AppPallete.cardBorder),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppPallete.inputFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      border: _border,
      enabledBorder: _border,
      focusedBorder: _border.copyWith(borderSide: const BorderSide(color: AppPallete.primary, width: 1.5)),
      errorBorder: _border.copyWith(borderSide: const BorderSide(color: AppPallete.danger)),
      focusedErrorBorder: _border.copyWith(borderSide: const BorderSide(color: AppPallete.danger, width: 1.5)),
      hintStyle: const TextStyle(fontSize: 14, color: AppPallete.textSecondary),
      labelStyle: const TextStyle(fontSize: 14, color: AppPallete.textSecondary),
      errorMaxLines: 3,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(
      backgroundColor: AppPallete.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      minimumSize: const Size(48, 48),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      shape: _shape,
    )),
    filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(
      backgroundColor: AppPallete.primary,
      foregroundColor: Colors.white,
      minimumSize: const Size(48, 48),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      shape: _shape,
    )),
    outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(
      foregroundColor: AppPallete.primary,
      minimumSize: const Size(48, 48),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      side: const BorderSide(color: AppPallete.cardBorder),
      shape: _shape,
    )),
    textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(
      foregroundColor: AppPallete.primary,
      minimumSize: const Size(48, 48),
      shape: _shape,
    )),
    iconButtonTheme: IconButtonThemeData(style: IconButton.styleFrom(
      minimumSize: const Size(48, 48),
      foregroundColor: AppPallete.textSecondary,
    )),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppPallete.primary,
      foregroundColor: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppPallete.cardBackground,
      modalBackgroundColor: AppPallete.cardBackground,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppPallete.cardBackground,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppPallete.textPrimary),
      contentTextStyle: const TextStyle(fontSize: 14, height: 1.4, color: AppPallete.textSecondary),
    ),
    drawerTheme: const DrawerThemeData(backgroundColor: AppPallete.cardBackground, surfaceTintColor: Colors.transparent),
    listTileTheme: const ListTileThemeData(
      iconColor: AppPallete.textSecondary,
      textColor: AppPallete.textPrimary,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      minVerticalPadding: 10,
      titleTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppPallete.textPrimary),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: AppPallete.cardBackground,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    dividerTheme: const DividerThemeData(color: AppPallete.cardBorder, thickness: 1),
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppPallete.primary),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}

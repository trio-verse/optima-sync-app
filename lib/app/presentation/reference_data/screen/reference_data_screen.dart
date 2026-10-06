import 'package:flutter/material.dart';
import 'package:optima_sync_v2/app/presentation/channel/screen/channel_screen.dart';
import 'package:optima_sync_v2/app/presentation/city/screen/city_screen.dart';
import 'package:optima_sync_v2/app/presentation/industry/screen/industry_screen.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';

class ReferenceDataScreen extends StatefulWidget {
  final int initialIndex;

  const ReferenceDataScreen({super.key, this.initialIndex = 0})
    : assert(initialIndex >= 0 && initialIndex < 3);

  @override
  State<ReferenceDataScreen> createState() => _ReferenceDataScreenState();
}

class _ReferenceDataScreenState extends State<ReferenceDataScreen> {
  late int _currentIndex = widget.initialIndex;

  Widget _buildTab(int index) {
    switch (index) {
      case 0:
        return const CityScreen(
          key: ValueKey('reference_cities'),
          embedded: true,
        );
      case 1:
        return const IndustryScreen(
          key: ValueKey('reference_industries'),
          embedded: true,
        );
      default:
        return const ChannelScreen(
          key: ValueKey('reference_channels'),
          embedded: true,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.pageBackground,
      appBar: AppBar(
        backgroundColor: AppPallete.pageBackground,
        surfaceTintColor: AppPallete.pageBackground,
        elevation: 0,
        foregroundColor: AppPallete.textPrimary,
        title: const Text('Reference Data'),
      ),
      body: _buildTab(_currentIndex),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppPallete.cardBackground,
          border: Border(top: BorderSide(color: AppPallete.cardBorder)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index == _currentIndex) return;
            setState(() => _currentIndex = index);
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppPallete.cardBackground,
          elevation: 0,
          selectedItemColor: AppPallete.salesPrimary,
          unselectedItemColor: AppPallete.textSecondary,
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on_outlined),
              activeIcon: Icon(Icons.location_on),
              label: 'Cities',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.apartment_outlined),
              activeIcon: Icon(Icons.apartment_rounded),
              label: 'Industries',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.wifi_tethering),
              activeIcon: Icon(Icons.wifi_tethering),
              label: 'Channels',
            ),
          ],
        ),
      ),
    );
  }
}

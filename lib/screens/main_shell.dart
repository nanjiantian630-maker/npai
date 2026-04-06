import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/icons.dart';
import '../widgets/sidebar.dart';
import 'dashboard_screen.dart';
import 'workbench_screen.dart';
import 'merchant_screen.dart';
import 'drama_screen.dart';
import 'templates_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  bool _sidebarOpen = false;

  final List<Widget> _screens = const [
    DashboardScreen(),
    WorkbenchScreen(),
    MerchantScreen(),
    DramaScreen(),
    TemplatesScreen(),
    _PlaceholderScreen(icon: NiubiIcons.assets,   title: '素材库',   desc: '海量素材即将上线'),
    _PlaceholderScreen(icon: NiubiIcons.settings,  title: '设置',    desc: '账户设置功能即将开放'),
    _LogoutPlaceholder(),
  ];

  void _navigate(int index) {
    setState(() {
      _currentIndex = index;
      _sidebarOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    return isMobile ? _buildMobileLayout() : _buildDesktopLayout();
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      backgroundColor: NiubiColors.bgPage,
      body: Row(
        children: [
          NiubiSidebar(currentIndex: _currentIndex, onNavigate: _navigate),
          Expanded(child: _screens[_currentIndex.clamp(0, _screens.length - 1)]),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      backgroundColor: NiubiColors.bgPage,
      appBar: AppBar(
        backgroundColor: NiubiColors.bgDeepest,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [NiubiColors.primaryDark, NiubiColors.accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(7),
              ),
              child: const Icon(NiubiIcons.logo, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [NiubiColors.primary, NiubiColors.accent],
              ).createShader(bounds),
              child: const Text(
                '牛批AI',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: NiubiColors.textPrimary),
          onPressed: () => setState(() => _sidebarOpen = !_sidebarOpen),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: NiubiColors.borderLight),
        ),
      ),
      drawer: Drawer(
        backgroundColor: NiubiColors.bgDeepest,
        child: NiubiSidebar(
          currentIndex: _currentIndex,
          onNavigate: (index) {
            Navigator.pop(context);
            _navigate(index);
          },
        ),
      ),
      body: _screens[_currentIndex.clamp(0, _screens.length - 1)],
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    const items = [
      {'icon': NiubiIcons.dashboard,  'label': '控制台'},
      {'icon': NiubiIcons.workbench,  'label': '工作台'},
      {'icon': NiubiIcons.merchant,   'label': '商家'},
      {'icon': NiubiIcons.drama,      'label': '短剧'},
      {'icon': NiubiIcons.templates,  'label': '模板'},
    ];

    return Container(
      decoration: const BoxDecoration(
        color: NiubiColors.bgDeepest,
        border: Border(top: BorderSide(color: NiubiColors.borderLight)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final isActive = _currentIndex == i;
              final iconData = items[i]['icon'] as IconData;
              return GestureDetector(
                onTap: () => _navigate(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isActive
                        ? NiubiColors.primary.withValues(alpha: 0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        iconData,
                        size: 22,
                        color: isActive ? NiubiColors.primary : NiubiColors.textMuted,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        items[i]['label'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          color: isActive ? NiubiColors.primaryLight : NiubiColors.textMuted,
                          fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ── Placeholder screen ───────────────────────────────────────────────────────
class _PlaceholderScreen extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;

  const _PlaceholderScreen({
    required this.icon,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NiubiColors.bgPage,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: NiubiColors.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: NiubiColors.primary.withValues(alpha: 0.25)),
              ),
              child: Icon(icon, size: 40, color: NiubiColors.primary),
            ),
            const SizedBox(height: 20),
            Text(title,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: NiubiColors.textPrimary)),
            const SizedBox(height: 8),
            Text(desc,
                style: const TextStyle(
                    fontSize: 14, color: NiubiColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

// ── Logout placeholder ───────────────────────────────────────────────────────
class _LogoutPlaceholder extends StatelessWidget {
  const _LogoutPlaceholder();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed('/login');
    });
    return const SizedBox.shrink();
  }
}

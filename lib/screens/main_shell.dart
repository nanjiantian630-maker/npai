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
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // AppBar Logo — 使用横版 logo_horizontal.png
            SizedBox(
              height: 32,
              child: Image.asset(
                'assets/images/logo_horizontal.png',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(
                  color: NiubiColors.borderColor.withValues(alpha: 0.5)),
            ),
            child: const Icon(Icons.menu_rounded,
                color: NiubiColors.textSecondary, size: 18),
          ),
          onPressed: () => setState(() => _sidebarOpen = !_sidebarOpen),
        ),
        actions: [
          // 通知按钮
          Container(
            margin: const EdgeInsets.only(right: 4),
            child: IconButton(
              icon: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                      color: NiubiColors.borderColor.withValues(alpha: 0.5)),
                ),
                child: const Icon(Icons.notifications_none_rounded,
                    color: NiubiColors.textSecondary, size: 17),
              ),
              onPressed: () {},
            ),
          ),
          // 头像
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6D28D9), Color(0xFFA855F7)],
                ),
                borderRadius: BorderRadius.circular(9),
              ),
              child:
                  const Icon(Icons.person_rounded, color: Colors.white, size: 16),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
              height: 1,
              color: NiubiColors.borderLight.withValues(alpha: 0.5)),
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
      {'icon': NiubiIcons.dashboard, 'label': '控制台'},
      {'icon': NiubiIcons.workbench, 'label': '工作台'},
      {'icon': NiubiIcons.merchant,  'label': '商家'},
      {'icon': NiubiIcons.drama,     'label': '短剧'},
      {'icon': NiubiIcons.templates, 'label': '模板'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: NiubiColors.bgDeepest,
        border: Border(
          top: BorderSide(
              color: NiubiColors.borderLight.withValues(alpha: 0.5)),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final isActive = _currentIndex == i;
              final iconData = items[i]['icon'] as IconData;
              return GestureDetector(
                onTap: () => _navigate(i),
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: 60,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: isActive ? 40 : 36,
                        height: isActive ? 32 : 28,
                        decoration: BoxDecoration(
                          color: isActive
                              ? NiubiColors.primary.withValues(alpha: 0.14)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(isActive ? 12 : 8),
                        ),
                        child: Icon(
                          iconData,
                          size: isActive ? 22 : 20,
                          color: isActive
                              ? NiubiColors.primary
                              : NiubiColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 3),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          fontSize: 10,
                          color: isActive
                              ? NiubiColors.primaryLight
                              : NiubiColors.textMuted,
                          fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                        ),
                        child: Text(items[i]['label'] as String),
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

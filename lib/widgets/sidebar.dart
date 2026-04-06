import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/icons.dart';

class NiubiSidebar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onNavigate;

  const NiubiSidebar({
    super.key,
    required this.currentIndex,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: NiubiColors.bgDeepest,
        border: Border(right: BorderSide(color: NiubiColors.borderLight)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [NiubiColors.primaryDark, NiubiColors.accent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: NiubiColors.primary.withValues(alpha: 0.4),
                        blurRadius: 12,
                      )
                    ],
                  ),
                  child: const Icon(NiubiIcons.logo, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [NiubiColors.primary, NiubiColors.accent],
                      ).createShader(bounds),
                      child: const Text(
                        '牛批AI',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Text(
                      'AI视频智能体平台',
                      style: TextStyle(fontSize: 10, color: NiubiColors.textMuted),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: NiubiColors.borderLight),
          // Navigation
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('工作台'),
                  _navItem(0, NiubiIcons.dashboard, '控制台'),
                  _navItem(1, NiubiIcons.workbench, '视频工作台'),
                  const SizedBox(height: 6),
                  _sectionTitle('业务模块'),
                  _navItem(2, NiubiIcons.merchant, '商家服务'),
                  _navItem(3, NiubiIcons.drama, '短剧制作'),
                  const SizedBox(height: 6),
                  _sectionTitle('资源'),
                  _navItem(4, NiubiIcons.templates, '模板市场'),
                  _navItem(5, NiubiIcons.assets, '素材库'),
                ],
              ),
            ),
          ),
          // Footer
          const Divider(height: 1, color: NiubiColors.borderLight),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                _navItem(6, NiubiIcons.settings, '设置'),
                _navItem(7, NiubiIcons.logout, '退出登录'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 6, 10, 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: NiubiColors.textMuted,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => onNavigate(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: isActive ? NiubiColors.primary.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border(
            left: BorderSide(
              color: isActive ? NiubiColors.primary : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? NiubiColors.primaryLight : NiubiColors.textSecondary,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                color: isActive ? NiubiColors.primaryLight : NiubiColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

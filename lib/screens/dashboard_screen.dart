import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/icons.dart';
import '../widgets/common_widgets.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  final _stats = const [
    {'icon': NiubiIcons.totalProjects, 'value': '12',  'label': '项目总数', 'color': NiubiColors.primary},
    {'icon': NiubiIcons.totalVideos,   'value': '48',  'label': '生成视频', 'color': NiubiColors.secondary},
    {'icon': NiubiIcons.credits,       'value': '320', 'label': '剩余额度', 'color': NiubiColors.accent},
    {'icon': NiubiIcons.creditsUsed,   'value': '180', 'label': '已用额度', 'color': NiubiColors.gold},
  ];

  final _quickActions = const [
    {'icon': NiubiIcons.text,     'title': '文字生成视频', 'desc': '输入描述，一键生成',   'color': NiubiColors.primary,   'page': 1},
    {'icon': NiubiIcons.image,    'title': '图片生成视频', 'desc': '上传图片让画面动起来', 'color': NiubiColors.secondary, 'page': 1},
    {'icon': NiubiIcons.merchant, 'title': '商品营销视频', 'desc': '快速制作电商视频',    'color': NiubiColors.accent,    'page': 2},
    {'icon': NiubiIcons.drama,    'title': '短剧创作',    'desc': 'AI导演你的故事',       'color': NiubiColors.gold,      'page': 3},
  ];

  final _recentTasks = const [
    {'icon': NiubiIcons.text,  'typeLabel': '文生视频', 'prompt': '赛博朋克城市夜景，霓虹灯闪烁，飞行汽车穿梭...', 'status': 'completed',  'time': '5分钟前'},
    {'icon': NiubiIcons.image, 'typeLabel': '图生视频', 'prompt': '产品360度展示视频，白色背景，专业摄影效果...', 'status': 'processing', 'time': '12分钟前'},
    {'icon': NiubiIcons.frame, 'typeLabel': '首尾帧',   'prompt': '花朵从花苞到盛开的延时动画，暖色调...', 'status': 'completed', 'time': '1小时前'},
  ];

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    return Scaffold(
      backgroundColor: NiubiColors.bgPage,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Column(
          children: [
            if (!isMobile) _buildDesktopHeader(),
            Expanded(
              child: isMobile ? _buildMobileBody() : _buildDesktopBody(),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════
  // DESKTOP LAYOUT
  // ══════════════════════════════════════════════

  Widget _buildDesktopHeader() {
    return NiubiPageHeader(
      icon: NiubiIcons.dashboard,
      title: '控制台',
      actions: [
        NiubiBadge(
          label: 'PRO',
          icon: NiubiIcons.plan,
          bgColor: NiubiColors.primaryGlow,
          textColor: NiubiColors.primaryLight,
        ),
        const SizedBox(width: 12),
        const Text('你好，创作者',
            style: TextStyle(fontSize: 13, color: NiubiColors.textSecondary)),
        const SizedBox(width: 10),
        Container(
          width: 34, height: 34,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [NiubiColors.primaryDark, NiubiColors.primary]),
            borderRadius: BorderRadius.circular(17),
          ),
          child: const Icon(NiubiIcons.user, color: Colors.white, size: 18),
        ),
      ],
    );
  }

  Widget _buildDesktopBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildStatsGrid(isMobile: false),
        const SizedBox(height: 28),
        _buildSectionLabel(NiubiIcons.generate, '快捷开始', NiubiColors.accent),
        const SizedBox(height: 14),
        _buildQuickActionsDesktop(),
        const SizedBox(height: 28),
        _buildRecentTasksCard(isMobile: false),
        const SizedBox(height: 20),
      ]),
    );
  }

  // ══════════════════════════════════════════════
  // MOBILE LAYOUT
  // ══════════════════════════════════════════════

  Widget _buildMobileBody() {
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // ① 顶部欢迎 Banner
        _buildMobileWelcomeBanner(),
        // ② 数据概览标题
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
          child: _buildSectionLabel(NiubiIcons.totalVideos, '数据概览', NiubiColors.primary),
        ),
        // ③ 数据统计紧凑Grid
        _buildMobileStatsRow(),
        const SizedBox(height: 20),
        // ④ 快捷功能标题
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildSectionLabel(NiubiIcons.generate, '快捷开始', NiubiColors.accent),
        ),
        const SizedBox(height: 12),
        _buildMobileQuickActions(),
        const SizedBox(height: 20),
        // ④ 最近任务列表
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildSectionLabel(NiubiIcons.history, '最近生成', NiubiColors.secondary),
        ),
        const SizedBox(height: 12),
        _buildMobileRecentTasks(),
        const SizedBox(height: 24),
      ]),
    );
  }

  // ── Mobile: Welcome Banner ──────────────────────────────
  Widget _buildMobileWelcomeBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A0A30), Color(0xFF0A1525)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: NiubiColors.primary.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: NiubiColors.primary.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // 用户头像
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [NiubiColors.primaryDark, NiubiColors.primary],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: NiubiColors.primary.withValues(alpha: 0.4),
                  blurRadius: 12,
                ),
              ],
            ),
            child: const Icon(NiubiIcons.user, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('你好，创作者',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800,
                            color: NiubiColors.textPrimary)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: NiubiColors.primaryGlow,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('PRO',
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w800,
                              color: NiubiColors.primaryLight)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text('今天创作了什么精彩内容？',
                    style: TextStyle(fontSize: 12, color: NiubiColors.textMuted)),
              ],
            ),
          ),
          // 通知按钮
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: NiubiColors.bgCard,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: NiubiColors.borderColor),
            ),
            child: const Icon(NiubiIcons.notification,
                color: NiubiColors.textSecondary, size: 18),
          ),
        ],
      ),
    );
  }

  // ── Mobile: Stats 紧凑2列Grid ──────────────────────────
  Widget _buildMobileStatsRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2.5,
        ),
        itemCount: _stats.length,
        itemBuilder: (_, i) {
          final s = _stats[i];
          final color = s['color'] as Color;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: NiubiColors.bgCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withValues(alpha: 0.22)),
            ),
            child: Row(
              children: [
                // 图标
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(s['icon'] as IconData, color: color, size: 18),
                ),
                const SizedBox(width: 10),
                // 数值 + 标签
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        s['value'] as String,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: color,
                          height: 1.1,
                        ),
                      ),
                      Text(
                        s['label'] as String,
                        style: const TextStyle(
                          fontSize: 11,
                          color: NiubiColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Mobile: Quick Actions 2x2 Grid ─────────────────────
  Widget _buildMobileQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.55,
        ),
        itemCount: _quickActions.length,
        itemBuilder: (_, i) {
          final a = _quickActions[i];
          final c = a['color'] as Color;
          return GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: NiubiColors.bgCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: c.withValues(alpha: 0.22)),
                boxShadow: [
                  BoxShadow(
                    color: c.withValues(alpha: 0.08),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(
                      color: c.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(a['icon'] as IconData, color: c, size: 20),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(a['title'] as String,
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w700,
                              color: NiubiColors.textPrimary)),
                      const SizedBox(height: 2),
                      Text(a['desc'] as String,
                          style: const TextStyle(
                              fontSize: 10, color: NiubiColors.textMuted),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Mobile: Recent Tasks ────────────────────────────────
  Widget _buildMobileRecentTasks() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: _recentTasks.map((t) {
          final statusInfo = _statusInfo(t['status'] as String);
          final statusColor = statusInfo['color'] as Color;
          final statusIcon = statusInfo['icon'] as IconData;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: NiubiColors.bgCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: NiubiColors.borderColor),
            ),
            child: Row(
              children: [
                // 缩略图
                Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    color: NiubiColors.bgHover,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: NiubiColors.borderLight),
                  ),
                  child: Icon(t['icon'] as IconData,
                      color: NiubiColors.textMuted, size: 24),
                ),
                const SizedBox(width: 12),
                // 内容
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(t['typeLabel'] as String,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w700,
                                  color: NiubiColors.textPrimary)),
                          const Spacer(),
                          Text(t['time'] as String,
                              style: const TextStyle(
                                  fontSize: 10, color: NiubiColors.textMuted)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(t['prompt'] as String,
                          style: const TextStyle(
                              fontSize: 11, color: NiubiColors.textMuted,
                              height: 1.3),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 6),
                      // 状态标签
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(statusIcon, size: 10, color: statusColor),
                                const SizedBox(width: 3),
                                Text(statusInfo['label'] as String,
                                    style: TextStyle(
                                        fontSize: 10, fontWeight: FontWeight.w700,
                                        color: statusColor)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ══════════════════════════════════════════════
  // SHARED / DESKTOP helpers
  // ══════════════════════════════════════════════

  Widget _buildSectionLabel(IconData icon, String label, Color color) {
    return Row(children: [
      Icon(icon, color: color, size: 16),
      const SizedBox(width: 7),
      Text(label,
          style: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w700,
              color: NiubiColors.textSecondary)),
    ]);
  }

  Widget _buildStatsGrid({required bool isMobile}) {
    return LayoutBuilder(builder: (ctx, constraints) {
      final cols = constraints.maxWidth > 700 ? 4 : 2;
      return GridView.builder(
        shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cols, crossAxisSpacing: 14,
          mainAxisSpacing: 14, childAspectRatio: 1.35,
        ),
        itemCount: _stats.length,
        itemBuilder: (_, i) {
          final s = _stats[i];
          return NiubiStatCard(
            icon: s['icon'] as IconData,
            value: s['value'] as String,
            label: s['label'] as String,
            color: s['color'] as Color,
          );
        },
      );
    });
  }

  Widget _buildQuickActionsDesktop() {
    return LayoutBuilder(builder: (ctx, constraints) {
      return GridView.builder(
        shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 14, mainAxisSpacing: 14,
          childAspectRatio: 1.4,
        ),
        itemCount: _quickActions.length,
        itemBuilder: (_, i) {
          final a = _quickActions[i];
          final c = a['color'] as Color;
          return NiubiGlowCard(
            glowColor: c,
            padding: const EdgeInsets.all(18),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: c.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: c.withValues(alpha: 0.25)),
                ),
                child: Icon(a['icon'] as IconData, color: c, size: 22),
              ),
              const SizedBox(height: 12),
              Text(a['title'] as String, style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w700,
                  color: NiubiColors.textPrimary)),
              const SizedBox(height: 4),
              Text(a['desc'] as String, style: const TextStyle(
                  fontSize: 11, color: NiubiColors.textMuted),
                  textAlign: TextAlign.center),
            ]),
          );
        },
      );
    });
  }

  Widget _buildRecentTasksCard({required bool isMobile}) {
    return NiubiGlowCard(
      hoverable: false,
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        NiubiSectionHeader(
          icon: NiubiIcons.history,
          title: '最近生成',
          subtitle: '近期视频生成任务',
          iconColor: NiubiColors.secondary,
        ),
        const SizedBox(height: 16),
        ..._recentTasks.map(_buildDesktopTaskRow),
      ]),
    );
  }

  Widget _buildDesktopTaskRow(Map<String, Object> t) {
    final statusInfo = _statusInfo(t['status'] as String);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: NiubiColors.borderLight))),
      child: Row(children: [
        Container(
          width: 80, height: 48,
          decoration: BoxDecoration(
            color: NiubiColors.bgHover,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: NiubiColors.borderLight),
          ),
          child: Icon(t['icon'] as IconData, color: NiubiColors.textMuted, size: 26),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(t['typeLabel'] as String, style: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w600,
              color: NiubiColors.textPrimary)),
          const SizedBox(height: 3),
          Text(t['prompt'] as String, style: const TextStyle(
              fontSize: 11, color: NiubiColors.textMuted),
              maxLines: 1, overflow: TextOverflow.ellipsis),
        ])),
        const SizedBox(width: 10),
        NiubiBadge(
          label: statusInfo['label'] as String,
          icon: statusInfo['icon'] as IconData,
          bgColor: (statusInfo['color'] as Color).withValues(alpha: 0.15),
          textColor: statusInfo['color'] as Color,
        ),
        const SizedBox(width: 10),
        Text(t['time'] as String,
            style: const TextStyle(fontSize: 10, color: NiubiColors.textMuted)),
      ]),
    );
  }

  Map<String, Object> _statusInfo(String status) {
    switch (status) {
      case 'completed':  return {'label': '已完成', 'color': NiubiColors.success,  'icon': NiubiIcons.completed};
      case 'processing': return {'label': '生成中', 'color': NiubiColors.primary,  'icon': NiubiIcons.processing};
      default:           return {'label': '等待中', 'color': NiubiColors.accent,   'icon': NiubiIcons.pending};
    }
  }
}

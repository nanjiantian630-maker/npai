import 'package:flutter/material.dart';
import '../theme/colors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _animCtrl;
  late AnimationController _pulseCtrl;
  late Animation<double> _fadeAnim;
  late Animation<double> _slideAnim;
  late Animation<double> _pulseAnim;
  final _searchCtrl = TextEditingController();
  bool _searchFocused = false;

  // 功能入口 — 精简为6个核心功能，高质感
  final _features = const [
    {
      'icon': Icons.auto_fix_high_rounded,
      'label': '智能创作',
      'sub': 'AI 驱动',
      'page': 1,
      'gradient': [Color(0xFF7C3AED), Color(0xFFA855F7)],
    },
    {
      'icon': Icons.movie_creation_rounded,
      'label': '短剧制作',
      'sub': '一键导演',
      'page': 3,
      'gradient': [Color(0xFF0E7490), Color(0xFF22D3EE)],
    },
    {
      'icon': Icons.storefront_rounded,
      'label': '商品视频',
      'sub': '电商利器',
      'page': 2,
      'gradient': [Color(0xFFC2410C), Color(0xFFF97316)],
    },
    {
      'icon': Icons.image_rounded,
      'label': '图生视频',
      'sub': '秒级生成',
      'page': 1,
      'gradient': [Color(0xFF047857), Color(0xFF10B981)],
    },
    {
      'icon': Icons.auto_awesome_mosaic_rounded,
      'label': '模板市场',
      'sub': '即开即用',
      'page': 4,
      'gradient': [Color(0xFF92400E), Color(0xFFFBBF24)],
    },
    {
      'icon': Icons.filter_frames_rounded,
      'label': '首尾帧',
      'sub': '精准控制',
      'page': 1,
      'gradient': [Color(0xFF6D28D9), Color(0xFFC084FC)],
    },
  ];

  // 最近任务
  final _recentTasks = const [
    {
      'typeLabel': '文生视频',
      'prompt': '赛博朋克城市夜景，霓虹灯闪烁，飞行汽车穿梭',
      'status': 'completed',
      'time': '5分钟前',
      'duration': '15s',
    },
    {
      'typeLabel': '图生视频',
      'prompt': '产品360度展示，白色背景，专业摄影风格',
      'status': 'processing',
      'time': '12分钟前',
      'duration': '8s',
    },
    {
      'typeLabel': '短剧脚本',
      'prompt': '花朵从花苞到盛开的延时动画，暖色调',
      'status': 'completed',
      'time': '1小时前',
      'duration': '30s',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000))
      ..repeat(reverse: true);

    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<double>(begin: 30, end: 0).animate(
        CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic));
    _pulseAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
        CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _pulseCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    return Scaffold(
      backgroundColor: NiubiColors.bgPage,
      body: AnimatedBuilder(
        animation: _animCtrl,
        builder: (ctx, child) => Opacity(
          opacity: _fadeAnim.value,
          child: Transform.translate(
            offset: Offset(0, _slideAnim.value),
            child: child,
          ),
        ),
        child: isMobile ? _buildMobile() : _buildDesktop(),
      ),
    );
  }

  // ══════════════════════════════════════════════
  // DESKTOP
  // ══════════════════════════════════════════════
  Widget _buildDesktop() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildDesktopHero(),
              const SizedBox(height: 36),
              _buildSearchBox(),
              const SizedBox(height: 48),
              _buildFeatureGrid(isMobile: false),
              const SizedBox(height: 48),
              _buildRecentSection(isMobile: false),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopHero() {
    return Column(
      children: [
        // 顶部装饰标签
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: NiubiColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: NiubiColors.primary.withValues(alpha: 0.20)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _pulseAnim,
                builder: (_, __) => Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: NiubiColors.success
                        .withValues(alpha: _pulseAnim.value),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: NiubiColors.success
                            .withValues(alpha: _pulseAnim.value * 0.5),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 7),
              const Text('AI 模型已就绪',
                  style: TextStyle(
                      fontSize: 12,
                      color: NiubiColors.textSecondary,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // 主标题
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              Color(0xFFE0E0FF),
              NiubiColors.primary,
              NiubiColors.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: const Text(
            '你的 AI 创作空间',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
              height: 1.1,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          '输入创意想法，AI 为你生成专业级视频内容',
          style: TextStyle(
              fontSize: 16,
              color: NiubiColors.textMuted,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.2),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════
  // MOBILE
  // ══════════════════════════════════════════════
  Widget _buildMobile() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // 顶部状态栏占位
          const SizedBox(height: 8),
          // ① Hero 区域
          _buildMobileHero(),
          const SizedBox(height: 20),
          // ② 搜索框
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildSearchBox(),
          ),
          const SizedBox(height: 24),
          // ③ 数据指标行
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildMobileStats(),
          ),
          const SizedBox(height: 28),
          // ④ 功能入口
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildFeatureGrid(isMobile: true),
          ),
          const SizedBox(height: 28),
          // ⑤ 最近任务
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildRecentSection(isMobile: true),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildMobileHero() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF130A22), Color(0xFF0A0F1E), Color(0xFF0D0A1A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: NiubiColors.primary.withValues(alpha: 0.15), width: 1),
      ),
      child: Stack(
        children: [
          // 背景装饰光晕
          Positioned(
            right: -20,
            top: -20,
            child: AnimatedBuilder(
              animation: _pulseAnim,
              builder: (_, __) => Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      NiubiColors.primary
                          .withValues(alpha: _pulseAnim.value * 0.12),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // 头像
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6D28D9), Color(0xFFA855F7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: NiubiColors.primary.withValues(alpha: 0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.person_rounded,
                        color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          const Text('你好，创作者',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: NiubiColors.textPrimary,
                                  letterSpacing: 0.1)),
                          const SizedBox(width: 8),
                          _buildProBadge(),
                        ]),
                        const SizedBox(height: 3),
                        const Text('今天想创作什么？',
                            style: TextStyle(
                                fontSize: 12,
                                color: NiubiColors.textMuted)),
                      ],
                    ),
                  ),
                  // 通知按钮
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08)),
                    ),
                    child: const Icon(Icons.notifications_none_rounded,
                        color: NiubiColors.textSecondary, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              // 副标题文案
              const Text(
                '每一个创意，都值得被精彩呈现',
                style: TextStyle(
                    fontSize: 13,
                    color: NiubiColors.textMuted,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.3),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFFA855F7)],
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Text(
        'PRO',
        style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 1),
      ),
    );
  }

  // ── 移动端数据指标 ────────────────────────────────────────
  Widget _buildMobileStats() {
    final stats = [
      {'value': '12', 'label': '项目', 'icon': Icons.folder_rounded, 'color': NiubiColors.primary},
      {'value': '48', 'label': '视频', 'icon': Icons.play_circle_rounded, 'color': NiubiColors.secondary},
      {'value': '320', 'label': '额度', 'icon': Icons.bolt_rounded, 'color': NiubiColors.accent},
    ];

    return Row(
      children: stats.asMap().entries.map((entry) {
        final i = entry.key;
        final s = entry.value;
        final color = s['color'] as Color;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < stats.length - 1 ? 10 : 0),
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: NiubiColors.bgCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: color.withValues(alpha: 0.15), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(s['icon'] as IconData,
                    color: color, size: 16),
                const SizedBox(height: 8),
                Text(
                  s['value'] as String,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: color,
                      height: 1),
                ),
                const SizedBox(height: 3),
                Text(
                  s['label'] as String,
                  style: const TextStyle(
                      fontSize: 11,
                      color: NiubiColors.textMuted),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ══════════════════════════════════════════════
  // 搜索框 — 高级感设计
  // ══════════════════════════════════════════════
  Widget _buildSearchBox() {
    return Focus(
      onFocusChange: (v) => setState(() => _searchFocused = v),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: NiubiColors.bgCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _searchFocused
                ? NiubiColors.primary.withValues(alpha: 0.5)
                : NiubiColors.borderColor.withValues(alpha: 0.6),
            width: _searchFocused ? 1.5 : 1,
          ),
          boxShadow: _searchFocused
              ? [
                  BoxShadow(
                    color: NiubiColors.primary.withValues(alpha: 0.08),
                    blurRadius: 32,
                    spreadRadius: 2,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Padding(
          padding:
              const EdgeInsets.fromLTRB(20, 6, 14, 12),
          child: Column(
            children: [
              TextField(
                controller: _searchCtrl,
                style: const TextStyle(
                    color: NiubiColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    height: 1.5),
                maxLines: 3,
                minLines: 2,
                decoration: InputDecoration(
                  hintText: '描述你想要生成的视频内容，AI 帮你实现...',
                  hintStyle: TextStyle(
                      color: NiubiColors.textMuted.withValues(alpha: 0.7),
                      fontSize: 14),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
              // 底部工具栏
              Row(
                children: [
                  // 上传图标
                  _buildSearchAction(
                      Icons.attach_file_rounded, '附件'),
                  const SizedBox(width: 8),
                  _buildSearchAction(
                      Icons.image_outlined, '图片'),
                  const Spacer(),
                  // 字数提示
                  Text(
                    '${_searchCtrl.text.length}/500',
                    style: const TextStyle(
                        fontSize: 11, color: NiubiColors.textMuted),
                  ),
                  const SizedBox(width: 12),
                  // 生成按钮
                  GestureDetector(
                    onTap: () {},
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF6D28D9),
                            Color(0xFFA855F7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color:
                                NiubiColors.primary.withValues(alpha: 0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.auto_awesome_rounded,
                              color: Colors.white, size: 14),
                          SizedBox(width: 6),
                          Text(
                            '生成',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAction(IconData icon, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: NiubiColors.borderColor.withValues(alpha: 0.5)),
          ),
          child: Icon(icon, color: NiubiColors.textMuted, size: 15),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════
  // 功能入口 — 高级卡片设计
  // ══════════════════════════════════════════════
  Widget _buildFeatureGrid({required bool isMobile}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题
        if (!isMobile) ...[
          const Text(
            '快捷入口',
            style: TextStyle(
                fontSize: 13,
                color: NiubiColors.textMuted,
                fontWeight: FontWeight.w500,
                letterSpacing: 1),
          ),
          const SizedBox(height: 16),
        ],
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isMobile ? 3 : 6,
            crossAxisSpacing: isMobile ? 12 : 16,
            mainAxisSpacing: isMobile ? 12 : 16,
            childAspectRatio: isMobile ? 0.85 : 0.88,
          ),
          itemCount: _features.length,
          itemBuilder: (_, i) =>
              _buildFeatureItem(_features[i], isMobile: isMobile),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(Map<String, dynamic> f,
      {required bool isMobile}) {
    final gradientColors = (f['gradient'] as List).cast<Color>();
    return GestureDetector(
      onTap: () {},
      child: _FeatureItemCard(
        icon: f['icon'] as IconData,
        label: f['label'] as String,
        sub: f['sub'] as String,
        gradientColors: gradientColors,
        isMobile: isMobile,
      ),
    );
  }

  // ══════════════════════════════════════════════
  // 最近任务
  // ══════════════════════════════════════════════
  Widget _buildRecentSection({required bool isMobile}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题行
        Row(
          children: [
            Container(
              width: 3,
              height: 16,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [NiubiColors.primary, NiubiColors.secondary],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              '最近创作',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: NiubiColors.textPrimary),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {},
              child: Row(children: [
                Text(
                  '全部',
                  style: TextStyle(
                      fontSize: 12,
                      color:
                          NiubiColors.primary.withValues(alpha: 0.75)),
                ),
                Icon(Icons.chevron_right_rounded,
                    size: 16,
                    color: NiubiColors.primary.withValues(alpha: 0.75)),
              ]),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ..._recentTasks.map((t) => _buildTaskCard(t, isMobile: isMobile)),
      ],
    );
  }

  Widget _buildTaskCard(Map<String, Object> t, {required bool isMobile}) {
    final status = t['status'] as String;
    final statusColor = _statusColor(status);
    final statusLabel = _statusLabel(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(isMobile ? 14 : 16),
      decoration: BoxDecoration(
        color: NiubiColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: NiubiColors.borderLight.withValues(alpha: 0.8)),
      ),
      child: Row(
        children: [
          // 左侧类型标识
          Container(
            width: isMobile ? 44 : 48,
            height: isMobile ? 44 : 48,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: statusColor.withValues(alpha: 0.15)),
            ),
            child: Icon(
              status == 'completed'
                  ? Icons.check_rounded
                  : Icons.autorenew_rounded,
              color: statusColor,
              size: isMobile ? 20 : 22,
            ),
          ),
          SizedBox(width: isMobile ? 12 : 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  // 类型标签
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: NiubiColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      t['typeLabel'] as String,
                      style: const TextStyle(
                          fontSize: 11,
                          color: NiubiColors.primaryLight,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  if (t['duration'] != null) ...[
                    const SizedBox(width: 6),
                    Text(
                      t['duration'] as String,
                      style: const TextStyle(
                          fontSize: 11,
                          color: NiubiColors.textMuted),
                    ),
                  ],
                  const Spacer(),
                  Text(
                    t['time'] as String,
                    style: const TextStyle(
                        fontSize: 11, color: NiubiColors.textMuted),
                  ),
                ]),
                const SizedBox(height: 5),
                Text(
                  t['prompt'] as String,
                  style: const TextStyle(
                      fontSize: 13,
                      color: NiubiColors.textSecondary,
                      fontWeight: FontWeight.w400,
                      height: 1.4),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                // 状态行
                Row(children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    statusLabel,
                    style: TextStyle(
                        fontSize: 11,
                        color: statusColor,
                        fontWeight: FontWeight.w600),
                  ),
                ]),
              ],
            ),
          ),
          // 右侧操作
          const SizedBox(width: 8),
          Icon(Icons.chevron_right_rounded,
              size: 18, color: NiubiColors.textMuted),
        ],
      ),
    );
  }

  Color _statusColor(String s) {
    if (s == 'completed') return NiubiColors.success;
    if (s == 'processing') return NiubiColors.primary;
    return NiubiColors.warning;
  }

  String _statusLabel(String s) {
    if (s == 'completed') return '已完成';
    if (s == 'processing') return '生成中';
    return '等待中';
  }
}

// ── 功能卡片 (有hover效果) ───────────────────────────────────────────────────
class _FeatureItemCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final String sub;
  final List<Color> gradientColors;
  final bool isMobile;

  const _FeatureItemCard({
    required this.icon,
    required this.label,
    required this.sub,
    required this.gradientColors,
    required this.isMobile,
  });

  @override
  State<_FeatureItemCard> createState() => _FeatureItemCardState();
}

class _FeatureItemCardState extends State<_FeatureItemCard>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;
  late AnimationController _hoverCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _hoverCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.04).animate(
        CurvedAnimation(parent: _hoverCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _hoverCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c1 = widget.gradientColors[0];
    final c2 = widget.gradientColors[1];

    return MouseRegion(
      onEnter: (_) => _hoverCtrl.forward(),
      onExit: (_) => _hoverCtrl.reverse(),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedBuilder(
          animation: _scaleAnim,
          builder: (_, child) => Transform.scale(
            scale: _pressed ? 0.95 : _scaleAnim.value,
            child: child,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
              color: NiubiColors.bgCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: c1.withValues(alpha: 0.18),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 图标容器 — 渐变背景
                Container(
                  width: widget.isMobile ? 44 : 48,
                  height: widget.isMobile ? 44 : 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        c1.withValues(alpha: 0.15),
                        c2.withValues(alpha: 0.10),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: c1.withValues(alpha: 0.25), width: 1),
                  ),
                  child: Icon(
                    widget.icon,
                    color: c2,
                    size: widget.isMobile ? 20 : 22,
                  ),
                ),
                SizedBox(height: widget.isMobile ? 8 : 10),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: widget.isMobile ? 11 : 12,
                    color: NiubiColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.1,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  widget.sub,
                  style: TextStyle(
                    fontSize: widget.isMobile ? 10 : 10,
                    color: c2.withValues(alpha: 0.65),
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


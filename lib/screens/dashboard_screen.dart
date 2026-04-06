import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/icons.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  final _searchCtrl = TextEditingController();
  bool _searchFocused = false;

  // 功能入口数据 — 统一紫色主色调，去掉多彩
  final _features = const [
    {'icon': Icons.edit_note_rounded,           'label': '文字生视频', 'page': 1},
    {'icon': Icons.image_rounded,               'label': '图片生视频', 'page': 1},
    {'icon': Icons.movie_creation_rounded,      'label': '短剧制作',   'page': 3},
    {'icon': Icons.storefront_rounded,          'label': '商品视频',   'page': 2},
    {'icon': Icons.auto_awesome_mosaic_rounded, 'label': '模板市场',   'page': 4},
    {'icon': Icons.filter_frames_rounded,       'label': '首尾帧',     'page': 1},
    {'icon': Icons.compare_rounded,             'label': '对比视频',   'page': 2},
    {'icon': Icons.campaign_rounded,            'label': '营销推广',   'page': 2},
    {'icon': Icons.perm_media_rounded,          'label': '素材库',     'page': 5},
    {'icon': Icons.history_rounded,             'label': '历史记录',   'page': 0},
    {'icon': Icons.auto_fix_high_rounded,       'label': '智能创作',   'page': 1},
  ];

  // 最近任务
  final _recentTasks = const [
    {'icon': NiubiIcons.text,  'typeLabel': '文生视频', 'prompt': '赛博朋克城市夜景，霓虹灯闪烁，飞行汽车穿梭...', 'status': 'completed',  'time': '5分钟前'},
    {'icon': NiubiIcons.image, 'typeLabel': '图生视频', 'prompt': '产品360度展示视频，白色背景，专业摄影效果...', 'status': 'processing', 'time': '12分钟前'},
    {'icon': NiubiIcons.frame, 'typeLabel': '首尾帧',   'prompt': '花朵从花苞到盛开的延时动画，暖色调风格...', 'status': 'completed',  'time': '1小时前'},
  ];

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim  = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    return Scaffold(
      backgroundColor: NiubiColors.bgPage,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: isMobile ? _buildMobile() : _buildDesktop(),
      ),
    );
  }

  // ══════════════════════════════════════════════
  // DESKTOP — 仿 Genspark 工作空间布局
  // ══════════════════════════════════════════════
  Widget _buildDesktop() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 860),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ① 大标题
              _buildDesktopTitle(),
              const SizedBox(height: 32),
              // ② 搜索框
              _buildSearchBox(),
              const SizedBox(height: 40),
              // ③ 功能入口 Grid
              _buildFeatureGrid(crossCount: 6, isMobile: false),
              const SizedBox(height: 40),
              // ④ 最近任务
              _buildRecentSection(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopTitle() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [NiubiColors.primary, NiubiColors.secondary],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(bounds),
          child: const Text(
            '牛批AI 创作空间',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '输入创意，一键生成专业视频内容',
          style: TextStyle(fontSize: 15, color: NiubiColors.textMuted),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════
  // MOBILE 布局
  // ══════════════════════════════════════════════
  Widget _buildMobile() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // ① 欢迎 Banner（紧凑版）
          _buildMobileBanner(),
          const SizedBox(height: 16),
          // ② 搜索框
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildSearchBox(),
          ),
          const SizedBox(height: 24),
          // ③ 功能入口
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildFeatureGrid(crossCount: 4, isMobile: true),
          ),
          const SizedBox(height: 24),
          // ④ 最近任务
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildRecentSection(),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildMobileBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A0A30), Color(0xFF0A1525)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: NiubiColors.primary.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [NiubiColors.primaryDark, NiubiColors.primary],
              ),
              borderRadius: BorderRadius.circular(13),
              boxShadow: [
                BoxShadow(color: NiubiColors.primary.withValues(alpha: 0.4), blurRadius: 12),
              ],
            ),
            child: const Icon(NiubiIcons.user, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Text('你好，创作者',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800,
                          color: NiubiColors.textPrimary)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: NiubiColors.primaryGlow,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('PRO', style: TextStyle(fontSize: 10,
                        fontWeight: FontWeight.w800, color: NiubiColors.primaryLight)),
                  ),
                ]),
                const SizedBox(height: 3),
                const Text('今天想创作什么内容？',
                    style: TextStyle(fontSize: 11, color: NiubiColors.textMuted)),
              ],
            ),
          ),
          // 数据小胶囊
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _miniStat('12', '项目'),
              const SizedBox(height: 4),
              _miniStat('320', '额度'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String value, String label) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Text(value, style: const TextStyle(
          fontSize: 13, fontWeight: FontWeight.w800, color: NiubiColors.primary)),
      const SizedBox(width: 3),
      Text(label, style: const TextStyle(fontSize: 10, color: NiubiColors.textMuted)),
    ]);
  }

  // ══════════════════════════════════════════════
  // 搜索框 — 极简版，只保留上传+发送
  // ══════════════════════════════════════════════
  Widget _buildSearchBox() {
    return Focus(
      onFocusChange: (v) => setState(() => _searchFocused = v),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.fromLTRB(18, 4, 12, 10),
        decoration: BoxDecoration(
          color: NiubiColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _searchFocused
                ? NiubiColors.primary.withValues(alpha: 0.55)
                : NiubiColors.borderColor,
            width: _searchFocused ? 1.5 : 1,
          ),
          boxShadow: _searchFocused
              ? [BoxShadow(color: NiubiColors.primary.withValues(alpha: 0.10),
                  blurRadius: 24)]
              : [],
        ),
        child: Column(
          children: [
            TextField(
              controller: _searchCtrl,
              style: const TextStyle(color: NiubiColors.textPrimary, fontSize: 15),
              maxLines: 4,
              minLines: 2,
              decoration: const InputDecoration(
                hintText: '描述你想要生成的视频内容...',
                hintStyle: TextStyle(color: NiubiColors.textMuted, fontSize: 14),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            // 底部：仅上传 + 发送
            Row(
              children: [
                // 上传附件（单一图标，低调）
                GestureDetector(
                  onTap: () {},
                  child: Icon(Icons.add_circle_outline_rounded,
                      color: NiubiColors.textMuted, size: 20),
                ),
                const Spacer(),
                // 发送按钮
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [NiubiColors.primaryDark, NiubiColors.primary],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: NiubiColors.primary.withValues(alpha: 0.30),
                          blurRadius: 14, offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Text('生成',
                        style: TextStyle(color: Colors.white,
                            fontSize: 14, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════
  // 功能入口 Grid (共用)
  // ══════════════════════════════════════════════
  Widget _buildFeatureGrid({required int crossCount, bool isMobile = false}) {
    // 手机端只展示前8个，避免太多
    final items = isMobile ? _features.take(8).toList() : _features;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossCount,
        crossAxisSpacing: 8,
        mainAxisSpacing: isMobile ? 20 : 22,
        childAspectRatio: isMobile ? 1.0 : 0.90,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) => _buildFeatureItem(items[i], crossCount),
    );
  }

  Widget _buildFeatureItem(Map<String, dynamic> f, int crossCount) {
    final isSmall = crossCount >= 6;
    final iconSize = isSmall ? 52.0 : 58.0;
    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 统一紫色调圆形图标容器
          Container(
            width: iconSize, height: iconSize,
            decoration: BoxDecoration(
              color: NiubiColors.primary.withValues(alpha: 0.10),
              shape: BoxShape.circle,
              border: Border.all(
                color: NiubiColors.primary.withValues(alpha: 0.18),
                width: 1,
              ),
            ),
            child: Icon(
              f['icon'] as IconData,
              color: NiubiColors.primary.withValues(alpha: 0.85),
              size: isSmall ? 22 : 26,
            ),
          ),
          SizedBox(height: isSmall ? 7 : 8),
          Text(
            f['label'] as String,
            style: const TextStyle(
              fontSize: 11,
              color: NiubiColors.textSecondary,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════
  // 最近任务 (共用)
  // ══════════════════════════════════════════════
  Widget _buildRecentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题行
        Row(children: [
          Icon(NiubiIcons.history, color: NiubiColors.textMuted, size: 15),
          const SizedBox(width: 6),
          const Text('最近生成',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                  color: NiubiColors.textSecondary)),
          const Spacer(),
          Text('查看全部',
              style: TextStyle(fontSize: 12,
                  color: NiubiColors.primary.withValues(alpha: 0.8))),
        ]),
        const SizedBox(height: 12),
        ..._recentTasks.map(_buildTaskCard),
      ],
    );
  }

  Widget _buildTaskCard(Map<String, Object> t) {
    final statusColor = _statusColor(t['status'] as String);
    final statusLabel = _statusLabel(t['status'] as String);
    final statusIcon  = _statusIcon(t['status'] as String);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: NiubiColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: NiubiColors.borderColor),
      ),
      child: Row(children: [
        // 缩略图
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(
            color: NiubiColors.bgHover,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: NiubiColors.borderLight),
          ),
          child: Icon(t['icon'] as IconData, color: NiubiColors.textMuted, size: 22),
        ),
        const SizedBox(width: 12),
        // 内容
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(t['typeLabel'] as String,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                    color: NiubiColors.textPrimary)),
            const Spacer(),
            Text(t['time'] as String,
                style: const TextStyle(fontSize: 11, color: NiubiColors.textMuted)),
          ]),
          const SizedBox(height: 3),
          Text(t['prompt'] as String,
              style: const TextStyle(fontSize: 11, color: NiubiColors.textMuted),
              maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 5),
          // 状态
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(statusIcon, size: 9, color: statusColor),
                const SizedBox(width: 3),
                Text(statusLabel, style: TextStyle(fontSize: 10,
                    fontWeight: FontWeight.w700, color: statusColor)),
              ]),
            ),
          ]),
        ])),
      ]),
    );
  }

  Color _statusColor(String s) {
    if (s == 'completed')  return NiubiColors.success;
    if (s == 'processing') return NiubiColors.primary;
    return NiubiColors.accent;
  }

  String _statusLabel(String s) {
    if (s == 'completed')  return '已完成';
    if (s == 'processing') return '生成中';
    return '等待中';
  }

  IconData _statusIcon(String s) {
    if (s == 'completed')  return Icons.check_circle_rounded;
    if (s == 'processing') return Icons.autorenew_rounded;
    return Icons.schedule_rounded;
  }
}

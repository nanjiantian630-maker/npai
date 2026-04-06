import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/icons.dart';
import '../widgets/common_widgets.dart';

class TemplatesScreen extends StatefulWidget {
  const TemplatesScreen({super.key});

  @override
  State<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends State<TemplatesScreen> {
  String _activeFilter = 'all';
  String _searchQuery  = '';
  final _searchCtrl    = TextEditingController();

  // Template icon uses IconData instead of emoji string
  final List<Map<String, dynamic>> _templates = [
    {
      'icon':        Icons.rotate_90_degrees_ccw_rounded,
      'iconColor':   NiubiColors.accent,
      'name':        '商品360°展示',
      'desc':        '商品自动旋转展示，适合电商主图视频，全方位呈现产品细节',
      'category':    'merchant',
      'tag':         '商家模板',
      'tagColor':    NiubiColors.accent,
      'subTag':      '商品展示',
      'subTagColor': NiubiColors.primary,
      'useCount':    1280,
      'likeCount':   356,
      'isFeatured':  true,
    },
    {
      'icon':        Icons.campaign_rounded,
      'iconColor':   NiubiColors.gold,
      'name':        '爆款种草短视频',
      'desc':        '年轻人种草风格，适合社交媒体推广，提升产品曝光量',
      'category':    'merchant',
      'tag':         '商家模板',
      'tagColor':    NiubiColors.accent,
      'subTag':      '营销推广',
      'subTagColor': NiubiColors.primary,
      'useCount':    960,
      'likeCount':   245,
      'isFeatured':  true,
    },
    {
      'icon':        Icons.celebration_rounded,
      'iconColor':   NiubiColors.secondary,
      'name':        '节日促销视频',
      'desc':        '节日氛围促销视频，带有庆典元素，适合各类节日营销',
      'category':    'merchant',
      'tag':         '商家模板',
      'tagColor':    NiubiColors.accent,
      'subTag':      '节日促销',
      'subTagColor': NiubiColors.primary,
      'useCount':    520,
      'likeCount':   128,
      'isFeatured':  true,
    },
    {
      'icon':        Icons.favorite_rounded,
      'iconColor':   const Color(0xFFFF5E7A),
      'name':        '都市爱情场景',
      'desc':        '现代都市浪漫场景生成，电影级画质，适合爱情短剧制作',
      'category':    'short_drama',
      'tag':         '短剧模板',
      'tagColor':    NiubiColors.secondary,
      'subTag':      '浪漫爱情',
      'subTagColor': NiubiColors.primary,
      'useCount':    780,
      'likeCount':   302,
      'isFeatured':  true,
    },
    {
      'icon':        Icons.flash_on_rounded,
      'iconColor':   NiubiColors.gold,
      'name':        '动作追逐场景',
      'desc':        '动作片风格的追逐场景，紧张刺激，引人入胜的影视级效果',
      'category':    'short_drama',
      'tag':         '短剧模板',
      'tagColor':    NiubiColors.secondary,
      'subTag':      '动作冒险',
      'subTagColor': NiubiColors.primary,
      'useCount':    640,
      'likeCount':   198,
      'isFeatured':  false,
    },
    {
      'icon':        Icons.psychology_rounded,
      'iconColor':   NiubiColors.primary,
      'name':        '悬疑氛围场景',
      'desc':        '悬疑惊悚氛围场景，引人入胜，适合推理悬疑类短剧制作',
      'category':    'short_drama',
      'tag':         '短剧模板',
      'tagColor':    NiubiColors.secondary,
      'subTag':      '悬疑推理',
      'subTagColor': NiubiColors.primary,
      'useCount':    430,
      'likeCount':   156,
      'isFeatured':  true,
    },
    {
      'icon':        Icons.mood_rounded,
      'iconColor':   NiubiColors.secondary,
      'name':        '喜剧搞笑片段',
      'desc':        '轻松搞笑的日常喜剧场景，适合流量内容创作者快速制作',
      'category':    'short_drama',
      'tag':         '短剧模板',
      'tagColor':    NiubiColors.secondary,
      'subTag':      '搞笑喜剧',
      'subTagColor': NiubiColors.primary,
      'useCount':    890,
      'likeCount':   412,
      'isFeatured':  false,
    },
    {
      'icon':        Icons.compare_rounded,
      'iconColor':   NiubiColors.accent,
      'name':        '产品对比视频',
      'desc':        'Before/After效果对比，突出产品优势，增加用户购买信心',
      'category':    'merchant',
      'tag':         '商家模板',
      'tagColor':    NiubiColors.accent,
      'subTag':      '产品对比',
      'subTagColor': NiubiColors.primary,
      'useCount':    340,
      'likeCount':   89,
      'isFeatured':  false,
    },
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredTemplates {
    return _templates.where((t) {
      final matchFilter = _activeFilter == 'all' ||
          (_activeFilter == 'featured' && t['isFeatured'] == true) ||
          t['category'] == _activeFilter;
      final matchSearch = _searchQuery.isEmpty ||
          (t['name'] as String).toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (t['desc'] as String).toLowerCase().contains(_searchQuery.toLowerCase());
      return matchFilter && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NiubiColors.bgPage,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildHero(),
                  const SizedBox(height: 24),
                  _buildFilterBar(),
                  const SizedBox(height: 16),
                  _buildTemplateGrid(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xE60A0A0F),
        border: Border(bottom: BorderSide(color: NiubiColors.borderLight)),
      ),
      child: Row(
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: NiubiColors.gold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: NiubiColors.gold.withValues(alpha: 0.3)),
            ),
            child: const Icon(NiubiIcons.templates, color: NiubiColors.gold, size: 18),
          ),
          const SizedBox(width: 12),
          const Text('模板市场',
              style: TextStyle(
                  fontSize: 17, fontWeight: FontWeight.w700,
                  color: NiubiColors.textPrimary)),
        ],
      ),
    );
  }

  // ── Hero banner ────────────────────────────────────────────────────────────
  Widget _buildHero() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0x1AF97316), Color(0x0EA855F7)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: NiubiColors.borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(NiubiIcons.templates, color: NiubiColors.gold, size: 22),
                    const SizedBox(width: 10),
                    const Text('海量模板，一键开拍',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w800,
                            color: NiubiColors.textPrimary)),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '精选商家营销和短剧制作模板，填入你的内容即可生成专业视频',
                  style: TextStyle(
                      color: NiubiColors.textSecondary, fontSize: 12, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFEA580C), NiubiColors.gold],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: NiubiColors.gold.withValues(alpha: 0.35),
                  blurRadius: 20,
                ),
              ],
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 34),
          ),
        ],
      ),
    );
  }

  // ── Filter bar ─────────────────────────────────────────────────────────────
  Widget _buildFilterBar() {
    final filters = [
      {'key': 'all',         'label': '全部',     'icon': Icons.apps_rounded},
      {'key': 'merchant',    'label': '商家模板',  'icon': NiubiIcons.merchant},
      {'key': 'short_drama', 'label': '短剧模板',  'icon': NiubiIcons.drama},
      {'key': 'featured',    'label': '精选推荐',  'icon': NiubiIcons.featured},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...filters.map((f) {
            final isActive = _activeFilter == f['key'];
            return GestureDetector(
              onTap: () => setState(() => _activeFilter = f['key'] as String),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive
                      ? NiubiColors.primary.withValues(alpha: 0.15)
                      : NiubiColors.bgCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive ? NiubiColors.primary : NiubiColors.borderColor,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      f['icon'] as IconData,
                      size: 14,
                      color: isActive ? NiubiColors.primaryLight : NiubiColors.textSecondary,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      f['label'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isActive ? NiubiColors.primaryLight : NiubiColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(width: 8),
          // Search
          Container(
            width: 200, height: 38,
            decoration: BoxDecoration(
              color: NiubiColors.bgCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: NiubiColors.borderColor),
            ),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _searchQuery = v),
              style: const TextStyle(color: NiubiColors.textPrimary, fontSize: 13),
              decoration: const InputDecoration(
                hintText: '搜索模板...',
                hintStyle: TextStyle(color: NiubiColors.textMuted, fontSize: 12),
                prefixIcon: Icon(Icons.search_rounded, color: NiubiColors.textMuted, size: 16),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Grid ───────────────────────────────────────────────────────────────────
  Widget _buildTemplateGrid() {
    final filtered = _filteredTemplates;

    if (filtered.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(48),
        child: Column(
          children: [
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                color: NiubiColors.textMuted.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.search_off_rounded,
                  size: 32, color: NiubiColors.textMuted),
            ),
            const SizedBox(height: 16),
            const Text('暂无匹配的模板',
                style: TextStyle(color: NiubiColors.textMuted, fontSize: 14)),
          ],
        ),
      );
    }

    return LayoutBuilder(builder: (context, constraints) {
      final crossAxisCount = constraints.maxWidth > 900
          ? 3
          : constraints.maxWidth > 600
              ? 2
              : 1;
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: crossAxisCount == 1 ? 2.5 : 0.72,
        ),
        itemCount: filtered.length,
        itemBuilder: (context, i) => _buildTemplateCard(filtered[i], crossAxisCount),
      );
    });
  }

  Widget _buildTemplateCard(Map<String, dynamic> t, int cols) {
    return NiubiGlowCard(
      padding: EdgeInsets.zero,
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('使用模板：${t['name']}'),
            backgroundColor: NiubiColors.primary,
          ),
        );
      },
      child: cols == 1 ? _buildCardHorizontal(t) : _buildCardVertical(t),
    );
  }

  // ── Vertical card (2-3 column grid) ───────────────────────────────────────
  Widget _buildCardVertical(Map<String, dynamic> t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cover
        AspectRatio(
          aspectRatio: 16 / 10,
          child: Container(
            decoration: BoxDecoration(
              color: (t['iconColor'] as Color).withValues(alpha: 0.10),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Center(
              child: Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  color: (t['iconColor'] as Color).withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: (t['iconColor'] as Color).withValues(alpha: 0.35)),
                ),
                child: Icon(t['icon'] as IconData,
                    size: 28, color: t['iconColor'] as Color),
              ),
            ),
          ),
        ),
        const Divider(height: 1, color: NiubiColors.borderLight),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    NiubiBadge(
                      label: t['tag'] as String,
                      bgColor: (t['tagColor'] as Color).withValues(alpha: 0.15),
                      textColor: t['tagColor'] as Color,
                    ),
                    const SizedBox(width: 6),
                    NiubiBadge(
                      label: t['subTag'] as String,
                      bgColor: NiubiColors.primary.withValues(alpha: 0.12),
                      textColor: NiubiColors.primaryLight,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(t['name'] as String,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700,
                        color: NiubiColors.textPrimary)),
                const SizedBox(height: 6),
                Expanded(
                  child: Text(t['desc'] as String,
                      style: const TextStyle(
                          fontSize: 11, color: NiubiColors.textSecondary, height: 1.5),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(NiubiIcons.totalVideos, size: 11, color: NiubiColors.textMuted),
                    const SizedBox(width: 3),
                    Text('${t['useCount']}',
                        style: const TextStyle(fontSize: 11, color: NiubiColors.textMuted)),
                    const SizedBox(width: 10),
                    Icon(NiubiIcons.favorite, size: 11, color: NiubiColors.textMuted),
                    const SizedBox(width: 3),
                    Text('${t['likeCount']}',
                        style: const TextStyle(fontSize: 11, color: NiubiColors.textMuted)),
                    if (t['isFeatured'] == true) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.local_fire_department_rounded,
                          size: 12, color: NiubiColors.accent),
                      const SizedBox(width: 2),
                      const Text('精选',
                          style: TextStyle(fontSize: 11, color: NiubiColors.accent,
                              fontWeight: FontWeight.w700)),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: NiubiPrimaryButton(
                    label: '使用此模板',
                    icon: NiubiIcons.play,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Horizontal card (single column) ───────────────────────────────────────
  Widget _buildCardHorizontal(Map<String, dynamic> t) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(
              color: (t['iconColor'] as Color).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: (t['iconColor'] as Color).withValues(alpha: 0.30)),
            ),
            child: Icon(t['icon'] as IconData,
                size: 32, color: t['iconColor'] as Color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    NiubiBadge(
                      label: t['tag'] as String,
                      bgColor: (t['tagColor'] as Color).withValues(alpha: 0.15),
                      textColor: t['tagColor'] as Color,
                    ),
                    if (t['isFeatured'] == true) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.local_fire_department_rounded,
                          size: 13, color: NiubiColors.accent),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Text(t['name'] as String,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700,
                        color: NiubiColors.textPrimary)),
                const SizedBox(height: 4),
                Text(t['desc'] as String,
                    style: const TextStyle(
                        fontSize: 11, color: NiubiColors.textSecondary),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(NiubiIcons.totalVideos, size: 11, color: NiubiColors.textMuted),
                    const SizedBox(width: 3),
                    Text('${t['useCount']}',
                        style: const TextStyle(
                            fontSize: 11, color: NiubiColors.textMuted)),
                    const SizedBox(width: 10),
                    Icon(NiubiIcons.favorite, size: 11, color: NiubiColors.textMuted),
                    const SizedBox(width: 3),
                    Text('${t['likeCount']}',
                        style: const TextStyle(
                            fontSize: 11, color: NiubiColors.textMuted)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          NiubiPrimaryButton(
            label: '使用',
            icon: NiubiIcons.play,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

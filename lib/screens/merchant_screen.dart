import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/icons.dart';
import '../widgets/common_widgets.dart';

class MerchantScreen extends StatefulWidget {
  const MerchantScreen({super.key});
  @override State<MerchantScreen> createState() => _MerchantScreenState();
}

class _MerchantScreenState extends State<MerchantScreen> {
  String? _selectedService;
  int _step = 0;
  int _selTpl = -1;
  bool _hasProdImg = false;
  bool _isGenerating = false;
  bool _isDone = false;
  double _genProgress = 0;
  final _prodNameCtrl  = TextEditingController();
  final _extraCtrl     = TextEditingController();
  String _ratio = '16:9';
  String _dur   = '5';

  static const _services = [
    {'key':'product',   'icon': NiubiIcons.productVideo,   'title':'商品展示视频',
     'desc':'360°旋转、多角度特写，适合电商主图',
     'badge':'最常用', 'bColor': NiubiColors.secondary},
    {'key':'marketing', 'icon': NiubiIcons.marketingVideo, 'title':'营销推广视频',
     'desc':'种草风格、KOL推荐、促销宣传',
     'badge':'高效', 'bColor': NiubiColors.accent},
    {'key':'compare',   'icon': NiubiIcons.compareVideo,   'title':'产品对比视频',
     'desc':'Before/After，突出产品优势',
     'badge':'特色', 'bColor': NiubiColors.primary},
  ];

  static const _templates = [
    {'icon': Icons.rotate_right_rounded,    'title':'360°旋转展示', 'desc':'全方位展示'},
    {'icon': Icons.home_rounded,             'title':'场景化展示',   'desc':'融入生活场景'},
    {'icon': Icons.center_focus_strong_rounded,'title':'特写动态',  'desc':'细节特写'},
    {'icon': Icons.star_rounded,             'title':'种草推荐',     'desc':'博主推荐风'},
    {'icon': Icons.celebration_rounded,      'title':'节日促销',     'desc':'节日氛围'},
    {'icon': Icons.auto_awesome_rounded,     'title':'极简高级',     'desc':'极简纯色背景'},
  ];

  static const _stepLabels = ['上传素材', '选模板', '设参数', '生成'];

  @override
  void dispose() { _prodNameCtrl.dispose(); _extraCtrl.dispose(); super.dispose(); }

  Future<void> _doGenerate() async {
    setState(() { _isGenerating = true; _genProgress = 0; _isDone = false; });
    for (int i = 0; i <= 100; i += 7) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (!mounted) return;
      setState(() => _genProgress = i / 100);
    }
    if (!mounted) return;
    setState(() { _isGenerating = false; _isDone = true; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NiubiColors.bgPage,
      body: Column(children: [
        NiubiPageHeader(
          icon: NiubiIcons.merchant,
          title: '商家服务中心',
          actions: [const NiubiCreditsChip(value: '320')],
        ),
        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            _buildHero(),
            const SizedBox(height: 24),
            if (_selectedService == null) ...[
              _sectionTitle('选择你需要的服务'),
              const SizedBox(height: 14),
              _buildServiceGrid(),
            ] else ...[
              _buildStepper(),
              const SizedBox(height: 20),
              _buildStep(),
            ],
            const SizedBox(height: 20),
          ]),
        )),
      ]),
    );
  }

  Widget _buildHero() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0x1AA855F7), Color(0x14F97316)]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: NiubiColors.borderColor),
      ),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('让你的商品「动」起来', style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w800, color: NiubiColors.textPrimary)),
          const SizedBox(height: 8),
          const Text('上传商品图 → 选择模板 → AI自动生成高质量营销视频，就这么简单',
              style: TextStyle(color: NiubiColors.textSecondary, fontSize: 12, height: 1.5)),
        ])),
        const SizedBox(width: 20),
        Container(
          width: 64, height: 64,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [NiubiColors.accent, Color(0xFFFB923C)],
                begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [BoxShadow(
                color: NiubiColors.accent.withValues(alpha: 0.35), blurRadius: 18)],
          ),
          child: const Icon(NiubiIcons.merchant, color: Colors.white, size: 32),
        ),
      ]),
    );
  }

  Widget _sectionTitle(String t) => Align(
    alignment: Alignment.centerLeft,
    child: Text(t, style: const TextStyle(
        fontSize: 14, fontWeight: FontWeight.w700, color: NiubiColors.textPrimary)),
  );

  Widget _buildServiceGrid() {
    return LayoutBuilder(builder: (ctx, c) {
      final cols = c.maxWidth > 700 ? 3 : 1;
      return GridView.builder(
        shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cols, crossAxisSpacing: 14, mainAxisSpacing: 14,
          childAspectRatio: cols == 3 ? 0.95 : 3.2,
        ),
        itemCount: _services.length,
        itemBuilder: (_, i) {
          final s = _services[i];
          return NiubiGlowCard(
            glowColor: s['bColor'] as Color,
            onTap: () => setState(() { _selectedService = s['key'] as String; _step = 0; }),
            padding: const EdgeInsets.all(22),
            child: cols == 3
                ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                      width: 52, height: 52,
                      decoration: BoxDecoration(
                        color: (s['bColor'] as Color).withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: (s['bColor'] as Color).withValues(alpha: 0.25)),
                      ),
                      child: Icon(s['icon'] as IconData, color: s['bColor'] as Color, size: 26),
                    ),
                    const SizedBox(height: 14),
                    Text(s['title'] as String, style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700, color: NiubiColors.textPrimary)),
                    const SizedBox(height: 6),
                    Text(s['desc'] as String, style: const TextStyle(
                        fontSize: 12, color: NiubiColors.textSecondary, height: 1.5)),
                    const Spacer(),
                    NiubiBadge(
                      label: s['badge'] as String,
                      icon: NiubiIcons.featured,
                      bgColor: (s['bColor'] as Color).withValues(alpha: 0.14),
                      textColor: s['bColor'] as Color,
                    ),
                  ])
                : Row(children: [
                    Container(
                      width: 46, height: 46,
                      decoration: BoxDecoration(
                        color: (s['bColor'] as Color).withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(s['icon'] as IconData, color: s['bColor'] as Color, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(s['title'] as String, style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w700, color: NiubiColors.textPrimary)),
                      Text(s['desc'] as String, style: const TextStyle(
                          fontSize: 11, color: NiubiColors.textSecondary)),
                    ])),
                    NiubiBadge(label: s['badge'] as String,
                        bgColor: (s['bColor'] as Color).withValues(alpha: 0.14),
                        textColor: s['bColor'] as Color),
                    const SizedBox(width: 4),
                    Icon(NiubiIcons.next, color: NiubiColors.textMuted, size: 14),
                  ]),
          );
        },
      );
    });
  }

  // ── Stepper ──────────────────────────────────────────────
  Widget _buildStepper() {
    return Row(children: List.generate(_stepLabels.length * 2 - 1, (idx) {
      if (idx.isOdd) {
        return Expanded(child: Container(height: 2,
            color: idx ~/ 2 < _step ? NiubiColors.success : NiubiColors.borderColor));
      }
      final si = idx ~/ 2;
      final done   = si < _step;
      final active = si == _step;
      return Column(children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 34, height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: done ? const LinearGradient(colors: [NiubiColors.success, NiubiColors.success])
                : active ? const LinearGradient(colors: [NiubiColors.primaryDark, NiubiColors.primary])
                : null,
            color: (!done && !active) ? NiubiColors.bgHover : null,
            border: Border.all(color: done ? NiubiColors.success : active ? NiubiColors.primary : NiubiColors.borderColor),
            boxShadow: active ? [BoxShadow(color: NiubiColors.primary.withValues(alpha: 0.3), blurRadius: 10)] : [],
          ),
          child: Icon(
            done ? Icons.check_rounded : _stepIcons[si],
            size: 14, color: (done || active) ? Colors.white : NiubiColors.textMuted,
          ),
        ),
        const SizedBox(height: 5),
        Text(_stepLabels[si], style: TextStyle(fontSize: 10,
            color: active ? NiubiColors.textPrimary : NiubiColors.textMuted,
            fontWeight: active ? FontWeight.w700 : FontWeight.normal)),
      ]);
    }));
  }

  static const _stepIcons = [
    Icons.cloud_upload_rounded,
    Icons.grid_view_rounded,
    Icons.tune_rounded,
    Icons.auto_awesome_rounded,
  ];

  Widget _buildStep() {
    switch (_step) {
      case 0: return _step1();
      case 1: return _step2();
      case 2: return _step3();
      case 3: return _step4();
      default: return const SizedBox.shrink();
    }
  }

  Widget _navBtns({required VoidCallback onBack, required VoidCallback onNext,
      String backLabel = '上一步', String nextLabel = '下一步',
      bool isAccent = false, bool isNextLoading = false}) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      NiubiPrimaryButton(label: backLabel, icon: Icons.arrow_back_rounded,
          onPressed: onBack,
          startColor: NiubiColors.bgElevated, endColor: NiubiColors.bgHover),
      NiubiPrimaryButton(label: nextLabel,
          icon: isAccent ? NiubiIcons.generate : Icons.arrow_forward_rounded,
          onPressed: isNextLoading ? null : onNext, isLoading: isNextLoading,
          startColor: isAccent ? const Color(0xFFEA580C) : NiubiColors.primaryDark,
          endColor: isAccent ? NiubiColors.accent : NiubiColors.primary),
    ]);
  }

  Widget _step1() {
    return NiubiGlowCard(hoverable: false, padding: const EdgeInsets.all(22),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          NiubiSectionHeader(icon: NiubiIcons.upload, title: '上传商品图片',
              iconColor: NiubiColors.primary),
          const SizedBox(height: 16),
          NiubiUploadZone(
            iconData: NiubiIcons.camera, title: '点击上传商品图片',
            subtitle: 'JPG / PNG / WEBP · 建议高清正面图',
            hasFile: _hasProdImg, fileName: '商品图.jpg',
            onTap: () => setState(() => _hasProdImg = !_hasProdImg),
          ),
          const SizedBox(height: 16),
          const Text('商品名称', style: TextStyle(fontSize: 11, color: NiubiColors.textMuted)),
          const SizedBox(height: 6),
          _textField(_prodNameCtrl, '例如：无线蓝牙耳机 Pro Max'),
          const SizedBox(height: 20),
          _navBtns(
            onBack: () => setState(() => _selectedService = null),
            backLabel: '返回',
            onNext: () => setState(() => _step = 1),
          ),
        ]));
  }

  Widget _step2() {
    return NiubiGlowCard(hoverable: false, padding: const EdgeInsets.all(22),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          NiubiSectionHeader(icon: NiubiIcons.templates, title: '选择视频模板',
              iconColor: NiubiColors.primary),
          const SizedBox(height: 16),
          LayoutBuilder(builder: (ctx, c) {
            final cols = c.maxWidth > 480 ? 3 : 2;
            return GridView.builder(
              shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.1),
              itemCount: _templates.length,
              itemBuilder: (_, i) {
                final t = _templates[i];
                final sel = _selTpl == i;
                return GestureDetector(
                  onTap: () => setState(() => _selTpl = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: sel ? NiubiColors.primary.withValues(alpha: 0.08) : NiubiColors.bgCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: sel ? NiubiColors.primary : NiubiColors.borderColor, width: 2),
                    ),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(t['icon'] as IconData,
                          color: sel ? NiubiColors.primary : NiubiColors.textSecondary, size: 26),
                      const SizedBox(height: 7),
                      Text(t['title'] as String, style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w700,
                          color: sel ? NiubiColors.textPrimary : NiubiColors.textSecondary),
                          textAlign: TextAlign.center),
                      const SizedBox(height: 3),
                      Text(t['desc'] as String, style: const TextStyle(
                          fontSize: 9, color: NiubiColors.textMuted), textAlign: TextAlign.center),
                    ]),
                  ),
                );
              },
            );
          }),
          const SizedBox(height: 20),
          _navBtns(onBack: () => setState(() => _step = 0), onNext: () => setState(() => _step = 2)),
        ]));
  }

  Widget _step3() {
    return NiubiGlowCard(hoverable: false, padding: const EdgeInsets.all(22),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          NiubiSectionHeader(icon: NiubiIcons.settings, title: '视频参数',
              iconColor: NiubiColors.primary),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: _dropGroup('比例', NiubiIcons.aspectRatio, _ratio,
                ['16:9','9:16','1:1'], (v) => setState(() => _ratio = v!))),
            const SizedBox(width: 14),
            Expanded(child: _dropGroup('时长', NiubiIcons.duration, _dur,
                ['5','10'], (v) => setState(() => _dur = v!))),
          ]),
          const SizedBox(height: 14),
          const Text('额外描述（可选）',
              style: TextStyle(fontSize: 11, color: NiubiColors.textMuted)),
          const SizedBox(height: 6),
          _textField(_extraCtrl, '如：高级质感、暖色调...'),
          const SizedBox(height: 20),
          _navBtns(
            onBack: () => setState(() => _step = 1),
            onNext: () { setState(() => _step = 3); _doGenerate(); },
            nextLabel: '一键生成视频', isAccent: true,
          ),
        ]));
  }

  Widget _step4() {
    return NiubiGlowCard(hoverable: false, padding: const EdgeInsets.all(24),
        child: Column(children: [
          if (_isDone) ...[
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                color: NiubiColors.success.withValues(alpha: 0.12), shape: BoxShape.circle),
              child: const Icon(NiubiIcons.completed, color: NiubiColors.success, size: 34),
            ),
            const SizedBox(height: 14),
            const Text('生成完成！', style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w700, color: NiubiColors.success)),
            const SizedBox(height: 16),
            AspectRatio(aspectRatio: 16/9, child: Container(
              decoration: BoxDecoration(color: NiubiColors.bgPage,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: NiubiColors.borderLight)),
              child: const Center(child: Icon(NiubiIcons.play,
                  color: NiubiColors.borderColor, size: 54)),
            )),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              NiubiPrimaryButton(label: '下载视频', icon: NiubiIcons.download, onPressed: () {}),
              const SizedBox(width: 14),
              NiubiPrimaryButton(label: '继续生成', icon: NiubiIcons.retry,
                  onPressed: () => setState(() {
                    _step = 0; _isDone = false; _hasProdImg = false; _selTpl = -1;
                  }),
                  startColor: NiubiColors.bgElevated, endColor: NiubiColors.bgHover),
            ]),
          ] else ...[
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                color: NiubiColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: const CircularProgressIndicator(
                  color: NiubiColors.primary, strokeWidth: 2.5),
            ),
            const SizedBox(height: 16),
            const Text('视频生成中...', style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700, color: NiubiColors.textPrimary)),
            const SizedBox(height: 8),
            const Text('AI正在制作中，请稍候',
                style: TextStyle(fontSize: 12, color: NiubiColors.textMuted)),
            const SizedBox(height: 20),
            ConstrainedBox(constraints: const BoxConstraints(maxWidth: 380),
                child: NiubiProgressBar(progress: _genProgress)),
            const SizedBox(height: 6),
            Text('${(_genProgress * 100).toInt()}%',
                style: const TextStyle(fontSize: 11, color: NiubiColors.textSecondary)),
          ],
        ]));
  }

  Widget _dropGroup(String label, IconData icon, String val,
      List<String> opts, ValueChanged<String?> cb) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(icon, color: NiubiColors.textMuted, size: 11),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: NiubiColors.textMuted)),
      ]),
      const SizedBox(height: 5),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(color: NiubiColors.bgDeepest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: NiubiColors.borderColor)),
        child: DropdownButton<String>(value: val, onChanged: cb, isExpanded: true,
            dropdownColor: NiubiColors.bgCard, underline: const SizedBox.shrink(),
            style: const TextStyle(color: NiubiColors.textPrimary, fontSize: 13),
            items: opts.map((o) => DropdownMenuItem<String>(value: o, child: Text(o))).toList()),
      ),
    ]);
  }

  Widget _textField(TextEditingController ctrl, String hint) {
    return TextField(controller: ctrl,
        style: const TextStyle(color: NiubiColors.textPrimary, fontSize: 13),
        decoration: InputDecoration(hintText: hint,
            hintStyle: const TextStyle(color: NiubiColors.textMuted),
            filled: true, fillColor: NiubiColors.bgDeepest,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: NiubiColors.borderColor)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: NiubiColors.borderColor)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: NiubiColors.primary, width: 1.5))));
  }
}

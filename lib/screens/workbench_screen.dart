import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/icons.dart';
import '../widgets/common_widgets.dart';

class WorkbenchScreen extends StatefulWidget {
  const WorkbenchScreen({super.key});
  @override State<WorkbenchScreen> createState() => _WorkbenchScreenState();
}

class _WorkbenchScreenState extends State<WorkbenchScreen> {
  String _mode = 'text_to_video';
  bool _isGenerating = false;
  double _progress = 0.0;
  String _progressText = '准备中...';
  bool _isDone = false;
  bool _hasImage = false;
  bool _hasFirstFrame = false;
  bool _hasLastFrame = false;

  final _promptCtrl = TextEditingController();
  final _negCtrl    = TextEditingController();
  String _ratio      = '16:9';
  String _duration   = '5';
  String _resolution = '1080p';

  static const _modes = [
    {'key': 'text_to_video',    'icon': NiubiIcons.text,      'label': '文字生视频'},
    {'key': 'image_to_video',   'icon': NiubiIcons.image,     'label': '图片生视频'},
    {'key': 'first_last_frame', 'icon': NiubiIcons.frame,     'label': '首尾帧控制'},
    {'key': 'video_extend',     'icon': NiubiIcons.extend,    'label': '视频延展'},
    {'key': 'reference_to_video','icon': NiubiIcons.reference,'label': '参考视频'},
  ];

  static const _history = [
    {'icon': NiubiIcons.text,  'text': '赛博朋克霓虹城市',  'status': '已完成'},
    {'icon': NiubiIcons.image, 'text': '产品360°展示',       'status': '已完成'},
    {'icon': NiubiIcons.frame, 'text': '花朵延时动画',       'status': '已完成'},
  ];

  @override
  void dispose() {
    _promptCtrl.dispose();
    _negCtrl.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    if (_promptCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('请先输入视频描述'), backgroundColor: NiubiColors.danger,
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }
    setState(() { _isGenerating = true; _progress = 0; _progressText = '正在提交任务...'; _isDone = false; });
    for (int i = 0; i <= 100; i += 4) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
      setState(() {
        _progress = i / 100;
        _progressText = i < 20 ? '初始化模型...' : i < 60 ? '画面渲染中 $i%' : '后处理优化...';
      });
    }
    if (!mounted) return;
    setState(() { _isGenerating = false; _isDone = true; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NiubiColors.bgPage,
      body: Column(children: [
        _buildHeader(),
        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(children: [
            _buildModeTabs(),
            const SizedBox(height: 18),
            LayoutBuilder(builder: (ctx, c) {
              return c.maxWidth > 900
                  ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Expanded(child: _buildConfigPanel()),
                      const SizedBox(width: 18),
                      SizedBox(width: 330, child: _buildPreviewPanel()),
                    ])
                  : Column(children: [
                      _buildConfigPanel(),
                      const SizedBox(height: 18),
                      _buildPreviewPanel(),
                    ]);
            }),
          ]),
        )),
      ]),
    );
  }

  // ── Header ───────────────────────────────────────────────
  Widget _buildHeader() {
    return NiubiPageHeader(
      icon: NiubiIcons.workbench,
      title: '视频生成工作台',
      actions: [const NiubiCreditsChip(value: '320')],
    );
  }

  // ── Mode tabs ────────────────────────────────────────────
  Widget _buildModeTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: _modes.map((m) {
        final active = _mode == m['key'];
        return GestureDetector(
          onTap: () => setState(() => _mode = m['key'] as String),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: active ? NiubiColors.primary.withValues(alpha: 0.14) : NiubiColors.bgCard,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: active ? NiubiColors.primary : NiubiColors.borderColor),
              boxShadow: active ? [BoxShadow(
                  color: NiubiColors.primary.withValues(alpha: 0.15), blurRadius: 12)] : [],
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(m['icon'] as IconData,
                  size: 15,
                  color: active ? NiubiColors.primaryLight : NiubiColors.textSecondary),
              const SizedBox(width: 6),
              Text(m['label'] as String, style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w700,
                  color: active ? NiubiColors.primaryLight : NiubiColors.textSecondary)),
            ]),
          ),
        );
      }).toList()),
    );
  }

  // ── Config panel ─────────────────────────────────────────
  Widget _buildConfigPanel() {
    return NiubiGlowCard(
      hoverable: false,
      padding: const EdgeInsets.all(22),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Prompt
        _label(NiubiIcons.text, '视频描述'),
        const SizedBox(height: 8),
        TextField(
          controller: _promptCtrl,
          maxLines: 4, maxLength: 2000,
          style: const TextStyle(color: NiubiColors.textPrimary, fontSize: 13),
          decoration: _inputDeco('描述你想要的视频画面，越详细效果越好...',
              counter: true),
        ),

        // Upload section
        if (_mode == 'image_to_video' || _mode == 'reference_to_video') ...[
          const SizedBox(height: 18),
          _label(NiubiIcons.image, '上传参考图片'),
          const SizedBox(height: 8),
          NiubiUploadZone(
            iconData: NiubiIcons.upload,
            title: '点击上传图片', subtitle: 'JPG / PNG / WEBP · 最大 10MB',
            hasFile: _hasImage, fileName: '参考图.jpg',
            onTap: () => setState(() => _hasImage = !_hasImage),
          ),
        ],

        // Frame section
        if (_mode == 'first_last_frame') ...[
          const SizedBox(height: 18),
          _label(NiubiIcons.frame, '首帧 & 尾帧'),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: NiubiUploadZone(
              iconData: Icons.first_page_rounded,
              title: '首帧', subtitle: '起始画面',
              hasFile: _hasFirstFrame,
              onTap: () => setState(() => _hasFirstFrame = !_hasFirstFrame),
            )),
            const SizedBox(width: 12),
            Expanded(child: NiubiUploadZone(
              iconData: Icons.last_page_rounded,
              title: '尾帧', subtitle: '结束画面',
              hasFile: _hasLastFrame,
              onTap: () => setState(() => _hasLastFrame = !_hasLastFrame),
            )),
          ]),
        ],

        // Params
        const SizedBox(height: 18),
        _label(NiubiIcons.settings, '视频参数'),
        const SizedBox(height: 10),
        _buildParamRow(),

        // Negative prompt
        const SizedBox(height: 18),
        _label(NiubiIcons.negPrompt, '排除内容（可选）'),
        const SizedBox(height: 8),
        TextField(
          controller: _negCtrl,
          style: const TextStyle(color: NiubiColors.textPrimary, fontSize: 13),
          decoration: _inputDeco('模糊、变形、低质量、水印...'),
        ),

        const SizedBox(height: 22),
        NiubiPrimaryButton(
          label: '开始生成',
          icon: NiubiIcons.generate,
          onPressed: _isGenerating ? null : _generate,
          isLoading: _isGenerating, width: double.infinity,
        ),

        if (_isGenerating) ...[
          const SizedBox(height: 14),
          _buildProgressBox(),
        ],
      ]),
    );
  }

  Widget _buildParamRow() {
    return LayoutBuilder(builder: (ctx, c) {
      final twoCol = c.maxWidth > 480;
      final items = [
        {'label': '比例', 'icon': NiubiIcons.aspectRatio, 'value': _ratio,
          'options': ['16:9','9:16','1:1'],
          'onChanged': (v) => setState(() => _ratio = v!)},
        {'label': '时长', 'icon': NiubiIcons.duration, 'value': _duration,
          'options': ['5','10'],
          'onChanged': (v) => setState(() => _duration = v!)},
        {'label': '分辨率', 'icon': NiubiIcons.resolution, 'value': _resolution,
          'options': ['1080p','720p'],
          'onChanged': (v) => setState(() => _resolution = v!)},
      ];
      if (twoCol) {
        return Wrap(spacing: 12, runSpacing: 12, children: items.map((item) {
          return SizedBox(
            width: (c.maxWidth - 12) / 2,
            child: _dropdown(item['label'] as String, item['icon'] as IconData,
                item['value'] as String, item['options'] as List<String>,
                item['onChanged'] as ValueChanged<String?>),
          );
        }).toList());
      }
      return Column(children: items.map((item) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: _dropdown(item['label'] as String, item['icon'] as IconData,
            item['value'] as String, item['options'] as List<String>,
            item['onChanged'] as ValueChanged<String?>),
      )).toList());
    });
  }

  Widget _buildProgressBox() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: NiubiColors.bgPage, borderRadius: BorderRadius.circular(10),
        border: Border.all(color: NiubiColors.borderLight),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          SizedBox(width: 16, height: 16,
              child: CircularProgressIndicator(
                  color: NiubiColors.primary, strokeWidth: 2,
                  value: _progress < 1 ? null : 1)),
          const SizedBox(width: 8),
          Text(_progressText,
              style: const TextStyle(fontSize: 12, color: NiubiColors.textSecondary)),
        ]),
        const SizedBox(height: 10),
        NiubiProgressBar(progress: _progress),
        const SizedBox(height: 5),
        Align(alignment: Alignment.centerRight,
            child: Text('${(_progress * 100).toInt()}%',
                style: const TextStyle(fontSize: 11, color: NiubiColors.textMuted))),
      ]),
    );
  }

  // ── Preview panel ────────────────────────────────────────
  Widget _buildPreviewPanel() {
    return NiubiGlowCard(
      hoverable: false,
      padding: const EdgeInsets.all(18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        NiubiSectionHeader(icon: NiubiIcons.preview, title: '预览',
            iconColor: NiubiColors.secondary),
        const SizedBox(height: 14),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            decoration: BoxDecoration(
              color: NiubiColors.bgPage, borderRadius: BorderRadius.circular(12),
              border: Border.all(color: NiubiColors.borderLight),
            ),
            child: _isDone
                ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                      width: 56, height: 56,
                      decoration: BoxDecoration(
                        color: NiubiColors.success.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(NiubiIcons.completed,
                          color: NiubiColors.success, size: 30),
                    ),
                    const SizedBox(height: 10),
                    const Text('生成完成！', style: TextStyle(
                        color: NiubiColors.success, fontWeight: FontWeight.w700)),
                  ])
                : _isGenerating
                    ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        SizedBox(width: 40, height: 40,
                            child: CircularProgressIndicator(
                                color: NiubiColors.primary, strokeWidth: 2,
                                value: _progress < 1 ? null : 1)),
                        const SizedBox(height: 12),
                        Text(_progressText, style: const TextStyle(
                            fontSize: 11, color: NiubiColors.textMuted)),
                      ])
                    : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(NiubiIcons.play, color: NiubiColors.borderColor, size: 52),
                        const SizedBox(height: 8),
                        const Text('视频将在这里显示', style: TextStyle(
                            color: NiubiColors.textMuted, fontSize: 12)),
                      ]),
          ),
        ),

        if (_isDone) ...[
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: NiubiPrimaryButton(
              label: '下载', icon: NiubiIcons.download,
              onPressed: () {}, width: double.infinity,
            )),
            const SizedBox(width: 10),
            Expanded(child: NiubiPrimaryButton(
              label: '重生成', icon: NiubiIcons.retry,
              onPressed: _generate, width: double.infinity,
              startColor: NiubiColors.bgElevated, endColor: NiubiColors.bgHover,
            )),
          ]),
        ],

        const SizedBox(height: 20),
        NiubiSectionHeader(icon: NiubiIcons.history, title: '历史',
            iconColor: NiubiColors.textMuted),
        const SizedBox(height: 10),
        ..._history.map((h) => _buildHistItem(h as Map<String, Object>)),
      ]),
    );
  }

  Widget _buildHistItem(Map<String, Object> h) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: NiubiColors.bgHover, borderRadius: BorderRadius.circular(8),
      ),
      child: Row(children: [
        Icon(h['icon'] as IconData, color: NiubiColors.primary, size: 16),
        const SizedBox(width: 8),
        Expanded(child: Text(h['text'] as String,
            style: const TextStyle(fontSize: 12, color: NiubiColors.textSecondary),
            maxLines: 1, overflow: TextOverflow.ellipsis)),
        const SizedBox(width: 6),
        NiubiBadge(label: h['status'] as String,
            bgColor: NiubiColors.success.withValues(alpha: 0.12),
            textColor: NiubiColors.success),
      ]),
    );
  }

  // ── Helpers ──────────────────────────────────────────────
  Widget _label(IconData icon, String text) {
    return Row(children: [
      Icon(icon, color: NiubiColors.textMuted, size: 14),
      const SizedBox(width: 6),
      Text(text, style: const TextStyle(
          fontSize: 11, fontWeight: FontWeight.w700,
          color: NiubiColors.textSecondary, letterSpacing: 0.5)),
    ]);
  }

  InputDecoration _inputDeco(String hint, {bool counter = false}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: NiubiColors.textMuted, fontSize: 12),
      filled: true, fillColor: NiubiColors.bgDeepest,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      counter: counter ? null : const SizedBox.shrink(),
      counterStyle: const TextStyle(color: NiubiColors.textMuted, fontSize: 10),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: NiubiColors.borderColor)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: NiubiColors.borderColor)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: NiubiColors.primary, width: 1.5)),
    );
  }

  Widget _dropdown(String label, IconData icon, String value,
      List<String> options, ValueChanged<String?> onChanged) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(icon, color: NiubiColors.textMuted, size: 12),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: NiubiColors.textMuted)),
      ]),
      const SizedBox(height: 5),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: NiubiColors.bgDeepest, borderRadius: BorderRadius.circular(8),
          border: Border.all(color: NiubiColors.borderColor),
        ),
        child: DropdownButton<String>(
          value: value, onChanged: onChanged, isExpanded: true,
          dropdownColor: NiubiColors.bgCard, underline: const SizedBox.shrink(),
          style: const TextStyle(color: NiubiColors.textPrimary, fontSize: 13),
          items: options.map((o) =>
              DropdownMenuItem<String>(value: o, child: Text(o))).toList(),
        ),
      ),
    ]);
  }
}

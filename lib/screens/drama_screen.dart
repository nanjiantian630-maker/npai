import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/icons.dart';
import '../widgets/common_widgets.dart';

class DramaScreen extends StatefulWidget {
  const DramaScreen({super.key});

  @override
  State<DramaScreen> createState() => _DramaScreenState();
}

class _DramaScreenState extends State<DramaScreen> {
  bool _projectCreated = false;
  String _projectName = '';
  final List<Map<String, dynamic>> _scenes = [];
  bool _showAddModal = false;

  final _projNameCtrl = TextEditingController();
  final _projDescCtrl = TextEditingController();
  String _genre = 'romance';

  // Scene modal
  final _scTitleCtrl  = TextEditingController();
  final _scDescCtrl   = TextEditingController();
  final _scDialogCtrl = TextEditingController();
  String _scDuration  = '5';
  String _scCamera    = 'static';

  @override
  void dispose() {
    _projNameCtrl.dispose();
    _projDescCtrl.dispose();
    _scTitleCtrl.dispose();
    _scDescCtrl.dispose();
    _scDialogCtrl.dispose();
    super.dispose();
  }

  void _createProject() {
    if (_projNameCtrl.text.isEmpty) return;
    setState(() {
      _projectName   = _projNameCtrl.text;
      _projectCreated = true;
    });
  }

  void _saveScene() {
    if (_scDescCtrl.text.isEmpty) return;
    setState(() {
      _scenes.add({
        'number':   _scenes.length + 1,
        'title':    _scTitleCtrl.text.isEmpty ? '场景 ${_scenes.length + 1}' : _scTitleCtrl.text,
        'desc':     _scDescCtrl.text,
        'dialogue': _scDialogCtrl.text,
        'duration': _scDuration,
        'camera':   _scCamera,
        'status':   'pending',
      });
      _showAddModal = false;
      _scTitleCtrl.clear();
      _scDescCtrl.clear();
      _scDialogCtrl.clear();
    });
  }

  Future<void> _generateScene(int index) async {
    setState(() => _scenes[index]['status'] = 'generating');
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _scenes[index]['status'] = 'completed');
  }

  Future<void> _generateAll() async {
    for (int i = 0; i < _scenes.length; i++) {
      if (_scenes[i]['status'] != 'completed') {
        setState(() => _scenes[i]['status'] = 'generating');
        await Future.delayed(Duration(milliseconds: 1500 * (i + 1)));
        if (mounted) setState(() => _scenes[i]['status'] = 'completed');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                      if (!_projectCreated) _buildCreateForm() else _buildStoryboard(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_showAddModal) _buildModal(),
      ],
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
              color: NiubiColors.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: NiubiColors.accent.withValues(alpha: 0.3)),
            ),
            child: const Icon(NiubiIcons.drama, color: NiubiColors.accent, size: 18),
          ),
          const SizedBox(width: 12),
          const Text('短剧制作工坊',
              style: TextStyle(
                  fontSize: 17, fontWeight: FontWeight.w700, color: NiubiColors.textPrimary)),
          const Spacer(),
          NiubiCreditsChip(value: '320'),
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
          colors: [Color(0x1AA855F7), Color(0x0E22D3EE)],
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
                    Icon(NiubiIcons.drama, color: NiubiColors.accent, size: 22),
                    const SizedBox(width: 10),
                    const Text('用AI导演你的短剧',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: NiubiColors.textPrimary)),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '创建项目 → 编写分镜 → 逐镜头生成 → 合成输出，轻松完成短剧制作',
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
                colors: [NiubiColors.primaryDark, NiubiColors.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: NiubiColors.accent.withValues(alpha: 0.35),
                  blurRadius: 20,
                ),
              ],
            ),
            child: const Icon(Icons.theaters_rounded, color: Colors.white, size: 34),
          ),
        ],
      ),
    );
  }

  // ── Create project form ────────────────────────────────────────────────────
  Widget _buildCreateForm() {
    final genreOptions = [
      {'value': 'romance',  'label': '浪漫爱情', 'icon': NiubiIcons.romance},
      {'value': 'action',   'label': '动作冒险', 'icon': NiubiIcons.action},
      {'value': 'comedy',   'label': '搞笑喜剧', 'icon': NiubiIcons.comedy},
      {'value': 'suspense', 'label': '悬疑推理', 'icon': NiubiIcons.suspense},
    ];

    return NiubiGlowCard(
      hoverable: false,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(NiubiIcons.project, color: NiubiColors.primary, size: 18),
              const SizedBox(width: 8),
              const Text('创建短剧项目',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700,
                      color: NiubiColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 20),
          LayoutBuilder(builder: (context, constraints) {
            final isWide = constraints.maxWidth > 500;
            return isWide
                ? Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: _inputGroup('项目名称', _projNameCtrl, '例如：都市甜宠第一集'),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('类型风格',
                                style: TextStyle(fontSize: 11, color: NiubiColors.textMuted)),
                            const SizedBox(height: 6),
                            _genreDropdown(genreOptions),
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      _inputGroup('项目名称', _projNameCtrl, '例如：都市甜宠第一集'),
                      const SizedBox(height: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('类型风格',
                              style: TextStyle(fontSize: 11, color: NiubiColors.textMuted)),
                          const SizedBox(height: 6),
                          _genreDropdown(genreOptions),
                        ],
                      ),
                    ],
                  );
          }),
          const SizedBox(height: 14),
          const Text('项目简介',
              style: TextStyle(fontSize: 11, color: NiubiColors.textMuted)),
          const SizedBox(height: 6),
          TextField(
            controller: _projDescCtrl,
            maxLines: 2,
            style: const TextStyle(color: NiubiColors.textPrimary, fontSize: 13),
            decoration: _inputDeco('简单描述你的短剧内容...'),
          ),
          const SizedBox(height: 20),
          NiubiPrimaryButton(
            label: '创建项目并开始编写分镜',
            icon: NiubiIcons.add,
            onPressed: _createProject,
          ),
        ],
      ),
    );
  }

  Widget _genreDropdown(List<Map<String, dynamic>> options) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: NiubiColors.bgDeepest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: NiubiColors.borderColor),
      ),
      child: DropdownButton<String>(
        value: _genre,
        onChanged: (v) => setState(() => _genre = v!),
        isExpanded: true,
        dropdownColor: NiubiColors.bgCard,
        underline: const SizedBox.shrink(),
        style: const TextStyle(color: NiubiColors.textPrimary, fontSize: 13),
        items: options.map((o) => DropdownMenuItem<String>(
          value: o['value'] as String,
          child: Row(
            children: [
              Icon(o['icon'] as IconData, color: NiubiColors.textSecondary, size: 14),
              const SizedBox(width: 6),
              Text(o['label'] as String),
            ],
          ),
        )).toList(),
      ),
    );
  }

  // ── Storyboard ─────────────────────────────────────────────────────────────
  Widget _buildStoryboard() {
    return Column(
      children: [
        Row(
          children: [
            Icon(NiubiIcons.script, color: NiubiColors.primary, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text('$_projectName - 分镜脚本',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700,
                      color: NiubiColors.textPrimary)),
            ),
            NiubiPrimaryButton(
              label: '添加分镜',
              icon: NiubiIcons.add,
              onPressed: () => setState(() => _showAddModal = true),
              startColor: NiubiColors.primaryDark,
              endColor: NiubiColors.primary,
            ),
            const SizedBox(width: 10),
            NiubiPrimaryButton(
              label: '全部生成',
              icon: NiubiIcons.generate,
              onPressed: _generateAll,
              startColor: const Color(0xFF0E7490),
              endColor: NiubiColors.secondary,
            ),
            const SizedBox(width: 10),
            NiubiPrimaryButton(
              label: '合成导出',
              icon: NiubiIcons.export_icon,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: const [
                        Icon(NiubiIcons.drama, color: Colors.white, size: 16),
                        SizedBox(width: 8),
                        Text('正在合成所有镜头为完整短剧...'),
                      ],
                    ),
                    backgroundColor: NiubiColors.accent,
                  ),
                );
              },
              startColor: const Color(0xFFEA580C),
              endColor: NiubiColors.accent,
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (_scenes.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(48),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: NiubiColors.borderColor, style: BorderStyle.solid, width: 2),
            ),
            child: Column(
              children: [
                Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(
                    color: NiubiColors.accent.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.movie_filter_rounded,
                      size: 32, color: NiubiColors.accent),
                ),
                const SizedBox(height: 16),
                const Text('点击「添加分镜」开始编写你的故事',
                    style: TextStyle(color: NiubiColors.textMuted, fontSize: 13)),
              ],
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _scenes.length,
            itemBuilder: (context, i) => _buildSceneCard(_scenes[i], i),
          ),
      ],
    );
  }

  // ── Scene card ─────────────────────────────────────────────────────────────
  Widget _buildSceneCard(Map<String, dynamic> scene, int index) {
    final statusMap = {
      'pending':    {'label': '待生成', 'color': NiubiColors.accent,   'icon': NiubiIcons.pending},
      'generating': {'label': '生成中', 'color': NiubiColors.primary,  'icon': NiubiIcons.processing},
      'completed':  {'label': '已完成', 'color': NiubiColors.success,  'icon': NiubiIcons.completed},
    };
    final cameraMap = {
      'static':    '固定',
      'pan_left':  '左移',
      'pan_right': '右移',
      'zoom_in':   '推近',
      'zoom_out':  '拉远',
      'tracking':  '跟踪',
    };
    final sm = statusMap[scene['status']] ?? statusMap['pending']!;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: NiubiColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: NiubiColors.borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Scene number badge
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [NiubiColors.primaryDark, NiubiColors.primary]),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text('${scene['number']}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
            ),
          ),
          const SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(scene['title'],
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700,
                              color: NiubiColors.textPrimary)),
                    ),
                    NiubiBadge(
                      label: sm['label']! as String,
                      icon: sm['icon']! as IconData,
                      bgColor: (sm['color']! as Color).withValues(alpha: 0.15),
                      textColor: sm['color']! as Color,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(scene['desc'],
                    style: const TextStyle(
                        fontSize: 12, color: NiubiColors.textSecondary, height: 1.4)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.mic_rounded, size: 12, color: NiubiColors.textMuted),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${scene['dialogue'].isEmpty ? '无对白' : scene['dialogue']}  ·  ${scene['duration']}s  ·  ${cameraMap[scene['camera']] ?? scene['camera']}',
                        style: const TextStyle(fontSize: 11, color: NiubiColors.textMuted),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          // Thumbnail + actions
          Column(
            children: [
              Container(
                width: 120, height: 68,
                decoration: BoxDecoration(
                  color: NiubiColors.bgPage,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: NiubiColors.borderLight),
                ),
                child: scene['status'] == 'completed'
                    ? const Center(child: Icon(Icons.check_circle_rounded,
                        color: NiubiColors.success, size: 32))
                    : scene['status'] == 'generating'
                        ? const Center(child: CircularProgressIndicator(
                            color: NiubiColors.primary, strokeWidth: 2))
                        : Center(child: Icon(NiubiIcons.video,
                            color: NiubiColors.textMuted.withValues(alpha: 0.5), size: 30)),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 120,
                child: NiubiPrimaryButton(
                  label: '生成',
                  icon: NiubiIcons.generate,
                  onPressed: scene['status'] == 'generating'
                      ? null
                      : () => _generateScene(index),
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: 120,
                child: NiubiPrimaryButton(
                  label: '删除',
                  icon: NiubiIcons.delete,
                  onPressed: () => setState(() {
                    _scenes.removeAt(index);
                    for (int i = 0; i < _scenes.length; i++) {
                      _scenes[i]['number'] = i + 1;
                    }
                  }),
                  startColor: NiubiColors.bgElevated,
                  endColor: NiubiColors.bgHover,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Add scene modal ────────────────────────────────────────────────────────
  Widget _buildModal() {
    final cameraOptions = [
      {'value': 'static',    'label': '固定镜头'},
      {'value': 'pan_left',  'label': '左平移'},
      {'value': 'pan_right', 'label': '右平移'},
      {'value': 'zoom_in',   'label': '推近'},
      {'value': 'zoom_out',  'label': '拉远'},
      {'value': 'tracking',  'label': '跟踪'},
    ];

    return Material(
      color: Colors.black.withValues(alpha: 0.7),
      child: Center(
        child: Container(
          width: 580,
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85),
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: NiubiColors.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: NiubiColors.borderColor),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(NiubiIcons.scene, color: NiubiColors.accent, size: 18),
                    const SizedBox(width: 8),
                    const Text('添加分镜场景',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700,
                            color: NiubiColors.textPrimary)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('场次',
                              style: TextStyle(fontSize: 11, color: NiubiColors.textMuted)),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              color: NiubiColors.bgDeepest,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: NiubiColors.borderColor),
                            ),
                            child: Text('${_scenes.length + 1}',
                                style: const TextStyle(
                                    color: NiubiColors.textPrimary, fontSize: 13)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(child: _inputGroup('场景标题', _scTitleCtrl, '如：咖啡馆偶遇')),
                  ],
                ),
                const SizedBox(height: 14),
                const Text('画面描述 *',
                    style: TextStyle(fontSize: 11, color: NiubiColors.textMuted)),
                const SizedBox(height: 6),
                TextField(
                  controller: _scDescCtrl,
                  maxLines: 3,
                  style: const TextStyle(color: NiubiColors.textPrimary, fontSize: 13),
                  decoration: _inputDeco('详细描述这个镜头的画面内容...'),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(child: _inputGroup('对白台词', _scDialogCtrl, '台词内容...')),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('时长(秒)',
                              style: TextStyle(fontSize: 11, color: NiubiColors.textMuted)),
                          const SizedBox(height: 6),
                          _simpleDropdown(
                              _scDuration, ['5', '10'], ['5秒', '10秒'],
                              (v) => setState(() => _scDuration = v!)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text('镜头运动',
                    style: TextStyle(fontSize: 11, color: NiubiColors.textMuted)),
                const SizedBox(height: 6),
                _simpleDropdown(
                    _scCamera,
                    cameraOptions.map((o) => o['value']!).toList(),
                    cameraOptions.map((o) => o['label']!).toList(),
                    (v) => setState(() => _scCamera = v!)),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    NiubiPrimaryButton(
                      label: '取消',
                      icon: NiubiIcons.close,
                      onPressed: () => setState(() => _showAddModal = false),
                      startColor: NiubiColors.bgElevated,
                      endColor: NiubiColors.bgHover,
                    ),
                    const SizedBox(width: 12),
                    NiubiPrimaryButton(
                      label: '保存分镜',
                      icon: NiubiIcons.save,
                      onPressed: _saveScene,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  Widget _inputGroup(String label, TextEditingController ctrl, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: NiubiColors.textMuted)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          style: const TextStyle(color: NiubiColors.textPrimary, fontSize: 13),
          decoration: _inputDeco(hint),
        ),
      ],
    );
  }

  InputDecoration _inputDeco(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: NiubiColors.textMuted, fontSize: 12),
      filled: true,
      fillColor: NiubiColors.bgDeepest,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: NiubiColors.borderColor)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: NiubiColors.borderColor)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: NiubiColors.primary, width: 1.5)),
    );
  }

  Widget _simpleDropdown(
    String value,
    List<String> values,
    List<String> labels,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: NiubiColors.bgDeepest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: NiubiColors.borderColor),
      ),
      child: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        isExpanded: true,
        dropdownColor: NiubiColors.bgCard,
        underline: const SizedBox.shrink(),
        style: const TextStyle(color: NiubiColors.textPrimary, fontSize: 13),
        items: List.generate(
          values.length,
          (i) => DropdownMenuItem<String>(value: values[i], child: Text(labels[i])),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/icons.dart';
import '../widgets/common_widgets.dart';
import 'main_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool _isLogin = true;
  bool _isLoading = false;
  String _selectedType = 'merchant';
  bool _obscurePass = true;
  bool _obscureRegPass = true;

  final _emailCtrl        = TextEditingController();
  final _passwordCtrl     = TextEditingController();
  final _usernameCtrl     = TextEditingController();
  final _regEmailCtrl     = TextEditingController();
  final _regPasswordCtrl  = TextEditingController();

  late AnimationController _animCtrl;
  late Animation<double>   _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    for (final c in [_emailCtrl, _passwordCtrl, _usernameCtrl,
                     _regEmailCtrl, _regPasswordCtrl]) c.dispose();
    super.dispose();
  }

  void _toast(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        Icon(isError ? Icons.error_rounded : Icons.check_circle_rounded,
            color: Colors.white, size: 18),
        const SizedBox(width: 8),
        Expanded(child: Text(msg)),
      ]),
      backgroundColor: isError ? NiubiColors.danger : NiubiColors.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    ));
  }

  Future<void> _handleLogin() async {
    if (_emailCtrl.text.isEmpty || _passwordCtrl.text.isEmpty) {
      _toast('请填写邮箱和密码', isError: true);
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isLoading = false);
    _toast('登录成功！欢迎回来');
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainShell()));
  }

  Future<void> _handleRegister() async {
    if (_usernameCtrl.text.isEmpty || _regEmailCtrl.text.isEmpty || _regPasswordCtrl.text.isEmpty) {
      _toast('请填写完整注册信息', isError: true);
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isLoading = false);
    _toast('注册成功！开始创作吧');
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainShell()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NiubiColors.bgDeepest,
      body: Stack(children: [
        _buildBg(),
        Center(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(children: [
                  _buildLogo(),
                  const SizedBox(height: 32),
                  _buildCard(),
                ]),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  // ── Background ───────────────────────────────────────────
  Widget _buildBg() {
    return Stack(children: [
      Positioned(top: -120, right: -120,
          child: _glow(600, NiubiColors.primary.withValues(alpha: 0.10))),
      Positioned(bottom: -100, left: -100,
          child: _glow(500, NiubiColors.accent.withValues(alpha: 0.07))),
      // Grid
      Opacity(opacity: 0.035,
          child: CustomPaint(painter: _GridPainter(), child: const SizedBox.expand())),
    ]);
  }

  Widget _glow(double s, Color c) => Container(
    width: s, height: s,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: RadialGradient(colors: [c, Colors.transparent]),
    ),
  );

  // ── Logo ─────────────────────────────────────────────────
  Widget _buildLogo() {
    return Column(children: [
      // 登录页 Logo — 透明抠图版，带光晕
      Stack(
        alignment: Alignment.center,
        children: [
          // 背景光晕层
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  NiubiColors.primary.withValues(alpha: 0.18),
                  const Color(0xFF22D3EE).withValues(alpha: 0.08),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
          // Logo 图片（透明背景）
          SizedBox(
            width: 200,
            height: 200,
            child: Image.asset(
              'assets/images/logo_square_transparent.png',
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
      const SizedBox(height: 4),
      const Text('AI驱动 · 视频智能体平台',
          style: TextStyle(color: NiubiColors.textMuted, fontSize: 13)),
    ]);
  }

  // ── Card ─────────────────────────────────────────────────
  Widget _buildCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: NiubiColors.bgCard.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: NiubiColors.borderColor),
        boxShadow: [BoxShadow(
          color: Colors.black.withValues(alpha: 0.45), blurRadius: 32, offset: const Offset(0, 10),
        )],
      ),
      child: Column(children: [
        _buildTabs(),
        const SizedBox(height: 24),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _isLogin ? _buildLoginForm() : _buildRegisterForm(),
        ),
      ]),
    );
  }

  // ── Tabs ─────────────────────────────────────────────────
  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: NiubiColors.bgPage, borderRadius: BorderRadius.circular(10),
      ),
      child: Row(children: [
        _tab('登 录', true),
        _tab('注 册', false),
      ]),
    );
  }

  Widget _tab(String label, bool isLoginTab) {
    final active = _isLogin == isLoginTab;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _isLogin = isLoginTab),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            gradient: active
                ? const LinearGradient(colors: [NiubiColors.primaryDark, NiubiColors.primary])
                : null,
            borderRadius: BorderRadius.circular(8),
            boxShadow: active ? [BoxShadow(
              color: NiubiColors.primary.withValues(alpha: 0.28), blurRadius: 10,
            )] : [],
          ),
          child: Text(label, textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w700,
                  color: active ? Colors.white : NiubiColors.textMuted)),
        ),
      ),
    );
  }

  // ── Login form ───────────────────────────────────────────
  Widget _buildLoginForm() {
    return Column(key: const ValueKey('login'), children: [
      _field('邮箱', _emailCtrl, NiubiIcons.email, '请输入邮箱地址',
          type: TextInputType.emailAddress),
      const SizedBox(height: 16),
      _field('密码', _passwordCtrl, NiubiIcons.password, '请输入密码',
          obscure: _obscurePass, toggleObscure: () => setState(() => _obscurePass = !_obscurePass)),
      const SizedBox(height: 24),
      NiubiPrimaryButton(label: '登 录', onPressed: _handleLogin,
          isLoading: _isLoading, width: double.infinity,
          icon: NiubiIcons.logo),
    ]);
  }

  // ── Register form ────────────────────────────────────────
  Widget _buildRegisterForm() {
    return Column(key: const ValueKey('register'), children: [
      _field('用户名', _usernameCtrl, NiubiIcons.user, '3-50个字符'),
      const SizedBox(height: 14),
      _field('邮箱', _regEmailCtrl, NiubiIcons.email, '请输入邮箱地址',
          type: TextInputType.emailAddress),
      const SizedBox(height: 14),
      _field('密码', _regPasswordCtrl, NiubiIcons.password, '至少6位',
          obscure: _obscureRegPass,
          toggleObscure: () => setState(() => _obscureRegPass = !_obscureRegPass)),
      const SizedBox(height: 16),
      _buildTypeSelector(),
      const SizedBox(height: 24),
      NiubiPrimaryButton(label: '注 册', onPressed: _handleRegister,
          isLoading: _isLoading, width: double.infinity,
          icon: Icons.person_add_rounded),
    ]);
  }

  Widget _field(String label, TextEditingController ctrl, IconData leadIcon,
      String hint, {
        TextInputType type = TextInputType.text,
        bool obscure = false,
        VoidCallback? toggleObscure,
      }) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(
          color: NiubiColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
      const SizedBox(height: 7),
      TextField(
        controller: ctrl,
        keyboardType: type,
        obscureText: obscure,
        style: const TextStyle(color: NiubiColors.textPrimary, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: NiubiColors.textMuted, fontSize: 13),
          filled: true, fillColor: NiubiColors.bgPage,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          prefixIcon: Icon(leadIcon, color: NiubiColors.textMuted, size: 18),
          suffixIcon: toggleObscure != null
              ? IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                    color: NiubiColors.textMuted, size: 18),
                  onPressed: toggleObscure)
              : null,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: NiubiColors.borderColor)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: NiubiColors.borderColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: NiubiColors.primary, width: 1.5)),
        ),
      ),
    ]);
  }

  Widget _buildTypeSelector() {
    final types = [
      {'key': 'merchant', 'icon': NiubiIcons.merchant_u, 'name': '商家', 'desc': '电商 / 营销'},
      {'key': 'creator',  'icon': NiubiIcons.creator,    'name': '创作者', 'desc': '短剧 / 内容'},
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('选择身份', style: TextStyle(
          color: NiubiColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
      const SizedBox(height: 10),
      Row(children: types.map((t) {
        final sel = _selectedType == t['key'];
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedType = t['key'] as String),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: EdgeInsets.only(right: t['key'] == 'merchant' ? 10 : 0),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
              decoration: BoxDecoration(
                color: sel ? NiubiColors.primary.withValues(alpha: 0.08) : NiubiColors.bgPage,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: sel ? NiubiColors.primary : NiubiColors.borderColor, width: 2),
                boxShadow: sel ? [BoxShadow(
                  color: NiubiColors.primary.withValues(alpha: 0.15), blurRadius: 12,
                )] : [],
              ),
              child: Column(children: [
                Icon(t['icon'] as IconData,
                    color: sel ? NiubiColors.primary : NiubiColors.textSecondary, size: 26),
                const SizedBox(height: 7),
                Text(t['name'] as String, style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700,
                    color: sel ? NiubiColors.textPrimary : NiubiColors.textSecondary)),
                const SizedBox(height: 3),
                Text(t['desc'] as String,
                    style: const TextStyle(fontSize: 10, color: NiubiColors.textMuted)),
              ]),
            ),
          ),
        );
      }).toList()),
    ]);
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = NiubiColors.primary..strokeWidth = 1;
    for (double x = 0; x < size.width;  x += 60) canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    for (double y = 0; y < size.height; y += 60) canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
  }
  @override bool shouldRepaint(covariant CustomPainter _) => false;
}

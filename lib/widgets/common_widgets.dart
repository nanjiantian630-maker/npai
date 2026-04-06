import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/icons.dart';

// ── Primary gradient button ──────────────────────────────────────────────────
class NiubiPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final IconData? icon;
  final Color startColor;
  final Color endColor;

  const NiubiPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.icon,
    this.startColor = NiubiColors.primaryDark,
    this.endColor = NiubiColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: onPressed == null
                ? [NiubiColors.bgHover, NiubiColors.bgElevated]
                : [startColor, endColor],
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: onPressed != null
              ? [
                  BoxShadow(
                    color: endColor.withValues(alpha: 0.28),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 22),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 16, height: 16,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 16, color: Colors.white),
                      const SizedBox(width: 7),
                    ],
                    Text(label,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                  ],
                ),
        ),
      ),
    );
  }
}

// ── Glow card ────────────────────────────────────────────────────────────────
class NiubiGlowCard extends StatefulWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? glowColor;
  final VoidCallback? onTap;
  final bool hoverable;

  const NiubiGlowCard({
    super.key,
    required this.child,
    this.padding,
    this.glowColor,
    this.onTap,
    this.hoverable = true,
  });

  @override
  State<NiubiGlowCard> createState() => _NiubiGlowCardState();
}

class _NiubiGlowCardState extends State<NiubiGlowCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final glow = widget.glowColor ?? NiubiColors.primary;
    return MouseRegion(
      onEnter: (_) { if (widget.hoverable) setState(() => _hovered = true); },
      onExit:  (_) { if (widget.hoverable) setState(() => _hovered = false); },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          decoration: BoxDecoration(
            color: NiubiColors.bgCard.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered ? glow : NiubiColors.borderColor,
            ),
            boxShadow: _hovered
                ? [BoxShadow(color: glow.withValues(alpha: 0.22), blurRadius: 20, spreadRadius: 1)]
                : [],
          ),
          transform: _hovered && widget.hoverable
              ? (Matrix4.identity()..translateByDouble(0, -2, 0, 1))
              : Matrix4.identity(),
          child: Padding(
            padding: widget.padding ?? const EdgeInsets.all(20),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

// ── Stat card ────────────────────────────────────────────────────────────────
class NiubiStatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const NiubiStatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return NiubiGlowCard(
      glowColor: color,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: 0.22)),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28, fontWeight: FontWeight.w800, color: NiubiColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(color: NiubiColors.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}

// ── Badge ────────────────────────────────────────────────────────────────────
class NiubiBadge extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color textColor;
  final IconData? icon;

  const NiubiBadge({
    super.key,
    required this.label,
    this.bgColor = const Color(0x26A855F7),
    this.textColor = NiubiColors.primaryLight,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(label,
              style: TextStyle(
                  color: textColor, fontSize: 11, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

// ── Progress bar ─────────────────────────────────────────────────────────────
class NiubiProgressBar extends StatelessWidget {
  final double progress;

  const NiubiProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: NiubiColors.bgDeepest,
        borderRadius: BorderRadius.circular(3),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [NiubiColors.primaryDark, NiubiColors.primary, NiubiColors.secondary],
            ),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }
}

// ── Upload zone ──────────────────────────────────────────────────────────────
class NiubiUploadZone extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool hasFile;
  final String? fileName;
  final VoidCallback onTap;
  final IconData? iconData;

  const NiubiUploadZone({
    super.key,
    required this.title,
    required this.subtitle,
    this.hasFile = false,
    this.fileName,
    required this.onTap,
    this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: hasFile
              ? NiubiColors.success.withValues(alpha: 0.06)
              : NiubiColors.bgPage,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasFile ? NiubiColors.success : NiubiColors.borderColor,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasFile ? Icons.check_circle_rounded : (iconData ?? NiubiIcons.upload),
              color: hasFile ? NiubiColors.success : NiubiColors.textSecondary,
              size: 36,
            ),
            const SizedBox(height: 10),
            Text(
              hasFile ? (fileName ?? '已上传') : title,
              style: TextStyle(
                color: hasFile ? NiubiColors.success : NiubiColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (!hasFile && subtitle.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(subtitle,
                  style: const TextStyle(color: NiubiColors.textMuted, fontSize: 11)),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Section Header ───────────────────────────────────────────────────────────
class NiubiSectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? iconColor;

  const NiubiSectionHeader({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? NiubiColors.primary;
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: NiubiColors.textPrimary)),
            if (subtitle != null)
              Text(subtitle!,
                  style: const TextStyle(
                      fontSize: 11, color: NiubiColors.textMuted)),
          ],
        ),
      ],
    );
  }
}

// ── Page Header ──────────────────────────────────────────────────────────────
class NiubiPageHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Widget>? actions;

  const NiubiPageHeader({
    super.key,
    required this.icon,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
      decoration: const BoxDecoration(
        color: Color(0xED0A0A0F),
        border: Border(bottom: BorderSide(color: NiubiColors.borderLight)),
      ),
      child: Row(
        children: [
          Icon(icon, color: NiubiColors.primary, size: 20),
          const SizedBox(width: 10),
          Text(title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: NiubiColors.textPrimary)),
          const Spacer(),
          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}

// ── Credits chip ─────────────────────────────────────────────────────────────
class NiubiCreditsChip extends StatelessWidget {
  final String value;
  const NiubiCreditsChip({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: NiubiColors.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: NiubiColors.accent.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(NiubiIcons.credits, color: NiubiColors.accent, size: 14),
          const SizedBox(width: 5),
          Text(value,
              style: const TextStyle(
                  color: NiubiColors.accent,
                  fontSize: 13,
                  fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

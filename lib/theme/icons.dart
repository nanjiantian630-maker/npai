import 'package:flutter/material.dart';
import 'colors.dart';

/// 牛批AI 统一图标系统 - 全部使用 Material Icons，不使用 emoji
class NiubiIcons {
  // ── Navigation ──────────────────────────────────────────
  static const IconData dashboard   = Icons.dashboard_rounded;
  static const IconData workbench   = Icons.video_library_rounded;
  static const IconData merchant    = Icons.storefront_rounded;
  static const IconData drama       = Icons.movie_creation_rounded;
  static const IconData templates   = Icons.auto_awesome_mosaic_rounded;
  static const IconData assets      = Icons.perm_media_rounded;
  static const IconData settings    = Icons.tune_rounded;
  static const IconData logout      = Icons.logout_rounded;

  // ── Actions ─────────────────────────────────────────────
  static const IconData generate    = Icons.bolt_rounded;
  static const IconData download    = Icons.file_download_rounded;
  static const IconData upload      = Icons.cloud_upload_rounded;
  static const IconData retry       = Icons.refresh_rounded;
  static const IconData add         = Icons.add_circle_rounded;
  static const IconData delete      = Icons.delete_outline_rounded;
  static const IconData save        = Icons.save_rounded;
  static const IconData play        = Icons.play_circle_rounded;
  static const IconData preview     = Icons.visibility_rounded;
  static const IconData search      = Icons.search_rounded;
  static const IconData filter      = Icons.tune_rounded;
  static const IconData close       = Icons.close_rounded;
  static const IconData check       = Icons.check_circle_rounded;
  static const IconData export_icon = Icons.ios_share_rounded;
  static const IconData back        = Icons.arrow_back_ios_rounded;
  static const IconData next        = Icons.arrow_forward_ios_rounded;

  // ── Content ─────────────────────────────────────────────
  static const IconData video       = Icons.videocam_rounded;
  static const IconData image       = Icons.image_rounded;
  static const IconData text        = Icons.edit_note_rounded;
  static const IconData camera      = Icons.camera_alt_rounded;
  static const IconData frame       = Icons.filter_frames_rounded;
  static const IconData extend      = Icons.open_in_full_rounded;
  static const IconData reference   = Icons.link_rounded;
  static const IconData project     = Icons.folder_special_rounded;
  static const IconData scene       = Icons.movie_filter_rounded;
  static const IconData script      = Icons.description_rounded;
  static const IconData history     = Icons.history_rounded;

  // ── Stats ────────────────────────────────────────────────
  static const IconData totalProjects = Icons.folder_rounded;
  static const IconData totalVideos   = Icons.ondemand_video_rounded;
  static const IconData credits       = Icons.electric_bolt_rounded;
  static const IconData creditsUsed   = Icons.local_fire_department_rounded;

  // ── Status ───────────────────────────────────────────────
  static const IconData pending     = Icons.schedule_rounded;
  static const IconData processing  = Icons.autorenew_rounded;
  static const IconData completed   = Icons.check_circle_rounded;
  static const IconData failed      = Icons.error_rounded;
  static const IconData featured    = Icons.star_rounded;
  static const IconData trending    = Icons.trending_up_rounded;
  static const IconData favorite    = Icons.favorite_rounded;

  // ── User / Auth ──────────────────────────────────────────
  static const IconData email       = Icons.alternate_email_rounded;
  static const IconData password    = Icons.lock_rounded;
  static const IconData user        = Icons.person_rounded;
  static const IconData merchant_u  = Icons.store_rounded;
  static const IconData creator     = Icons.auto_fix_high_rounded;
  static const IconData plan        = Icons.workspace_premium_rounded;

  // ── Service types ────────────────────────────────────────
  static const IconData productVideo   = Icons.rotate_90_degrees_ccw_rounded;
  static const IconData marketingVideo = Icons.campaign_rounded;
  static const IconData compareVideo   = Icons.compare_rounded;

  // ── Camera movements ─────────────────────────────────────
  static const IconData camStatic   = Icons.crop_square_rounded;
  static const IconData camPanL     = Icons.arrow_back_rounded;
  static const IconData camPanR     = Icons.arrow_forward_rounded;
  static const IconData camZoomIn   = Icons.zoom_in_rounded;
  static const IconData camZoomOut  = Icons.zoom_out_rounded;
  static const IconData camTracking = Icons.gps_fixed_rounded;

  // ── Genre ────────────────────────────────────────────────
  static const IconData romance     = Icons.favorite_border_rounded;
  static const IconData action      = Icons.flash_on_rounded;
  static const IconData comedy      = Icons.mood_rounded;
  static const IconData suspense    = Icons.psychology_rounded;

  // ── Misc ─────────────────────────────────────────────────
  static const IconData logo        = Icons.smart_toy_rounded;
  static const IconData menu        = Icons.menu_rounded;
  static const IconData notification = Icons.notifications_none_rounded;
  static const IconData help        = Icons.help_outline_rounded;
  static const IconData negPrompt   = Icons.block_rounded;
  static const IconData aspectRatio = Icons.aspect_ratio_rounded;
  static const IconData duration    = Icons.timer_rounded;
  static const IconData resolution  = Icons.hd_rounded;
  static const IconData seed        = Icons.casino_rounded;
}

/// 带渐变色背景的图标容器
class NiubiIconBox extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color color;
  final double iconSize;
  final double borderRadius;

  const NiubiIconBox({
    super.key,
    required this.icon,
    this.size = 48,
    this.color = NiubiColors.primary,
    this.iconSize = 24,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
      ),
      child: Icon(icon, color: color, size: iconSize),
    );
  }
}

/// 发光渐变图标容器（用于 Logo / 主视觉）
class NiubiGlowIconBox extends StatelessWidget {
  final IconData icon;
  final double size;
  final List<Color> gradientColors;
  final double iconSize;
  final double borderRadius;

  const NiubiGlowIconBox({
    super.key,
    required this.icon,
    this.size = 72,
    this.gradientColors = const [NiubiColors.primaryDark, NiubiColors.primary, NiubiColors.accent],
    this.iconSize = 36,
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: gradientColors.last.withValues(alpha: 0.4),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: iconSize),
    );
  }
}

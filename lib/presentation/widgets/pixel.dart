import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/audio/sfx.dart';
import '../../core/theme/app_palette.dart';

/// Building blocks of the "modern pixel" design language:
/// flat colors, chunky 2px outlines and hard (no-blur) offset shadows.
/// Buttons behave like key caps — pressing sinks them into their shadow.

/// Static framed container (cards, panels, wells).
class PixelBox extends StatelessWidget {
  final Widget child;
  final Color? color;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final double radius;
  final Offset shadowOffset;
  final bool shadow;
  final double? width;
  final double? height;

  const PixelBox({
    super.key,
    required this.child,
    this.color,
    this.borderColor,
    this.padding,
    this.radius = 12,
    this.shadowOffset = const Offset(4, 4),
    this.shadow = true,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? p.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor ?? p.borderStrong, width: 2),
        boxShadow: shadow
            ? [
                BoxShadow(
                  color: p.shadow,
                  offset: shadowOffset,
                  blurRadius: 0,
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}

/// Key-cap button: flat fill, chunky outline, hard shadow. Pressing translates
/// the cap into the shadow. Plays a soft tap by default ([sound]).
class PixelButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? color;
  final Color? borderColor;
  final EdgeInsetsGeometry padding;
  final double radius;
  final double? width;
  final double? height;
  final Sfx? sound;

  const PixelButton({
    super.key,
    required this.child,
    required this.onTap,
    this.onLongPress,
    this.color,
    this.borderColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
    this.radius = 10,
    this.width,
    this.height,
    this.sound = Sfx.tap,
  });

  @override
  State<PixelButton> createState() => _PixelButtonState();
}

class _PixelButtonState extends State<PixelButton> {
  bool _pressed = false;

  bool get _enabled => widget.onTap != null;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    const drop = 4.0;
    final down = _pressed && _enabled;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _enabled ? (_) => setState(() => _pressed = true) : null,
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: _enabled
          ? (_) {
              setState(() => _pressed = false);
              if (widget.sound != null) sfx(widget.sound!);
              widget.onTap!();
            }
          : null,
      onLongPress: widget.onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 70),
        curve: Curves.easeOut,
        width: widget.width,
        height: widget.height,
        padding: widget.padding,
        transform: Matrix4.translationValues(0, down ? drop : 0, 0),
        decoration: BoxDecoration(
          color: widget.color ?? p.surface2,
          borderRadius: BorderRadius.circular(widget.radius),
          border: Border.all(color: widget.borderColor ?? p.borderStrong, width: 2),
          boxShadow: [
            BoxShadow(
              color: p.shadow,
              offset: Offset(0, down ? 0 : drop),
              blurRadius: 0,
            ),
          ],
        ),
        child: Center(widthFactor: 1, heightFactor: 1, child: widget.child),
      ),
    );
  }
}

/// Pixel-framed snackbar with guaranteed text contrast in both themes.
/// Neutral (no [accent]): surface background + theme text color.
/// With [accent] (e.g. red/green): colored background + white text.
void showPixelSnack(BuildContext context, String message, {Color? accent}) {
  final p = context.palette;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          color: accent != null ? Colors.white : p.textPrimary,
        ),
      ),
      backgroundColor: accent ?? p.surface,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: p.borderStrong, width: 2),
      ),
    ),
  );
}

/// Stylized pokéball in the app palette (blue top instead of red): chunky rim,
/// horizontal band and center button. Used for the coin-flip action and other
/// brand moments.
class PixelPokeball extends StatelessWidget {
  final double size;
  final Color? topColor;
  const PixelPokeball({super.key, this.size = 30, this.topColor});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final rim = p.borderStrong;
    final band = size * 0.14;
    final button = size * 0.32;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: rim, width: 2.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Top hemisphere
          Align(
            alignment: Alignment.topCenter,
            child: FractionallySizedBox(
              heightFactor: 0.5,
              widthFactor: 1,
              child: ColoredBox(color: topColor ?? const Color(0xFF4D8EFF)),
            ),
          ),
          // Horizontal band
          Center(child: Container(height: band, color: rim)),
          // Center button
          Center(
            child: Container(
              width: button,
              height: button,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: rim, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Square icon-only key cap.
class PixelIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color? color;
  final Color? iconColor;
  final double size;
  final double iconSize;
  final Sfx? sound;

  const PixelIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.color,
    this.iconColor,
    this.size = 46,
    this.iconSize = 22,
    this.sound = Sfx.tap,
  });

  @override
  Widget build(BuildContext context) {
    return PixelButton(
      onTap: onTap,
      color: color,
      sound: sound,
      width: size,
      height: size,
      padding: EdgeInsets.zero,
      child: Icon(icon, size: iconSize, color: iconColor ?? Colors.white),
    );
  }
}

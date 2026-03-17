#!/bin/bash
set -e

# 1. Create missing file
mkdir -p lib/presentation/components/buttons
cat <<'INNER_EOF' >lib/presentation/components/buttons/buttons_bouncing_effect.dart
import 'package:flutter/material.dart';

class ButtonsBouncingEffect extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;

  const ButtonsBouncingEffect({
    Key? key,
    required this.child,
    this.onPressed,
  }) : super(key: key);

  @override
  _ButtonsBouncingEffectState createState() => _ButtonsBouncingEffectState();
}

class _ButtonsBouncingEffectState extends State<ButtonsBouncingEffect>
    with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.05,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    if (widget.onPressed != null) {
      widget.onPressed!();
    }
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Transform.scale(
        scale: _scale,
        child: widget.child,
      ),
    );
  }
}
INNER_EOF

# 2. Copy other buttons over
cp lib/presentation/components/manager/buttons/custom_button.dart lib/presentation/components/buttons/custom_button.dart 2>/dev/null || true
cp lib/presentation/components/manager/buttons/pop_button.dart lib/presentation/components/buttons/pop_button.dart 2>/dev/null || true
cp lib/presentation/components/manager/buttons/social_button.dart lib/presentation/components/buttons/social_button.dart 2>/dev/null || true
cp lib/presentation/components/manager/buttons/forgot_text_button.dart lib/presentation/components/buttons/forgot_text_button.dart 2>/dev/null || true
cp lib/presentation/components/manager/buttons/second_button.dart lib/presentation/components/buttons/second_button.dart 2>/dev/null || true

# 3. Fix imports inside those copied buttons (so they don't reference old manager paths)
find lib/presentation/components/buttons -name "*.dart" -type f -exec sed -i 's/package:venderfoodyman\/presentation\/components\/manager\/buttons\//package:venderfoodyman\/presentation\/components\/buttons\//g' {} +

# 4. Fix imports across the whole project
find lib -name "*.dart" -type f -exec sed -i 's/package:venderfoodyman\/presentation\/components\/manager\/buttons\//package:venderfoodyman\/presentation\/components\/buttons\//g' {} +
find lib -name "*.dart" -type f -exec sed -i 's/package:venderfoodyman\/presentation\/components\/driver\/buttons\//package:venderfoodyman\/presentation\/components\/buttons\//g' {} +
find lib -name "*.dart" -type f -exec sed -i 's/package:venderfoodyman\/presentation\/components\/manager\/app_bars\//package:venderfoodyman\/presentation\/components\/app_bars\//g' {} +
find lib -name "*.dart" -type f -exec sed -i 's/package:venderfoodyman\/presentation\/components\/driver\/app_bars\//package:venderfoodyman\/presentation\/components\/app_bars\//g' {} +
find lib -name "*.dart" -type f -exec sed -i 's/package:venderfoodyman\/presentation\/components\/manager\//package:venderfoodyman\/presentation\/components\//g' {} +
find lib -name "*.dart" -type f -exec sed -i 's/package:venderfoodyman\/presentation\/components\/driver\//package:venderfoodyman\/presentation\/components\//g' {} +
find lib -name "*.dart" -type f -exec sed -i 's/package:venderfoodyman\/presentation\/components\/app_bars\/common_app_bar.dart/package:venderfoodyman\/presentation\/components\/common_app_bar.dart/g' {} +
find lib -name "*.dart" -type f -exec sed -i 's/package:venderfoodyman\/presentation\/components\/text_fields\/outline_bordered_text_field.dart/package:venderfoodyman\/presentation\/components\/driver\/text_fields\/outline_bordered_text_field.dart/g' {} +
find lib -name "*.dart" -type f -exec sed -i 's/package:venderfoodyman\/presentation\/components\/app_bars\/app_bar_bottom_sheet.dart/package:venderfoodyman\/presentation\/components\/app_bar_bottom_sheet.dart/g' {} +
find lib -name "*.dart" -type f -exec sed -i 's/package:venderfoodyman\/application\/shop_order\/shop_order_provider.dart/package:venderfoodyman\/application\/shops\/shop_order\/shop_order_provider.dart/g' {} +
find lib -name "*.dart" -type f -exec sed -i 's/\.\.\/\.\.\/\.\.\/\.\.\/application\/shop_order\/shop_order_provider.dart/..\/..\/..\/..\/application\/shops\/shop_order\/shop_order_provider.dart/g' {} +
find lib -name "*.dart" -type f -exec sed -i 's/package:venderfoodyman\/application\/edit_profile\/edit_profile_provider.dart/package:venderfoodyman\/application\/profile\/edit_profile\/edit_profile_provider.dart/g' {} +

import 'package:flutter/material.dart';

/// A customizable button widget for the application
/// Provides consistent styling across the app with multiple variants
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isFullWidth = false,
    this.isLoading = false,
    this.isDisabled = false,
    this.leftIcon,
    this.rightIcon,
    this.loadingText,
  });

  /// Button variants
  final AppButtonVariant variant;

  /// Button size
  final AppButtonSize size;

  /// Button text
  final String text;

  /// Callback when button is pressed
  final VoidCallback? onPressed;

  /// Whether the button takes full width
  final bool isFullWidth;

  /// Whether the button is in loading state
  final bool isLoading;

  /// Whether the button is disabled
  final bool isDisabled;

  /// Optional icon on the left
  final Widget? leftIcon;

  /// Optional icon on the right
  final Widget? rightIcon;

  /// Text to show when loading
  final String? loadingText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final buttonStyle = _getButtonStyle(theme, colorScheme);
    final buttonChild = _buildButtonChild(theme, colorScheme);

    Widget button;

    switch (variant) {
      case AppButtonVariant.primary:
        button = ElevatedButton(
          onPressed: _getOnPressed(),
          style: buttonStyle,
          child: buttonChild,
        );
        break;
      case AppButtonVariant.secondary:
        button = OutlinedButton(
          onPressed: _getOnPressed(),
          style: buttonStyle,
          child: buttonChild,
        );
        break;
      case AppButtonVariant.tertiary:
      case AppButtonVariant.text:
        button = TextButton(
          onPressed: _getOnPressed(),
          style: buttonStyle,
          child: buttonChild,
        );
        break;
      case AppButtonVariant.destructive:
        button = ElevatedButton(
          onPressed: _getOnPressed(),
          style: buttonStyle,
          child: buttonChild,
        );
        break;
    }

    if (isFullWidth) {
      button = SizedBox(width: double.infinity, child: button);
    }

    return button;
  }

  VoidCallback? _getOnPressed() {
    if (isDisabled || isLoading) return null;
    return onPressed;
  }

  Widget _buildButtonChild(ThemeData theme, ColorScheme colorScheme) {
    if (isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: _getIconSize(),
            height: _getIconSize(),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                variant == AppButtonVariant.primary ||
                        variant == AppButtonVariant.destructive
                    ? Colors.white
                    : colorScheme.primary,
              ),
            ),
          ),
          if (loadingText != null) ...[
            const SizedBox(width: 8),
            Text(loadingText!),
          ],
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leftIcon != null) ...[
          leftIcon!,
          const SizedBox(width: 8),
        ],
        Text(text),
        if (rightIcon != null) ...[
          const SizedBox(width: 8),
          rightIcon!,
        ],
      ],
    );
  }

  ButtonStyle _getButtonStyle(ThemeData theme, ColorScheme colorScheme) {
    final baseStyle = ElevatedButton.styleFrom(
      padding: _getPadding(),
      minimumSize: Size(0, _getHeight()),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_getBorderRadius()),
      ),
    );

    switch (variant) {
      case AppButtonVariant.primary:
        return baseStyle.copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.primary.withAlpha(150);
            }
            return colorScheme.primary;
          }),
          foregroundColor: WidgetStateProperty.all(Colors.white),
        );

      case AppButtonVariant.secondary:
        return OutlinedButton.styleFrom(
          padding: _getPadding(),
          minimumSize: Size(0, _getHeight()),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_getBorderRadius()),
          ),
          side: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return BorderSide(color: colorScheme.outline.withAlpha(150));
            }
            return BorderSide(color: colorScheme.outline);
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.onSurface.withAlpha(150);
            }
            return colorScheme.primary;
          }),
        );

      case AppButtonVariant.tertiary:
        return TextButton.styleFrom(
          padding: _getPadding(),
          minimumSize: Size(0, _getHeight()),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_getBorderRadius()),
          ),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.primaryContainer.withAlpha(100);
            }
            return colorScheme.primaryContainer;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.onPrimaryContainer.withAlpha(150);
            }
            return colorScheme.onPrimaryContainer;
          }),
        );

      case AppButtonVariant.text:
        return TextButton.styleFrom(
          padding: _getPadding(),
          minimumSize: Size(0, _getHeight()),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.primary.withAlpha(150);
            }
            return colorScheme.primary;
          }),
        );

      case AppButtonVariant.destructive:
        return baseStyle.copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.error.withAlpha(150);
            }
            return colorScheme.error;
          }),
          foregroundColor: WidgetStateProperty.all(Colors.white),
        );
    }
  }

  double _getHeight() {
    switch (size) {
      case AppButtonSize.small:
        return 36;
      case AppButtonSize.medium:
        return 44;
      case AppButtonSize.large:
        return 52;
    }
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case AppButtonSize.small:
        return 8;
      case AppButtonSize.medium:
        return 12;
      case AppButtonSize.large:
        return 16;
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 20;
      case AppButtonSize.large:
        return 24;
    }
  }
}

/// Button variants
enum AppButtonVariant {
  /// Primary button with solid background
  primary,

  /// Secondary button with outline
  secondary,

  /// Tertiary button with subtle background
  tertiary,

  /// Text button with no background
  text,

  /// Destructive button for dangerous actions
  destructive,
}

/// Button sizes
enum AppButtonSize {
  /// Small button (36px height)
  small,

  /// Medium button (44px height)
  medium,

  /// Large button (52px height)
  large,
}

/// A social sign-in button for authentication
class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.isFullWidth = false,
    this.isLoading = false,
  });

  final VoidCallback? onPressed;
  final String text;
  final Widget icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final bool isFullWidth;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget button = OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        minimumSize: const Size(0, 50),
        backgroundColor: backgroundColor ?? colorScheme.surface,
        foregroundColor: foregroundColor ?? colorScheme.onSurface,
        side: BorderSide(
          color: borderColor ?? colorScheme.outline.withAlpha(100),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  foregroundColor ?? colorScheme.onSurface,
                ),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(width: 12),
                Text(text),
              ],
            ),
    );

    if (isFullWidth) {
      button = SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}

/// Icon button wrapper with consistent styling
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.size = 44,
    this.borderRadius = 12,
  });

  final VoidCallback? onPressed;
  final Widget icon;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget button = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        color: foregroundColor ?? colorScheme.onSurface,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      ),
    );

    if (tooltip != null) {
      button = Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_form_field/phone_form_field.dart';

/// A customizable text field widget for the application
/// Provides consistent styling and functionality across the app
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.focusNode,
    this.autofocus = false,
    this.initialValue,
    this.fillColor,
    this.borderColor,
    this.variant = AppTextFieldVariant.outlined,
    this.size = AppTextFieldSize.medium,
  });

  /// Text editing controller
  final TextEditingController? controller;

  /// Label text above the field
  final String? label;

  /// Placeholder text inside the field
  final String? hint;

  /// Error text below the field
  final String? errorText;

  /// Helper text below the field
  final String? helperText;

  /// Icon at the start of the field
  final Widget? prefixIcon;

  /// Icon at the end of the field
  final Widget? suffixIcon;

  /// Callback when suffix icon is pressed
  final VoidCallback? onSuffixIconPressed;

  /// Whether to obscure the text (for passwords)
  final bool obscureText;

  /// Whether the field is enabled
  final bool enabled;

  /// Whether the field is read-only
  final bool readOnly;

  /// Maximum number of lines
  final int maxLines;

  /// Minimum number of lines
  final int? minLines;

  /// Maximum character length
  final int? maxLength;

  /// Keyboard type
  final TextInputType? keyboardType;

  /// Text input action
  final TextInputAction? textInputAction;

  /// Text capitalization
  final TextCapitalization textCapitalization;

  /// Input formatters
  final List<TextInputFormatter>? inputFormatters;

  /// Callback when text changes
  final ValueChanged<String>? onChanged;

  /// Callback when text is submitted
  final ValueChanged<String>? onSubmitted;

  /// Callback when field is tapped
  final VoidCallback? onTap;

  /// Validator function
  final String? Function(String?)? validator;

  /// Focus node
  final FocusNode? focusNode;

  /// Whether to autofocus
  final bool autofocus;

  /// Initial value
  final String? initialValue;

  /// Fill color
  final Color? fillColor;

  /// Border color
  final Color? borderColor;

  /// Text field variant
  final AppTextFieldVariant variant;

  /// Text field size
  final AppTextFieldSize size;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: widget.enabled
                  ? colorScheme.onSurface
                  : colorScheme.onSurface.withAlpha(150),
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: widget.controller,
          initialValue: widget.initialValue,
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          obscureText: _obscureText,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          inputFormatters: widget.inputFormatters,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          validator: widget.validator,
          style: theme.textTheme.bodyLarge,
          decoration: _buildDecoration(theme, colorScheme),
        ),
        if (widget.errorText != null || widget.helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.errorText ?? widget.helperText ?? '',
            style: theme.textTheme.bodySmall?.copyWith(
              color: widget.errorText != null
                  ? colorScheme.error
                  : colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  InputDecoration _buildDecoration(ThemeData theme, ColorScheme colorScheme) {
    final borderRadius = BorderRadius.circular(_getBorderRadius());
    final defaultFillColor = widget.fillColor ??
        (theme.brightness == Brightness.light
            ? colorScheme.surfaceContainerHighest
            : colorScheme.surfaceContainerHighest);

    Widget? suffixIcon = widget.suffixIcon;

    // Add password visibility toggle if obscure text
    if (widget.obscureText) {
      suffixIcon = IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: colorScheme.onSurfaceVariant,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }

    switch (widget.variant) {
      case AppTextFieldVariant.outlined:
        return InputDecoration(
          hintText: widget.hint,
          errorText: widget.errorText,
          helperText: null,
          filled: false,
          prefixIcon: widget.prefixIcon,
          suffixIcon: suffixIcon,
          contentPadding: _getContentPadding(),
          border: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: colorScheme.outline),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: colorScheme.outline.withAlpha(150)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: colorScheme.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: colorScheme.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: colorScheme.error, width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: colorScheme.outline.withAlpha(100)),
          ),
        );

      case AppTextFieldVariant.filled:
        return InputDecoration(
          hintText: widget.hint,
          errorText: widget.errorText,
          helperText: null,
          filled: true,
          fillColor: defaultFillColor,
          prefixIcon: widget.prefixIcon,
          suffixIcon: suffixIcon,
          contentPadding: _getContentPadding(),
          border: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: colorScheme.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: colorScheme.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: colorScheme.error, width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide.none,
          ),
        );

      case AppTextFieldVariant.underline:
        return InputDecoration(
          hintText: widget.hint,
          errorText: widget.errorText,
          helperText: null,
          filled: false,
          prefixIcon: widget.prefixIcon,
          suffixIcon: suffixIcon,
          contentPadding: _getContentPadding(),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: colorScheme.outline),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colorScheme.outline),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colorScheme.primary, width: 2),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colorScheme.error),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colorScheme.error, width: 2),
          ),
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colorScheme.outline.withAlpha(100)),
          ),
        );
    }
  }

  EdgeInsetsGeometry _getContentPadding() {
    switch (widget.size) {
      case AppTextFieldSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 10);
      case AppTextFieldSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 14);
      case AppTextFieldSize.large:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 18);
    }
  }

  double _getBorderRadius() {
    switch (widget.size) {
      case AppTextFieldSize.small:
        return 8;
      case AppTextFieldSize.medium:
        return 12;
      case AppTextFieldSize.large:
        return 16;
    }
  }
}

/// Text field variants
enum AppTextFieldVariant {
  /// Outlined border
  outlined,

  /// Filled background with no border
  filled,

  /// Underline border only
  underline,
}

/// Text field sizes
enum AppTextFieldSize {
  /// Small text field
  small,

  /// Medium text field (default)
  medium,

  /// Large text field
  large,
}

/// A specialized text field for email input
class EmailTextField extends StatelessWidget {
  const EmailTextField({
    super.key,
    this.controller,
    this.label = 'Email',
    this.hint = 'Enter your email',
    this.errorText,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.focusNode,
    this.autofocus = false,
    this.initialValue,
  });

  final TextEditingController? controller;
  final String label;
  final String hint;
  final String? errorText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label: label,
      hint: hint,
      errorText: errorText,
      validator: validator,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      enabled: enabled,
      focusNode: focusNode,
      autofocus: autofocus,
      initialValue: initialValue,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.none,
      prefixIcon: const Icon(Icons.email_outlined),
    );
  }
}

/// A specialized text field for password input
class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    this.controller,
    this.label = 'Password',
    this.hint = 'Enter your password',
    this.errorText,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.focusNode,
    this.autofocus = false,
    this.initialValue,
    this.showStrengthIndicator = false,
  });

  final TextEditingController? controller;
  final String label;
  final String hint;
  final String? errorText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? initialValue;
  final bool showStrengthIndicator;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;
  String _password = '';

  @override
  void initState() {
    super.initState();
    _password = widget.controller?.text ?? widget.initialValue ?? '';
    widget.controller?.addListener(_onPasswordChange);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onPasswordChange);
    super.dispose();
  }

  void _onPasswordChange() {
    if (widget.showStrengthIndicator) {
      setState(() {
        _password = widget.controller?.text ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextField(
          controller: widget.controller,
          label: widget.label,
          hint: widget.hint,
          errorText: widget.errorText,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          enabled: widget.enabled,
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          initialValue: widget.initialValue,
          obscureText: _obscureText,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          prefixIcon: const Icon(Icons.lock_outlined),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
        if (widget.showStrengthIndicator && _password.isNotEmpty) ...[
          const SizedBox(height: 8),
          _PasswordStrengthIndicator(password: _password),
        ],
      ],
    );
  }
}

class _PasswordStrengthIndicator extends StatelessWidget {
  const _PasswordStrengthIndicator({required this.password});

  final String password;

  int get _strength {
    int strength = 0;
    if (password.length >= 8) strength++;
    if (password.length >= 12) strength++;
    if (RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password)) {
      strength++;
    }
    if (RegExp(r'[0-9]').hasMatch(password)) strength++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength++;
    return strength.clamp(0, 4);
  }

  String get _strengthLabel {
    switch (_strength) {
      case 0:
      case 1:
        return 'Weak';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Strong';
      default:
        return 'Weak';
    }
  }

  Color get _strengthColor {
    switch (_strength) {
      case 0:
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.lightGreen;
      case 4:
        return Colors.green;
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (index) {
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: index < 3 ? 4 : 0),
                decoration: BoxDecoration(
                  color: index < _strength
                      ? _strengthColor
                      : theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        Text(
          'Password strength: $_strengthLabel',
          style: theme.textTheme.bodySmall?.copyWith(
            color: _strengthColor,
          ),
        ),
      ],
    );
  }
}

/// A specialized text field for OTP input
class OtpTextField extends StatefulWidget {
  const OtpTextField({
    super.key,
    required this.length,
    this.onCompleted,
    this.onChanged,
    this.controller,
    this.enabled = true,
    this.autofocus = false,
    this.errorText,
  });

  final int length;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final bool enabled;
  final bool autofocus;
  final String? errorText;

  @override
  State<OtpTextField> createState() => _OtpTextFieldState();
}

class _OtpTextFieldState extends State<OtpTextField> {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
    _controllers = List.generate(
      widget.length,
      (index) => TextEditingController(
        text: widget.controller?.text.isNotEmpty == true
            ? widget.controller!.text[index]
            : null,
      ),
    );
  }

  @override
  void dispose() {
    for (final node in _focusNodes) {
      node.dispose();
    }
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  String get _otp => _controllers.map((c) => c.text).join();

  void _onChanged(int index, String value) {
    if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    final otp = _otp;
    widget.onChanged?.call(otp);

    if (otp.length == widget.length) {
      widget.onCompleted?.call(otp);
    }
  }

  void _onKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.length, (index) {
            return Container(
              width: 50,
              height: 56,
              margin: EdgeInsets.only(
                right: index < widget.length - 1 ? 8 : 0,
              ),
              child: KeyboardListener(
                focusNode: FocusNode(),
                onKeyEvent: (event) => _onKeyEvent(index, event),
                child: TextField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  enabled: widget.enabled,
                  autofocus: widget.autofocus && index == 0,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest,
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colorScheme.primary, width: 2),
                    ),
                    errorBorder: widget.errorText != null
                        ? OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: colorScheme.error),
                          )
                        : null,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) => _onChanged(index, value),
                ),
              ),
            );
          }),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.errorText!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }
}

/// A specialized text field for phone number input
class PhoneTextField extends StatelessWidget {
  const PhoneTextField({
    super.key,
    this.controller,
    this.label = 'Phone Number',
    this.hint = 'Enter your phone number',
    this.errorText,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.focusNode,
    this.autofocus = false,
    this.initialValue,
    this.defaultCountry = CountryCode.parse('TN'),
  });

  final PhoneController? controller;
  final String label;
  final String hint;
  final String? errorText;
  final String? Function(PhoneNumber?)? validator;
  final ValueChanged<PhoneNumber?>? onChanged;
  final bool enabled;
  final FocusNode? focusNode;
  final bool autofocus;
  final PhoneNumber? initialValue;
  final CountryCode defaultCountry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: enabled
                  ? colorScheme.onSurface
                  : colorScheme.onSurface.withAlpha(150),
            ),
          ),
          const SizedBox(height: 8),
        ],
        PhoneFormField(
          controller: controller,
          initialValue: initialValue,
          focusNode: focusNode,
          autofocus: autofocus,
          enabled: enabled,
          onChanged: onChanged,
          validator: validator,
          defaultCountry: defaultCountry,
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.error),
            ),
          ),
        ),
      ],
    );
  }
}

/// A text field with a dropdown selector
class DropdownTextField<T> extends StatelessWidget {
  const DropdownTextField({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.label,
    this.hint = 'Select an option',
    this.enabled = true,
    this.prefixIcon,
    this.validator,
    this.itemBuilder,
  });

  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final T? value;
  final String? label;
  final String hint;
  final bool enabled;
  final Widget? prefixIcon;
  final String? Function(T?)? validator;
  final Widget Function(T)? itemBuilder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: enabled
                  ? colorScheme.onSurface
                  : colorScheme.onSurface.withAlpha(150),
            ),
          ),
          const SizedBox(height: 8),
        ],
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: enabled ? onChanged : null,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest,
            prefixIcon: prefixIcon,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.error),
            ),
          ),
          icon: const Icon(Icons.keyboard_arrow_down),
          dropdownColor: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
      ],
    );
  }
}

/// A search text field with clear button
class SearchTextField extends StatefulWidget {
  const SearchTextField({
    super.key,
    this.controller,
    this.hint = 'Search...',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.autofocus = false,
    this.enabled = true,
  });

  final TextEditingController? controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final bool autofocus;
  final bool enabled;

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_onTextChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChange);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTextChange() {
    setState(() {
      _hasText = _controller.text.isNotEmpty;
    });
  }

  void _onClear() {
    _controller.clear();
    widget.onClear?.call();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextField(
      controller: _controller,
      autofocus: widget.autofocus,
      enabled: widget.enabled,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: widget.hint,
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _hasText
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _onClear,
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),
    );
  }
}

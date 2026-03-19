import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// App localizations configuration
/// Provides internationalization support using the intl package
class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  // ============================================================
  // Singleton Pattern
  // ============================================================

  static AppLocalizations? _instance;

  static AppLocalizations get instance {
    if (_instance == null) {
      throw StateError('AppLocalizations not initialized. Call AppLocalizations.delegate.load() first.');
    }
    return _instance!;
  }

  // ============================================================
  // Helper Methods
  // ============================================================

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'), // English
    Locale('ar', 'TN'), // Arabic (Tunisia)
    Locale('fr', 'FR'), // French
  ];

  // ============================================================
  // Locale Resolution
  // ============================================================

  static Locale localeResolutionCallback(
    Locale? locale,
    Iterable<Locale> supportedLocales,
  ) {
    // If the locale is null, return English
    if (locale == null) {
      return const Locale('en', 'US');
    }

    // Check if the locale is supported
    for (final supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return supportedLocale;
      }
    }

    // Default to English
    return const Locale('en', 'US');
  }

  // ============================================================
  // Text Direction
  // ============================================================

  /// Check if the current locale is RTL (Right-to-Left)
  bool get isRTL {
    return locale.languageCode == 'ar';
  }

  /// Get the text direction based on locale
  TextDirection get textDirection {
    return isRTL ? TextDirection.rtl : TextDirection.ltr;
  }

  // ============================================================
  // Language Info
  // ============================================================

  /// Get the language name in its own language
  String get languageName {
    switch (locale.languageCode) {
      case 'ar':
        return 'العربية';
      case 'fr':
        return 'Français';
      default:
        return 'English';
    }
  }

  /// Get the language name in English
  String get languageNameInEnglish {
    switch (locale.languageCode) {
      case 'ar':
        return 'Arabic';
      case 'fr':
        return 'French';
      default:
        return 'English';
    }
  }

  // ============================================================
  // App Strings
  // ============================================================

  // App Info
  String get appName => _t('appName', defaultValue: 'Masarat');
  String get appTagline => _t('appTagline', defaultValue: 'Your journey starts here');

  // Common
  String get ok => _t('ok', defaultValue: 'OK');
  String get cancel => _t('cancel', defaultValue: 'Cancel');
  String get confirm => _t('confirm', defaultValue: 'Confirm');
  String get save => _t('save', defaultValue: 'Save');
  String get delete => _t('delete', defaultValue: 'Delete');
  String get edit => _t('edit', defaultValue: 'Edit');
  String get add => _t('add', defaultValue: 'Add');
  String get remove => _t('remove', defaultValue: 'Remove');
  String get close => _t('close', defaultValue: 'Close');
  String get done => _t('done', defaultValue: 'Done');
  String get next => _t('next', defaultValue: 'Next');
  String get previous => _t('previous', defaultValue: 'Previous');
  String get skip => _t('skip', defaultValue: 'Skip');
  String get retry => _t('retry', defaultValue: 'Retry');
  String get loading => _t('loading', defaultValue: 'Loading...');
  String get noData => _t('noData', defaultValue: 'No data available');
  String get error => _t('error', defaultValue: 'Error');
  String get success => _t('success', defaultValue: 'Success');
  String get warning => _t('warning', defaultValue: 'Warning');
  String get info => _t('info', defaultValue: 'Info');

  // Navigation
  String get home => _t('home', defaultValue: 'Home');
  String get explore => _t('explore', defaultValue: 'Explore');
  String get profile => _t('profile', defaultValue: 'Profile');
  String get settings => _t('settings', defaultValue: 'Settings');
  String get notifications => _t('notifications', defaultValue: 'Notifications');
  String get search => _t('search', defaultValue: 'Search');
  String get filter => _t('filter', defaultValue: 'Filter');
  String get sort => _t('sort', defaultValue: 'Sort');

  // Auth
  String get login => _t('login', defaultValue: 'Login');
  String get register => _t('register', defaultValue: 'Register');
  String get logout => _t('logout', defaultValue: 'Logout');
  String get signUp => _t('signUp', defaultValue: 'Sign Up');
  String get signIn => _t('signIn', defaultValue: 'Sign In');
  String get forgotPassword => _t('forgotPassword', defaultValue: 'Forgot Password?');
  String get resetPassword => _t('resetPassword', defaultValue: 'Reset Password');
  String get newPassword => _t('newPassword', defaultValue: 'New Password');
  String get confirmPassword => _t('confirmPassword', defaultValue: 'Confirm Password');
  String get verifyEmail => _t('verifyEmail', defaultValue: 'Verify Email');
  String get verifyPhone => _t('verifyPhone', defaultValue: 'Verify Phone');
  String get resendCode => _t('resendCode', defaultValue: 'Resend Code');
  String get verificationCode => _t('verificationCode', defaultValue: 'Verification Code');
  String get noAccount => _t('noAccount', defaultValue: "Don't have an account?");
  String get haveAccount => _t('haveAccount', defaultValue: 'Already have an account?');
  String get orSignInWith => _t('orSignInWith', defaultValue: 'Or sign in with');
  String get orSignUpWith => _t('orSignUpWith', defaultValue: 'Or sign up with');
  String get continueAsGuest => _t('continueAsGuest', defaultValue: 'Continue as Guest');
  String get termsAndConditions => _t('termsAndConditions', defaultValue: 'Terms & Conditions');
  String get privacyPolicy => _t('privacyPolicy', defaultValue: 'Privacy Policy');
  String get agreeToTerms => _t('agreeToTerms', defaultValue: 'I agree to the Terms & Conditions');

  // Form Labels
  String get email => _t('email', defaultValue: 'Email');
  String get password => _t('password', defaultValue: 'Password');
  String get firstName => _t('firstName', defaultValue: 'First Name');
  String get lastName => _t('lastName', defaultValue: 'Last Name');
  String get fullName => _t('fullName', defaultValue: 'Full Name');
  String get username => _t('username', defaultValue: 'Username');
  String get phoneNumber => _t('phoneNumber', defaultValue: 'Phone Number');
  String get address => _t('address', defaultValue: 'Address');
  String get city => _t('city', defaultValue: 'City');
  String get country => _t('country', defaultValue: 'Country');
  String get bio => _t('bio', defaultValue: 'Bio');
  String get description => _t('description', defaultValue: 'Description');
  String get title => _t('title', defaultValue: 'Title');
  String get name => _t('name', defaultValue: 'Name');
  String get message => _t('message', defaultValue: 'Message');
  String get subject => _t('subject', defaultValue: 'Subject');
  String get date => _t('date', defaultValue: 'Date');
  String get time => _t('time', defaultValue: 'Time');
  String get status => _t('status', defaultValue: 'Status');

  // Validation Messages
  String get fieldRequired => _t('fieldRequired', defaultValue: 'This field is required');
  String get invalidEmail => _t('invalidEmail', defaultValue: 'Please enter a valid email');
  String get invalidPhone => _t('invalidPhone', defaultValue: 'Please enter a valid phone number');
  String get passwordTooShort => _t('passwordTooShort', defaultValue: 'Password must be at least 8 characters');
  String get passwordMismatch => _t('passwordMismatch', defaultValue: 'Passwords do not match');
  String get invalidUsername => _t('invalidUsername', defaultValue: 'Username can only contain letters, numbers, and underscores');

  // Error Messages
  String get genericError => _t('genericError', defaultValue: 'Something went wrong. Please try again.');
  String get networkError => _t('networkError', defaultValue: 'Please check your internet connection.');
  String get sessionExpired => _t('sessionExpired', defaultValue: 'Your session has expired. Please login again.');
  String get unauthorized => _t('unauthorized', defaultValue: 'You are not authorized to perform this action.');
  String get serverError => _t('serverError', defaultValue: 'Server error. Please try again later.');
  String get notFound => _t('notFound', defaultValue: 'The requested resource was not found.');
  String get invalidCredentials => _t('invalidCredentials', defaultValue: 'Invalid email or password.');
  String get emailAlreadyExists => _t('emailAlreadyExists', defaultValue: 'An account with this email already exists.');
  String get userNotFound => _t('userNotFound', defaultValue: 'No account found with this email.');
  String get tooManyAttempts => _t('tooManyAttempts', defaultValue: 'Too many attempts. Please try again later.');

  // Success Messages
  String get loginSuccess => _t('loginSuccess', defaultValue: 'Login successful!');
  String get registerSuccess => _t('registerSuccess', defaultValue: 'Account created successfully!');
  String get passwordResetSent => _t('passwordResetSent', defaultValue: 'Password reset email sent!');
  String get passwordChanged => _t('passwordChanged', defaultValue: 'Password changed successfully!');
  String get profileUpdated => _t('profileUpdated', defaultValue: 'Profile updated successfully!');
  String get emailVerified => _t('emailVerified', defaultValue: 'Email verified successfully!');

  // Actions
  String get viewAll => _t('viewAll', defaultValue: 'View All');
  String get seeMore => _t('seeMore', defaultValue: 'See More');
  String get learnMore => _t('learnMore', defaultValue: 'Learn More');
  String get getStarted => _t('getStarted', defaultValue: 'Get Started');
  String get tryAgain => _t('tryAgain', defaultValue: 'Try Again');
  String get refresh => _t('refresh', defaultValue: 'Refresh');
  String get share => _t('share', defaultValue: 'Share');
  String get copy => _t('copy', defaultValue: 'Copy');
  String get download => _t('download', defaultValue: 'Download');
  String get upload => _t('upload', defaultValue: 'Upload');
  String get takePhoto => _t('takePhoto', defaultValue: 'Take Photo');
  String get chooseFromGallery => _t('chooseFromGallery', defaultValue: 'Choose from Gallery');
  String get editProfile => _t('editProfile', defaultValue: 'Edit Profile');
  String get changePassword => _t('changePassword', defaultValue: 'Change Password');
  String get changeLanguage => _t('changeLanguage', defaultValue: 'Change Language');
  String get changeTheme => _t('changeTheme', defaultValue: 'Change Theme');
  String get enableNotifications => _t('enableNotifications', defaultValue: 'Enable Notifications');
  String get clearCache => _t('clearCache', defaultValue: 'Clear Cache');
  String get deleteAccount => _t('deleteAccount', defaultValue: 'Delete Account');
  String get logOut => _t('logOut', defaultValue: 'Log Out');

  // Settings
  String get account => _t('account', defaultValue: 'Account');
  String get appearance => _t('appearance', defaultValue: 'Appearance');
  String get language => _t('language', defaultValue: 'Language');
  String get theme => _t('theme', defaultValue: 'Theme');
  String get darkMode => _t('darkMode', defaultValue: 'Dark Mode');
  String get lightMode => _t('lightMode', defaultValue: 'Light Mode');
  String get systemDefault => _t('systemDefault', defaultValue: 'System Default');
  String get notificationSettings => _t('notificationSettings', defaultValue: 'Notification Settings');
  String get pushNotifications => _t('pushNotifications', defaultValue: 'Push Notifications');
  String get emailNotifications => _t('emailNotifications', defaultValue: 'Email Notifications');
  String get about => _t('about', defaultValue: 'About');
  String get version => _t('version', defaultValue: 'Version');
  String get contactUs => _t('contactUs', defaultValue: 'Contact Us');
  String get rateApp => _t('rateApp', defaultValue: 'Rate App');
  String get helpCenter => _t('helpCenter', defaultValue: 'Help Center');
  String get faq => _t('faq', defaultValue: 'FAQ');

  // Onboarding
  String get welcome => _t('welcome', defaultValue: 'Welcome!');
  String get welcomeMessage => _t('welcomeMessage', defaultValue: 'Welcome to Masarat');
  String get onboardingTitle1 => _t('onboardingTitle1', defaultValue: 'Discover Amazing Places');
  String get onboardingDesc1 => _t('onboardingDesc1', defaultValue: 'Explore thousands of destinations around the world');
  String get onboardingTitle2 => _t('onboardingTitle2', defaultValue: 'Plan Your Journey');
  String get onboardingDesc2 => _t('onboardingDesc2', defaultValue: 'Create personalized itineraries with ease');
  String get onboardingTitle3 => _t('onboardingTitle3', defaultValue: 'Share Experiences');
  String get onboardingDesc3 => _t('onboardingDesc3', defaultValue: 'Connect with travelers and share your stories');

  // Time
  String get justNow => _t('justNow', defaultValue: 'Just now');
  String get minutesAgo => _t('minutesAgo', defaultValue: 'minutes ago');
  String get hoursAgo => _t('hoursAgo', defaultValue: 'hours ago');
  String get daysAgo => _t('daysAgo', defaultValue: 'days ago');
  String get weeksAgo => _t('weeksAgo', defaultValue: 'weeks ago');
  String get monthsAgo => _t('monthsAgo', defaultValue: 'months ago');
  String get yearsAgo => _t('yearsAgo', defaultValue: 'years ago');

  // Confirmation Dialogs
  String get confirmLogout => _t('confirmLogout', defaultValue: 'Are you sure you want to logout?');
  String get confirmDelete => _t('confirmDelete', defaultValue: 'Are you sure you want to delete this?');
  String get confirmDeleteAccount => _t('confirmDeleteAccount', defaultValue: 'Are you sure you want to delete your account? This action cannot be undone.');
  String get yes => _t('yes', defaultValue: 'Yes');
  String get no => _t('no', defaultValue: 'No');

  // ============================================================
  // Translation Helper
  // ============================================================

  String _t(String key, {String defaultValue = ''}) {
    // Get the translation from the appropriate map
    final translations = _getTranslations();
    return translations[key] ?? defaultValue;
  }

  Map<String, String> _getTranslations() {
    switch (locale.languageCode) {
      case 'ar':
        return _arabicTranslations;
      case 'fr':
        return _frenchTranslations;
      default:
        return _englishTranslations;
    }
  }

  // ============================================================
  // English Translations
  // ============================================================

  static const Map<String, String> _englishTranslations = {
    'appName': 'Masarat',
    'appTagline': 'Your journey starts here',
    'ok': 'OK',
    'cancel': 'Cancel',
    'confirm': 'Confirm',
    'save': 'Save',
    'delete': 'Delete',
    'edit': 'Edit',
    'add': 'Add',
    'remove': 'Remove',
    'close': 'Close',
    'done': 'Done',
    'next': 'Next',
    'previous': 'Previous',
    'skip': 'Skip',
    'retry': 'Retry',
    'loading': 'Loading...',
    'noData': 'No data available',
    'error': 'Error',
    'success': 'Success',
    'warning': 'Warning',
    'info': 'Info',
    'home': 'Home',
    'explore': 'Explore',
    'profile': 'Profile',
    'settings': 'Settings',
    'notifications': 'Notifications',
    'search': 'Search',
    'filter': 'Filter',
    'sort': 'Sort',
    'login': 'Login',
    'register': 'Register',
    'logout': 'Logout',
    'signUp': 'Sign Up',
    'signIn': 'Sign In',
    'forgotPassword': 'Forgot Password?',
    'resetPassword': 'Reset Password',
    'newPassword': 'New Password',
    'confirmPassword': 'Confirm Password',
    'verifyEmail': 'Verify Email',
    'verifyPhone': 'Verify Phone',
    'resendCode': 'Resend Code',
    'verificationCode': 'Verification Code',
    'noAccount': "Don't have an account?",
    'haveAccount': 'Already have an account?',
    'orSignInWith': 'Or sign in with',
    'orSignUpWith': 'Or sign up with',
    'continueAsGuest': 'Continue as Guest',
    'termsAndConditions': 'Terms & Conditions',
    'privacyPolicy': 'Privacy Policy',
    'agreeToTerms': 'I agree to the Terms & Conditions',
  };

  // ============================================================
  // Arabic Translations
  // ============================================================

  static const Map<String, String> _arabicTranslations = {
    'appName': 'مسارات',
    'appTagline': 'رحلتك تبدأ من هنا',
    'ok': 'موافق',
    'cancel': 'إلغاء',
    'confirm': 'تأكيد',
    'save': 'حفظ',
    'delete': 'حذف',
    'edit': 'تعديل',
    'add': 'إضافة',
    'remove': 'إزالة',
    'close': 'إغلاق',
    'done': 'تم',
    'next': 'التالي',
    'previous': 'السابق',
    'skip': 'تخطي',
    'retry': 'إعادة المحاولة',
    'loading': 'جاري التحميل...',
    'noData': 'لا توجد بيانات',
    'error': 'خطأ',
    'success': 'نجاح',
    'warning': 'تحذير',
    'info': 'معلومات',
    'home': 'الرئيسية',
    'explore': 'استكشف',
    'profile': 'الملف الشخصي',
    'settings': 'الإعدادات',
    'notifications': 'الإشعارات',
    'search': 'بحث',
    'filter': 'تصفية',
    'sort': 'ترتيب',
    'login': 'تسجيل الدخول',
    'register': 'إنشاء حساب',
    'logout': 'تسجيل الخروج',
    'signUp': 'إنشاء حساب',
    'signIn': 'تسجيل الدخول',
    'forgotPassword': 'نسيت كلمة المرور؟',
    'resetPassword': 'إعادة تعيين كلمة المرور',
    'newPassword': 'كلمة المرور الجديدة',
    'confirmPassword': 'تأكيد كلمة المرور',
    'verifyEmail': 'تأكيد البريد الإلكتروني',
    'verifyPhone': 'تأكيد رقم الهاتف',
    'resendCode': 'إعادة إرسال الكود',
    'verificationCode': 'رمز التحقق',
    'noAccount': 'ليس لديك حساب؟',
    'haveAccount': 'لديك حساب بالفعل؟',
    'orSignInWith': 'أو سجل الدخول بواسطة',
    'orSignUpWith': 'أو أنشئ حساب بواسطة',
    'continueAsGuest': 'المتابعة كزائر',
    'termsAndConditions': 'الشروط والأحكام',
    'privacyPolicy': 'سياسة الخصوصية',
    'agreeToTerms': 'أوافق على الشروط والأحكام',
  };

  // ============================================================
  // French Translations
  // ============================================================

  static const Map<String, String> _frenchTranslations = {
    'appName': 'Masarat',
    'appTagline': 'Votre voyage commence ici',
    'ok': 'OK',
    'cancel': 'Annuler',
    'confirm': 'Confirmer',
    'save': 'Enregistrer',
    'delete': 'Supprimer',
    'edit': 'Modifier',
    'add': 'Ajouter',
    'remove': 'Retirer',
    'close': 'Fermer',
    'done': 'Terminé',
    'next': 'Suivant',
    'previous': 'Précédent',
    'skip': 'Passer',
    'retry': 'Réessayer',
    'loading': 'Chargement...',
    'noData': 'Aucune donnée disponible',
    'error': 'Erreur',
    'success': 'Succès',
    'warning': 'Avertissement',
    'info': 'Info',
    'home': 'Accueil',
    'explore': 'Explorer',
    'profile': 'Profil',
    'settings': 'Paramètres',
    'notifications': 'Notifications',
    'search': 'Rechercher',
    'filter': 'Filtrer',
    'sort': 'Trier',
    'login': 'Connexion',
    'register': "S'inscrire",
    'logout': 'Déconnexion',
    'signUp': "S'inscrire",
    'signIn': 'Se connecter',
    'forgotPassword': 'Mot de passe oublié ?',
    'resetPassword': 'Réinitialiser le mot de passe',
    'newPassword': 'Nouveau mot de passe',
    'confirmPassword': 'Confirmer le mot de passe',
    'verifyEmail': 'Vérifier email',
    'verifyPhone': 'Vérifier téléphone',
    'resendCode': 'Renvoyer le code',
    'verificationCode': 'Code de vérification',
    'noAccount': "Vous n'avez pas de compte ?",
    'haveAccount': 'Vous avez déjà un compte ?',
    'orSignInWith': 'Ou connectez-vous avec',
    'orSignUpWith': "Ou inscrivez-vous avec",
    'continueAsGuest': 'Continuer en tant qu\'invité',
    'termsAndConditions': 'Conditions générales',
    'privacyPolicy': 'Politique de confidentialité',
    'agreeToTerms': "J'accepte les conditions générales",
  };
}

/// Localizations delegate for AppLocalizations
class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar', 'fr'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // Initialize intl with the locale
    Intl.defaultLocale = locale.toString();

    // Create and return the localizations instance
    final localizations = AppLocalizations(locale);
    AppLocalizations._instance = localizations;

    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

/// Extension on BuildContext for easy access to localizations
extension LocalizationExtension on BuildContext {
  /// Get the localizations instance
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  /// Get the current locale
  Locale get locale => Localizations.localeOf(this);

  /// Check if the current locale is RTL
  bool get isRTL => l10n.isRTL;

  /// Get the text direction
  TextDirection get textDirection => l10n.textDirection;
}

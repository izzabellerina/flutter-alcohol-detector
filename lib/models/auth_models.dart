enum ContactType { phone, email }

class OtpRequest {
  const OtpRequest({
    required this.contactType,
    required this.maskedContact,
    required this.referenceCode,
  });

  final ContactType contactType;
  final String maskedContact;
  final String referenceCode;

  String get destinationLabel => contactType == ContactType.phone
      ? 'หมายเลข $maskedContact'
      : 'อีเมล์ $maskedContact';
}

class ContactValidator {
  ContactValidator._();

  static final RegExp _emailPattern = RegExp(
    r'^[\w\.\-]+@[\w\-]+\.[\w\-\.]+$',
  );
  static final RegExp _phonePattern = RegExp(r'^0\d{8,9}$');

  static ContactType? detect(String value) {
    final trimmed = value.trim();
    if (_emailPattern.hasMatch(trimmed)) return ContactType.email;
    final digitsOnly = trimmed.replaceAll(RegExp(r'[\s\-]'), '');
    if (_phonePattern.hasMatch(digitsOnly)) return ContactType.phone;
    return null;
  }

  /// "0812345678" → "081-234-xxxx"
  static String maskPhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'[\s\-]'), '');
    if (digits.length < 7) return digits;
    final prefix = digits.substring(0, 3);
    final middle = digits.substring(3, 6);
    return '$prefix-$middle-xxxx';
  }

  /// "demo@gmail.com" → "dem*********com"
  static String maskEmail(String email) {
    final at = email.indexOf('@');
    if (at <= 0) return email;
    final local = email.substring(0, at);
    final domain = email.substring(at + 1);
    final visibleLocal = local.length <= 3
        ? local
        : local.substring(0, 3);
    final dot = domain.lastIndexOf('.');
    final tld = dot >= 0 ? domain.substring(dot + 1) : '';
    final hiddenLength = email.length - visibleLocal.length - tld.length;
    final stars = '*' * hiddenLength.clamp(3, 12);
    return '$visibleLocal$stars$tld';
  }
}

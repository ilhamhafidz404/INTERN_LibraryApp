String getInitials(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));

  if (parts.length == 1) {
    final word = parts[0];
    final firstTwo = word.length >= 2
        ? word.substring(0, 2).toUpperCase()
        : word.toUpperCase(); // kalau cuma 1 huruf
    return firstTwo.split('').join(' ');
  } else {
    final initials = parts.map((part) => part[0].toUpperCase()).join(' ');
    return initials;
  }
}

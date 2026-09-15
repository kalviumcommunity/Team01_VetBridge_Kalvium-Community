// ===== lib/core/utils/formatters.dart =====
class Fmt {
  Fmt._();

  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  static const _daysShort = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  static String date(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';
  static String dayShort(DateTime d) => '${_daysShort[d.weekday - 1]}, ${d.day} ${_months[d.month - 1]}';
  static String time(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  static String weight(double? kg) => kg == null ? '—' : '$kg kg';
}

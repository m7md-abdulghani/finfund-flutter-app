import 'package:intl/intl.dart';

class Formatters {
  static String formatCurrency(double amount) {
    final formatter = NumberFormat('#,##0', 'ar');
    return '${formatter.format(amount)} ر.س';
  }

  static String formatCurrencyCompact(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}م ر.س';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}ك ر.س';
    }
    return formatCurrency(amount);
  }

  static String formatPercentage(double value) {
    return '${value.toStringAsFixed(1)}%';
  }

  static String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('yyyy/MM/dd', 'ar').format(date);
    } catch (e) {
      return dateString;
    }
  }

  static String formatPhone(String phone) {
    if (phone.length == 10) {
      return '${phone.substring(0, 3)} ${phone.substring(3, 6)} ${phone.substring(6)}';
    }
    return phone;
  }

  static String getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'قيد المراجعة';
      case 'approved':
        return 'تمت الموافقة';
      case 'awaiting_signature':
        return 'بانتظار التوقيع';
      case 'ready_to_fund':
        return 'جاهز للتمويل';
      case 'funded':
        return 'تم التمويل';
      case 'rejected':
        return 'مرفوض';
      default:
        return status;
    }
  }

  static String getDurationLabel(int months) {
    if (months == 1) return 'شهر واحد';
    if (months == 2) return 'شهران';
    if (months <= 10) return '$months أشهر';
    return '$months شهر';
  }
}

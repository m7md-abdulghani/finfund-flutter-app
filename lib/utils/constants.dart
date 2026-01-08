import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryDark = Color(0xFF1a5c45);
  static const Color primaryLight = Color(0xFF1f6b50);
  static const Color accent = Color(0xFF3dbf99);
  static const Color accentDark = Color(0xFF2ca882);
  static const Color accentLight = Color(0xFF5dd9b3);
  static const Color background = Color(0xFFF5F5F5);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF1a1a1a);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textMuted = Color(0xFF999999);
  static const Color border = Color(0xFFE0E0E0);
  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF43A047);
  static const Color warning = Color(0xFFFFA000);
  static const Color gold = Color(0xFFD4AF37);
}

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.textMuted,
  );
}

class AppDurations {
  static const List<Map<String, dynamic>> fundDurations = [
    {'months': 3, 'label': '٣ أشهر', 'return': 5.0},
    {'months': 6, 'label': '٦ أشهر', 'return': 8.0},
    {'months': 9, 'label': '٩ أشهر', 'return': 11.0},
    {'months': 12, 'label': '١٢ شهر', 'return': 15.0},
  ];
}

class MockData {
  static final List<Map<String, dynamic>> funds = [
    {
      'id': '1',
      'name': 'صندوق النمو السريع',
      'durationMonths': 3,
      'expectedReturn': 5.0,
      'totalInvested': 150000.0,
      'targetAmount': 500000.0,
    },
    {
      'id': '2',
      'name': 'صندوق الاستثمار المتوازن',
      'durationMonths': 6,
      'expectedReturn': 8.0,
      'totalInvested': 320000.0,
      'targetAmount': 750000.0,
    },
    {
      'id': '3',
      'name': 'صندوق العائد المرتفع',
      'durationMonths': 9,
      'expectedReturn': 11.0,
      'totalInvested': 480000.0,
      'targetAmount': 1000000.0,
    },
    {
      'id': '4',
      'name': 'صندوق الاستثمار طويل الأجل',
      'durationMonths': 12,
      'expectedReturn': 15.0,
      'totalInvested': 890000.0,
      'targetAmount': 2000000.0,
    },
  ];

  static final List<Map<String, dynamic>> myInvestments = [
    {
      'id': '1',
      'fundName': 'صندوق النمو السريع',
      'amount': 10000.0,
      'expectedProfit': 500.0,
      'durationMonths': 3,
      'createdAt': '2025-01-01',
    },
    {
      'id': '2',
      'fundName': 'صندوق الاستثمار المتوازن',
      'amount': 25000.0,
      'expectedProfit': 2000.0,
      'durationMonths': 6,
      'createdAt': '2024-12-15',
    },
  ];

  static final List<Map<String, dynamic>> myFundingRequests = [
    {
      'id': '1',
      'amount': 50000.0,
      'duration': 6,
      'purpose': 'توسيع المشروع',
      'status': 'pending',
      'monthlyInstallment': 8750.0,
      'createdAt': '2025-01-05',
    },
    {
      'id': '2',
      'amount': 30000.0,
      'duration': 3,
      'purpose': 'شراء معدات',
      'status': 'approved',
      'monthlyInstallment': 10500.0,
      'contractSigned': false,
      'promissoryNoteSigned': false,
      'createdAt': '2024-12-20',
    },
  ];

  static final Map<String, dynamic> adminStats = {
    'totalUsers': 1250,
    'totalInvestors': 450,
    'totalFundingSeekers': 800,
    'totalInvestments': 5500000.0,
    'totalFundedAmount': 3200000.0,
    'pendingRequests': 45,
    'approvedRequests': 120,
    'fundedRequests': 85,
    'rejectedRequests': 15,
    'totalAdminFees': 32000.0,
  };
}

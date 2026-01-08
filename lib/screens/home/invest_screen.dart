import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';

class InvestScreen extends StatefulWidget {
  final Map<String, dynamic> fund;

  const InvestScreen({super.key, required this.fund});

  @override
  State<InvestScreen> createState() => _InvestScreenState();
}

class _InvestScreenState extends State<InvestScreen> {
  final _amountController = TextEditingController();
  bool _isLoading = false;
  bool _showSuccess = false;

  double get _amount => double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0;
  double get _expectedProfit => _amount * (widget.fund['expectedReturn'] as double) / 100;
  double get _totalReturn => _amount + _expectedProfit;
  bool get _isValidAmount => _amount >= 1000;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(() => setState(() {}));
  }

  Future<void> _handleInvest() async {
    if (!_isValidAmount) return;

    setState(() => _isLoading = true);
    
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _isLoading = false;
      _showSuccess = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSuccess) {
      return _buildSuccessScreen();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        title: const Text('استثمار'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildFundHeader(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAmountInput(),
                  const SizedBox(height: 24),
                  _buildCalculationCard(),
                  const SizedBox(height: 24),
                  _buildTermsCard(),
                  const SizedBox(height: 32),
                  _buildInvestButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFundHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primaryLight],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          Text(
            widget.fund['name'],
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFundStat(
                '${widget.fund['durationMonths']}',
                'شهر',
                Icons.access_time,
              ),
              Container(
                width: 1,
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                color: Colors.white.withOpacity(0.2),
              ),
              _buildFundStat(
                '${widget.fund['expectedReturn']}%',
                'العائد المتوقع',
                Icons.trending_up,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFundStat(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.7), size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'مبلغ الاستثمار',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              hintText: '0',
              hintStyle: TextStyle(
                fontSize: 28,
                color: Colors.grey[300],
              ),
              suffixText: 'ر.س',
              suffixStyle: TextStyle(
                fontSize: 18,
                color: AppColors.textMuted,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(20),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'الحد الأدنى ١,٠٠٠ ر.س',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildQuickAmountButton(1000),
            const SizedBox(width: 8),
            _buildQuickAmountButton(5000),
            const SizedBox(width: 8),
            _buildQuickAmountButton(10000),
            const SizedBox(width: 8),
            _buildQuickAmountButton(25000),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAmountButton(int amount) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () {
          _amountController.text = amount.toString();
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryDark,
          side: BorderSide(color: AppColors.primaryDark.withOpacity(0.3)),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          '${amount ~/ 1000}ك',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildCalculationCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildCalculationRow(
            'مبلغ الاستثمار',
            Formatters.formatCurrency(_amount),
            icon: Icons.account_balance_wallet,
          ),
          const Divider(height: 24),
          _buildCalculationRow(
            'العائد المتوقع',
            Formatters.formatCurrency(_expectedProfit),
            icon: Icons.trending_up,
            valueColor: AppColors.success,
          ),
          const Divider(height: 24),
          _buildCalculationRow(
            'إجمالي العائد',
            Formatters.formatCurrency(_totalReturn),
            icon: Icons.savings,
            valueColor: AppColors.primaryDark,
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildCalculationRow(
    String label,
    String value, {
    required IconData icon,
    Color? valueColor,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: AppColors.textMuted),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 18 : 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildTermsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryDark.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryDark.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 18, color: AppColors.primaryDark),
              const SizedBox(width: 8),
              const Text(
                'شروط الاستثمار',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTermItem('مدة الاستثمار ${widget.fund['durationMonths']} أشهر'),
          _buildTermItem('العائد يُحتسب على أساس سنوي'),
          _buildTermItem('لا يمكن سحب المبلغ قبل انتهاء المدة'),
        ],
      ),
    );
  }

  Widget _buildTermItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            size: 16,
            color: AppColors.accent,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvestButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading || !_isValidAmount ? null : _handleInvest,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primaryDark.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Text(
                'تأكيد الاستثمار',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildSuccessScreen() {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 56,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'تم الاستثمار بنجاح!',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'تم استثمار ${Formatters.formatCurrency(_amount)} في ${widget.fund['name']}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'العودة للرئيسية',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}

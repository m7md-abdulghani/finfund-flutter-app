import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../home/main_screen.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final List<TextEditingController> _pinControllers = List.generate(4, (_) => TextEditingController());
  final List<TextEditingController> _confirmControllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _pinFocusNodes = List.generate(4, (_) => FocusNode());
  final List<FocusNode> _confirmFocusNodes = List.generate(4, (_) => FocusNode());

  String _step = 'create';
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pinFocusNodes[0].requestFocus();
    });
  }

  void _onChanged(int index, String value, bool isConfirm) {
    final controllers = isConfirm ? _confirmControllers : _pinControllers;
    final focusNodes = isConfirm ? _confirmFocusNodes : _pinFocusNodes;

    if (value.isNotEmpty && index < 3) {
      focusNodes[index + 1].requestFocus();
    }

    final pin = controllers.map((c) => c.text).join();
    if (pin.length == 4) {
      if (!isConfirm) {
        setState(() => _step = 'confirm');
        Future.delayed(const Duration(milliseconds: 100), () {
          _confirmFocusNodes[0].requestFocus();
        });
      } else {
        _handleSubmit(pin);
      }
    }
  }

  Future<void> _handleSubmit(String confirmPin) async {
    final originalPin = _pinControllers.map((c) => c.text).join();

    if (originalPin != confirmPin) {
      setState(() {
        _error = 'الرمز السري غير متطابق';
        for (var c in _confirmControllers) {
          c.clear();
        }
      });
      _confirmFocusNodes[0].requestFocus();
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.setPin(originalPin);

    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
        (route) => false,
      );
    } else {
      setState(() => _error = 'فشل في تعيين الرمز السري');
    }
  }

  void _resetPin() {
    setState(() {
      _step = 'create';
      _error = null;
      for (var c in _pinControllers) {
        c.clear();
      }
      for (var c in _confirmControllers) {
        c.clear();
      }
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      _pinFocusNodes[0].requestFocus();
    });
  }

  Widget _buildPinInput(List<TextEditingController> controllers, List<FocusNode> focusNodes, bool isConfirm) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (index) {
          return Container(
            width: 64,
            height: 72,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            child: TextField(
              controller: controllers[index],
              focusNode: focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              obscureText: true,
              obscuringCharacter: '●',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: AppColors.accent,
                    width: 2,
                  ),
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (value) => _onChanged(index, value, isConfirm),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),

              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_outline,
                  size: 40,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                _step == 'create' ? 'إنشاء رمز سري' : 'تأكيد الرمز السري',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _step == 'create'
                    ? 'أنشئ رمز سري من 4 أرقام لتأمين حسابك'
                    : 'أعد إدخال الرمز السري للتأكيد',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              if (_step == 'create')
                _buildPinInput(_pinControllers, _pinFocusNodes, false)
              else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (i) {
                    return Container(
                      width: 16,
                      height: 16,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accent,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accent.withOpacity(0.4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 32),
                _buildPinInput(_confirmControllers, _confirmFocusNodes, true),
              ],

              if (_error != null) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Text(_error!, style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],

              if (_isLoading) ...[
                const SizedBox(height: 24),
                const CircularProgressIndicator(color: AppColors.accent),
              ],

              if (_step == 'confirm') ...[
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: _resetPin,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('إعادة المحاولة'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white.withOpacity(0.3)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],

              const Spacer(),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shield_outlined, size: 18, color: Colors.white.withOpacity(0.7)),
                    const SizedBox(width: 8),
                    Text(
                      'رمزك السري مشفر ومحمي بالكامل',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var c in _pinControllers) {
      c.dispose();
    }
    for (var c in _confirmControllers) {
      c.dispose();
    }
    for (var f in _pinFocusNodes) {
      f.dispose();
    }
    for (var f in _confirmFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }
}

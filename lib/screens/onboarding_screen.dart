import 'package:flutter/material.dart';
import '../theme.dart';
import '../main.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final List<String> _options = ['💼 프리랜서·소상공인', '🌱 사회초년생', '🏠 부동산·임차인', '👨‍👩‍👧 육아·가족', '📱 플랫폼 종사자', '🎓 학생'];
  final Set<String> _selected = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0D1B4B), AppColors.navy],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text('나에게 맞는\n법률 정보를 받으세요',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, height: 1.4)),
                const SizedBox(height: 8),
                const Text('해당되는 유형을 모두 선택해주세요',
                    style: TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 32),
                Wrap(
                  spacing: 10, runSpacing: 10,
                  children: _options.map((opt) {
                    final selected = _selected.contains(opt);
                    return GestureDetector(
                      onTap: () => setState(() {
                        selected ? _selected.remove(opt) : _selected.add(opt);
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: selected ? Colors.white : Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: selected ? Colors.white : Colors.white30),
                        ),
                        child: Text(opt,
                            style: TextStyle(
                              color: selected ? AppColors.navy : Colors.white,
                              fontWeight: FontWeight.w600, fontSize: 13,
                            )),
                      ),
                    );
                  }).toList(),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _selected.isEmpty ? null : () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const MainScreen()),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.navy,
                      disabledBackgroundColor: Colors.white30,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('시작하기', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
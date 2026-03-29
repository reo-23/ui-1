import 'package:flutter/material.dart';
import '../theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // 토글 상태
  bool _trendToggle = true;
  bool _billToggle = true;
  bool _bookmarkToggle = false;

  // 관심 유형 선택
  final List<String> _interestOptions = [
    '💼 프리랜서·소상공인',
    '🌱 사회초년생',
    '🏠 부동산·임차인',
    '👨‍👩‍👧 육아·가족',
    '📱 플랫폼 종사자',
    '🎓 학생',
  ];
  final Set<String> _selectedInterests = {'💼 프리랜서·소상공인', '🌱 사회초년생'};
  final PageController _interestController = PageController(viewportFraction: 0.45);
  int _interestPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('설정',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
            const SizedBox(height: 16),

            // 프로필 카드
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.navy, Color(0xFF2A4FAD)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('김민준',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                        Text('minjun@email.com',
                            style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.white70),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── 관심 유형 (좌우 스와이프) ──
            const Text('관심 유형',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      children: [
                        Icon(Icons.label_outline, color: AppColors.navy, size: 20),
                        SizedBox(width: 8),
                        Text('내 관심 유형',
                            style: TextStyle(fontSize: 14, color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // 좌우 스와이프 카드
                  SizedBox(
                    height: 52,
                    child: PageView.builder(
                      controller: _interestController,
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (i) => setState(() => _interestPage = i),
                      itemCount: _interestOptions.length,
                      itemBuilder: (context, index) {
                        final opt = _interestOptions[index];
                        final isSelected = _selectedInterests.contains(opt);
                        final isCenter = index == _interestPage;
                        return GestureDetector(
                          onTap: () => setState(() {
                            isSelected
                                ? _selectedInterests.remove(opt)
                                : _selectedInterests.add(opt);
                          }),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.navy
                                  : isCenter
                                  ? AppColors.navy.withOpacity(0.06)
                                  : Colors.grey.withOpacity(0.07),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: isSelected ? AppColors.navy : AppColors.border,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Center(
                              child: Text(opt,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : AppColors.textSecondary,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    fontSize: 13,
                                  )),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  // 인디케이터 점
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_interestOptions.length, (i) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: i == _interestPage ? 16 : 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: i == _interestPage ? AppColors.navy : AppColors.border,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    )),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── 알림 설정 ──
            const Text('알림 설정',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _ToggleRow(
                    icon: Icons.phone_android,
                    label: '트렌드 카드뉴스',
                    sub: '주목받는 법률 카드 알림',
                    value: _trendToggle,
                    onChanged: (v) => setState(() => _trendToggle = v),
                    showDivider: true,
                  ),
                  _ToggleRow(
                    icon: Icons.balance_outlined,
                    label: '새 법안 발의',
                    sub: '관심 유형 관련 법안',
                    value: _billToggle,
                    onChanged: (v) => setState(() => _billToggle = v),
                    showDivider: true,
                  ),
                  _ToggleRow(
                    icon: Icons.notifications_outlined,
                    label: '북마크 법안 상태 변경',
                    sub: '저장된 법안 진행 알림',
                    value: _bookmarkToggle,
                    onChanged: (v) => setState(() => _bookmarkToggle = v),
                    showDivider: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── 고객지원 ──
            const Text('고객지원',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _ChevronRow(icon: Icons.chat_bubble_outline, label: 'Help & Support', showDivider: true),
                  _ChevronRow(icon: Icons.person_outline, label: '계정 관리', showDivider: false),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 로그아웃
            TextButton(
              onPressed: () {},
              child: const Text('🚪  로그아웃',
                  style: TextStyle(color: AppColors.red, fontWeight: FontWeight.w600, fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? sub;
  final bool value, showDivider;
  final ValueChanged<bool> onChanged;
  const _ToggleRow({
    required this.icon, required this.label, this.sub,
    required this.value, required this.onChanged, required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: AppColors.navy, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
                    if (sub != null)
                      Text(sub!, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: AppColors.navy,
              ),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1, color: AppColors.border),
      ],
    );
  }
}

class _ChevronRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool showDivider;
  const _ChevronRow({required this.icon, required this.label, required this.showDivider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: AppColors.navy, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(label,
                    style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textMuted),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1, color: AppColors.border),
      ],
    );
  }
}
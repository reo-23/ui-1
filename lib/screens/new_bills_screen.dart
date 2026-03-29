import 'package:flutter/material.dart';
import '../theme.dart';
import 'bill_detail_screen.dart';

class NewBillsScreen extends StatelessWidget {
  const NewBillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Text('새 법안',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  _BillCard(
                    category: '부동산',
                    title: '전월세 신고제 의무화 범위 확대안',
                    summary: '보증금 6천만원 또는 월세 30만원 초과 임대차 계약 신고 의무 대상 확대.',
                    score: 92,
                    statusIndex: 2,
                  ),
                  SizedBox(height: 12),
                  _BillCard(
                    category: '노동',
                    title: '플랫폼 종사자 보호 및 고용안정에 관한 법률안',
                    summary: '배달·대리운전 등 플랫폼 노동자의 최저 보수 기준 및 계약 해지 사전 고지 의무화.',
                    score: 88,
                    statusIndex: 1,
                  ),
                  SizedBox(height: 12),
                  _BillCard(
                    category: '세금',
                    title: '소득세법 일부개정법률안',
                    summary: '프리랜서·1인 사업자 단순경비율 적용 기준 완화 및 신고 간소화.',
                    score: 75,
                    statusIndex: 0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BillCard extends StatelessWidget {
  final String category, title, summary;
  final int score, statusIndex;
  const _BillCard({
    required this.category, required this.title, required this.summary,
    required this.score, required this.statusIndex,
  });

  @override
  Widget build(BuildContext context) {
    final steps = ['발의', '위원회', '본회의', '공포'];
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CardNewsScreen(title: title),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.navy.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('#$category',
                      style: const TextStyle(color: AppColors.navy, fontSize: 11, fontWeight: FontWeight.w600)),
                ),
                const Spacer(),
                const Icon(Icons.star_border, color: AppColors.textMuted, size: 20),
              ],
            ),
            const SizedBox(height: 10),
            Text(title,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary)),
            const SizedBox(height: 6),
            Text(summary,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.5)),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('종합 영향도',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                const Spacer(),
                Text('$score/100',
                    style: const TextStyle(color: AppColors.navy, fontSize: 11, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: score / 100,
                backgroundColor: AppColors.border,
                color: AppColors.navy,
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: steps.asMap().entries.map((e) {
                final isDone = e.key < statusIndex;
                final isCurrent = e.key == statusIndex;
                return Expanded(
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 10, height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDone || isCurrent ? AppColors.navy : AppColors.border,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(e.value,
                              style: TextStyle(
                                fontSize: 9,
                                color: isCurrent ? AppColors.navy : AppColors.textMuted,
                                fontWeight: isCurrent ? FontWeight.w700 : FontWeight.normal,
                              )),
                        ],
                      ),
                      if (e.key < steps.length - 1)
                        Expanded(
                          child: Container(
                              height: 1,
                              color: e.key < statusIndex ? AppColors.navy : AppColors.border),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
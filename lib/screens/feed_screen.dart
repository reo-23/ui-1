import 'package:flutter/material.dart';
import '../theme.dart';
import '../main.dart';
import 'bill_detail_screen.dart';

// ── 리포트 데이터 모델 ──
class _ReportData {
  final String category, title, summary, tag;
  final int comments, likes, dislikes;
  const _ReportData({
    required this.category,
    required this.title,
    required this.summary,
    required this.tag,
    required this.comments,
    required this.likes,
    required this.dislikes,
  });
}

// ── 전체 리포트 목록 (카테고리별 1개씩) ──
const _allReports = <_ReportData>[
  _ReportData(
    category: '세금',
    title: '프리랜서 종합소득세 신고,\n올해부터 달라지는 것들',
    summary: '5월 종소세 신고 시즌. 사업소득·기타소득 구분이 핵심입니다. 공제 한도 변경 사항을 꼭 확인하세요.',
    tag: '청년 세액공제 →',
    comments: 24,
    likes: 112,
    dislikes: 8,
  ),
  _ReportData(
    category: '주거',
    title: '전세사기 피해자 지원법,\n핵심 조항 3가지',
    summary: '임차인 우선변제권 강화와 경매 유예 기간 연장이 포함됩니다. 내가 해당되는지 확인해 보세요.',
    tag: 'HUG 보증보험 →',
    comments: 87,
    likes: 256,
    dislikes: 14,
  ),
  _ReportData(
    category: '노동',
    title: '주 52시간제 예외 업종,\n2026년 개정 포인트',
    summary: '연구·개발직 특례 연장과 탄력근무제 단위기간 확대가 핵심입니다. 내 업종이 해당되는지 확인하세요.',
    tag: '연장근로 수당 →',
    comments: 45,
    likes: 189,
    dislikes: 11,
  ),
  _ReportData(
    category: '금융',
    title: '신용점수 올리는 법,\n금융위가 바꾼 규칙',
    summary: '통신비·공과금 납부 이력이 신용평가에 반영됩니다. 씬파일러를 위한 새 기준을 확인하세요.',
    tag: '마이데이터 조회 →',
    comments: 63,
    likes: 204,
    dislikes: 6,
  ),
  _ReportData(
    category: '청년',
    title: '청년도약계좌 vs 청년희망적금,\n뭐가 더 유리할까',
    summary: '정부 매칭 비율, 만기 수령액, 중도해지 패널티까지 한눈에 비교해 드립니다.',
    tag: '가입 조건 확인 →',
    comments: 102,
    likes: 341,
    dislikes: 19,
  ),
  _ReportData(
    category: '교통',
    title: '음주운전 처벌 강화,\n면허취소 기준 변경',
    summary: '혈중알코올농도 0.03% 이상이면 면허정지. 대리운전 미이용 시 차량 압수도 가능해졌습니다.',
    tag: '벌금 기준표 →',
    comments: 38,
    likes: 178,
    dislikes: 22,
  ),
  _ReportData(
    category: '소비자',
    title: '환불 거부는 불법?\n전자상거래법 핵심 정리',
    summary: '7일 이내 청약철회권은 소비자의 기본 권리입니다. 예외 사유와 대응 방법을 알려드립니다.',
    tag: '소비자원 신고 →',
    comments: 56,
    likes: 230,
    dislikes: 9,
  ),
];

// ── 해시태그 목록 (전체 + 각 카테고리) ──
const _allCategories = ['전체', '세금', '주거', '노동', '금융', '청년', '교통', '소비자'];

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  String _selectedCategory = '전체';

  List<_ReportData> get _filteredReports {
    if (_selectedCategory == '전체') return _allReports;
    return _allReports.where((r) => r.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final weekdays = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
    final dateStr = '${now.month}월 ${now.day}일 ${weekdays[now.weekday - 1]}';

    final reports = _filteredReports;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          children: [
            // ── 헤더 ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('오늘의 법률 리포트',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary)),
                Text(dateStr,
                    style: const TextStyle(
                        color: AppColors.textMuted, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 16),

            // ── 해시태그 필터 (가로 스크롤) ──
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _allCategories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = _allCategories[index];
                  final isSelected = _selectedCategory == cat;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.navy
                            : AppColors.navy.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.navy
                              : AppColors.navy.withOpacity(0.15),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        cat == '전체' ? '# 전체' : '#$cat',
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.navy,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 18),

            // ── 리포트 카드 목록 ──
            if (reports.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Center(
                  child: Text('해당 카테고리에 리포트가 없습니다.',
                      style: TextStyle(
                          color: AppColors.textMuted, fontSize: 14)),
                ),
              )
            else
              ...List.generate(reports.length, (i) {
                final r = reports[i];
                return Padding(
                  padding: EdgeInsets.only(bottom: i < reports.length - 1 ? 14 : 0),
                  child: _FeedCard(
                    key: ValueKey(r.title),
                    category: r.category,
                    title: r.title,
                    summary: r.summary,
                    tag: r.tag,
                    comments: r.comments,
                    likes: r.likes,
                    dislikes: r.dislikes,
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

// ── 피드 카드 (기존과 동일) ──
class _FeedCard extends StatefulWidget {
  final String category, title, summary, tag;
  final int comments, likes, dislikes;
  const _FeedCard({
    super.key,
    required this.category,
    required this.title,
    required this.summary,
    required this.tag,
    required this.comments,
    required this.likes,
    required this.dislikes,
  });
  @override
  State<_FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<_FeedCard> {
  late int _likes;
  late int _dislikes;
  bool? _myVote;
  late bool _bookmarked;

  @override
  void initState() {
    super.initState();
    _likes = widget.likes;
    _dislikes = widget.dislikes;
    _bookmarked = BookmarkStore.isBookmarked(widget.title.replaceAll('\n', ' '));
  }

  void _vote(bool isLike) {
    setState(() {
      if (_myVote == isLike) {
        isLike ? _likes-- : _dislikes--;
        _myVote = null;
      } else {
        if (_myVote != null) {
          _myVote! ? _likes-- : _dislikes--;
        }
        isLike ? _likes++ : _dislikes++;
        _myVote = isLike;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cleanTitle = widget.title.replaceAll('\n', ' ');
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CardNewsScreen(title: cleanTitle)),
      ).then((_) => setState(() {
        _bookmarked = BookmarkStore.isBookmarked(cleanTitle);
      })),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.navy.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('#${widget.category}',
                      style: const TextStyle(
                          color: AppColors.navy,
                          fontSize: 11,
                          fontWeight: FontWeight.w600)),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _bookmarked = !_bookmarked;
                      _bookmarked
                          ? BookmarkStore.add(cleanTitle)
                          : BookmarkStore.remove(cleanTitle);
                    });
                  },
                  child: Icon(
                    _bookmarked ? Icons.star : Icons.star_border,
                    color: _bookmarked ? AppColors.amber : AppColors.textMuted,
                    size: 22,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(widget.title,
                style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                    color: AppColors.textPrimary,
                    height: 1.35)),
            const SizedBox(height: 8),
            Text(widget.summary,
                style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.6)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.greenLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.circle, color: AppColors.green, size: 7),
                  const SizedBox(width: 5),
                  Text(widget.tag,
                      style: const TextStyle(
                          color: AppColors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline,
                          color: AppColors.textMuted, size: 16),
                      const SizedBox(width: 4),
                      Text('${widget.comments}',
                          style: const TextStyle(
                              color: AppColors.textMuted, fontSize: 13)),
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => _vote(true),
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _myVote == true
                          ? AppColors.navy.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text('👍',
                            style: TextStyle(
                              fontSize: 15,
                              color: _myVote == true ? AppColors.navy : null,
                            )),
                        const SizedBox(width: 4),
                        Text('$_likes',
                            style: TextStyle(
                              color: _myVote == true
                                  ? AppColors.navy
                                  : AppColors.textMuted,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _vote(false),
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _myVote == false
                          ? AppColors.red.withOpacity(0.08)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text('👎',
                            style: TextStyle(
                              fontSize: 15,
                              color: _myVote == false ? AppColors.red : null,
                            )),
                        const SizedBox(width: 4),
                        Text('$_dislikes',
                            style: TextStyle(
                              color: _myVote == false
                                  ? AppColors.red
                                  : AppColors.textMuted,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
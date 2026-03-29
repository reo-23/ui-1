import 'package:flutter/material.dart';
import '../theme.dart';
import '../main.dart';
import 'bill_detail_screen.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final weekdays = ['월요일','화요일','수요일','목요일','금요일','토요일','일요일'];
    final dateStr = '${now.month}월 ${now.day}일 ${weekdays[now.weekday - 1]}';

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          children: [
            // 헤더
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('오늘의 법률 리포트',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                Text(dateStr,
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 20),

            _FeedCard(
              category: '세금',
              title: '프리랜서 종합소득세 신고,\n올해부터 달라지는 것들',
              summary: '5월 종소세 신고 시즌. 사업소득·기타소득 구분이 핵심입니다. 공제 한도 변경 사항을 꼭 확인하세요.',
              tag: '청년 세액공제 →',
              comments: 24,
              likes: 112,
              dislikes: 8,
            ),
            const SizedBox(height: 14),
            _FeedCard(
              category: '주거',
              title: '전세사기 피해자 지원법,\n핵심 조항 3가지',
              summary: '임차인 우선변제권 강화와 경매 유예 기간 연장이 포함됩니다. 내가 해당되는지 확인해 보세요.',
              tag: 'HUG 보증보험 →',
              comments: 87,
              likes: 256,
              dislikes: 14,
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedCard extends StatefulWidget {
  final String category, title, summary, tag;
  final int comments, likes, dislikes;
  const _FeedCard({
    required this.category, required this.title, required this.summary,
    required this.tag, required this.comments, required this.likes, required this.dislikes,
  });
  @override
  State<_FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<_FeedCard> {
  late int _likes;
  late int _dislikes;
  // null = 선택 안함, true = 좋아요, false = 싫어요
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
        // 같은 버튼 다시 누르면 취소
        isLike ? _likes-- : _dislikes--;
        _myVote = null;
      } else {
        // 반대 버튼으로 바꿀 때
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
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
          ],
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
                  child: Text('#${widget.category}',
                      style: const TextStyle(color: AppColors.navy, fontSize: 11, fontWeight: FontWeight.w600)),
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
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: AppColors.textPrimary, height: 1.35)),
            const SizedBox(height: 8),
            Text(widget.summary,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.6)),
            const SizedBox(height: 12),
            // 태그 버튼
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
                      style: const TextStyle(color: AppColors.green, fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 12),
            // 반응 버튼
            Row(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline, color: AppColors.textMuted, size: 16),
                      const SizedBox(width: 4),
                      Text('${widget.comments}',
                          style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => _vote(true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _myVote == true ? AppColors.navy.withOpacity(0.1) : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text('👍', style: TextStyle(
                          fontSize: 15,
                          color: _myVote == true ? AppColors.navy : null,
                        )),
                        const SizedBox(width: 4),
                        Text('$_likes',
                            style: TextStyle(
                              color: _myVote == true ? AppColors.navy : AppColors.textMuted,
                              fontSize: 13, fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _vote(false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _myVote == false ? AppColors.red.withOpacity(0.08) : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text('👎', style: TextStyle(
                          fontSize: 15,
                          color: _myVote == false ? AppColors.red : null,
                        )),
                        const SizedBox(width: 4),
                        Text('$_dislikes',
                            style: TextStyle(
                              color: _myVote == false ? AppColors.red : AppColors.textMuted,
                              fontSize: 13, fontWeight: FontWeight.w600,
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
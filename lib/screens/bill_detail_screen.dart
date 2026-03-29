import 'package:flutter/material.dart';
import '../theme.dart';
import '../main.dart';

class CardNewsScreen extends StatefulWidget {
  final String title;
  const CardNewsScreen({super.key, required this.title});

  @override
  State<CardNewsScreen> createState() => _CardNewsScreenState();
}

class _Comment {
  final String nickname;
  final String text;
  final DateTime createdAt;
  bool liked;
  int likeCount;

  _Comment({
    required this.nickname,
    required this.text,
    required this.createdAt,
    this.liked = false,
    this.likeCount = 0,
  });
}

class _CardNewsScreenState extends State<CardNewsScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.88);
  int _currentPage = 0;
  late bool _bookmarked;

  // 좋아요/싫어요 상태
  int _likes = 112;
  int _dislikes = 8;
  bool? _myVote; // null=미선택, true=좋아요, false=싫어요

  // 댓글
  final List<_Comment> _comments = [
    _Comment(nickname: '법린이', text: '이 법안 정말 필요했어요. 전세사기 피해자로서 희망이 보입니다.', createdAt: DateTime.now().subtract(const Duration(hours: 2)), likeCount: 14),
    _Comment(nickname: '부동산왕', text: '우선변제권 확대는 좋은데 임대인 입장도 고려해야 하지 않나요?', createdAt: DateTime.now().subtract(const Duration(hours: 1)), likeCount: 7),
    _Comment(nickname: '월세러', text: '월세도 해당되나요?', createdAt: DateTime.now().subtract(const Duration(minutes: 30)), likeCount: 3),
  ];

  final List<Map<String, dynamic>> _cards = [
    {
      'label': '이슈 배경',
      'emoji': '📰',
      'title': '왜 지금 이 법이\n중요한가?',
      'body': '최근 전세사기 피해자가 급증하면서 임차인 보호를 위한 법률 개정 논의가 활발해졌습니다.',
      'quote': null,
      'color1': const Color(0xFF1A3A8F),
      'color2': const Color(0xFF0D2466),
    },
    {
      'label': '핵심 법 조항',
      'emoji': '⚖️',
      'title': '주택임대차보호법\n제3조의2 개정안',
      'body': '임차인의 우선변제권 행사 요건이 완화됩니다. 확정일자 취득 후 익일 효력 발생 조항이 삭제되고, 등기 접수 당일 효력이 인정됩니다.',
      'quote': '제8조(보증금의 우선변제) ① 임차인은 보증금 중 일정액을 다른 담보물권자보다 우선하여 변제받을 권리가 있다.',
      'color1': const Color(0xFF2A4FAD),
      'color2': const Color(0xFF1A3A8F),
    },
    {
      'label': '나에게 미치는 영향',
      'emoji': '👤',
      'title': '세입자라면\n꼭 알아야 할 변화',
      'body': '월세 계약 시 전입신고와 확정일자를 받는 즉시 보호를 받을 수 있습니다.',
      'quote': null,
      'color1': const Color(0xFF1aaa6e),
      'color2': const Color(0xFF0d7a4f),
    },
    {
      'label': '핵심 요약',
      'emoji': '✅',
      'title': '3줄 요약',
      'body': '① 확정일자 당일 효력 인정\n② 전입신고 즉시 보호 적용\n③ 경매 시 우선변제 요건 완화',
      'quote': null,
      'color1': const Color(0xFF0D1B4B),
      'color2': const Color(0xFF1A3A8F),
    },
  ];

  @override
  void initState() {
    super.initState();
    _bookmarked = BookmarkStore.isBookmarked(widget.title);
  }

  void _toggleBookmark() {
    setState(() {
      _bookmarked = !_bookmarked;
      _bookmarked
          ? BookmarkStore.add(widget.title)
          : BookmarkStore.remove(widget.title);
    });
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

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return '방금';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    return '${diff.inDays}일 전';
  }

  void _showCommentSheet() {
    final textController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Container(
              height: MediaQuery.of(ctx).size.height * 0.65,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // 핸들 바
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 4),
                    width: 40, height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // 헤더
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        Text('댓글 ${_comments.length}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => Navigator.pop(ctx),
                          child: const Icon(Icons.close, color: AppColors.textMuted, size: 22),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.border),
                  // 댓글 리스트
                  Expanded(
                    child: _comments.isEmpty
                        ? const Center(
                      child: Text('아직 댓글이 없습니다.\n첫 댓글을 남겨보세요!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textMuted, fontSize: 14)),
                    )
                        : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      itemCount: _comments.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (_, i) {
                        final c = _comments[i];
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 프로필 아바타
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: AppColors.navy.withOpacity(0.1),
                              child: Text(c.nickname[0],
                                  style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w700, fontSize: 13)),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(c.nickname,
                                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary)),
                                      const SizedBox(width: 6),
                                      Text(_timeAgo(c.createdAt),
                                          style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(c.text,
                                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.4)),
                                ],
                              ),
                            ),
                            // 좋아요
                            GestureDetector(
                              onTap: () {
                                setSheetState(() {
                                  c.liked = !c.liked;
                                  c.likeCount += c.liked ? 1 : -1;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8, top: 4),
                                child: Column(
                                  children: [
                                    Icon(
                                      c.liked ? Icons.favorite : Icons.favorite_border,
                                      size: 16,
                                      color: c.liked ? AppColors.red : AppColors.textMuted,
                                    ),
                                    if (c.likeCount > 0)
                                      Text('${c.likeCount}',
                                          style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  // 입력창
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(top: BorderSide(color: AppColors.border)),
                    ),
                    padding: EdgeInsets.only(
                      left: 16, right: 8, top: 8,
                      bottom: MediaQuery.of(ctx).viewInsets.bottom + 8,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.navy.withOpacity(0.1),
                          child: const Icon(Icons.person, color: AppColors.navy, size: 18),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: textController,
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              hintText: '댓글 추가...',
                              hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            final text = textController.text.trim();
                            if (text.isEmpty) return;
                            setSheetState(() {
                              _comments.add(_Comment(
                                nickname: '나',
                                text: text,
                                createdAt: DateTime.now(),
                              ));
                            });
                            setState(() {}); // 메인 화면 댓글 수 갱신
                            textController.clear();
                          },
                          icon: const Icon(Icons.send_rounded, color: AppColors.navy, size: 22),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B4B),
      body: SafeArea(
        child: Column(
          children: [
            // 상단 앱바
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                    ),
                  ),
                  Expanded(
                    child: Text(widget.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
                        overflow: TextOverflow.ellipsis),
                  ),
                  GestureDetector(
                    onTap: _toggleBookmark,
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: _bookmarked
                            ? AppColors.amber.withOpacity(0.2)
                            : Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _bookmarked ? Icons.star : Icons.star_border,
                        color: _bookmarked ? AppColors.amber : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 카드 스와이프
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _cards.length,
                itemBuilder: (context, index) {
                  final card = _cards[index];
                  final isActive = index == _currentPage;
                  return AnimatedScale(
                    scale: isActive ? 1.0 : 0.93,
                    duration: const Duration(milliseconds: 300),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [card['color1'], card['color2']],
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: isActive
                              ? [BoxShadow(
                              color: (card['color1'] as Color).withOpacity(0.4),
                              blurRadius: 20, offset: const Offset(0, 8))]
                              : [],
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('CARD ${index + 1} / ${_cards.length}',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1,
                                )),
                            const SizedBox(height: 4),
                            Row(children: [
                              Text(card['emoji'], style: const TextStyle(fontSize: 16)),
                              const SizedBox(width: 6),
                              Text(card['label'],
                                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
                            ]),
                            const SizedBox(height: 20),
                            Text(card['title'],
                                style: const TextStyle(
                                  color: Colors.white, fontSize: 24,
                                  fontWeight: FontWeight.w900, height: 1.3,
                                )),
                            const SizedBox(height: 16),
                            Text(card['body'],
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: 14, height: 1.7,
                                )),
                            if (card['quote'] != null) ...[
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('관련 조항',
                                        style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 11)),
                                    const SizedBox(height: 6),
                                    Text(card['quote'],
                                        style: const TextStyle(
                                          color: Colors.white, fontSize: 13, height: 1.6, fontWeight: FontWeight.w500,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                            const Spacer(),
                            Row(
                              children: List.generate(_cards.length, (i) => Container(
                                margin: const EdgeInsets.only(right: 6),
                                width: i == _currentPage ? 20 : 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: i == _currentPage ? Colors.white : Colors.white30,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // 하단 반응 버튼
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 좋아요
                  GestureDetector(
                    onTap: () => _vote(true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _myVote == true
                            ? Colors.white.withOpacity(0.25)
                            : Colors.white.withOpacity(0.08),
                        border: _myVote == true
                            ? Border.all(color: Colors.white54, width: 1.5)
                            : null,
                      ),
                      child: Column(
                        children: [
                          const Text('👍', style: TextStyle(fontSize: 22)),
                          if (_myVote == true)
                            Text('$_likes',
                                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // 싫어요
                  GestureDetector(
                    onTap: () => _vote(false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _myVote == false
                            ? Colors.white.withOpacity(0.2)
                            : Colors.white.withOpacity(0.08),
                        border: _myVote == false
                            ? Border.all(color: Colors.red.withOpacity(0.6), width: 1.5)
                            : null,
                      ),
                      child: Column(
                        children: [
                          const Text('👎', style: TextStyle(fontSize: 22)),
                          if (_myVote == false)
                            Text('$_dislikes',
                                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // 댓글
                  GestureDetector(
                    onTap: () => _showCommentSheet(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.08),
                      ),
                      child: Column(
                        children: [
                          const Text('💬', style: TextStyle(fontSize: 22)),
                          Text('${_comments.length}',
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
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

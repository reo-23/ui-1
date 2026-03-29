import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/splash_screen.dart';
import 'screens/feed_screen.dart';
import 'screens/new_bills_screen.dart';
import 'screens/bookmark_screen.dart';
import 'screens/settings_screen.dart';

void main() => runApp(const LawLinkApp());

class LawLinkApp extends StatelessWidget {
  const LawLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LawLink',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.navy),
      ),
      home: const SplashScreen(),
    );
  }
}

// ── 전역 북마크 상태 ──
class BookmarkStore {
  static final List<BookmarkItem> items = [
    BookmarkItem(
      icon: Icons.article_outlined,
      type: '카드뉴스',
      title: '프리랜서 종합소득세 신고, 달라지는 것들',
      memo: '5월 신고 전에 다시 읽기',
      date: '2025.03.21',
      alert: null,
    ),
    BookmarkItem(
      icon: Icons.balance_outlined,
      type: '법안',
      title: '전월세 신고제 의무화 범위 확대안',
      memo: '임대차 계약 갱신 시 확인',
      date: '2025.03.18',
      alert: '상태 변경',
    ),
    BookmarkItem(
      icon: Icons.article_outlined,
      type: '카드뉴스',
      title: '전세사기 피해자 지원법 핵심 조항 3가지',
      memo: '메모 없음',
      date: '2025.03.14',
      alert: null,
    ),
    BookmarkItem(
      icon: Icons.balance_outlined,
      type: '법안',
      title: '플랫폼 종사자 보호 및 고용안정에 관한 법률안',
      memo: '플랫폼 노동자 친구한테 공유',
      date: '2025.03.10',
      alert: '위원회 통과',
    ),
  ];

  static bool isBookmarked(String title) =>
      items.any((e) => e.title == title);

  static void add(String title) {
    if (!isBookmarked(title)) {
      items.insert(0, BookmarkItem(
        icon: Icons.article_outlined,
        type: '카드뉴스',
        title: title,
        memo: '메모 없음',
        date: '${DateTime.now().year}.${DateTime.now().month.toString().padLeft(2,'0')}.${DateTime.now().day.toString().padLeft(2,'0')}',
        alert: null,
      ));
    }
  }

  static void remove(String title) {
    items.removeWhere((e) => e.title == title);
  }
}

class BookmarkItem {
  final IconData icon;
  final String type, title, memo, date;
  final String? alert;
  BookmarkItem({
    required this.icon, required this.type, required this.title,
    required this.memo, required this.date, required this.alert,
  });
}

// ── 메인 탭 화면 ──
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const FeedScreen(),
      const NewBillsScreen(),
      BookmarkScreen(onUpdate: () => setState(() {})),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.navy,
        unselectedItemColor: AppColors.textMuted,
        backgroundColor: Colors.white,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.article_outlined), label: '피드'),
          BottomNavigationBarItem(icon: Icon(Icons.balance_outlined), label: '새 법안'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_outline), label: '북마크'),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: '더보기'),
        ],
      ),
    );
  }
}
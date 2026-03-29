import 'package:flutter/material.dart';
import '../theme.dart';
import '../main.dart';
import 'bill_detail_screen.dart';

class BookmarkScreen extends StatefulWidget {
  final VoidCallback? onUpdate;
  const BookmarkScreen({super.key, this.onUpdate});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
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
              child: Text('북마크',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
            ),
            Expanded(
              child: BookmarkStore.items.isEmpty
                  ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('🔖', style: TextStyle(fontSize: 40)),
                    SizedBox(height: 12),
                    Text('북마크한 항목이 없어요',
                        style: TextStyle(color: AppColors.textMuted, fontSize: 15)),
                  ],
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: BookmarkStore.items.length,
                itemBuilder: (context, index) {
                  final item = BookmarkStore.items[index];
                  return _BookmarkItem(
                    item: item,
                    onRemove: () {
                      setState(() {
                        BookmarkStore.remove(item.title);
                      });
                      widget.onUpdate?.call();
                    },
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CardNewsScreen(title: item.title),
                      ),
                    ).then((_) => setState(() {})),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookmarkItem extends StatelessWidget {
  final BookmarkItem item;
  final VoidCallback onRemove;
  final VoidCallback onTap;
  const _BookmarkItem({required this.item, required this.onRemove, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: AppColors.navy.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icon, color: AppColors.navy, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.type,
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 3),
                  Text(item.title,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text('✏️ ${item.memo}',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(item.date, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                      if (item.alert != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.greenLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text('🔔 ${item.alert}',
                              style: const TextStyle(color: AppColors.green, fontSize: 10, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // 별 버튼 (북마크 제거)
            GestureDetector(
              onTap: onRemove,
              child: const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.star, color: AppColors.amber, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
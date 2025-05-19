import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_template/app/core/config/app_color.dart';

class SavedSlidableTile extends StatefulWidget {
  const SavedSlidableTile({
    required this.title,
    required this.sites,
    required this.amount,
    required this.date,
    required this.onDelete,
    super.key,
    this.onTap,
  });
  final String title;
  final List<Map<String, String>> sites;

  final String amount;
  final String date;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  @override
  State<SavedSlidableTile> createState() => _SavedSlidableTileState();
}

class _SavedSlidableTileState extends State<SavedSlidableTile> {
  bool _showAllSites = false;

  List<Widget> buildSiteChips(List<Map<String, String>> sites) => sites
      .map(
        (site) => Container(
          margin: const EdgeInsets.only(right: 6, bottom: 6),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F5F6),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            site['siteName'] ?? '',
            style: const TextStyle(
              color: Color(0xFFB0B7C3),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      )
      .toList();

  List<Widget> getSiteRows() {
    final sites = widget.sites;
    final totalCount = sites.length;
    final List<Widget> rows = [];

    if (!_showAllSites && totalCount > 2) {
      // Show first 2 + "+N more"
      final firstTwo = sites.take(2).toList();
      final remainingCount = totalCount - 2;
      rows.add(
        Wrap(
          children: [
            ...buildSiteChips(firstTwo),
            GestureDetector(
              onTap: () => setState(() => _showAllSites = true),
              child: Container(
                margin: const EdgeInsets.only(right: 6, bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.grey60,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '+$remainingCount more',
                  style: const TextStyle(
                    color: AppColors.textBlack60,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // Show all in chunks of 3
      for (int i = 0; i < totalCount; i += 3) {
        final chunk = sites.skip(i).take(3).toList();
        rows.add(Wrap(children: buildSiteChips(chunk)));
      }
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) => Slidable(
        key: ValueKey(widget.title + widget.date),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.3,
          children: [
            CustomSlidableAction(
              onPressed: (_) => widget.onDelete(),
              backgroundColor: Colors.transparent,
              child: Container(
                height: 56,
                width: 200,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.error70,
                  borderRadius: BorderRadius.circular(
                    16,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Delete',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        child: ListTile(
          onTap: widget.onTap,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          leading: SvgPicture.asset(
            'assets/icons/history.svg', // Ensure this asset exists
            width: 20,
            height: 20,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xFF23262F),
                ),
              ),
              const SizedBox(height: 4),
              ...getSiteRows(), // This expands when "+more" is tapped
            ],
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.amount,
                style: const TextStyle(
                  color: Color(0xFF10B981),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                widget.date,
                style: const TextStyle(
                  color: Color(0xFFB0B7C3),
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
}

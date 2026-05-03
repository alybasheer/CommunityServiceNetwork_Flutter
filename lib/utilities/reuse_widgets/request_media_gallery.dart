import 'package:flutter/material.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';
import 'package:fyp_source_code/utilities/reuse_components/storage_helper.dart';

class RequestMediaStrip extends StatelessWidget {
  final List<String> mediaUrls;
  final double height;

  const RequestMediaStrip({
    super.key,
    required this.mediaUrls,
    this.height = 92,
  });

  @override
  Widget build(BuildContext context) {
    final urls = _cleanUrls(mediaUrls);
    if (urls.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: urls.length,
        separatorBuilder: (_, __) => SizedBox(width: AppSize.s),
        itemBuilder: (context, index) {
          return _MediaThumb(
            url: urls[index],
            onTap: () => _openViewer(context, urls, index),
          );
        },
      ),
    );
  }
}

class _MediaThumb extends StatelessWidget {
  final String url;
  final VoidCallback onTap;

  const _MediaThumb({required this.url, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 116,
          height: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(color: scheme.surfaceContainerHighest),
            child: _MediaImage(url: url),
          ),
        ),
      ),
    );
  }
}

class _MediaImage extends StatelessWidget {
  final String url;

  const _MediaImage({required this.url});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (url.startsWith('assets/')) {
      return Image.asset(url, fit: BoxFit.cover);
    }

    return Image.network(
      url,
      headers: _authHeaders(),
      fit: BoxFit.cover,
      errorBuilder:
          (_, __, ___) => Center(
            child: Icon(
              Icons.broken_image_outlined,
              color: scheme.onSurfaceVariant,
            ),
          ),
    );
  }
}

void _openViewer(BuildContext context, List<String> urls, int initialIndex) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.82),
    builder:
        (_) => Dialog.fullscreen(
          backgroundColor: Colors.black,
          child: SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: PageController(initialPage: initialIndex),
                    itemCount: urls.length,
                    itemBuilder: (_, index) {
                      return InteractiveViewer(
                        minScale: 1,
                        maxScale: 4,
                        child: Center(child: _MediaImage(url: urls[index])),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(AppSize.m),
                  child: Text(
                    'Situation photo ${initialIndex + 1} of ${urls.length}',
                    style: AppTextStyling.body_12S.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
  );
}

List<String> _cleanUrls(List<String> values) {
  final seen = <String>{};
  final result = <String>[];
  for (final value in values) {
    final text = value.trim();
    if (text.isEmpty || text.toLowerCase() == 'null') {
      continue;
    }
    if (seen.add(text)) {
      result.add(text);
    }
  }
  return result;
}

Map<String, String>? _authHeaders() {
  final token = StorageHelper().readData('token')?.toString().trim();
  if (token == null || token.isEmpty) {
    return null;
  }
  return {'Authorization': 'Bearer $token'};
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ComingSoonMovie extends StatelessWidget {
  /// Full URL; if empty, shows a local placeholder (no network).
  final String imageUrl;
  final String overview;
  /// Optional small logo/banner; unreliable third-party URLs removed — prefer TMDB.
  final String? logoUrl;
  final String displayTitle;
  final String month;
  final String day;

  const ComingSoonMovie({
    super.key,
    required this.imageUrl,
    required this.overview,
    this.logoUrl,
    required this.displayTitle,
    required this.month,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final heroHeight = size.height * 0.25;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Text(
                month.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              Text(
                day,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                  letterSpacing: 4,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imageUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          width: double.infinity,
                          height: heroHeight,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            height: heroHeight,
                            color: Colors.grey[800],
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: heroHeight,
                            color: Colors.grey[900],
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.movie_outlined,
                              color: Colors.white54,
                              size: 48,
                            ),
                          ),
                        )
                      : Container(
                          height: heroHeight,
                          width: double.infinity,
                          color: Colors.grey[900],
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.movie_outlined,
                            color: Colors.white54,
                            size: 48,
                          ),
                        ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: logoUrl != null && logoUrl!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: logoUrl!,
                              height: 40,
                              fit: BoxFit.contain,
                              placeholder: (context, url) => const SizedBox(
                                height: 40,
                              ),
                              errorWidget: (context, url, error) => Text(
                                displayTitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            )
                          : Text(
                              displayTitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                    ),
                    const Spacer(),
                    Column(
                      children: const [
                        Icon(Icons.notifications_none_rounded, size: 24),
                        SizedBox(height: 4),
                        Text("Remind Me", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: const [
                        Icon(Icons.info_outline_rounded, size: 24),
                        SizedBox(height: 4),
                        Text("Info", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  "Coming on $month $day",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  overview,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[300],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

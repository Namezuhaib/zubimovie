import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ComingSoonMovie extends StatelessWidget {
  final String imageUrl;
  final String overview;
  final String logoUrl;
  final String month;
  final String day;

  const ComingSoonMovie({
    super.key,
    required this.imageUrl,
    required this.overview,
    required this.logoUrl,
    required this.month,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Date Section
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

          // Right Content Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Movie Poster
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: double.infinity,
                    height: size.height * 0.25,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: size.height * 0.25,
                      color: Colors.grey[800],
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error, color: Colors.red),
                  ),
                ),

                const SizedBox(height: 12),

                // Logo and Icons
                Row(
                  children: [
                    // Movie Logo
                    Expanded(
                      child: CachedNetworkImage(
                        imageUrl: logoUrl,
                        height: 40,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => const SizedBox(
                          height: 40,
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error, color: Colors.red),
                      ),
                    ),

                    // Spacer
                    const Spacer(),

                    // Remind Me
                    Column(
                      children: const [
                        Icon(Icons.notifications_none_rounded, size: 24),
                        SizedBox(height: 4),
                        Text("Remind Me", style: TextStyle(fontSize: 12)),
                      ],
                    ),

                    const SizedBox(width: 20),

                    // Info
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

                // Coming Date Text
                Text(
                  "Coming on $month $day",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 10),

                // Movie Overview
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

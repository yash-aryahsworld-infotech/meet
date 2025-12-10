import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorCard extends StatelessWidget {
  final Map<String, dynamic> doc;

  const DoctorCard({super.key, required this.doc});

  Future<void> _launchURL(BuildContext context, String urlString) async {
    if (urlString.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No map link available for this doctor")),
      );
      return;
    }

    try {
      final Uri url = Uri.parse(urlString);
      
      // mode: LaunchMode.externalApplication is crucial for opening Maps app on mobile
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      debugPrint("Error launching URL: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open maps application")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Image/Icon, Title, Category, Rating, Distance
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    shape: BoxShape.circle,
                    image: doc["image"] != null && doc["image"].toString().isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(doc["image"]),
                            fit: BoxFit.cover)
                        : null,
                  ),
                  child: doc["image"] == null || doc["image"].toString().isEmpty
                      ? const Icon(Icons.person, color: Colors.blueAccent)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doc["title"],
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${doc["category"]} • Walk-in clinic",
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, size: 12, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            "${doc["rating"]}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${(doc["distance"] as double).toStringAsFixed(1)} km away",
                      style: const TextStyle(
                          fontSize: 11, color: Colors.blueAccent),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Address Row - Full Address shown (No epsilon/ellipsis)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Icon(Icons.location_on_outlined,
                      size: 16, color: Colors.grey[500]),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    doc["address"],
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    // Removed maxLines and overflow to show full text
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Phone Row
            if (doc["phone"].toString().isNotEmpty)
              Row(
                children: [
                  Icon(Icons.phone_outlined,
                      size: 16, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    doc["phone"].toString(),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            
            const SizedBox(height: 16),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Call Logic here
                    },
                    icon: const Icon(Icons.call, size: 16),
                    label: const Text("Call"),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      foregroundColor: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _launchURL(context, doc["url"]),
                    icon: const Icon(Icons.location_on, size: 16),
                    label: const Text("View Map"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
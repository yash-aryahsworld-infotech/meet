// import 'package:flutter/material.dart';
// import 'package:healthcare_plus/utils/app_responsive.dart';

// class NearbyProvidersSection extends StatelessWidget {
//   const NearbyProvidersSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Mock Data
//     final List<Map<String, dynamic>> providers = [
//       {
//         "name": "Lilavati Hospital",
//         "rating": 4.3,
//         "type": "Hospital",
//         "distance": "2.5 km",
//         "tags": ["Emergency", "Cardiology"],
//       },
//       {
//         "name": "Apollo Clinic Bandra",
//         "rating": 4.1,
//         "type": "Clinic",
//         "distance": "1.2 km",
//         "tags": ["General Medicine", "Pediatrics"],
//       },
//       {
//         "name": "Dr. Lal PathLabs",
//         "rating": 4.0,
//         "type": "Lab",
//         "distance": "800 m",
//         "tags": ["Blood Tests", "Diagnostics"],
//       },
//     ];

//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header Row
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Flexible(
//                 child: Row(
//                   children: [
//                     const Icon(Icons.location_on_outlined, size: 22),
//                     const SizedBox(width: 8),
//                     Flexible(
//                       child: Text(
//                         "Nearby Healthcare Providers in Mumbai",
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.grey.shade900,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               TextButton(
//                 onPressed: () => debugPrint("Show More Clicked"),
//                 child: const Text("Show More"),
//               )
//             ],
//           ),
//           const SizedBox(height: 20),

//           // Responsive Grid Wrapper
//           LayoutBuilder(
//             builder: (context, constraints) {
//               // 1. Determine columns based on screen type
//               int crossAxisCount = 3;
//               if (AppResponsive.isMobile(context)) {
//                 crossAxisCount = 1;
//               } else if (AppResponsive.isTablet(context)) {
//                 crossAxisCount = 2;
//               }

//               // 2. Calculate ideal aspect ratio dynamically
//               // We want the card to be roughly ~180-200px tall to fit content without overflow.
//               // Formula: Ratio = Width / Height
//               double spacing = 16;
//               double totalSpacing = (crossAxisCount - 1) * spacing;
//               double availableWidth = constraints.maxWidth - totalSpacing;
//               double itemWidth = availableWidth / crossAxisCount;
              
//               // Define fixed height for the card content to ensure consistency
//               double desiredItemHeight = 190; 
//               double childAspectRatio = itemWidth / desiredItemHeight;

//               return GridView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: providers.length,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: crossAxisCount,
//                   mainAxisSpacing: spacing,
//                   crossAxisSpacing: spacing,
//                   childAspectRatio: childAspectRatio,
//                 ),
//                 itemBuilder: (context, index) {
//                   return _ProviderCard(data: providers[index]);
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _ProviderCard extends StatelessWidget {
//   final Map<String, dynamic> data;

//   const _ProviderCard({required this.data});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         // Use standard start alignment to let content flow naturally
//         mainAxisAlignment: MainAxisAlignment.start, 
//         children: [
//           // Top Section: Name and Rating
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: Text(
//                   data['name'],
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   maxLines: 1,
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Row(
//                 children: [
//                   const Icon(Icons.star, size: 16, color: Colors.amber),
//                   const SizedBox(width: 4),
//                   Text(
//                     "${data['rating']}",
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),

//           // Type Pill
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey.shade300),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Text(
//               data['type'],
//               style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
//             ),
//           ),
          
//           const SizedBox(height: 8),
//           Text(
//             data['distance'],
//             style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
//           ),

//           const Spacer(), // Pushes tags to the bottom

//           // Bottom Section: Tags
//           SizedBox(
//             width: double.infinity,
//             child: Wrap(
//               spacing: 8,
//               runSpacing: 4,
//               children: (data['tags'] as List<String>).map((tag) {
//                 return Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade100,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     tag,
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.grey.shade800,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
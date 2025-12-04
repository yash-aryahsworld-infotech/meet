import 'package:flutter/material.dart';

class CommunitySection extends StatelessWidget {
  CommunitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Main Container for the whole section
        Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(Icons.people_outline, color: Colors.grey[800], size: 24),
                  const SizedBox(width: 12),
                  Text(
                    "Health Community & Support",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "Connect with others on similar health journeys, get expert advice, and join wellness programs.",
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),

              const SizedBox(height: 32),

              // 1. Popular Health Forums Section
              const Text(
                "Popular Health Forums",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              
              // Grid of Forum Cards
              LayoutBuilder(
                builder: (context, constraints) {
                  // Responsive grid: 1 column on small screens, 2 on larger
                  final double width = constraints.maxWidth;
                  final int crossAxisCount = width > 700 ? 2 : 1;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      mainAxisExtent: 130, // Fixed height for consistent look
                    ),
                    itemCount: _forums.length,
                    itemBuilder: (context, index) {
                      return _buildForumCard(_forums[index]);
                    },
                  );
                }
              ),

              const SizedBox(height: 32),

              // 2. Recommended Wellness Programs Section
              const Text(
                "Recommended Wellness Programs",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

              // Horizontal Scrollable List for Programs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _programs.map((program) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: SizedBox(
                        width: 300, // Fixed width for program cards
                        child: _buildProgramCard(program),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- Helper Widgets ---

  Widget _buildForumCard(ForumData data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.title,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  data.category,
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${data.members} members",
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              Text(
                "${data.posts} posts",
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildProgramCard(ProgramData data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 16),
          _buildInfoRow("Duration:", data.duration),
          const SizedBox(height: 8),
          _buildInfoRow("Participants:", data.participants.toString()),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Rating:", style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    data.rating.toString(),
                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Cost:", style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              Container(
                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                 decoration: BoxDecoration(
                   color: Colors.grey[100],
                   borderRadius: BorderRadius.circular(12),
                 ),
                 child: Text(
                   data.cost, 
                   style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
                 ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2), // Blue color from image
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text("Join Program", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
      ],
    );
  }

  // --- Data ---
  
  final List<ForumData> _forums = [
    ForumData("Maternal Health Support", "Pregnancy & Motherhood", 1250, 450),
    ForumData("Mental Wellness Circle", "Mental Health", 890, 320),
    ForumData("Diabetes Management", "Chronic Conditions", 650, 280),
    ForumData("Child Development", "Pediatrics", 430, 150),
  ];

  final List<ProgramData> _programs = [
    ProgramData("Stress Busters", "4 weeks", 156, 4.6, "Free"),
    ProgramData("Pregnancy Yoga", "8 weeks", 89, 4.8, "₹2,000"),
    ProgramData("Heart Health Challenge", "6 weeks", 203, 4.4, "₹500"),
  ];
}

// --- Data Models ---

class ForumData {
  final String title;
  final String category;
  final int members;
  final int posts;

  ForumData(this.title, this.category, this.members, this.posts);
}

class ProgramData {
  final String title;
  final String duration;
  final int participants;
  final double rating;
  final String cost;

  ProgramData(this.title, this.duration, this.participants, this.rating, this.cost);
}
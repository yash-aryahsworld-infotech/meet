import 'package:flutter/material.dart';

// -----------------------------
// DATA MODEL
// -----------------------------
class Invoice {
  final String id;
  final String status;
  final String description;
  final String date;
  final String due;
  final String? paidDate;
  final String amount;
  final bool hasPayButton;

  Invoice({
    required this.id,
    required this.status,
    required this.description,
    required this.date,
    required this.due,
    this.paidDate,
    required this.amount,
    required this.hasPayButton,
  });
}

// -----------------------------
// PAGE
// -----------------------------
class InvoicesPage extends StatefulWidget {
  const InvoicesPage({super.key});

  @override
  State<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  // Static Invoice Data
  final List<Invoice> invoices = [
    Invoice(
      id: 'INV-2024-001',
      status: 'Paid',
      description: 'Monthly wellness program subscription - January 2024',
      date: '01/01/2024',
      due: '31/01/2024',
      paidDate: '28/01/2024',
      amount: '₹45,000',
      hasPayButton: false,
    ),
    Invoice(
      id: 'INV-2024-002',
      status: 'Paid',
      description: 'Monthly wellness program subscription - February 2024',
      date: '01/02/2024',
      due: '29/02/2024',
      paidDate: '25/02/2024',
      amount: '₹47,500',
      hasPayButton: false,
    ),
    Invoice(
      id: 'INV-2024-003',
      status: 'Pending',
      description: 'Monthly wellness program subscription - March 2024',
      date: '01/03/2024',
      due: '31/03/2024',
      amount: '₹52,000',
      hasPayButton: true,
    ),
    Invoice(
      id: 'INV-2023-012',
      status: 'Overdue',
      description: 'Monthly wellness program subscription - December 2023',
      date: '01/12/2023',
      due: '31/12/2023',
      amount: '₹38,000',
      hasPayButton: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchFilter(),
        const SizedBox(height: 20),

        // ✔️ ListView inside SingleChildScrollView (fixed height)
        ListView.separated(
          itemCount: invoices.length,
          shrinkWrap: true,               // IMPORTANT
          physics: const NeverScrollableScrollPhysics(), // IMPORTANT
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) =>
              _buildInvoiceCard(invoices[index]),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------
  // SEARCH & FILTER
  // ---------------------------------------------------------------
  Widget _buildSearchFilter() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Search invoices by number or description...',
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                prefixIcon: Icon(Icons.search, size: 20, color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 45,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: const [
              Text("All Status", style: TextStyle(fontSize: 14)),
              Icon(Icons.keyboard_arrow_down, size: 18),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------
  // CARD UI
  // ---------------------------------------------------------------
  Widget _buildInvoiceCard(Invoice invoice) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(invoice.id,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              _buildStatusBadge(invoice.status),
            ],
          ),

          const SizedBox(height: 8),
          Text(invoice.description,
              style: TextStyle(color: Colors.grey[600], fontSize: 13)),

          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildIconText(Icons.calendar_today, "Date: ${invoice.date}"),
              _buildIconText(Icons.access_time, "Due: ${invoice.due}"),
              if (invoice.paidDate != null)
                Text("Paid: ${invoice.paidDate}",
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),

          const SizedBox(height: 8),
          Text(invoice.amount,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.bold)),

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),

          // Buttons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildOutlinedButton("Download", icon: Icons.download),
              const SizedBox(width: 8),
              if (invoice.hasPayButton)
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Pay Now"),
                ),
              const SizedBox(width: 8),
              _buildOutlinedButton("View Details"),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------
  // SMALL COMPONENTS
  // ---------------------------------------------------------------
  Widget _buildStatusBadge(String status) {
    Color bg, text;
    IconData icon;

    switch (status) {
      case 'Paid':
        bg = const Color(0xFFDCFCE7);
        text = const Color(0xFF15803D);
        icon = Icons.check_circle_outline;
        break;
      case 'Pending':
        bg = const Color(0xFFDBEAFE);
        text = const Color(0xFF1D4ED8);
        icon = Icons.access_time;
        break;
      case 'Overdue':
        bg = const Color(0xFFFEE2E2);
        text = const Color(0xFFB91C1C);
        icon = Icons.error_outline;
        break;
      default:
        bg = Colors.grey.shade100;
        text = Colors.grey.shade700;
        icon = Icons.info_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Icon(icon, size: 14, color: text),
          const SizedBox(width: 4),
          Text(status,
              style:
                  TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: text)),
        ],
      ),
    );
  }

  Widget _buildIconText(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey[400]),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
      ],
    );
  }

  Widget _buildOutlinedButton(String text, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 6),
          ],
          Text(text,
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:healthcare_plus/utils/app_responsive.dart';

class UploadDocuments extends StatefulWidget {
  const UploadDocuments({super.key});

  @override
  State<UploadDocuments> createState() => _UploadDocumentsState();
}

class _UploadDocumentsState extends State<UploadDocuments> {
  final _providerController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  String? _selectedCategory;

  static const _kPrimary = Color(0xFF3B82F6);
  static const _kTextDark = Color(0xFF1F2937);
  static const _kTextGrey = Color(0xFF6B7280);
  static const _kBorder = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    // REPLACEMENT: Using Material instead of Scaffold
    return Material(
      child: SingleChildScrollView(
        // Fix for Infinite Size: Explicitly constrain the width
        child: Center(
          // Simple padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildUploadForm(context),
              const SizedBox(height: 24),
              _buildDocumentList(context),
              const SizedBox(height: 24),
              _buildSecuritySection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.upload_file, color: _kPrimary, size: 28),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "Medical Document Upload",
                style: TextStyle(
                  // Fallback to fixed size if AppResponsive causes issues
                  fontSize: MediaQuery.of(context).size.width > 600 ? 30 : 24,
                  fontWeight: FontWeight.bold,
                  color: _kTextDark,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          "Securely upload and manage your medical documents with end-to-end encryption",
          style: TextStyle(color: _kTextGrey, fontSize: 14),
        ),
      ],
    );
  }

  // --- REUSABLE SHELLS ---

  Widget _cardshell({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _kBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _inputShell({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: _kTextDark,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }

  // --- FORM SECTION ---

  Widget _buildUploadForm(BuildContext context) {
    bool isMobile = AppResponsive.isMobile(context);

    final catDropdown = _buildDropdown();
    final datePicker = _buildDatePicker(context);

    return _cardshell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMobile) ...[
            _inputShell(label: "Document Category *", child: catDropdown),
            const SizedBox(height: 16),
            _inputShell(label: "Test/Document Date", child: datePicker),
          ] else
            Row(
              children: [
                Expanded(
                  child: _inputShell(
                    label: "Document Category *",
                    child: catDropdown,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _inputShell(
                    label: "Test/Document Date",
                    child: datePicker,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 16),
          _inputShell(
            label: "Doctor/Provider Name",
            child: _buildTextField(
              _providerController,
              "e.g., Dr. Smith, ABC Hospital",
            ),
          ),
          const SizedBox(height: 16),
          _inputShell(
            label: "Description (Optional)",
            child: _buildTextField(
              _descriptionController,
              "Brief description...",
              maxLines: 3,
            ),
          ),
          const SizedBox(height: 24),
          _buildDropZone(context),
          const SizedBox(height: 16),
          _buildFooterNotes(),
        ],
      ),
    );
  }

  // --- INPUT HELPER WIDGETS ---

  InputDecoration _inputDeco(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _kBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _kBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _kPrimary),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 14),
      decoration: _inputDeco(hint),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      decoration: _inputDeco("Select category"),
      icon: const Icon(Icons.keyboard_arrow_down),
      items: ["Lab Report", "Prescription", "Scan", "Invoice"]
          .map(
            (v) => DropdownMenuItem(
              value: v,
              child: Text(v, style: const TextStyle(fontSize: 14)),
            ),
          )
          .toList(),
      onChanged: (v) => setState(() => _selectedCategory = v),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return TextField(
      controller: _dateController,
      readOnly: true,
      style: const TextStyle(fontSize: 14),
      decoration: _inputDeco("dd-mm-yyyy").copyWith(
        suffixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
      ),
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (picked != null) {
          _dateController.text = "${picked.day}-${picked.month}-${picked.year}";
        }
      },
    );
  }

  Widget _buildDropZone(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Icon(Icons.upload_file_outlined, size: 40, color: Colors.grey[400]),
          const SizedBox(height: 12),
          const Text(
            "Upload Medical Documents",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _kTextDark,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Drag & drop or click to browse",
            style: TextStyle(color: _kTextGrey, fontSize: 14),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: _kPrimary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Select Files"),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterNotes() {
    Widget note(IconData i, String t, {Color? c}) => Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(i, size: 14, color: c ?? Colors.grey[400]),
          const SizedBox(width: 8),
          Text(t, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
        ],
      ),
    );
    return Column(
      children: [
        note(Icons.folder_outlined, "Supported: PDF, DOC, JPG, PNG"),
        note(Icons.attach_file, "Max size: 10 MB"),
        note(
          Icons.lock_outline,
          "Encrypted & HIPAA compliant",
          c: Colors.orange,
        ),
      ],
    );
  }

  // --- LIST SECTION ---

  Widget _buildDocumentList(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    return _cardshell(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Your Documents (1)",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: _kTextDark,
                ),
              ),
              if (!isMobile) _buildBadge(),
            ],
          ),
          if (isMobile) ...[
            const SizedBox(height: 8),
            Align(alignment: Alignment.centerLeft, child: _buildBadge()),
          ],
          const SizedBox(height: 16),
          _buildListItem(context),
        ],
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: const Row(
        children: [
          Icon(Icons.lock_outline, size: 14, color: _kTextGrey),
          SizedBox(width: 4),
          Text("Encrypted", style: TextStyle(fontSize: 12, color: _kTextGrey)),
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _kBorder),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.science_outlined, color: Colors.green),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      children: [
                        const Text(
                          "blood_test_results.pdf",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withAlpha(  25),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "completed",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Lab Report • 2.34 MB • 22/11/2025",
                      style: TextStyle(color: _kTextGrey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.visibility_outlined, color: _kTextGrey),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.download_outlined, color: _kTextGrey),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- SECURITY SECTION ---

  Widget _buildSecuritySection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withAlpha(51)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.security, color: _kPrimary, size: 20),
              SizedBox(width: 8),
              Text(
                "Security & Privacy",
                style: TextStyle(
                  color: _kPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...[
            "All documents are encrypted with AES-256 encryption",
            "Only you and authorized healthcare providers can access your documents",
            "Documents are stored in HIPAA-compliant secure cloud storage",
          ].map(
            (text) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Icon(Icons.circle, size: 4, color: _kPrimary),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: _kPrimary,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

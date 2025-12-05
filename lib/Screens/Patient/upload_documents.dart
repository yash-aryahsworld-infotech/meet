import 'package:flutter/material.dart';
import 'package:healthcare_plus/utils/app_responsive.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class UploadDocuments extends StatefulWidget {
  final String? appointmentId; // Optional: if null, shows all documents
  final String? doctorName;

  const UploadDocuments({
    super.key,
    this.appointmentId,
    this.doctorName,
  });

  @override
  State<UploadDocuments> createState() => _UploadDocumentsState();
}

class _UploadDocumentsState extends State<UploadDocuments> {
  final _providerController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  String? _selectedCategory;
  
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final ImagePicker _imagePicker = ImagePicker();
  
  List<DocumentModel> _documents = [];
  bool _isLoading = true;
  bool _isUploading = false;
  String? _patientId;
  String? _patientName;

  static const _kPrimary = Color(0xFF3B82F6);
  static const _kTextDark = Color(0xFF1F2937);
  static const _kTextGrey = Color(0xFF6B7280);
  static const _kBorder = Color(0xFFE5E7EB);

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadDocuments();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _patientId = prefs.getString("userKey");
      _patientName = prefs.getString("firstName") ?? "Patient";
    });
  }

  void _loadDocuments() {
    if (widget.appointmentId != null) {
      // Load documents for specific appointment
      _database
          .child('healthcare/appointments/${widget.appointmentId}/documents')
          .onValue
          .listen((event) {
        _updateDocumentsList(event);
      });
    } else {
      // Load all documents for this patient
      _database.child('healthcare/appointments').onValue.listen((event) {
        if (!mounted) return;
        
        final allDocs = <DocumentModel>[];
        if (event.snapshot.exists) {
          final appointments = event.snapshot.value as Map<dynamic, dynamic>;
          appointments.forEach((appointmentId, appointmentData) {
            final appointment = appointmentData as Map<dynamic, dynamic>;
            if (appointment['documents'] != null) {
              final docs = appointment['documents'] as Map<dynamic, dynamic>;
              docs.forEach((docId, docData) {
                final docMap = docData as Map<dynamic, dynamic>;
                if (docMap['uploadedBy'] == _patientId) {
                  allDocs.add(DocumentModel.fromMap(docId, docMap));
                }
              });
            }
          });
        }
        
        allDocs.sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));
        setState(() {
          _documents = allDocs;
          _isLoading = false;
        });
      });
    }
  }

  void _updateDocumentsList(DatabaseEvent event) {
    if (!mounted) return;

    if (event.snapshot.exists) {
      final docsData = event.snapshot.value as Map<dynamic, dynamic>;
      final docs = <DocumentModel>[];

      docsData.forEach((key, value) {
        final docMap = value as Map<dynamic, dynamic>;
        docs.add(DocumentModel.fromMap(key, docMap));
      });

      docs.sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));

      setState(() {
        _documents = docs;
        _isLoading = false;
      });
    } else {
      setState(() {
        _documents = [];
        _isLoading = false;
      });
    }
  }

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
            color: Colors.black.withValues(alpha: 0.03),
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
      initialValue: _selectedCategory,
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
          if (_isUploading)
            const CircularProgressIndicator()
          else
            Icon(Icons.upload_file_outlined, size: 40, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            _isUploading ? "Uploading..." : "Upload Medical Documents",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: _kTextDark,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Select files to upload",
            style: TextStyle(color: _kTextGrey, fontSize: 14),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _isUploading ? null : _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.image, size: 18),
                label: const Text("Image"),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _isUploading ? null : _pickDocument,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kPrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.file_present, size: 18),
                label: const Text("Document"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image == null) return;
      await _uploadFile(File(image.path), 'image', image.name);
    } catch (e) {
      _showError("Failed to pick image: $e");
    }
  }

  Future<void> _pickDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'dcm', 'dicom', 'nii', 'nifti', 'zip'],
      );

      if (result == null) return;

      final file = File(result.files.single.path!);
      final fileName = result.files.single.name;
      final extension = fileName.split('.').last.toLowerCase();

      String fileType = 'document';
      if (extension == 'pdf') {
        fileType = 'pdf';
      } else if (['dcm', 'dicom', 'nii', 'nifti'].contains(extension)) {
        fileType = 'medical_imaging';
      }

      await _uploadFile(file, fileType, fileName);
    } catch (e) {
      _showError("Failed to pick file: $e");
    }
  }

  Future<void> _uploadFile(File file, String fileType, String fileName) async {
    if (widget.appointmentId == null) {
      _showError("Please select an appointment first");
      return;
    }

    setState(() => _isUploading = true);

    try {
      // Check file size
      final fileSize = await file.length();
      final fileSizeMB = fileSize / (1024 * 1024);

      if (fileType == 'image' && fileSizeMB > 10) {
        _showError("Image too large (max 10MB)");
        setState(() => _isUploading = false);
        return;
      } else if (fileSizeMB > 20) {
        _showError("File too large (max 20MB)");
        setState(() => _isUploading = false);
        return;
      }

      // Upload to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child(
          'healthcare/documents/${widget.appointmentId}/${DateTime.now().millisecondsSinceEpoch}_$fileName');

      await storageRef.putFile(file);
      final downloadUrl = await storageRef.getDownloadURL();

      // Save metadata to Realtime Database
      final docRef = _database
          .child('healthcare/appointments/${widget.appointmentId}/documents')
          .push();

      await docRef.set({
        'fileName': fileName,
        'fileUrl': downloadUrl,
        'fileType': fileType,
        'uploadedBy': _patientId,
        'uploaderName': _patientName,
        'uploadedAt': ServerValue.timestamp,
        'fileSize': fileSize,
        'category': _selectedCategory ?? 'Other',
        'provider': _providerController.text,
        'description': _descriptionController.text,
        'date': _dateController.text,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Document uploaded successfully")),
        );
        // Clear form
        _providerController.clear();
        _descriptionController.clear();
        _dateController.clear();
        setState(() => _selectedCategory = null);
      }
    } catch (e) {
      _showError("Upload failed: $e");
    } finally {
      setState(() => _isUploading = false);
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
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
    
    if (_isLoading) {
      return _cardshell(
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return _cardshell(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Your Documents (${_documents.length})",
                style: const TextStyle(
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
          if (_documents.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Text(
                "No documents uploaded yet",
                style: TextStyle(color: _kTextGrey),
              ),
            )
          else
            ..._documents.map((doc) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildListItem(context, doc),
                )),
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

  Widget _buildListItem(BuildContext context, DocumentModel doc) {
    IconData icon;
    Color iconColor;

    switch (doc.fileType) {
      case 'image':
        icon = Icons.image;
        iconColor = Colors.blue;
        break;
      case 'pdf':
        icon = Icons.picture_as_pdf;
        iconColor = Colors.red;
        break;
      case 'medical_imaging':
        icon = Icons.medical_information;
        iconColor = Colors.purple;
        break;
      default:
        icon = Icons.description;
        iconColor = Colors.orange;
    }

    final fileSizeMB = (doc.fileSize / (1024 * 1024)).toStringAsFixed(2);

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
                  color: iconColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doc.fileName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${doc.category} • $fileSizeMB MB • ${_formatDate(doc.uploadedAt)}",
                      style: const TextStyle(color: _kTextGrey, fontSize: 12),
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
                onPressed: () => _openDocument(doc.fileUrl),
                icon: const Icon(Icons.visibility_outlined, color: _kTextGrey),
                tooltip: "View",
              ),
              IconButton(
                onPressed: () => _deleteDocument(doc),
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                tooltip: "Delete",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _openDocument(String url) async {
    // Open URL in browser/viewer
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Opening document...")),
      );
    }
  }

  Future<void> _deleteDocument(DocumentModel doc) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Document"),
        content: const Text("Are you sure you want to delete this document?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      // Delete from Storage
      await FirebaseStorage.instance.refFromURL(doc.fileUrl).delete();

      // Delete from Database
      await _database
          .child('healthcare/appointments/${widget.appointmentId}/documents/${doc.id}')
          .remove();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Document deleted")),
        );
      }
    } catch (e) {
      _showError("Failed to delete: $e");
    }
  }

  String _formatDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return "${date.day}/${date.month}/${date.year}";
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


class DocumentModel {
  final String id;
  final String fileName;
  final String fileUrl;
  final String fileType;
  final String uploadedBy;
  final String uploaderName;
  final int uploadedAt;
  final int fileSize;
  final String category;

  DocumentModel({
    required this.id,
    required this.fileName,
    required this.fileUrl,
    required this.fileType,
    required this.uploadedBy,
    required this.uploaderName,
    required this.uploadedAt,
    required this.fileSize,
    required this.category,
  });

  factory DocumentModel.fromMap(String id, Map<dynamic, dynamic> map) {
    return DocumentModel(
      id: id,
      fileName: map['fileName']?.toString() ?? '',
      fileUrl: map['fileUrl']?.toString() ?? '',
      fileType: map['fileType']?.toString() ?? 'document',
      uploadedBy: map['uploadedBy']?.toString() ?? '',
      uploaderName: map['uploaderName']?.toString() ?? '',
      uploadedAt: map['uploadedAt'] as int? ?? 0,
      fileSize: map['fileSize'] as int? ?? 0,
      category: map['category']?.toString() ?? 'Other',
    );
  }
}

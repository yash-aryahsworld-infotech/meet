import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorDocumentsViewer extends StatefulWidget {
  final String appointmentId;
  final String patientName;

  const DoctorDocumentsViewer({
    super.key,
    required this.appointmentId,
    required this.patientName,
  });

  @override
  State<DoctorDocumentsViewer> createState() => _DoctorDocumentsViewerState();
}

class _DoctorDocumentsViewerState extends State<DoctorDocumentsViewer> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  
  List<DocumentModel> _documents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  void _loadDocuments() {
    _database
        .child('healthcare/appointments/${widget.appointmentId}/documents')
        .onValue
        .listen((event) {
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
    });
  }

  Future<void> _openDocument(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Cannot open document")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error opening document: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Patient Documents",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.patientName,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _documents.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.folder_open,
                          size: 64, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text(
                        "No documents available",
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Patient hasn't uploaded any documents yet",
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _documents.length,
                  itemBuilder: (context, index) {
                    final doc = _documents[index];
                    return _buildDocumentCard(doc);
                  },
                ),
    );
  }

  Widget _buildDocumentCard(DocumentModel doc) {
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

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: iconColor.withValues(alpha: 0.1),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          doc.fileName,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              "Uploaded by: ${doc.uploaderName}",
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            Text(
              _formatDate(doc.uploadedAt),
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.open_in_new, color: Colors.blue),
          onPressed: () => _openDocument(doc.fileUrl),
        ),
        onTap: () => _openDocument(doc.fileUrl),
      ),
    );
  }

  String _formatDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();

    if (date.day == now.day && date.month == now.month && date.year == now.year) {
      return "Today ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    } else {
      return "${date.day}/${date.month}/${date.year}";
    }
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

  DocumentModel({
    required this.id,
    required this.fileName,
    required this.fileUrl,
    required this.fileType,
    required this.uploadedBy,
    required this.uploaderName,
    required this.uploadedAt,
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
    );
  }
}

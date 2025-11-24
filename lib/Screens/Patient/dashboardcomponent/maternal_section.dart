import 'package:flutter/material.dart';

class MaternalSection extends StatefulWidget {
  const MaternalSection({super.key});

  @override
  State<MaternalSection> createState() => _MaternalSectionState();
}

class _MaternalSectionState extends State<MaternalSection> {
  final TextEditingController _weekController = TextEditingController(text: '0');
  final TextEditingController _dateController = TextEditingController();

  String? _selectedStage = 'Prenatal';

  @override
  void dispose() {
    _weekController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  bool _isMobileLayout(BuildContext context) {
    return MediaQuery.of(context).size.width < 700; // Mobile + Tablet breakpoint
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = _isMobileLayout(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        /// ---------- TOP BANNER ----------
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFCE4EC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.pink.shade100),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.favorite_border, color: Colors.pink[800], size: 20),
                  const SizedBox(width: 8),
                  Text(
                    "Maternal Health Tracker",
                    style: TextStyle(
                      color: Colors.pink[800],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 28),
                child: Text(
                  "Track your pregnancy journey with personalized insights.",
                  style: TextStyle(color: Colors.pink[700], fontSize: 13),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        /// ---------- FORM CARD ----------
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                children: [
                  Icon(Icons.face_retouching_natural, color: Colors.grey[800], size: 20),
                  const SizedBox(width: 8),
                  Text(
                    "Set Up Your Pregnancy Tracker",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[900],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// ---------- ROW 1: Stage + Week ----------
              isMobile
                  ? Column(
                      children: [
                        _buildStageField(),
                        const SizedBox(height: 20),
                        _buildWeekField(),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(child: _buildStageField()),
                        const SizedBox(width: 20),
                        Expanded(child: _buildWeekField()),
                      ],
                    ),

              const SizedBox(height: 20),

              /// ---------- DUE DATE ----------
              _buildLabel("Expected Due Date"),
              const SizedBox(height: 8),
              SizedBox(
                height: 48,
                child: TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  decoration: _decoration().copyWith(
                    hintText: 'dd-mm-yyyy',
                    suffixIcon:
                        const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.black54),
                  ),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null) {
                      setState(() {
                        _dateController.text =
                            "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
                      });
                    }
                  },
                ),
              ),

              const SizedBox(height: 24),

              /// ---------- BUTTON ----------
              SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text(
                    "Create Pregnancy Tracker",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// ---------- FIELD BUILDERS ----------

  Widget _buildStageField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Pregnancy Stage"),
        const SizedBox(height: 8),
        SizedBox(
          height: 48,
          child: DropdownButtonFormField<String>(
            value: _selectedStage,
            decoration: _decoration(),
            items: ['Prenatal', 'Postnatal', 'Trying to Conceive']
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
            onChanged: (value) => setState(() => _selectedStage = value),
          ),
        ),
      ],
    );
  }

  Widget _buildWeekField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Current Gestational Week"),
        const SizedBox(height: 8),
        SizedBox(
          height: 48,
          child: TextFormField(
            controller: _weekController,
            keyboardType: TextInputType.number,
            decoration: _decoration(),
          ),
        ),
      ],
    );
  }

  /// ---------- DECORATION ----------
  InputDecoration _decoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.blue),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[800]),
    );
  }
}

import 'package:flutter/material.dart';
import 'form_surat_page.dart';

class PilihJenisSuratPage extends StatefulWidget {
  final int? pendudukId;
  const PilihJenisSuratPage({Key? key, this.pendudukId}) : super(key: key);

  @override
  State<PilihJenisSuratPage> createState() => _PilihJenisSuratPageState();
}

class _PilihJenisSuratPageState extends State<PilihJenisSuratPage> {
  String? selectedSurat;

  final List<Map<String, String>> jenisSurat = [
    {'value': 'Surat Belum Menikah', 'label': 'Surat Belum Menikah'},
    {'value': 'Surat Domisili', 'label': 'Surat Domisili'},
    // {'value': 'Surat Keterangan Usaha', 'label': 'Surat Keterangan Usaha'},
    // {'value': 'Surat Pengantar', 'label': 'Surat Pengantar'},
    // {'value': 'Surat Keterangan Kelahiran', 'label': 'Surat Keterangan Kelahiran'},
  ];

  // Update colors to use blue theme
  static const Color themeColor = Color(0xFF3AC53E); // Material blue
  final Color primaryColor = themeColor;
  final Color disabledColor = themeColor.withOpacity(0.4);
  final Color textColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: primaryColor,
      elevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Layanan Surat',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xFFE3F2FD)], // Light blue gradient
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepIndicator(),
            const SizedBox(height: 24),
            _buildPendudukIdCard(),
            const SizedBox(height: 24),
            _buildHeaderText(),
            const SizedBox(height: 16),
            _buildSuratDropdown(),
            const Spacer(),
            _buildContinueButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepCircle(1, true, 'Pilih'),
        _buildStepLine(true),
        _buildStepCircle(2, false, 'Isi'),
        _buildStepLine(false),
        _buildStepCircle(3, false, 'Kirim'),
      ],
    );
  }

  Widget _buildStepCircle(int step, bool active, String label) {
    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: active ? primaryColor : Colors.grey[300],
            shape: BoxShape.circle,
            boxShadow: active
                ? [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              '$step',
              style: TextStyle(
                color: active ? Colors.white : Colors.grey[600],
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
            color: active ? primaryColor : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(bool active) {
    return Container(
      width: 60,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      color: active ? primaryColor : Colors.grey[300],
    );
  }

  Widget _buildPendudukIdCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              color: primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ID Penduduk',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  widget.pendudukId?.toString() ?? 'Tidak tersedia',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: widget.pendudukId != null ? primaryColor.withOpacity(0.1) : Colors.red[50],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              widget.pendudukId != null ? 'Tervalidasi' : 'Tidak Valid',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: widget.pendudukId != null ? primaryColor : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Surat apaan nih yang mau kamu urus?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Pilih jenis surat yang kamu butuhkan dari daftar di bawah',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSuratDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedSurat,
          isExpanded: true,
          hint: Text(
            'Pilih jenis surat',
            style: TextStyle(color: Colors.grey[600]),
          ),
          icon: Icon(Icons.keyboard_arrow_down, color: primaryColor),
          borderRadius: BorderRadius.circular(12),
          onChanged: (String? newValue) => setState(() => selectedSurat = newValue),
          items: jenisSurat.map((item) => DropdownMenuItem<String>(
            value: item['value'],
            child: Text(
              item['label']!,
              style: const TextStyle(fontSize: 15),
            ),
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: selectedSurat == null ? null : () => _navigateToFormSurat(),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          disabledBackgroundColor: disabledColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Lanjutkan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, color: Colors.white),
          ],
        ),
      ),
    );
  }

  void _navigateToFormSurat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormSuratPage(
          jenisSurat: selectedSurat!,
          pendudukId: widget.pendudukId,
        ),
      ),
    );
  }
}
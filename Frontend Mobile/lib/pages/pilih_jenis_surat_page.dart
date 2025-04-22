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
    {'value': 'Surat Tidak Mampu', 'label': 'Surat Tidak Mampu'},
    {'value': 'Surat Keterangan Domisili', 'label': 'Surat Keterangan Domisili'},
    {'value': 'Surat Keterangan Usaha', 'label': 'Surat Keterangan Usaha'},
    {'value': 'Surat Pengantar', 'label': 'Surat Pengantar'},
    {'value': 'Surat Keterangan Kelahiran', 'label': 'Surat Keterangan Kelahiran'},
  ];

  final Color primaryColor = Colors.blue[700]!;
  final Color disabledColor = Colors.blue[200]!;
  final Color textColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: primaryColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Layanan Surat',
        style: TextStyle(
          color: Colors.white, 
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderText(),
          const SizedBox(height: 24),
          _buildSuratDropdown(),
          const SizedBox(height: 32),
          _buildContinueButton(),
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
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[200]!,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedSurat,
          isExpanded: true,
          hint: const Text('Pilih jenis surat'),
          icon: const Icon(Icons.keyboard_arrow_down),
          borderRadius: BorderRadius.circular(8),
          onChanged: (String? newValue) => setState(() => selectedSurat = newValue),
          items: jenisSurat.map((item) => DropdownMenuItem<String>(
            value: item['value'],
            child: Text(item['label']!),
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: selectedSurat == null 
            ? null 
            : () => _navigateToFormSurat(),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          disabledBackgroundColor: disabledColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
        ),
        child: Text(
          'Lanjutkan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
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
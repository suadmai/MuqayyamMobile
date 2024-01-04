

import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms and Conditions'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Borang Persetujuan [Nama Aplikasi Anda]',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Gambaran Keseluruhan:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Terima kasih kerana memilih [Nama Aplikasi Anda]. Sebelum anda meneruskan untuk mencipta akaun, sila ambil masa sejenak untuk membaca dan memahami terma dan syarat berikut.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Terma dan Syarat:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '1. Maklumat Peribadi:\n'
              '   - [Nama Aplikasi Anda] mengumpul dan memproses maklumat peribadi, termasuk tetapi tidak terhad kepada, nama anda, alamat emel, umur, nombor telefon, dan alamat.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '2. Tujuan Pengumpulan:\n'
              '   - Maklumat yang dikumpul digunakan untuk tujuan mencipta dan mengekalkan akaun pengguna anda, menyediakan perkhidmatan yang dipersonalisasi, dan meningkatkan keseluruhan pengalaman pengguna.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '3. Maklumat Kesihatan (jika berkenaan):\n'
              '   - Jika anda seorang pesakit, anda mungkin diminta untuk memberikan maklumat mengenai gejala dan pembedahan. Maklumat ini digunakan untuk menawarkan perkhidmatan berkaitan kesihatan yang dipersonalisasi.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '4. Keselamatan:\n'
              '   - Kami mengambil serius mengenai keselamatan data anda. [Nama Aplikasi Anda] menggunakan langkah-langkah piawai industri untuk melindungi maklumat peribadi anda daripada akses, pendedahan, pengubahan, dan pemusnahan yang tidak dibenarkan.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '5. Persetujuan untuk Pemprosesan:\n'
              '   - Dengan menekan "Daftar," anda bersetuju untuk pemprosesan maklumat peribadi anda seperti yang diterangkan dalam borang persetujuan ini.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '6. Terma Perkhidmatan dan Dasar Privasi:\n'
              '   - Anda digalakkan untuk membaca dan memahami [Terma Perkhidmatan Kami](#) dan [Dasar Privasi Kami](#) untuk memahami sepenuhnya hak anda dan amalan pemprosesan data kami.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '7. PDPA (Akta Perlindungan Data Peribadi):\n'
              '   - Dengan menggunakan [Nama Aplikasi Anda], anda mengakui dan bersetuju bahawa pemprosesan maklumat peribadi anda akan tertakluk kepada peruntukan Akta Perlindungan Data Peribadi (PDPA) dan dasar-dasar privasi kami.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '8. Had Umur:\n'
              '   - Aplikasi ini ditujukan untuk pengguna yang berumur [masukkan syarat umur]. Jika anda berada di bawah umur ini, harap untuk tidak menggunakan aplikasi ini.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Saya telah membaca dan memahami terma dan syarat yang dinyatakan dalam Borang Persetujuan [Nama Aplikasi Anda]. Dengan menekan "Daftar," saya dengan ini memberikan persetujuan untuk pemprosesan maklumat peribadi saya sebagaimana yang diterangkan.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle user confirmation
                    Navigator.pop(context, true); // Pass true for confirmation
                  },
                  child: Text('Setuju'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    // Handle user rejection
                    Navigator.pop(context, false); // Pass false for rejection
                  },
                  child: Text('Tidak Setuju'),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Nota: Jika anda tidak bersetuju, anda mungkin tidak dapat mencipta akaun dan menggunakan perkhidmatan yang disediakan oleh [Nama Aplikasi Anda].',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

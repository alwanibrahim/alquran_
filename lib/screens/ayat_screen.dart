import 'package:flutter/material.dart';
import 'package:tiket_wisata/api/surat_service.dart';
import 'package:tiket_wisata/models/surat_model.dart';

class DetailSuratScreen extends StatefulWidget {
  final int nomorSurat;

  const DetailSuratScreen({super.key, required this.nomorSurat});

  @override
  State<DetailSuratScreen> createState() => _DetailSuratScreenState();
}

class _DetailSuratScreenState extends State<DetailSuratScreen> {
  final ApiSurat suratApi = ApiSurat();
  Surat? surat;

  @override
  void initState() {
    super.initState();
    fetchDetailSurat();
  }

  Future<void> fetchDetailSurat() async {
    try {
      final suratDetail = await suratApi.getDetailSurat(widget.nomorSurat);
      if (!mounted) return;

      setState(() {
        surat = suratDetail;
      });
    } catch (e) {
      throw Exception("Error fetching detail: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Surat",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[700],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/alquran_bg.jpeg"), // Ganti dengan path gambar latar belakang Anda
            fit: BoxFit.cover,
          ),
          
        ),


        child: surat == null
            ? Center(child: CircularProgressIndicator(color: Colors.green[700]))
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surat!.namaLatin,
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "(${surat!.nama}) - ${surat!.arti}",
                      style: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          color: Colors.white70),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Jumlah Ayat: ${surat!.jumlahAyat}, Diturunkan di ${surat!.tempatTurun}",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              surat!.deskripsi,
                              textAlign: TextAlign.justify,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            SizedBox(height: 20),
                            if (surat!.audio.isNotEmpty)
                              Center(
                                child: ElevatedButton(
                                    onPressed: () {
                                      // Implementasi pemutar audio
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green[700],
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: Text(
                                      "Dengarkan Audio",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    )),
                              ),
                            SizedBox(height: 20),
                            Text(
                              "Ayat-ayat:",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: surat!.ayat.length,
                              itemBuilder: (context, index) {
                                final ayat = surat!.ayat[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Card(
                                    color: Colors.white.withOpacity(0.9),
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ayat.ar,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green[900]),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            ayat.tr,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontStyle: FontStyle.italic,
                                                color: Colors.green[700]),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            ayat.idn,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.green[900]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

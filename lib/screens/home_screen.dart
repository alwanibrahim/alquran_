import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tiket_wisata/api/doa_service.dart';
import 'package:tiket_wisata/api/surat_service.dart';
import 'package:tiket_wisata/models/doa_model.dart';
import 'package:tiket_wisata/models/surat_model.dart';
import 'package:tiket_wisata/screens/ayat_screen.dart';
import 'doa_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiDoa doaApi = ApiDoa();
  final ApiSurat suratApi = ApiSurat();
  List<Doa> tigaDoas = [];
  List<Surat> surats = [];
  List<Surat> filteredSurahs = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final doaData = await doaApi.getDoa();
    final suratData = await suratApi.getSurat();

    if (!mounted) return;

    setState(() {
      doaData.shuffle();
      tigaDoas = doaData.take(3).toList();
      surats = suratData;
      filteredSurahs = suratData;
    });
  }

  void searchSurah(String query) {
    final results = surats.where((surah) {
      final name = surah.namaLatin.toLowerCase();
      return name.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredSurahs = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mari Mengaji", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[700],
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: surats.isEmpty || tigaDoas.isEmpty
          ? Center(child: CircularProgressIndicator(color: Colors.green[700]))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Doa Harian",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700]),
                    ),
                  ),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 200,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                    ),
                    items: tigaDoas.map((doa) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DoaScreen(doa: doa),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.green[700]!, Colors.green[400]!],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  doa.judul,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  doa.arab,
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  textAlign: TextAlign.right,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Daftar Surat",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Cari surat...",
                        hintStyle: TextStyle(color: Colors.green[700]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.green[700] ?? Colors.green),
                        ),
                        prefixIcon:
                            Icon(Icons.search, color: Colors.green[700]),
                      ),
                      onChanged: searchSurah,
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(16),
                    itemCount: filteredSurahs.length,
                    itemBuilder: (context, index) {
                      final surat = filteredSurahs[index];
                      return Card(
                        elevation: 3,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.green[200],
                            child: Text(
                              surat.nomor.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          title: Text(surat.namaLatin,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700])),
                          subtitle: Text("Jumlah Ayat: ${surat.jumlahAyat}",
                              style: TextStyle(color: Colors.green[700])),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DetailSuratScreen(nomorSurat: surat.nomor)));
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}

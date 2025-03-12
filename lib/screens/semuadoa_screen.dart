import 'package:flutter/material.dart';
import 'package:tiket_wisata/api/doa_service.dart';
import 'package:tiket_wisata/models/doa_model.dart';

class SemuadoaScreen extends StatefulWidget {
  const SemuadoaScreen({super.key});

  @override
  State<SemuadoaScreen> createState() => _SemuadoaScreenState();
}

class _SemuadoaScreenState extends State<SemuadoaScreen> {
  final ApiDoa doaApi = ApiDoa();
  final TextEditingController searchController = TextEditingController();
  List<Doa> doas = [];
  List<Doa> filteredDoas = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final doaData = await doaApi.getDoa();
    if (!mounted) return;
    setState(() {
      doas = doaData;
      filteredDoas = doaData;
    });
  }

  void searchDoas(String query) {
    final result = doas.where((item) {
      final name = item.judul.toLowerCase();
      return name.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredDoas = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Semua Doa",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green[700],
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Cari doa...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                filled: true,
                fillColor: Colors.green[600],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                prefixIcon: Icon(Icons.search, color: Colors.white),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.white),
                        onPressed: () {
                          searchController.clear();
                          searchDoas('');
                        },
                      )
                    : null,
              ),
              style: TextStyle(color: Colors.white),
              onChanged: searchDoas,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: filteredDoas.isEmpty
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.green[700],
                ),
              )
            : ListView.builder(
                itemCount: filteredDoas.length,
                itemBuilder: (context, index) {
                  final doa = filteredDoas[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doa.judul,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            doa.arab,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                            textAlign: TextAlign.right,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            doa.latin,
                            style: TextStyle(
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              color: Colors.green[700],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            doa.terjemah,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

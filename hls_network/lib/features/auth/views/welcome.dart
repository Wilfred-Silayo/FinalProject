import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/features/auth/views/verify.dart';
import '../../../providers/theme_provider.dart';
import '../../../utils/utils.dart';

class Welcome extends ConsumerStatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  ConsumerState<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends ConsumerState<Welcome> {
  late TextEditingController _searchController;
  late QuerySnapshot<Map<String, dynamic>> _querySnapshot;
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _fetchData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('universities').get();

      setState(() {
        _querySnapshot = querySnapshot;
        _searchResults = querySnapshot.docs.map((doc) => doc.data()).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _search(String keyword) {
    if (keyword.isEmpty) {
      setState(() {
        _searchResults = _querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    } else {
      setState(() {
        _searchResults = _querySnapshot.docs
            .map((doc) => doc.data())
            .where((data) =>
                data['name']
                    .toString()
                    .toLowerCase()
                    .contains(keyword.toLowerCase()) ||
                data['description']
                    .toString()
                    .toLowerCase()
                    .contains(keyword.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Welcome for registration',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Please choose your college, institute or university to continue.',
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: currentTheme.brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
                labelText: 'Search',
                prefixIcon: const Icon(Icons.search),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: currentTheme.colorScheme.secondary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: currentTheme.colorScheme.secondary),
                ),
              ),
              onChanged: _search,
            ),
          ),
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : _searchResults.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          _searchResults
                              .sort((a, b) => a['name'].compareTo(b['name']));
                          final result = _searchResults[index];
                          return Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                            ),
                            child: ListTile(
                              title: Row(
                                children: [
                                  SizedBox(
                                    width: 80, // Set a fixed width for the name
                                    child: Text(
                                      result['name'],
                                      maxLines: 1,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Expanded(
                                    flex:
                                        1, // Allocate remaining space for the description
                                    child: Text(
                                      result['description'],
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                if (result['apiUrl'] != null &&
                                    result['name'] != null &&
                                    result['apiUrl'] != '' &&
                                    result['id'] != '' &&
                                    result['name'] != '') {
                                  final String name = result['name'];
                                  final String apiUrl = result['apiUrl'];
                                  final String id = result['id'];
                                  final String description =
                                      result['description'];
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VerificationScreen(
                                          uniName: name,
                                          uniId: id,
                                          apiUrl: apiUrl,
                                          description: description),
                                    ),
                                  );
                                } else {
                                  String res =
                                      'Sorry the selected institution current not available';
                                  showSnackBar(context, res);
                                }
                              },
                            ),
                          );
                        },
                      ),
                    )
                  : const Center(
                      child: Text('No results found.'),
                    ),
        ],
      ),
    );
  }
}

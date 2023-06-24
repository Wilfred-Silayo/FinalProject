import 'package:flutter/material.dart';
import 'package:hls_network/themes/themes_helper.dart';

class Search extends StatefulWidget {
  const Search({Key? key}): super(key:key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  void initState() {
    super.initState();
  }

  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: TextField(
          controller: _searchController,
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: const TextStyle(color: Colors.white),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.clear,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _searchController.text = '';
                });
              },
            ),
            filled: true,
          ),
          onChanged: (input) {
            if (input.isNotEmpty) {
              setState(() {
                // _users = DatabaseServices.searchUsers(input);
              });
            }
          },
        ),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
      ),
    );
  }
}

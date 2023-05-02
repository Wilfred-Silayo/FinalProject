import 'package:flutter/material.dart';
import 'package:hls_network/themes/themes_helper.dart';

class Search extends StatefulWidget {
  const Search({super.key});
  
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
   ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  void _loadThemeMode() async {
    ThemeMode themeMode = await ThemeHelper.loadThemeMode();
    setState(() {
      _themeMode = themeMode;
    });
  }
  Color _backgroundScaffold(){
    if(_themeMode==ThemeMode.light){
          return Colors.white;
    }
    else if(_themeMode==ThemeMode.dark){
       return Colors.black;
    }
    else{
      Brightness brightness = MediaQuery.of(context).platformBrightness;
      if (brightness == Brightness.dark) {
        return Colors.black;
      }
      return Colors.white;
    }
   
  }
  Color _backgroundAppBar(){
    if(_themeMode==ThemeMode.light){
          return Color.fromRGBO(55, 103, 138, 1);
    }
    else if(_themeMode==ThemeMode.dark){
       return Color.fromARGB(255, 36, 35, 35);
    }
    else{
      Brightness brightness = MediaQuery.of(context).platformBrightness;
      if (brightness == Brightness.dark) {
        return Color.fromARGB(255, 36, 35, 35);
      }
      return Color.fromRGBO(55, 103, 138, 1);
    }
   
  }
  
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
        return Scaffold(
          backgroundColor: _backgroundScaffold(),
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: _backgroundAppBar(),     
              title: TextField(
                controller: _searchController,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.white),
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
        );
  }
}

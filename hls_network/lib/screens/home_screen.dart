import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hls_network/widgets/drawer.dart';
import 'package:hls_network/themes/themes_helper.dart';
import 'package:hls_network/screens/screens.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}): super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

int _page = 2;
final List _pages = const <Widget>[
  Conferences(),
  Groups(),
  Homepage(),
  Notifications(),
  DirectMessages(),
];

Color curvedAnimationColor(){
  if(_themeMode==ThemeMode.light){
    return Color.fromRGBO(55, 103, 138, 1);
  }
  else if(_themeMode==ThemeMode.dark){
    return Color.fromARGB(255, 36, 35, 35);
  }
  else{
    Brightness brightness = MediaQuery.of(context).platformBrightness;
      if (brightness == Brightness.dark) {
        return  Color.fromARGB(255, 36, 35, 35);
      }
      return Color.fromRGBO(55, 103, 138, 1);
  }
             
}

Widget title(){
  if(_themeMode==ThemeMode.light){
    return SizedBox(height: 60,width: 60, child: Image.asset("assets/appicon.png",));
  }
  else if(_themeMode==ThemeMode.dark){
    return  SizedBox(height: 50,width: 50, child: Image.asset("assets/logo.png",));
  }
  else{
    Brightness brightness = MediaQuery.of(context).platformBrightness;
      if (brightness == Brightness.dark) {
        return  SizedBox(height: 50,width: 50, child: Image.asset("assets/logo.png",));
      }
      return SizedBox(height: 60,width: 60, child: Image.asset("assets/appicon.png",));
  }
             
}
  void _saveThemeMode(ThemeMode themeMode) async {
    await ThemeHelper.saveThemeMode(themeMode);
  }

  SystemUiOverlayStyle _getSystemUIOverlayStyle() {
    return ThemeHelper.getSystemUIOverlayStyle(_themeMode, context);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _getSystemUIOverlayStyle(),
      child: MaterialApp(
        theme: ThemeHelper.lightTheme,
        darkTheme: ThemeHelper.darkTheme,
        debugShowCheckedModeBanner: false,
        themeMode: _themeMode,
        home: Scaffold(
          extendBody: true,
          appBar: _page==2? AppBar(
            centerTitle: true,
             title:title(),
             bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50.0),
               child: Column(
                 children: [
                   Container(
                    width:double.infinity,
                    child: Center(child: Text('Social Higher learning', style: TextStyle(color: Colors.white,fontSize: 20),)),
                    constraints: BoxConstraints.expand(height: 50),
                   ),
                   const SizedBox(child: Divider(color: Color(0xff37678a)),height: 1.0,),
                 ],
               ),
               ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Search(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.search,
                  ),
                ),
              ],
            ): null,
          drawer: _page==2 ? DrawerWidget(
            context:context,
            themeMode: _themeMode,
            onThemeChanged: (ThemeMode value) {
              setState(() {
                _themeMode = value;
                _saveThemeMode(_themeMode);
                SystemChrome.setSystemUIOverlayStyle(_getSystemUIOverlayStyle());
              });
            },
          ): null,
          body: _pages[_page],
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              iconTheme: IconThemeData(color: Colors.white, )
            ),
             child: CurvedNavigationBar(
                height: 60,
                animationCurve: Curves.easeInOut,
                animationDuration: const Duration(milliseconds: 300),
                color: curvedAnimationColor(),
                buttonBackgroundColor: Colors.purple,
                backgroundColor: Colors.transparent,
                index: _page,
                items: <Widget>[
                  Icon(Icons.event, size: 25),
                  Icon(Icons.group_sharp,size: 25),
                  Icon(Icons.home, size: 25),
                  Icon(Icons.notifications, size: 25),
                  Icon(Icons.message, size: 25),
                ],
               onTap: (index) {
              setState(() {
                _page = index;
              });
              },
              ),
           ),
        ),
      ),
    );
  }
}

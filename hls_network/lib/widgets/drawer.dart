import 'package:flutter/material.dart';
import 'package:hls_network/screens/screens.dart';

class DrawerWidget extends StatelessWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;
  final BuildContext context; 
  const DrawerWidget({
    Key? key,
    required this.onThemeChanged,
    required this.themeMode,
    required this.context,  
  }) : super(key: key);
  Widget _themeleading(){
    if(themeMode==ThemeMode.system){
       Brightness brightness = MediaQuery.of(context).platformBrightness;
      if (brightness == Brightness.dark) {
        return Icon(Icons.dark_mode);
      } else {
        return  Icon(Icons.light_mode);
      }
    }
    else if(themeMode==ThemeMode.light){
     return Icon(Icons.light_mode); 
    }
    return Icon(Icons.dark_mode);
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color:Theme.of(context).brightness==Brightness.dark? Colors.grey[900]: Color.fromARGB(255, 245, 237, 245), 
        child: ListView(
          children: <Widget>[
             DrawerHeader(
              decoration: BoxDecoration(),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 50.0,
                      ),
                      SizedBox(height: 10,),
                      Text("username"),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.close)),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:const [
                            Text("Followers: 200"),
                            SizedBox(height: 20,),
                            Text("Followings: 500"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(leading: Icon(Icons.person),
            title: Text("Profile"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));
            },
            ),
           Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
            ),
             child: ExpansionTile(title: const Text('Themes'),
              leading: _themeleading(),
              children: [ ListTile(
                title: Text('System Theme'),
                leading: Radio(
                  value: ThemeMode.system,
                  groupValue: themeMode,
                  onChanged: (value) {
                    if (value != null) {
                       onThemeChanged(value);
                    }
                  },
                ),
                onTap: () {
                  onThemeChanged(ThemeMode.system);
                },
              ),
              ListTile(
                title: Text('Light Theme'),
                leading: Radio(
                  value: ThemeMode.light,
                  groupValue: themeMode,
                  onChanged: (value) {
                    if (value != null) {
                       onThemeChanged(value);
                    }
                  },
                ),
               onTap: () {
                  onThemeChanged(ThemeMode.system);
                },
              ),
              ListTile(
                title: Text('Dark Theme'),
                leading: Radio(
                  value: ThemeMode.dark,
                  groupValue: themeMode,
                  onChanged: (value) {
                    if (value != null) {
                       onThemeChanged(value);
                    }
                  },
                ),
                onTap: () {
                  onThemeChanged(ThemeMode.system);
                },
              ),],),
           ),
          ],
        ),
      ),
    );
  }
}


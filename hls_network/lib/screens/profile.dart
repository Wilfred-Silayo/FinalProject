import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        children: [
          Container(
            color: Theme.of(context).brightness==Brightness.light? Color(0xff37678a) : Color.fromARGB(255, 36, 35, 35) ,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Row(
              children: [
                IconButton(onPressed: ()=> Navigator.of(context).pop(), 
                icon: Icon(Icons.arrow_back),color: Colors.white,),
                SizedBox(width: 30,),
                const Text("Profile",style: TextStyle(color:Colors.white, fontWeight:FontWeight.bold,fontSize: 20, ),),
              ]),
          ),
          Expanded(child: Center(child: Text("Content"),)),
      ],),
    );
  }
}
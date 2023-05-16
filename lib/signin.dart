import 'dart:convert';

import 'package:ecommercedemo/homepage.dart';
import 'package:ecommercedemo/signup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Signinpage extends StatefulWidget {
  static SharedPreferences? pref;

  @override
  State<Signinpage> createState() => _SigninpageState();
}

class _SigninpageState extends State<Signinpage> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  bool loginstatus = false;
  Logindata? login;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callingpreference();

  }
   callingpreference() async {
    Signinpage.pref  =await SharedPreferences.getInstance();


        setState(() {
          loginstatus= Signinpage.pref!.getBool('islogin') ?? false;
        });

        if(loginstatus){
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return Homepage();
            },
          ));
        }
        // else{
        //   Navigator.pushReplacement(context, MaterialPageRoute(
        //     builder: (context) {
        //       return Signinpage();
        //     },
        //   ));
        // }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: username,
            decoration: InputDecoration(
                hintText: "username", border: OutlineInputBorder()),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: password,
            decoration: InputDecoration(
                hintText: "password", border: OutlineInputBorder()),
          ),
          ElevatedButton(
              onPressed: () async {
                Map passdata = {
                  'name': username.text,
                  'password': password.text
                };

                var url = Uri.parse(
                    'https://ecommercerutvik.000webhostapp.com/ecommercedata/login.php');
                var response = await http.post(url, body: passdata);
                print('Response status: ${response.statusCode}');
                print('Response body: ${response.body}');

                print("=================$url");

                var dcode = jsonDecode(response.body);

                setState(() {
                  login = Logindata.fromJson(dcode);
                });

                print("=========dcode======$dcode===");
                print("=========login======$login===");

                String? id = login!.userdata!.id;
                String? name = login!.userdata!.name;
                String? email = login!.userdata!.email;
                String? pass = login!.userdata!.password;
                String? mobile = login!.userdata!.mobile;
                String? image = login!.userdata!.image;

                if (login!.connection == 1 && login!.result == 1) {

                    setState(() {
                      Signinpage.pref!.setString('id', id!);
                      Signinpage.pref!.setString('name', name!);
                      Signinpage.pref!.setString('email', email!);
                      Signinpage.pref!.setString('pass', pass!);
                      Signinpage.pref!.setString('mobile', mobile!);
                      Signinpage.pref!.setString('image', image!);
                      Signinpage.pref!.setBool('islogin', true);
                    });
                 
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) {
                      return Homepage();
                    },
                  ));
                }
                else{
                  print("not login or data not found");
                }
              },
              child: Text("sign in")),
          SizedBox(height: 10,),
          ElevatedButton(onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return Signuppage();
              },
            ));
          }, child: Text("sign up"))
        ],
      ),
    );
  }
}

class Logindata {
  int? connection;
  int? result;
  Userdata? userdata;

  Logindata({this.connection, this.result, this.userdata});

  Logindata.fromJson(Map<String, dynamic> json) {
    connection = json['connection'];
    result = json['result'];
    userdata = json['userdata'] != null
        ? new Userdata.fromJson(json['userdata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['connection'] = this.connection;
    data['result'] = this.result;
    if (this.userdata != null) {
      data['userdata'] = this.userdata!.toJson();
    }
    return data;
  }
}

class Userdata {
  String? id;
  String? name;
  String? email;
  String? password;
  String? mobile;
  String? image;

  Userdata(
      {this.id, this.name, this.email, this.password, this.mobile, this.image});

  Userdata.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    mobile = json['mobile'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['mobile'] = this.mobile;
    data['image'] = this.image;
    return data;
  }
}

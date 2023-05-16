import 'dart:convert';
import 'dart:io';
import 'package:ecommercedemo/signin.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Signuppage extends StatefulWidget {

  @override
  State<Signuppage> createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController password = TextEditingController();
  bool imagest = false;
  String imagepath = "";

  Registereddata? rg;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async {
                  final ImagePicker _picker = ImagePicker();
                // Pick an image
                final XFile? image =
                    await _picker.pickImage(source: ImageSource.gallery,imageQuality: 20);

                setState(() {
                  imagepath = image!.path;
                  imagest = true;
                });
              },
              child: imagest
                  ? CircleAvatar(
                      radius: 80,
                      backgroundImage: FileImage(
                        File(imagepath),
                      ),
                    )
                  : CircleAvatar(backgroundColor: Colors.blue, radius: 80),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: name,
              decoration: InputDecoration(
                  hintText: "Name", border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: email,
              decoration: InputDecoration(
                  hintText: "email", border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: contact,
              decoration: InputDecoration(
                  hintText: "contact", border: OutlineInputBorder()),
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

                  List<int> bytearray = File(imagepath).readAsBytesSync();
                  String imagepathe = base64Encode(bytearray);

                  Map registermap = {
                    "name": name.text,
                    "email": email.text,
                    "contact": contact.text,
                    "password": password.text,
                    "imagedata": imagepathe
                  };

                  var url = Uri.parse(
                      'https://ecommercerutvik.000webhostapp.com/ecommercedata/register.php');
                  var response = await http.post(url, body: registermap);
                  print('Response status: ${response.statusCode}');
                  print('Response body: ${response.body}');

                  print("=======$url");
                  var dcode = jsonDecode(response.body);
                  setState(() {
                    rg = Registereddata.fromJson(dcode);
                  });

                  print("=========dcode========$dcode");
                  print("=======rg======$rg");

                  if (rg!.connection == 1 && rg!.result == 1) {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return Signinpage();
                      },
                    ));
                  } else if (rg!.result == 2) {
                    print("user already exist");
                  } else if (rg!.connection == 0) {
                    print("connection error");
                  } else {
                    print("all error");
                  }
                },
                child: Text("Sign Up")),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return Signinpage();
                },
              ));
            }, child: Text("sign in"))
          ],
        ),
      ),
    );
  }
}

class Registereddata {
  int? connection;
  int? result;

  Registereddata({this.connection, this.result});

  Registereddata.fromJson(Map<String, dynamic> json) {
    connection = json['connection'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['connection'] = this.connection;
    data['result'] = this.result;
    return data;
  }
}

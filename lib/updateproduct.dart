import 'dart:convert';
import 'dart:io';
import 'package:ecommercedemo/homepage.dart';
import 'package:http/http.dart' as http;
import 'package:ecommercedemo/signin.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Updatepage extends StatefulWidget {
  Productdata productdata;
  Updatepage(Productdata this.productdata);


  @override
  State<Updatepage> createState() => _UpdatepageState();
}

class _UpdatepageState extends State<Updatepage> {

  TextEditingController name = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController description = TextEditingController();

  String imagepath = "";

  Updatedata? updatedata;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      name.text = widget.productdata.productname!;
      type.text = widget.productdata.producttype!;
      price.text = widget.productdata.productprice!;
      description.text = widget.productdata.productdisc!;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("updating product"),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 80,
            ),
            InkWell(
              onTap: () async {
                final ImagePicker _picker = ImagePicker();
                // Pick an image
                final XFile? image = await _picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 20
                );

                setState(() {
                  imagepath = image!.path;
                });
              },
              child: imagepath==""
                  ?CircleAvatar(backgroundImage: NetworkImage("https://ecommercerutvik.000webhostapp.com/ecommercedata/${widget.productdata.productimage}"), radius: 80):
              CircleAvatar(radius: 80, backgroundImage: FileImage(File(imagepath),),),

            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: name,
              decoration: InputDecoration(
                  hintText: "product name", border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: type,
              decoration: InputDecoration(
                  hintText: "product type", border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: price,
              decoration: InputDecoration(
                  hintText: "product price", border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: description,
              maxLines: 5,
              decoration: InputDecoration(
                  hintText: "product description",
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: ButtonStyle(
                    fixedSize: MaterialStatePropertyAll(Size(140, 45))),
                onPressed: () async {
                  List<int> bytearray = File(imagepath).readAsBytesSync();
                  String imagepathe = base64Encode(bytearray);

                  String userid = "${Signinpage.pref!.getString('id')}";

                  Map productmap = {
                    "pid":widget.productdata.productid,
                    "pname": name.text,
                    "ptype": type.text,
                    "pprice": price.text,
                    "pdes": description.text,
                    "newimage": imagepathe,
                    "oldimage":widget.productdata.productimage
                  };

                  var url = Uri.parse('https://ecommercerutvik.000webhostapp.com/ecommercedata/updateproduct.php');
                  var response = await http.post(url, body: productmap);
                  print('Response status: ${response.statusCode}');
                  print('Response body====: ${response.body}');

                  var map = jsonDecode(response.body);
                  setState(() {
                    updatedata = Updatedata.fromJson(map);
                  });
                  if(updatedata!.connection == 1 && updatedata!.result == 1){
                    Future.delayed(Duration(seconds: 1)).then((value) {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                        return Homepage();
                      },));
                    });
                  }

                },
                child: Text("Update product")),
          ],
        ),
      ),
    );
  }
}

class Updatedata {
  int? connection;
  int? result;

  Updatedata({this.connection, this.result});

  Updatedata.fromJson(Map<String, dynamic> json) {
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

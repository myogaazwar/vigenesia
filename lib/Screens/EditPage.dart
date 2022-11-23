import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:vigenesia/Constant/const.dart';
import 'package:vigenesia/Models/Motivasi_Model.dart';

class EditPage extends StatefulWidget {
  final String id;
  final String isi_motivasi;
  const EditPage({Key key, this.id, this.isi_motivasi}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  String baseurl = url;
  var dio = Dio();
  Future<dynamic> putPost(String isi_motivasi, String ids) async {
    Map<String, dynamic> data = {"isi_motivasi": isi_motivasi, "id": ids};
    var response = await dio.put('$baseurl/vigenesia/api/dev/PUTmotivasi',
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ));

    print("---> ${response.data} + ${response.statusCode}");
    return response.data;
  }

  TextEditingController isiMotivasiC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Edit"),
      ),
      body: SafeArea(
          child: Container(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [
                Colors.white,
                Colors.red,
              ])),
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${widget.isi_motivasi}",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.4,
                  child: FormBuilderTextField(
                    name: "isi_motivasi",
                    controller: isiMotivasiC,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.redAccent, width: 1.2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.redAccent, width: 1.2),
                      ),
                      labelText: "Ubah Motivasi",
                      labelStyle: TextStyle(color: Colors.red),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.only(left: 10),
                    ),
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                    onPressed: () {
                      putPost(isiMotivasiC.text, widget.id).then((value) => {
                            if (value != null)
                              {
                                Navigator.pop(context),
                                Flushbar(
                                  message:
                                      "Berhasil Update & Harap Refresh Terlebih Dahulu !",
                                  duration: Duration(seconds: 5),
                                  backgroundColor: Colors.green,
                                  flushbarPosition: FlushbarPosition.TOP,
                                ).show(context)
                              }
                          });
                    },
                    child: Text("Submit"))
              ],
            ),
          ),
        ),
      )),
    );
  }
}

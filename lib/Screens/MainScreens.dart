import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vigenesia/Screens/Login.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:vigenesia/Constant/const.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:vigenesia/Models/Motivasi_Model.dart';
import 'package:vigenesia/Screens/EditPage.dart';

class MainScreens extends StatefulWidget {
  final String iduser;
  final String nama;

  const MainScreens({Key key, this.nama, this.iduser}) : super(key: key);

  @override
  State<MainScreens> createState() => _MainScreensState();
}

class _MainScreensState extends State<MainScreens> {
  String baseurl = url;
  String id;
  var dio = Dio();

  List<MotivasiModel> ass = [];
  TextEditingController titleController = TextEditingController();

  Future<dynamic> sendMotivasi(String isi) async {
    Map<String, dynamic> body = {"isi_motivasi": isi, "iduser": widget.iduser};

    try {
      Response response = await dio.post(
          "$baseurl/vigenesia/api/dev/POSTmotivasi/",
          data: body,
          options: Options(
              contentType: Headers
                  .formUrlEncodedContentType)); // Formatnya Harus Form Data

      print("Respon -> ${response.data} + ${response.statusCode}");
      return response;
    } catch (e) {
      print("Error di -> $e");
    }
  }

  List<MotivasiModel> listproduk = [];

  Future<List<MotivasiModel>> getData() async {
    var response = await dio.get(
        '$baseurl/vigenesia/api/Get_motivasi?iduser=${widget.iduser}'); // NGambil by data

    print(" ${response.data}");
    if (response.statusCode == 200) {
      var getUsersData = response.data as List;
      var listUsers =
          getUsersData.map((i) => MotivasiModel.fromJson(i)).toList();
      return listUsers;
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<dynamic> deletePost(String id) async {
    dynamic data = {
      "id": id,
    };
    var response = await dio.delete('$baseurl/vigenesia/api/dev/DELETEmotivasi',
        data: data,
        options: Options(
            contentType: Headers.formUrlEncodedContentType,
            headers: {"Content-type": "application/json"}));
    print("---> ${response.data} + ${response.statusCode}");
    return response.data;
  }

  Future<List<MotivasiModel>> getData2() async {
    var response = await dio
        .get('$baseurl/vigenesia/api/Get_motivasi'); // Ngambil by ALL USER

    print(" ${response.data}");
    if (response.statusCode == 200) {
      var getUsersData = response.data as List;
      var listUsers =
          getUsersData.map((i) => MotivasiModel.fromJson(i)).toList();
      return listUsers;
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<void> _getData() async {
    setState(() {
      getData();
      listproduk.clear();
      return CircularProgressIndicator();
    });
  }

  TextEditingController isiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
    getData2();
    _getData();
  }

  String trigger;
  String triggeruser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Container(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          //pembuka row
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //pembuka children
                            Text(
                              "Hallo ${widget.nama}",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                            TextButton(
                              child: Icon(
                                Icons.logout,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          new Login(),
                                    ));
                              },
                            ),
                          ], //penutup children
                        ),
                      ), //penutup row
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "ISI MOTIVASI MU DI KOLOM BAWAH INI ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FormBuilderTextField(
                          controller: isiController,
                          name: "isi_motivasi",
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.5),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.5),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.red),
                          onPressed: () async {
                            if (isiController.text.toString().isEmpty) {
                              Flushbar(
                                message: "Tidak Boleh Kosong",
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.redAccent,
                                flushbarPosition: FlushbarPosition.TOP,
                              ).show(context);
                            } else if (isiController.text
                                .toString()
                                .isNotEmpty) {
                              await sendMotivasi(
                                isiController.text.toString(),
                              ).then((value) => {
                                    if (value != null)
                                      {
                                        Flushbar(
                                          message:
                                              "Motivasi Kamu Berhasil Ditambahkan",
                                          messageColor: Colors.black,
                                          duration: Duration(seconds: 2),
                                          backgroundColor:
                                              Colors.lightBlueAccent,
                                          flushbarPosition:
                                              FlushbarPosition.TOP,
                                        ).show(context)
                                      }
                                  });
                            }
                            _getData();
                            print("Sukses");
                          },
                          child: Text("Submit"),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      TextButton(
                        child: Icon(
                          Icons.refresh,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          _getData();
                        },
                      ),
                      FormBuilderRadioGroup(
                          onChanged: (value) {
                            setState(() {
                              trigger = value;
                              print(
                                  " HASILNYA --> ${trigger}"); // hasil ganti value
                            });
                          },
                          name: "_",
                          activeColor: Colors.red,
                          options: ["Motivasi By All", "Motivasi By User"]
                              .map((e) => FormBuilderFieldOption(
                                  value: e, child: Text("${e}")))
                              .toList()),

                      trigger == "Motivasi By All"
                          ? FutureBuilder(
                              future: getData2(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<MotivasiModel>> snapshot) {
                                if (snapshot.hasData) {
                                  return Container(
                                      child: Card(
                                    child: Column(
                                      children: [
                                        for (var item in snapshot.data)
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Card(
                                              child: ListView(
                                                shrinkWrap: true,
                                                children: [
                                                  Container(
                                                      child: Text(
                                                          item.isiMotivasi)),
                                                ],
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ));
                                } else if (snapshot.hasData &&
                                    snapshot.data.isEmpty) {
                                  return Text("No Data");
                                } else {
                                  return CircularProgressIndicator();
                                }
                              })
                          : Container(),
                      trigger == "Motivasi By User"
                          ? FutureBuilder(
                              future: getData(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<MotivasiModel>> snapshot) {
                                if (snapshot.hasData) {
                                  return Column(
                                    children: [
                                      for (var item in snapshot.data)
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: ListView(
                                            shrinkWrap: true,
                                            physics: ScrollPhysics(),
                                            children: [
                                              Container(
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                    Expanded(
                                                        child: Text(
                                                            item.isiMotivasi)),
                                                    Row(children: [
                                                      TextButton(
                                                        child: Icon(
                                                          Icons.settings,
                                                          color: Colors.red,
                                                        ),
                                                        onPressed: () {
                                                          String id;
                                                          String isi_motivasi;
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    EditPage(
                                                                        id: item
                                                                            .id,
                                                                        isi_motivasi:
                                                                            item.isiMotivasi),
                                                              ));
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: Icon(
                                                            Icons.delete,
                                                            color: Colors.red),
                                                        onPressed: () {
                                                          deletePost(item.id)
                                                              .then((value) => {
                                                                    if (value !=
                                                                        null)
                                                                      {
                                                                        Flushbar(
                                                                          message:
                                                                              "Motivasi Kamu Berhasil DiHapus",
                                                                          messageColor:
                                                                              Colors.black,
                                                                          duration:
                                                                              Duration(seconds: 2),
                                                                          backgroundColor:
                                                                              Colors.greenAccent,
                                                                          flushbarPosition:
                                                                              FlushbarPosition.TOP,
                                                                        ).show(
                                                                            context)
                                                                      }
                                                                  });
                                                          _getData();
                                                        },
                                                      )
                                                    ]),
                                                  ])),
                                            ],
                                          ),
                                        ),
                                    ],
                                  );
                                } else if (snapshot.hasData &&
                                    snapshot.data.isEmpty) {
                                  return Text("No Data");
                                } else {
                                  return CircularProgressIndicator();
                                }
                              })
                          : Container(),
                    ]))),
      ),
    );
  }
}

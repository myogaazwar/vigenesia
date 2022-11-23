import 'package:vigenesia/Constant/const.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:dio/dio.dart';
import 'package:vigenesia/Screens/MainScreens.dart';
import 'package:vigenesia/Screens/Register.dart';
import 'package:vigenesia/Models/Login_Model.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscureText = true;
  String nama;
  String iduser;

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  Future<LoginModels> postLogin(String email, String password) async {
    var dio = Dio();
    String baseurl = url;

    Map<String, dynamic> data = {"email": email, "password": password};
    try {
      final response = await dio.post("$baseurl/vigenesia/api/login",
          data: data,
          options: Options(headers: {'Content-type': 'application/json'}));
      print("Respon -> ${response.data} + ${response.statusCode}");
      if (response.statusCode == 200) {
        final logilModel = LoginModels.fromJson(response.data);
        return logilModel;
      }
    } catch (e) {
      print("Failed To Load $e");
    }
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Selamat Datang',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                    Text(
                      "Mahasiswa Universitas Bina Sarana Informatika Kelas 19.5A.05",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 3,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/vigenesiaicon.png"))),
                    ),
                    Center(
                      child: Form(
                          child: Container(
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: Column(
                          children: [
                            FormBuilderTextField(
                              name: "Email",
                              controller: emailController,
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 2.5),
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 2.5),
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.redAccent,
                                  ),
                                  labelText: "Email",
                                  labelStyle: TextStyle(color: Colors.red)),
                            ),
                            SizedBox(height: 20),
                            FormBuilderTextField(
                              obscureText:
                                  _obscureText, // <-- buat bikin bintang
                              name: "Password",
                              controller: passwordController,
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 2.5),
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 2.5),
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  contentPadding: EdgeInsets.only(left: 10),
                                  border: OutlineInputBorder(),
                                  labelText: "Password",
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.redAccent,
                                  ),
                                  labelStyle: TextStyle(color: Colors.red)),
                            ),
                            SizedBox(height: 20),
                            Text.rich(
                              TextSpan(children: [
                                TextSpan(
                                  text: 'Kamu Belum Mempunyai Akun ?',
                                  style: TextStyle(color: Colors.black54),
                                ),
                                TextSpan(
                                    text: ' Daftar',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        new Register()));
                                      },
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.redAccent)),
                              ]),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.red),
                                  onPressed: () async {
                                    await postLogin(emailController.text,
                                            passwordController.text)
                                        .then((value) => {
                                              if (value != null)
                                                {
                                                  setState(() {
                                                    nama = value.data.nama;
                                                    iduser = value.data.iduser;
                                                    print(
                                                        "Ini Data ID ---->$iduser");
                                                    Navigator.pushReplacement(
                                                        context,
                                                        new MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                new MainScreens(
                                                                    iduser:
                                                                        iduser,
                                                                    nama:
                                                                        nama)));
                                                  })
                                                }
                                              else if (value == null)
                                                {
                                                  Flushbar(
                                                    message:
                                                        "Check Your Email / Password",
                                                    duration:
                                                        Duration(seconds: 5),
                                                    backgroundColor:
                                                        Colors.redAccent,
                                                    flushbarPosition:
                                                        FlushbarPosition.TOP,
                                                  ).show(context)
                                                }
                                            });
                                  },
                                  child: Text(
                                    "Sign In",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                          ],
                        ),
                      )),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

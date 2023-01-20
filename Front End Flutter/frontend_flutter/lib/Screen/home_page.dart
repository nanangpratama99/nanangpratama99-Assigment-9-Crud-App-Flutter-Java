import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:dropdown_search/dropdown_search.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final add1 = TextEditingController();
    final add2 = TextEditingController();
    final add3 = TextEditingController();

    int red = 0x3F;
    int green = 0x3B;
    int blue = 0x6C;
    Color color = Color.fromARGB(255, red, green, blue);

    // < ---- Key Validasi Input ----- >
    final _formKey = GlobalKey<FormState>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: color,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: color,
          title: Text(
            "CRUD APP",
            style: TextStyle(fontSize: 30),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              padding: EdgeInsets.only(right: 25),
              onPressed: () {},
              icon: Icon(
                Icons.person,
                size: 35,
              ),
            )
          ],
        ),
        body: Container(
          child: UsingTheData(),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            size: 40,
          ),
          backgroundColor: Colors.orange,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Center(
                  child: Icon(
                    Icons.person_add,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: add1,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: "Input your name",
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: add2,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: "Input your email",
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some email';
                          } else if (!EmailValidator.validate(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: add3,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: "Input your gender",
                          prefixIcon: Icon(Icons.people),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.purple,
                        fixedSize: const Size(100, 25),
                      ),
                      child: Text(
                        "Submit",
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            backgroundColor: Colors.purple),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          postData(
                            {
                              "nama": add1.text,
                              "email": add2.text,
                              "gender": add3.text,
                              "password": "",
                            },
                          );
                          add1.clear();
                          add2.clear();
                          add3.clear();
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class PrintResponseBody extends StatelessWidget {
  Future<http.Response> getData() async {
    final response =
        await http.get(Uri.parse("http://192.168.0.129:8082/api/user/getAll"));
    // await http.get(Uri.parse("https://reqres.in/api/users?per_page=15"));
    // await Future.delayed(const Duration(seconds: 2));

    return response;
  }

  const PrintResponseBody({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<http.Response>(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.body);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return Center(child: const CircularProgressIndicator());
      },
    );
  }
}

class UsingTheData extends StatefulWidget {
  UsingTheData({super.key});

  @override
  State<UsingTheData> createState() => _UsingTheDataState();
}

class _UsingTheDataState extends State<UsingTheData> {
  Future<http.Response> getData() async {
    final response =
        await http.get(Uri.parse("http://192.168.0.129:8082/api/user/getAll"));
    // await http.get(Uri.parse("https://reqres.in/api/users?per_page=15"));
    // await Future.delayed(const Duration(seconds: 2));
    setState(() {
      response;
    });
    return response;
  }

  @override
  Widget build(BuildContext context) {
    final add1 = TextEditingController();
    final add2 = TextEditingController();
    final add3 = TextEditingController();

    // < ---- Key Validasi Input ----- >
    final _formKey = GlobalKey<FormState>();

    return FutureBuilder(
        future: getData().then((value) => value.body),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<dynamic> json = jsonDecode(snapshot.data!);
            // List<dynamic> json = jsonDecode(snapshot.data!)["data"];
            return ListView.builder(
              itemCount: json.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.white.withOpacity(0.8),
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Container(
                    width: 300,
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ListTile(
                            leading: SizedBox(
                              width: 70,
                              child: CircleAvatar(
                                radius: 70,
                                backgroundColor:
                                    json[index]["gender"].toUpperCase() ==
                                            "WANITA"
                                        ? Colors.pink[300]
                                        : Colors.blue[300],
                                child: Image(
                                  image: json[index]["gender"] == "wanita"
                                      ? AssetImage("images/female.png")
                                      : AssetImage("images/male.png"),
                                ),
                                //
                                // Text(
                                //   "${json[index]["nama"][0] ?? 'A'}",
                                //   style: TextStyle(color: Colors.white),
                                // ),
                              ),
                            ),
                            title: Text(
                              "${json[index]["nama"] ?? 'A'}",
                              style: TextStyle(fontSize: 25),
                            ),
                            subtitle: Text(
                              "${json[index]["email"]}",
                              style: TextStyle(fontSize: 15),
                            ),
                            onTap: () {
                              print("nama: ${json[index]["nama"] ?? ''}");
                              print("email: ${json[index]["email"]}");
                            },
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    add1.text = json[index]["nama"];
                                    add2.text = json[index]["email"];
                                    add3.text = json[index]["gender"];
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Center(
                                          child: Text("Update Data"),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        content: Form(
                                          key: _formKey,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextFormField(
                                                controller: add1,
                                                autofocus: true,
                                                decoration: InputDecoration(
                                                    hintText:
                                                        "Update your name"),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please enter some text';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              TextFormField(
                                                controller: add2,
                                                autofocus: true,
                                                decoration: InputDecoration(
                                                    hintText:
                                                        "Update your email"),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please enter some email';
                                                  } else if (!EmailValidator
                                                      .validate(value)) {
                                                    return 'Please enter a valid email';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              TextFormField(
                                                controller: add3,
                                                autofocus: true,
                                                decoration: InputDecoration(
                                                    hintText:
                                                        "Update your gender"),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          IconButton(
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                updateData(json[index]["id"], {
                                                  "nama": add1.text,
                                                  "email": add2.text,
                                                  "gender": add3.text,
                                                  "password": "",
                                                });
                                                add1.clear();
                                                add2.clear();
                                                add3.clear();
                                                Navigator.of(context).pop();
                                              }
                                            },
                                            icon: IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.draw_outlined),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.draw_sharp,
                                    size: 40,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    deleteData(json[index]["id"]);
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    size: 40,
                                  ),
                                )
                              ],
                            )),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Center(child: const CircularProgressIndicator());
        });
  }
}

// Future<http.Response> getData() async {
//   final response =
//       await http.get(Uri.parse("http://192.168.0.1:8082/api/user/getAll"));
//   // await http.get(Uri.parse("https://reqres.in/api/users?per_page=15"));
//   // await Future.delayed(const Duration(seconds: 2));

//   return response;
// }

Future<http.Response> postData(Map<String, String> data) async {
  // data object example
  // data = {"name": "post method", "email": "postmethod@test.con"};
  final response =
      await http.post(Uri.parse("http://192.168.0.129:8082/api/user/insert"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data));
  print(response.statusCode);
  print(response.body);
  return response;
}

Future<http.Response> updateData(int id, Map<String, String> data) async {
  // data object example
  // data = {"name": "post method", "email": "postmethod@test.con"};
  final response = await http.put(
      Uri.parse("http://192.168.0.129:8082/api/user/update/${id}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data));
  print(response.statusCode);
  print(response.body);
  return response;
}

Future<http.Response> deleteData(id) async {
  // data object example
  // data = {"name": "post method", "email": "postmethod@test.con"};
  final response = await http.delete(
    Uri.parse("http://192.168.0.129:8082/api/user/delete/${id}"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  print(response.statusCode);
  print(response.body);
  return response;
}

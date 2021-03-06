import 'package:flutter/material.dart';
import 'package:project/services/auth.dart';
import 'package:project/widgets/loading.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController? _usernameController = TextEditingController();

  final TextEditingController? _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _obscure = true;
  @override
  void dispose() {
    _usernameController!.dispose();
    _passwordController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthenticationService>(context);
    return _isLoading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              title: const Text("Driver Login"),
              backgroundColor: const Color.fromARGB(170, 59, 50, 231),
            ),
            body: Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Please enter username";
                        }
                        return null;
                      },
                      cursorColor: const Color.fromARGB(170, 59, 50, 231),
                      decoration: const InputDecoration(
                        label: Text(
                            "Username",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(170, 59, 50, 231)),
                          ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2,
                              color: Color.fromARGB(170, 59, 50, 231)),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(170, 59, 50, 231)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Please enter password";
                        }
                        return null;
                      },
                      obscureText: _obscure,
                      cursorColor: const Color.fromARGB(170, 59, 50, 231),
                      decoration: InputDecoration(
                          label: const Text(
                            "Password",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(170, 59, 50, 231)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: Color.fromARGB(170, 59, 50, 231)),
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(170, 59, 50, 231)),
                          ),
                          suffixIcon: IconButton(
                              color: const Color.fromARGB(170, 59, 50, 231),
                              onPressed: () {
                                setState(() {
                                  _obscure = !_obscure;
                                });
                              },
                              icon: _obscure
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off))),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      height: 90,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: const Color.fromARGB(170, 59, 50, 231)),
                        child: const Text(
                          "LOGIN",
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });
                            dynamic res = await authService.signIn(
                                email: _usernameController!.text + "@gmail.com",
                                password: _passwordController!.text);
                            setState(() {
                              _isLoading = false;
                            });
                            if (res == null) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Invalid Details"),
                                      content: const Text("Check the details"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Ok"))
                                      ],
                                    );
                                  });
                            } else {
                              Navigator.pop(context);
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

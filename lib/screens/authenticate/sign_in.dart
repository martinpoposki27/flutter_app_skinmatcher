import 'package:flutter/material.dart';
import 'package:lab193004/services/auth.dart';
import 'package:lab193004/widgets/loading.dart';

import '../../widgets/constants.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;

  SignIn(this.toggleView);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        title: Text("Sign in"),
        actions: <Widget>[
          ElevatedButton.icon(
            onPressed: () { widget.toggleView(); },
            icon: Icon(Icons.how_to_reg),
            label: Text("Register"),
            style: ElevatedButton.styleFrom(elevation: 0),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form (
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20,),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: "Email"),
                validator: (val) => val!.isEmpty ? "Enter email!" : null,
                onChanged: (val) {
                  setState(() {
                    email = val;
                  });
                },
              ),
              SizedBox(height: 20,),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: "Password"),
                validator: (val) => val!.length < 6 ? "Enter at least 6 characters!" : null,
                obscureText: true,
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                child: Text("Sign in"),
                onPressed: () async {
                  if(_formKey.currentState!.validate()){
                    setState(() { loading = true; });
                    dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                    if(result == null) {
                      setState(() {
                        error = "Check your credentials!";
                        loading = false;
                      });
                    }
                  }
                }
              ),
              SizedBox(height: 12),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

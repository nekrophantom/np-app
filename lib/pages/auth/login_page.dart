import 'package:flutter/material.dart';
import '/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    

    return Scaffold(
      body: Stack(
        children: [
          Auth(deviceSize: deviceSize)
        ],
      ),
    );
  }
}

class Auth extends StatefulWidget {
  const Auth({
    super.key,
    required this.deviceSize,
  });

  final Size deviceSize;

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var _isLoading = false;


  Future<void> _submit() async {
    if(!_formKey.currentState!.validate()){
      return;
    }

    _formKey.currentState!.save();
    
    setState(() {
      _isLoading = true;
    });

    try {

      await Provider.of<AuthProvider>(context, listen: false).login(_emailController.text, _passwordController.text);
      
    } catch (e) {
      throw e;
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          height: widget.deviceSize.height,
          width: widget.deviceSize.width,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'Please enter email';
                    }
                    return null;
                  },
                ),
                
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'Please enter password';
                    }
                    return null;
                  },
                ),

                ElevatedButton(
                  onPressed: _submit, 
                  child: _isLoading ? CircularProgressIndicator() : Text('Login')
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
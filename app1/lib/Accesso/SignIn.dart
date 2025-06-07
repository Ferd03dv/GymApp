// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gymfit/CustomItem/BackgroundContainer.dart';
import 'package:gymfit/CustomItem/CustomButton.dart';
import 'package:gymfit/Providers/AuthProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gymfit/CustomItem/CustomFormField.dart';

class SignInWidget extends StatefulWidget {
  const SignInWidget({
    super.key,
  });

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  late AuthProvider authProvider =
      Provider.of<AuthProvider>(context, listen: false);

  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    authProvider = AuthProvider();
    _loadSavedCredentials();
    _autoSignIn();

    authProvider.loadSavedCredentials(
        _emailController.text, _passwordController.text, _rememberMe);
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email');
    final savedPassword = prefs.getString('password');
    if (savedEmail != null) {
      _emailController.text = savedEmail;
      setState(() {
        _rememberMe = true;
      });
    }
    if (savedPassword != null) {
      _passwordController.text = savedPassword;
    }
  }

  Future<void> _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('email', _emailController.text);
      await prefs.setString('password', _passwordController.text);
    } else {
      await prefs.remove('email');
      await prefs.remove('password');
    }
  }

  Future<void> _autoSignIn() async {
    setState(() {
      isLoading = true; // Inizia a caricare
    });

    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final password = prefs.getString('password');

    if (email != null && password != null) {
      if (context.mounted) {
        await authProvider.signInWithMongoDB(email, password, context);
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black,
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        const BackgroundContainer(),
        Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : Column(
                  children: [
                    Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(32),
                          child: Image.asset(
                            'assets/GymFitLOGO-2.png',
                            fit: BoxFit.cover,
                          ),
                        )),
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          width: 400,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                  sigmaX: 5.0,
                                  sigmaY: 5.0), // Sfocatura meno intensa
                              child: Container(
                                color: Colors.white.withOpacity(
                                    1), // Sfondo leggermente trasparente
                                padding: const EdgeInsets.all(16.0),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Center(
                                        child: Text(
                                          'Accedi al tuo account!',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors
                                                .black, // Testo in nero per contrastare il background bianco
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      CustomTextInput(
                                        controller: _emailController,
                                        labelText: 'Email',
                                        labelStyle: const TextStyle(
                                            color: Colors.black),
                                      ),
                                      const SizedBox(height: 16),
                                      TextFormField(
                                        controller: _passwordController,
                                        obscureText: _obscurePassword,
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.black,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          labelText: 'Password',
                                          labelStyle: const TextStyle(
                                            color: Colors.black,
                                            // Assicurati che questo colore sia visibile
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.black,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          disabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.black,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          border: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.black,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _obscurePassword
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _obscurePassword =
                                                    !_obscurePassword;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: _rememberMe,
                                            onChanged: (value) {
                                              setState(() {
                                                _rememberMe = value ?? false;
                                              });
                                            },
                                          ),
                                          const Text(
                                            'Ricordami',
                                            style: TextStyle(
                                                color: Colors
                                                    .black), // Cambiato a nero per contrastare il background bianco
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                      CustomButton(
                                        text: 'Accedi',
                                        colortext: Colors.white,
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _rememberMe = true;
                                            await _saveCredentials();
                                            authProvider.signInWithMongoDB(
                                              _emailController.text,
                                              _passwordController.text,
                                              context,
                                            );
                                          }
                                        },
                                        backgroundColor: Colors.black,
                                      ),
                                      const SizedBox(height: 12),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context)
                                              .pushNamed('/create_account');
                                        },
                                        child: const Center(
                                          child: Text(
                                            'Non sei iscritto? Iscriviti!',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors
                                                  .black, // Cambiato a nero per contrastare il background bianco
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context)
                                              .pushNamed('/forgot_password');
                                        },
                                        child: const Center(
                                          child: Text(
                                            'Clicca qui se non ricordi la password',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors
                                                  .black, // Cambiato a nero per contrastare il background bianco
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/base/base_view.dart';
import '../../../core/init/snackbar_manager.dart';
import '../viewmodel/auth_view_model.dart';

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BaseView<AuthViewModel>(
      viewModel: AuthViewModel(),
      onPageBuilder: (context, model, _) => Scaffold(
        appBar: AppBar(
          title: const Text('Giriş Yap'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen email adresinizi girin';
                    }
                    if (!value.contains('@')) {
                      return 'Geçerli bir email adresi girin';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Şifre',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen şifrenizi girin';
                    }
                    if (value.length < 6) {
                      return 'Şifre en az 6 karakter olmalıdır';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                if (model.isLoading)
                  const CircularProgressIndicator()
                else
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final success = await model.signIn(
                              _emailController.text,
                              _passwordController.text,
                            );
                            if (context.mounted) {
                              if (success) {
                                SnackBarManager.showSuccess(
                                  context,
                                  'Giriş başarılı! Yönlendiriliyorsunuz...',
                                );
                                context.go('/listings');
                              } else if (model.errorMessage != null) {
                                SnackBarManager.showError(
                                  context,
                                  model.errorMessage!,
                                );
                              }
                            }
                          }
                        },
                        child: const Text('Giriş Yap'),
                      ),
                      TextButton(
                        onPressed: () => context.push('/register'),
                        child: const Text('Hesabınız yok mu? Kayıt olun'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 
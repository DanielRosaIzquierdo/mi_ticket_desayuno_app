import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mi_ticket_desayuno_app/presentation/utils/utils.dart';
import 'package:mi_ticket_desayuno_app/presentation/widgets/custom_text_form_field_widget.dart';
import 'package:mi_ticket_desayuno_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _password = '';

  void _submit(AuthProvider authProvider) async {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      authProvider.setIsLoading();
      final bool registerResult = await authProvider.register(
        _name,
        _email,
        _password,
      );
      if (registerResult) {
        context.pushReplacement('/client-dashboard');
        authProvider.setHasLoaded();
      } else {
        authProvider.setHasLoaded();
        PresentationUtils.showCustomSnackbar(
          context,
          'Error en el registro o datos incorrectos',
        );
      }
    }
  }

  String? _nameValidator(String? value) {
    if (value == null || value.isEmpty) return 'El nombre es obligatorio';
    if (value.length < 2) return 'Debe tener al menos 2 caracteres';
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) return 'El correo es obligatorio';
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$');
    if (!regex.hasMatch(value)) return 'Correo no válido';
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) return 'La contraseña es obligatoria';
    if (value.length < 6) return 'Debe tener al menos 6 caracteres';
    return null;
  }

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                 Image.asset('assets/images/logo.png'),
                  const SizedBox(height: 24),
                  Text(
                    'Registro',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 32),
                  CustomTextFormField(
                    label: 'Nombre',
                    icon: Icons.person,
                    keyboardType: TextInputType.name,
                    validator: _nameValidator,
                    onSaved: (value) => _name = value ?? '',
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    label: 'Correo electrónico',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: _emailValidator,
                    onSaved: (value) => _email = value ?? '',
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    label: 'Contraseña',
                    icon: Icons.lock,
                    obscureText: true,
                    validator: _passwordValidator,
                    onSaved: (value) => _password = value ?? '',
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed:
                        (authProvider.isLoading)
                            ? null
                            : () => _submit(authProvider),
                    child: const Text('Registrarse'),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      context.pushReplacement('/login');
                    },
                    child: const Text('¿Ya tienes cuenta? Inicia sesión'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

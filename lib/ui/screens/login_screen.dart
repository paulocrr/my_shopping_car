import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:my_shopping_car/blocs/auth_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Correo',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(48),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Contraseña',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(48),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Iniciar sesion'),
                ),
                const Divider(),
                SignInButton(
                  Buttons.Google,
                  onPressed: () {
                    context.read<AuthBloc>().signInWithGoogle();
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

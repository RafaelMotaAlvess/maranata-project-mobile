// presentation/sign_in_screen/sign_in_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Importação do pacote
import 'package:jwt_decoder/jwt_decoder.dart'; // Importar jwt_decoder
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import '../sign_up_screen/sign_up_screen.dart';
import '../waitlist_screen/waitlist_screen.dart'; // Importar a WaitlistScreen
import '../users_list_screen/users_list_screen.dart'; // Importar a UsersListScreen

// Converta para StatefulWidget para gerenciar estados
class SignInScreen extends StatefulWidget {
  SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // Controladores de texto
  TextEditingController emailInputController = TextEditingController();
  TextEditingController passwordInputController = TextEditingController();

  // Chave do formulário
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Variável para gerenciar o estado de carregamento
  bool _isLoading = false;

  // Instância de FlutterSecureStorage
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Função para extrair refreshToken do cabeçalho Set-Cookie
  String? _extractRefreshTokenFromCookies(String? setCookieHeader) {
    if (setCookieHeader == null) return null;

    // Dividir múltiplos cookies, se houver
    List<String> cookies = setCookieHeader.split(',');

    for (var cookie in cookies) {
      // Procurar pelo cookie refreshToken
      if (cookie.trim().startsWith('refreshToken=')) {
        // Extrair o valor do refreshToken
        String refreshTokenPart = cookie.split(';')[0];
        List<String> keyValue = refreshTokenPart.split('=');
        if (keyValue.length == 2) {
          return keyValue[1];
        }
      }
    }

    return null;
  }

  // Função para lidar com o login
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Construir o payload
      final Map<String, dynamic> payload = {
        "email": emailInputController.text.trim(),
        "password": passwordInputController.text,
      };

      try {
        // Realizar a requisição POST
        final response = await http.post(
          Uri.parse('https://maranata-project-api.onrender.com/login'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(payload),
        );

        setState(() {
          _isLoading = false;
        });

        print('Status da resposta: ${response.statusCode}');
        print('Corpo da resposta: ${response.body}');
        print('Headers da resposta: ${response.headers}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Sucesso no login
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login realizado com sucesso!')),
          );

          // Parse da resposta para obter o token
          final responseData = jsonDecode(response.body);
          String token = responseData['token'] ?? '';

          // Exibir o token no console para depuração
          print('Token recebido: $token');

          // Extrair o refreshToken do cabeçalho Set-Cookie
          String? setCookie = response.headers['set-cookie'];
          String? refreshToken = _extractRefreshTokenFromCookies(setCookie);

          // Exibir o refreshToken no console para depuração
          print('RefreshToken extraído: $refreshToken');

          if (token.isNotEmpty &&
              refreshToken != null &&
              refreshToken.isNotEmpty) {
            // Decodificar o token JWT para extrair a role
            try {
              Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

              // Adicionar log do token decodificado
              print('Token Decodificado: $decodedToken');

              // Extrair a role do token
              String? userRole =
                  decodedToken['type']; // Ajuste conforme a estrutura do token

              // Verificar se 'type' existe e não é nulo
              if (userRole != null) {
                // Exibir a role no console
                print('Role do usuário: $userRole');
              } else {
                print('Role do usuário não encontrada no token.');
              }

              // Armazenar os tokens de forma segura
              await _secureStorage.write(key: 'jwt_token', value: token);
              await _secureStorage.write(
                  key: 'refreshToken', value: refreshToken);

              // Navegar para a tela apropriada com base na role do usuário
              if (userRole != null && userRole.toUpperCase() == 'ADMIN') {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.waitlistScreen, // Rota para WaitlistScreen
                  (route) => false, // Remove todas as rotas anteriores
                );
              } else {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.usersListScreen, // Rota para UsersListScreen
                  (route) => false, // Remove todas as rotas anteriores
                );
              }
            } catch (e) {
              print('Erro ao decodificar o token JWT: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('Erro ao processar o token de autenticação.')),
              );
            }
          } else {
            // Token ou refreshToken não encontrado na resposta
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Tokens não recebidos.')),
            );
          }
        } else {
          // Falha no login
          final responseData = jsonDecode(response.body);
          String errorMessage = responseData['message'] ?? 'Erro no login.';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        // Erro de conexão ou outro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha de conexão. Tente novamente.')),
        );
        print('Erro no login: $e'); // Log para depuração
      }
    }
  }

  @override
  void dispose() {
    // Dispose dos controladores
    emailInputController.dispose();
    passwordInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
          key: _formKey,
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                _buildMaranataSection(context),
                SizedBox(height: 64.h),
                _buildLoginForm(context),
                if (_isLoading)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMaranataSection(BuildContext context) {
    return SizedBox(
      height: 294.h,
      width: double.maxFinite,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(
                horizontal: 32.h,
                vertical: 62.h,
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    ImageConstant.imgGroup1,
                  ),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.only(right: 22.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Maranata",
                          style: theme.textTheme.displayLarge,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 34.h),
                ],
              ),
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgGroup2,
            height: 138.h,
            width: 176.h,
          ),
        ],
      ),
    );
  }

  /// Campo de E-mail
  Widget _buildEmailInput(BuildContext context) {
    return CustomTextFormField(
      controller: emailInputController,
      hintText: "E-mail",
      textInputType: TextInputType.emailAddress,
      contentPadding: EdgeInsets.all(16.h),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Por favor, insira seu e-mail';
        }
        // Validação básica de e-mail
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Por favor, insira um e-mail válido';
        }
        return null;
      },
    );
  }

  /// Campo de Senha
  Widget _buildPasswordInput(BuildContext context) {
    return CustomTextFormField(
      controller: passwordInputController,
      hintText: "Senha",
      textInputAction: TextInputAction.done,
      textInputType: TextInputType.visiblePassword,
      obscureText: true,
      contentPadding: EdgeInsets.all(16.h),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, insira sua senha';
        }
        if (value.length < 6) {
          return 'A senha deve ter pelo menos 6 caracteres';
        }
        return null;
      },
    );
  }

  /// Botão de Login
  Widget _buildLoginButton(BuildContext context) {
    return CustomElevatedButton(
      text: "ENTRAR",
      margin: EdgeInsets.only(
        left: 42.h,
        right: 34.h,
      ),
      onPressed: _isLoading ? null : _login,
      buttonStyle: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF73CAAD), // Cor do botão
        // Caso queira mudar a cor do texto:
        // foregroundColor: Colors.white,
      ),
    );
  }

  /// Botão de Criar Conta
  Widget _buildCreateAccountButton(BuildContext context) {
    return CustomElevatedButton(
      text: "CRIAR CONTA",
      margin: EdgeInsets.only(
        left: 42.h,
        right: 34.h,
      ),
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignUpScreen()),
        );

        if (result == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Conta criada com sucesso! Faça login.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      buttonStyle: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF73CAAD), // Cor do botão
        // foregroundColor: Colors.white, // Caso queira a cor do texto branca
      ),
    );
  }

  /// Seção do Formulário de Login
  Widget _buildLoginForm(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 32.h),
      child: Column(
        children: [
          _buildEmailInput(context),
          SizedBox(height: 24.h),
          _buildPasswordInput(context),
          SizedBox(height: 24.h),
          GestureDetector(
            onTap: () {
              // Implementar a lógica de "Esqueci minha senha" se necessário
            },
            child: Text(
              "ESQUECI MINHA SENHA",
              style: theme.textTheme.titleSmall?.copyWith(
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          _buildLoginButton(context),
          SizedBox(height: 24.h),
          _buildCreateAccountButton(context),
        ],
      ),
    );
  }
}

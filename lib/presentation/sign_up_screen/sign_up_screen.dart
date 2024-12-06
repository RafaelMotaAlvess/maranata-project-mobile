import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_landing_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';

// Converta para StatefulWidget para gerenciar estados
class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Controladores de texto
  final TextEditingController fullNameInputController = TextEditingController();
  final TextEditingController cpfInputController = TextEditingController();
  final TextEditingController emailInputController = TextEditingController();
  final TextEditingController passwordInputController = TextEditingController();
  final TextEditingController confirmPasswordInputController =
      TextEditingController();
  final TextEditingController phoneInputController = TextEditingController();

  // Chave do formulário
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Variável para gerenciar o estado de carregamento
  bool _isLoading = false;

  // Função para lidar com o cadastro
  Future<void> _createAccount() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Construir o payload
      final Map<String, dynamic> payload = {
        "name": fullNameInputController.text.trim(),
        "email": emailInputController.text.trim(),
        "password": passwordInputController.text,
        "phone": phoneInputController.text.trim(),
        "cpf": cpfInputController.text.trim(),
      };

      try {
        // Realizar a requisição POST
        final response = await http.post(
          Uri.parse('https://maranata-project-api.onrender.com/users'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(payload),
        );

        setState(() {
          _isLoading = false;
        });

        if (response.statusCode == 201 || response.statusCode == 200) {
          // Sucesso no cadastro
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Conta criada com sucesso!')),
          );

          // Navegar de volta para a primeira página (SignInScreen)
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.initialRoute, // Rota para SignInScreen
            (route) => false, // Remove todas as rotas anteriores
          );
        } else {
          // Falha no cadastro
          final responseData = jsonDecode(response.body);
          String errorMessage = responseData['message'] ?? 'Erro no cadastro.';
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
      }
    }
  }

  @override
  void dispose() {
    // Dispose dos controladores
    fullNameInputController.dispose();
    cpfInputController.dispose();
    emailInputController.dispose();
    passwordInputController.dispose();
    confirmPasswordInputController.dispose();
    phoneInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              children: [
                _buildMainStack(context),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.all(30.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 4.h),
                          _buildFullNameInput(context),
                          SizedBox(height: 20.h),
                          _buildCpfInput(context),
                          SizedBox(height: 20.h),
                          _buildPhoneInput(context), // Campo de telefone
                          SizedBox(height: 20.h),
                          _buildEmailInput(context),
                          SizedBox(height: 20.h),
                          _buildPasswordInput(context),
                          SizedBox(height: 20.h),
                          _buildConfirmPasswordInput(context),
                          SizedBox(height: 32.h),
                          _buildCreateAccountButton(context),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Seção do Stack Principal
  Widget _buildMainStack(BuildContext context) {
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
              padding: EdgeInsets.symmetric(vertical: 6.h),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageConstant.imgGroup1),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomAppBar(
                    leadingWidth: 34.h,
                    leading: AppbarLeadingImage(
                      imagePath: ImageConstant.imgArrowLeft,
                      margin: EdgeInsets.only(left: 5.h),
                      onTap: () {
                        onTapArrowLeftone(context);
                      },
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    width: double.maxFinite,
                    margin: EdgeInsets.symmetric(horizontal: 32.h),
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
                  SizedBox(height: 90.h),
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

  /// Campo de Nome Completo
  Widget _buildFullNameInput(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 2.h),
      child: CustomTextFormField(
        controller: fullNameInputController,
        hintText: "Nome Completo",
        contentPadding: EdgeInsets.all(16.h),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Por favor, insira seu nome completo';
          }
          return null;
        },
      ),
    );
  }

  /// Campo de CPF
  Widget _buildCpfInput(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 2.h),
      child: CustomTextFormField(
        controller: cpfInputController,
        hintText: "CPF",
        contentPadding: EdgeInsets.all(16.h),
        textInputType: TextInputType.number,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Por favor, insira seu CPF';
          }
          // Adicione validação adicional de CPF se necessário
          return null;
        },
      ),
    );
  }

  /// Campo de Telefone
  Widget _buildPhoneInput(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 2.h),
      child: CustomTextFormField(
        controller: phoneInputController,
        hintText: "Telefone",
        contentPadding: EdgeInsets.all(16.h),
        textInputType: TextInputType.phone,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Por favor, insira seu telefone';
          }
          return null;
        },
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
    return Padding(
      padding: EdgeInsets.only(left: 2.h),
      child: CustomTextFormField(
        controller: passwordInputController,
        hintText: "Senha",
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
      ),
    );
  }

  /// Campo de Confirmar Senha
  Widget _buildConfirmPasswordInput(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 2.h),
      child: CustomTextFormField(
        controller: confirmPasswordInputController,
        hintText: "Confirmar senha",
        textInputAction: TextInputAction.done,
        obscureText: true,
        contentPadding: EdgeInsets.all(16.h),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, confirme sua senha';
          }
          if (value != passwordInputController.text) {
            return 'As senhas não correspondem';
          }
          return null;
        },
      ),
    );
  }

  /// Botão de Criar Conta
  Widget _buildCreateAccountButton(BuildContext context) {
    return CustomElevatedButton(
      text: "CRIAR CONTA",
      margin: EdgeInsets.only(
        left: 42.h,
        right: 38.h,
      ),
      onPressed: _isLoading
          ? null
          : _createAccount, // Desativa o botão durante o carregamento
    );
  }

  /// Navega de volta para a tela anterior.
  void onTapArrowLeftone(BuildContext context) {
    Navigator.pop(context);
  }
}

// ./users_register_two_screen/users_register_two_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Importar o FlutterSecureStorage
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_landing_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';

class UsersRegisterTwoScreen extends StatefulWidget {
  UsersRegisterTwoScreen({Key? key}) : super(key: key);

  @override
  _UsersRegisterTwoScreenState createState() => _UsersRegisterTwoScreenState();
}

class _UsersRegisterTwoScreenState extends State<UsersRegisterTwoScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores de texto
  TextEditingController homelessStatusInputController = TextEditingController();
  TextEditingController substanceUseInputController = TextEditingController();
  TextEditingController usageDurationInputController = TextEditingController();
  TextEditingController referralInputController = TextEditingController();

  bool _isLoading = false;

  // Dados recebidos da primeira tela
  Map<String, dynamic>? _firstFormData;

  // Instância do FlutterSecureStorage
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  @override
  void dispose() {
    // Limpar os controladores ao descartar o widget
    homelessStatusInputController.dispose();
    substanceUseInputController.dispose();
    usageDurationInputController.dispose();
    referralInputController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Receber os dados da primeira tela
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      _firstFormData = args;
    } else {
      // Se não houver dados, retornar para a tela anterior
      Navigator.pop(context);
    }
  }

  Future<void> _submitRegistration() async {
    if (_formKey.currentState!.validate()) {
      // Coletar os dados do segundo formulário
      Map<String, dynamic> secondFormData = {
        "isHomeless":
            homelessStatusInputController.text.trim().toLowerCase() == 'sim',
        "substances": substanceUseInputController.text.trim(),
        "usageDuration": usageDurationInputController.text.trim(),
        "referredBy": referralInputController.text.trim(),
      };

      // Combinar os dados dos dois formulários
      Map<String, dynamic> combinedData = {
        ...?_firstFormData, // Operador de propagação para evitar erros se for nulo
        ...secondFormData,
      };

      // Exibir indicador de carregamento
      setState(() {
        _isLoading = true;
      });

      try {
        // Recupera o token armazenado
        String? token = await _secureStorage.read(key: 'refreshToken');

        if (token == null) {
          // Token não encontrado, redirecionar para o login ou exibir erro
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Token de autenticação não encontrado. Faça login novamente.')),
          );
          // Opcional: Navegar para a tela de login
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.signInScreen,
            (route) => false,
          );
          return;
        }

        // Fazer a requisição POST para registrar o paciente
        final response = await http.post(
          Uri.parse(
              'https://maranata-project-api.onrender.com/patients/register'),
          headers: {
            'Content-Type': 'application/json',
            'Cookie': 'refreshToken=$token', // Incluir o Cookie com o token
            // Se a API também requer o cabeçalho Authorization, adicione-o:
            // 'Authorization': 'Bearer $token',
          },
          body: jsonEncode(combinedData),
        );

        // Verificar o status da resposta
        if (response.statusCode == 201 || response.statusCode == 200) {
          // Registro bem-sucedido
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Paciente registrado com sucesso!')),
          );

          // Retornar para a UsersRegisterScreen com sucesso
          Navigator.pop(context, true);
        } else {
          // Erro no registro
          final responseData = jsonDecode(response.body);
          String errorMessage =
              responseData['message'] ?? 'Erro ao registrar paciente.';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      } catch (e) {
        // Erro de conexão ou outro erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha de conexão. Tente novamente.')),
        );
        print('Erro ao registrar paciente: $e');
      } finally {
        // Ocultar indicador de carregamento
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              width: double.maxFinite,
              child: Column(
                children: [
                  buildHeaderSection(context),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.only(
                          left: 32.h,
                          top: 44.h,
                          right: 32.h,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              buildHomelessStatusSection(context),
                              SizedBox(height: 18.h),
                              buildSubstanceUseSection(context),
                              SizedBox(height: 18.h),
                              buildUsageDurationSection(context),
                              SizedBox(height: 22.h),
                              buildReferralSection(context),
                              SizedBox(height: 30.h),
                              buildRegisterButton(context),
                              SizedBox(height: 14.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildHeaderSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(vertical: 6.h),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            ImageConstant.imgGroup1,
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        children: [
          CustomAppBar(
            leadingWidth: 34.h,
            leading: AppbarLeadingImage(
              imagePath: ImageConstant.imgArrowLeft,
              margin: EdgeInsets.only(left: 5.h),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          SizedBox(height: 22.h),
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 32.h),
            child: Column(
              children: [
                Text(
                  "Cadastrar Usuário",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.displayLarge!.copyWith(
                    height: 1.19,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 34.h),
        ],
      ),
    );
  }

  Widget buildHomelessStatusSection(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "O usuário está em situação de rua?",
            style: theme.textTheme.titleMedium,
          ),
          SizedBox(height: 4.h),
          buildHomelessStatusInput(context),
        ],
      ),
    );
  }

  Widget buildHomelessStatusInput(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: homelessStatusInputController.text.trim().isEmpty
          ? null
          : homelessStatusInputController.text.trim(),
      items: ['Sim', 'Não']
          .map((label) => DropdownMenuItem(
                child: Text(label),
                value: label.toLowerCase(),
              ))
          .toList(),
      hint: Text("Selecione uma opção"),
      onChanged: (value) {
        setState(() {
          homelessStatusInputController.text = value ?? '';
        });
      },
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Por favor, selecione uma opção.';
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(16.h),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget buildSubstanceUseSection(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Quais substâncias o usuário consome?",
            style: theme.textTheme.titleMedium,
          ),
          SizedBox(height: 6.h),
          buildSubstanceUseInput(context),
        ],
      ),
    );
  }

  Widget buildSubstanceUseInput(BuildContext context) {
    return CustomTextFormField(
      controller: substanceUseInputController,
      hintText: "Substâncias que consome",
      contentPadding: EdgeInsets.all(16.h),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Por favor, insira as substâncias.';
        }
        return null;
      },
    );
  }

  Widget buildUsageDurationSection(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Há quanto tempo você faz uso?",
            style: theme.textTheme.titleMedium,
          ),
          SizedBox(height: 4.h),
          buildUsageDurationInput(context),
        ],
      ),
    );
  }

  Widget buildUsageDurationInput(BuildContext context) {
    return CustomTextFormField(
      controller: usageDurationInputController,
      hintText: "Tempo de uso das substâncias",
      contentPadding: EdgeInsets.all(16.h),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Por favor, insira a duração do uso.';
        }
        return null;
      },
    );
  }

  Widget buildReferralSection(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Você foi indicado? Se sim, coloque o nome de quem indicou",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium!.copyWith(
              height: 1.19,
            ),
          ),
          SizedBox(height: 4.h),
          buildReferralInput(context),
        ],
      ),
    );
  }

  Widget buildReferralInput(BuildContext context) {
    return CustomTextFormField(
      controller: referralInputController,
      hintText: "Nome de quem indicou",
      textInputAction: TextInputAction.done,
      contentPadding: EdgeInsets.all(16.h),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Por favor, insira o nome de quem indicou.';
        }
        return null;
      },
    );
  }

  Widget buildRegisterButton(BuildContext context) {
    return CustomElevatedButton(
      text: "PRÓXIMO",
      margin: EdgeInsets.symmetric(horizontal: 46.h),
      onPressed: _submitRegistration,
      buttonStyle: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF73CAAD),
      ),
    );
  }
}

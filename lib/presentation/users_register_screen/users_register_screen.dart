// ./users_register_screen/users_register_screen.dart

import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_landing_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';

// Alterar de StatelessWidget para StatefulWidget
class UsersRegisterScreen extends StatefulWidget {
  UsersRegisterScreen({Key? key}) : super(key: key);

  @override
  _UsersRegisterScreenState createState() => _UsersRegisterScreenState();
}

class _UsersRegisterScreenState extends State<UsersRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores de texto
  TextEditingController nameInputFieldController = TextEditingController();
  TextEditingController municipalityInputFieldController =
      TextEditingController();
  TextEditingController ageInputFieldController = TextEditingController();
  TextEditingController descriptionInputFieldController =
      TextEditingController();

  @override
  void dispose() {
    // Limpar os controladores ao descartar o widget
    nameInputFieldController.dispose();
    municipalityInputFieldController.dispose();
    ageInputFieldController.dispose();
    descriptionInputFieldController.dispose();
    super.dispose();
  }

  void _goToNextScreen() async {
    if (_formKey.currentState!.validate()) {
      // Coletar os dados do formulário
      Map<String, dynamic> formData = {
        "name": nameInputFieldController.text.trim(),
        "city": municipalityInputFieldController.text.trim(),
        "age": ageInputFieldController.text.trim(),
        "description": descriptionInputFieldController.text.trim(),
      };

      // Navegar para a segunda tela de registro passando os dados e aguardando o resultado
      final result = await Navigator.pushNamed(
        context,
        AppRoutes.usersRegisterTwoScreen,
        arguments: formData,
      );

      if (result == true) {
        // Se o registro foi bem-sucedido, retornar para a UsersListScreen com o resultado
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              buildHeaderSection(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.all(24.h),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 4.h),
                          buildNameInputSection(context),
                          SizedBox(height: 20.h),
                          buildMunicipalityInputSection(context),
                          SizedBox(height: 18.h),
                          buildAgeInputSection(context),
                          SizedBox(height: 20.h),
                          buildDescriptionInputSection(context),
                          SizedBox(height: 30.h),
                          buildNextButton(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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

  Widget buildNameInputSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(right: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Qual o seu nome?",
            style: theme.textTheme.titleMedium,
          ),
          SizedBox(height: 4.h),
          buildNameInputField(context),
        ],
      ),
    );
  }

  Widget buildNameInputField(BuildContext context) {
    return CustomTextFormField(
      controller: nameInputFieldController,
      hintText: "Nome",
      contentPadding: EdgeInsets.all(16.h),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Por favor, insira o nome.';
        }
        return null;
      },
    );
  }

  Widget buildMunicipalityInputSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(right: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Qual o seu município?",
            style: theme.textTheme.titleMedium,
          ),
          SizedBox(height: 4.h),
          buildMunicipalityInputField(context),
        ],
      ),
    );
  }

  Widget buildMunicipalityInputField(BuildContext context) {
    return CustomTextFormField(
      controller: municipalityInputFieldController,
      hintText: "Município",
      contentPadding: EdgeInsets.all(16.h),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Por favor, insira o município.';
        }
        return null;
      },
    );
  }

  Widget buildAgeInputSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(right: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Qual a sua idade?",
            style: theme.textTheme.titleMedium,
          ),
          SizedBox(height: 4.h),
          buildAgeInputField(context),
        ],
      ),
    );
  }

  Widget buildAgeInputField(BuildContext context) {
    return CustomTextFormField(
      controller: ageInputFieldController,
      hintText: "Idade",
      textInputType: TextInputType.number,
      contentPadding: EdgeInsets.all(16.h),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Por favor, insira a idade.';
        }
        if (int.tryParse(value.trim()) == null) {
          return 'Por favor, insira um número válido.';
        }
        return null;
      },
    );
  }

  Widget buildDescriptionInputSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Descreva brevemente a sua situação",
            style: theme.textTheme.titleMedium,
          ),
          SizedBox(height: 4.h),
          buildDescriptionInputField(context),
        ],
      ),
    );
  }

  Widget buildDescriptionInputField(BuildContext context) {
    return CustomTextFormField(
      controller: descriptionInputFieldController,
      hintText: "Descrição",
      textInputAction: TextInputAction.done,
      maxLines: 4,
      contentPadding: EdgeInsets.all(16.h),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Por favor, insira uma descrição.';
        }
        return null;
      },
    );
  }

  Widget buildNextButton(BuildContext context) {
    return CustomElevatedButton(
      text: "PRÓXIMO",
      margin: EdgeInsets.symmetric(horizontal: 46.h),
      onPressed: _goToNextScreen,
    );
  }
}

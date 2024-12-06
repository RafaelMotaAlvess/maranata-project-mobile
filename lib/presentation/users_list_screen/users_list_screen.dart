import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_floating_button.dart';
import 'widgets/userlist_item_widget.dart';
import '../../models/patient.dart'; // Importar o modelo de paciente

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({Key? key}) : super(key: key);

  @override
  _UsersListScreenState createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  List<Patient> _patients = [];
  bool _isLoading = false;

  // Função para buscar pacientes da API
  Future<void> _fetchPatients() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Recupera o token armazenado
      String? token = await _secureStorage.read(key: 'refreshToken');

      // Imprimir o token recuperado para depuração
      print('Token recuperado: $token');

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

      // Fazer a requisição GET para obter a lista de pacientes
      final response = await http.get(
        Uri.parse('https://maranata-project-api.onrender.com/patients'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie':
              'refreshToken=$token', // Passando o token correto no cabeçalho Cookie
          // Se a API espera no cabeçalho Authorization, use o seguinte:
          // 'Authorization': 'Bearer $token',
        },
      );

      // Imprimir o status da resposta e o corpo da resposta para depuração
      print('Status da resposta: ${response.statusCode}');
      print('Corpo da resposta: ${response.body}');

      if (response.statusCode == 200) {
        // Sucesso na requisição
        final List<dynamic> data = jsonDecode(response.body);
        print('Dados recebidos: $data'); // Imprimir os dados recebidos
        setState(() {
          _patients = data.map((json) => Patient.fromJson(json)).toList();
        });
      } else {
        // Falha na requisição
        final responseData = jsonDecode(response.body);
        String errorMessage =
            responseData['message'] ?? 'Erro ao buscar pacientes.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e, stackTrace) {
      // Erro na conexão ou outro erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha de conexão. Tente novamente.')),
      );
      print('Erro ao buscar pacientes: $e'); // Log para depuração
      print('StackTrace: $stackTrace'); // Log do stack trace para depuração
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Função para deletar um paciente
  Future<void> _deletePatient(String patientId) async {
    bool confirm = await _showDeleteConfirmationDialog();
    if (!confirm) return;

    setState(() {
      _isLoading = true;
    });

    try {
      String? token = await _secureStorage.read(key: 'refreshToken');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Token de autenticação não encontrado. Faça login novamente.')),
        );
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.signInScreen,
          (route) => false,
        );
        return;
      }

      final response = await http.delete(
        Uri.parse(
            'https://maranata-project-api.onrender.com/patients/$patientId'),
        headers: {
          'Cookie': 'refreshToken=$token',
        },
      );

      print('Status da resposta DELETE: ${response.statusCode}');
      print('Corpo da resposta DELETE: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Remover o paciente da lista localmente
        setState(() {
          _patients.removeWhere((patient) => patient?.id == patientId);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Paciente deletado com sucesso.')),
        );
      } else {
        final responseData = jsonDecode(response.body);
        String errorMessage =
            responseData['message'] ?? 'Erro ao deletar o paciente.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Falha ao deletar o paciente. Tente novamente.')),
      );
      print('Erro ao deletar paciente: $e');
      print('StackTrace: $stackTrace');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Função para mostrar um diálogo de confirmação antes da deleção
  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Confirmar Deleção'),
            content: Text('Você tem certeza que deseja deletar este paciente?'),
            actions: [
              TextButton(
                child: Text('Cancelar'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: Text(
                  'Deletar',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        ) ??
        false;
  }

  // Inicializar a busca de pacientes quando o widget é inserido na árvore
  @override
  void initState() {
    super.initState();
    _fetchPatients();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: SizeUtils.height,
          width: double.maxFinite,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: SizeUtils.height,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    _buildUserSummary(context),
                    _buildUserList(context),
                  ],
                ),
              ),
              if (_isLoading)
                Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
        floatingActionButton: _buildFloatingActionButton(context),
      ),
    );
  }

  /// Seção do Resumo do Usuário
  Widget _buildUserSummary(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 32.h,
        vertical: 40.h,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImageConstant.imgGroup1),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 24.h),
          SizedBox(
            width: double.maxFinite,
            child: Column(
              children: [
                Text(
                  "Seus Pacientes",
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
        ],
      ),
    );
  }

  /// Seção da Lista de Usuários
  Widget _buildUserList(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 28.h,
        top: 216.h,
        right: 28.h,
      ),
      child: _patients.isEmpty
          ? Center(
              child: Text(
                'Nenhum paciente encontrado.',
                style: theme.textTheme.bodyMedium,
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.zero,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: _patients.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 14.h);
              },
              itemBuilder: (context, index) {
                final patient = _patients[index];
                return UserListItemWidget(
                  patient: patient,
                  onDelete: () => patient.id != null
                      ? _deletePatient(patient.id!)
                      : null, // Passa o callback
                );
              },
            ),
    );
  }

  /// Botão Flutuante
  Widget _buildFloatingActionButton(BuildContext context) {
    return CustomFloatingButton(
      height: 70,
      width: 70,
      backgroundColor: theme.colorScheme.onError,
      child: Icon(
        Icons.add, // Ícone de mais (+)
        color: Colors.white,
        size: 35.0.h,
      ),
      onTap: () async {
        final result =
            await Navigator.pushNamed(context, AppRoutes.usersRegisterScreen);
        if (result == true) {
          _fetchPatients();
        }
      },
    );
  }
}

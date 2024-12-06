import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/app_export.dart';
import 'widgets/waitlistsection_item_widget.dart';
import '../../models/patient.dart';
import '../userdetails_screen/userdetails_screen.dart'; // Importando a tela de detalhes do paciente

class WaitlistScreen extends StatefulWidget {
  const WaitlistScreen({Key? key}) : super(key: key);

  @override
  _WaitlistScreenState createState() => _WaitlistScreenState();
}

class _WaitlistScreenState extends State<WaitlistScreen> {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  List<Patient> _waitlistPatients = [];
  bool _isLoading = false;

  // Função para buscar pacientes da fila de espera
  Future<void> _fetchWaitlistPatients() async {
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

      final response = await http.get(
        Uri.parse('https://maranata-project-api.onrender.com/patients'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'refreshToken=$token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _waitlistPatients =
              data.map((json) => Patient.fromJson(json)).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao buscar fila de espera.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha na conexão. Tente novamente.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Função para aprovar paciente e abrir conversa no WhatsApp
  Future<void> _approvePatient(String patientId, String? phone) async {
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

      final response = await http.patch(
        Uri.parse(
            'https://maranata-project-api.onrender.com/patients/status/$patientId'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'refreshToken=$token',
        },
        body: jsonEncode({
          'status': 'APPROVED',
        }),
      );

      if (response.statusCode == 200) {
        // Atualiza a lista de pacientes
        setState(() {
          _waitlistPatients.removeWhere((patient) => patient.id == patientId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Paciente aprovado.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao aprovar paciente.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao aprovar paciente. Tente novamente.')),
      );
    }
  }

  // Função de negação de paciente
  Future<void> _denyPatient(String patientId) async {
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

      final response = await http.patch(
        Uri.parse(
            'https://maranata-project-api.onrender.com/patients/status/$patientId'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'refreshToken=$token',
        },
        body: jsonEncode({
          'status': 'DENIED',
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _waitlistPatients.removeWhere((patient) => patient.id == patientId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Paciente reprovado.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao reprovar paciente.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao reprovar paciente. Tente novamente.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWaitlistPatients();
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
                    _buildFilaDeEsperaSection(context),
                    _buildWaitlistSection(context),
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
      ),
    );
  }

  Widget _buildFilaDeEsperaSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(vertical: 60.h),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImageConstant.imgGroup1),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Fila de Espera",
            style: theme.textTheme.displayLarge,
          ),
          SizedBox(height: 36.h),
        ],
      ),
    );
  }

  Widget _buildWaitlistSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 28.h, top: 198.h, right: 28.h),
      child: _waitlistPatients.isEmpty
          ? Center(
              child: Text(
                'Nenhum paciente na fila de espera.',
                style: theme.textTheme.bodyMedium,
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.zero,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (context, index) {
                return SizedBox(height: 14.h);
              },
              itemCount: _waitlistPatients.length,
              itemBuilder: (context, index) {
                final patient = _waitlistPatients[index];
                return GestureDetector(
                  onTap: () {
                    // Navegar para a tela de detalhes do paciente
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserdetailsScreen(
                          patient: patient,
                          onApprove: () =>
                              _approvePatient(patient.id!, patient.phone),
                          onDeny: () => _denyPatient(patient.id!),
                        ),
                      ),
                    );
                  },
                  child: WaitlistsectionItemWidget(
                    patient: patient,
                    onApprove: () =>
                        _approvePatient(patient.id!, patient.phone),
                    onDeny: () => _denyPatient(patient.id!),
                  ),
                );
              },
            ),
    );
  }
}

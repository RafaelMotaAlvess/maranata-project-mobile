import 'package:flutter/material.dart';
import '../../models/patient.dart';
import '../../core/app_export.dart';

class UserdetailsScreen extends StatelessWidget {
  final Patient patient;
  final VoidCallback onApprove;
  final VoidCallback onDeny;

  const UserdetailsScreen({
    Key? key,
    required this.patient,
    required this.onApprove,
    required this.onDeny,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Cabeçalho
              _buildHeader(context, theme),

              // Conteúdo Principal logo abaixo do header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildMainContent(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Container(
      width: double.infinity,
      height: 200, // Ajuste a altura conforme necessário
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImageConstant.imgGroup1),
          fit: BoxFit.fill,
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              "Informações",
              style: theme.textTheme.displayLarge?.copyWith(
                color: Colors.white,
                fontSize: 46,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildPatientDetails(),
          const SizedBox(height: 24),
          _buildSectionTitle("Descrição"),
          const SizedBox(height: 12),
          Text(
            patient.description ?? "Descrição não fornecida",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle("Questionário"),
          const SizedBox(height: 12),
          _buildQuestionnaire(),
          const SizedBox(height: 24),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildPatientDetails() {
    return Column(
      children: [
        Text(
          patient.name ?? "Paciente",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "${patient.age} anos, ${patient.city ?? 'Cidade não informada'}",
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade400)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: Divider(color: Colors.grey.shade400)),
      ],
    );
  }

  Widget _buildQuestionnaire() {
    final questions = [
      {
        "question": "O usuário está em situação de rua?",
        "answer": patient.isHomeless ? "Sim" : "Não",
      },
      {
        "question": "Quais substâncias o usuário consome?",
        "answer": patient.substances ?? "Não informado",
      },
      {
        "question": "A quanto tempo você faz uso?",
        "answer": patient.usageDuration ?? "Não informado",
      },
      {
        "question": "Você foi indicado?",
        "answer": patient.referredBy != null
            ? "Sim, ${patient.referredBy}"
            : "Não informado",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: questions.map((q) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                q["question"]!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                q["answer"]!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: onApprove,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(24),
          ),
          child: const Icon(
            Icons.done_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
        ElevatedButton(
          onPressed: onDeny,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(24),
          ),
          child: const Icon(
            Icons.close_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
      ],
    );
  }
}

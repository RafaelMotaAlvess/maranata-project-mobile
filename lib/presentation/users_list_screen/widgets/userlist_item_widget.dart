import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import '../../../models/patient.dart';

class UserListItemWidget extends StatelessWidget {
  final Patient patient;
  final VoidCallback onDelete; // Adicionado callback para deleção

  const UserListItemWidget({
    Key? key,
    required this.patient,
    required this.onDelete, // Requerido no construtor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 18, vertical: 14), // Ajuste direto sem 'h'
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimaryContainer,
        borderRadius: BorderRadius.circular(10), // Usando BorderRadius direto
        boxShadow: [
          BoxShadow(
            color: appTheme.gray500,
            spreadRadius: 2,
            blurRadius: 2,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildPlaceholderIcon(),
          SizedBox(width: 12), // Ajuste direto sem 'h'
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient.name,
                  style: theme.textTheme.bodyLarge,
                ),
                SizedBox(height: 4),
                Text(
                  '${patient.city}, ${patient.age} anos',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: appTheme.gray700,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    _buildStatusIndicator(patient.status),
                    SizedBox(width: 8),
                    Text(
                      _statusToString(patient.status),
                      style: CustomTextStyles.labelMediumPrimaryContainer,
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.red, // Cor do ícone de lixeira
            ),
            onPressed: onDelete, // Chama o callback quando clicado
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderIcon() {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        Icons.person,
        size: 24,
        color: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildStatusIndicator(Status? status) {
    Color color;
    switch (status) {
      case Status.APPROVED:
        color = appTheme.green900;
        break;
      case Status.UNDER_REVIEW:
        color = appTheme.yellow500;
        break;
      case Status.DENIED:
        color = appTheme.red500;
        break;
      default:
        color = appTheme.gray500;
    }

    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  String _statusToString(Status? status) {
    switch (status) {
      case Status.APPROVED:
        return 'Aprovado';
      case Status.UNDER_REVIEW:
        return 'Em Análise';
      case Status.DENIED:
        return 'Negado';
      default:
        return 'Desconhecido';
    }
  }
}

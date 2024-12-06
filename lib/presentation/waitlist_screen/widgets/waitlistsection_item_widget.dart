import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../models/patient.dart';

class WaitlistsectionItemWidget extends StatelessWidget {
  final Patient patient;
  final VoidCallback onApprove;
  final VoidCallback onDeny;

  const WaitlistsectionItemWidget({
    Key? key,
    required this.patient,
    required this.onApprove,
    required this.onDeny,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 14.h,
        vertical: 18.h,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimaryContainer,
        borderRadius: BorderRadiusStyle.roundedBorder10,
        boxShadow: [
          BoxShadow(
            color: appTheme.gray500,
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: CustomTextStyles.bodyLargePoppins_l.copyWith(
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Solicitado: ${patient.createdAt != null ? patient.createdAt!.toLocal().toString().split(' ')[0] : 'Desconhecido'}",
                  style: CustomTextStyles.bodySmallGray700,
                ),
              ],
            ),
          ),
          SizedBox(width: 10.h),
          IconButton(
            icon: Icon(Icons.check, color: appTheme.green900),
            onPressed: onApprove,
          ),
          SizedBox(width: 10.h),
          IconButton(
            icon: Icon(Icons.close, color: appTheme.red500),
            onPressed: onDeny,
          ),
        ],
      ),
    );
  }
}

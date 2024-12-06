// lib/models/patient.dart

enum Status {
  DENIED,
  UNDER_REVIEW,
  APPROVED,
}

class Patient {
  final String? id;
  final String name;
  final String city;
  final String age;
  final String phone;
  final String description;
  final bool isHomeless;
  final String substances;
  final String usageDuration;
  final String? referredBy;
  final Status? status;
  final String? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Patient({
    this.id,
    required this.name,
    required this.city,
    required this.age,
    required this.description,
    required this.isHomeless,
    required this.substances,
    required this.usageDuration,
    required this.phone,
    this.referredBy,
    this.status,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      name: json['name'] ?? 'Sem Nome',
      city: json['city'] ?? 'Desconhecida',
      age: json['age'] ?? '0',
      phone: json['phone'] ?? '47992322389',
      description: json['description'] ?? '',
      isHomeless: json['isHomeless'] ?? false,
      substances: json['substances'] ?? '',
      usageDuration: json['usageDuration'] ?? '',
      referredBy: json['referredBy'],
      status: _statusFromString(
          json['status']), // Corrigido para tratar como String
      userId: json['userId'],
      createdAt:
          json['createdAt'] != null ? _parseTimestamp(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? _parseTimestamp(json['updatedAt']) : null,
    );
  }

  /// Função auxiliar para converter String em enum Status
  static Status? _statusFromString(String? status) {
    if (status == null) return null;
    switch (status.toUpperCase()) {
      case 'DENIED':
        return Status.DENIED;
      case 'UNDER_REVIEW':
        return Status.UNDER_REVIEW;
      case 'APPROVED':
        return Status.APPROVED;
      default:
        return null;
    }
  }

  /// Função auxiliar para converter timestamp em DateTime
  static DateTime _parseTimestamp(Map<String, dynamic> timestamp) {
    int seconds = timestamp['seconds'] ?? 0;
    int nanoseconds = timestamp['nanoseconds'] ?? 0;
    return DateTime.fromMillisecondsSinceEpoch(
      (seconds * 1000) + (nanoseconds / 1000000).round(),
      isUtc: true,
    );
  }
}

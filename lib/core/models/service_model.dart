import 'package:flutter/material.dart';

class ServiceModel {
  final int id;
  final String title;
  final String description;
  final IconData icon;

  const ServiceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
  });

  ServiceModel copyWith({
    int? id,
    String? title,
    String? description,
    IconData? icon,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
    );
  }
}

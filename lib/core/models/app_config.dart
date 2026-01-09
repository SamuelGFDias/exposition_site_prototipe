import 'package:flutter/material.dart';
import 'service_model.dart';
import 'theme_config.dart';

class GeneralConfig {
  final String companyName;
  final String heroTitle;
  final String heroSubtitle;
  final String heroImage;
  final String aboutText;
  final String footerText;

  const GeneralConfig({
    required this.companyName,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.heroImage,
    required this.aboutText,
    required this.footerText,
  });

  GeneralConfig copyWith({
    String? companyName,
    String? heroTitle,
    String? heroSubtitle,
    String? heroImage,
    String? aboutText,
    String? footerText,
  }) {
    return GeneralConfig(
      companyName: companyName ?? this.companyName,
      heroTitle: heroTitle ?? this.heroTitle,
      heroSubtitle: heroSubtitle ?? this.heroSubtitle,
      heroImage: heroImage ?? this.heroImage,
      aboutText: aboutText ?? this.aboutText,
      footerText: footerText ?? this.footerText,
    );
  }
}

class ContactConfig {
  final String address;
  final String phone;
  final String email;
  final String hours;

  const ContactConfig({
    required this.address,
    required this.phone,
    required this.email,
    required this.hours,
  });

  ContactConfig copyWith({
    String? address,
    String? phone,
    String? email,
    String? hours,
  }) {
    return ContactConfig(
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      hours: hours ?? this.hours,
    );
  }
}

class ChatbotFlowOption {
  final String label;
  final String nextId;

  const ChatbotFlowOption({
    required this.label,
    required this.nextId,
  });

  ChatbotFlowOption copyWith({
    String? label,
    String? nextId,
  }) {
    return ChatbotFlowOption(
      label: label ?? this.label,
      nextId: nextId ?? this.nextId,
    );
  }

  Map<String, dynamic> toJson() => {
        'label': label,
        'nextId': nextId,
      };

  factory ChatbotFlowOption.fromJson(Map<String, dynamic> json) =>
      ChatbotFlowOption(
        label: json['label'] as String,
        nextId: json['nextId'] as String,
      );
}

class ChatbotFlowStep {
  final String id;
  final String message;
  final List<ChatbotFlowOption> options;

  const ChatbotFlowStep({
    required this.id,
    required this.message,
    required this.options,
  });

  ChatbotFlowStep copyWith({
    String? id,
    String? message,
    List<ChatbotFlowOption>? options,
  }) {
    return ChatbotFlowStep(
      id: id ?? this.id,
      message: message ?? this.message,
      options: options ?? this.options,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'message': message,
        'options': options.map((o) => o.toJson()).toList(),
      };

  factory ChatbotFlowStep.fromJson(Map<String, dynamic> json) =>
      ChatbotFlowStep(
        id: json['id'] as String,
        message: json['message'] as String,
        options: (json['options'] as List)
            .map((o) => ChatbotFlowOption.fromJson(o as Map<String, dynamic>))
            .toList(),
      );
}

class ChatbotFAQ {
  final int id;
  final List<String> keywords;
  final String answer;

  const ChatbotFAQ({
    required this.id,
    required this.keywords,
    required this.answer,
  });
}

class ChatbotConfig {
  final String botName;
  final String welcomeMessage;
  final List<ChatbotFlowStep> flow;

  const ChatbotConfig({
    required this.botName,
    required this.welcomeMessage,
    required this.flow,
  });

  ChatbotConfig copyWith({
    String? botName,
    String? welcomeMessage,
    List<ChatbotFlowStep>? flow,
  }) {
    return ChatbotConfig(
      botName: botName ?? this.botName,
      welcomeMessage: welcomeMessage ?? this.welcomeMessage,
      flow: flow ?? this.flow,
    );
  }
}

class AppConfig {
  final AppThemePreset theme;
  final GeneralConfig general;
  final ContactConfig contact;
  final List<ServiceModel> services;
  final ChatbotConfig chatbot;

  const AppConfig({
    required this.theme,
    required this.general,
    required this.contact,
    required this.services,
    required this.chatbot,
  });

  AppConfig copyWith({
    AppThemePreset? theme,
    GeneralConfig? general,
    ContactConfig? contact,
    List<ServiceModel>? services,
    ChatbotConfig? chatbot,
  }) {
    return AppConfig(
      theme: theme ?? this.theme,
      general: general ?? this.general,
      contact: contact ?? this.contact,
      services: services ?? this.services,
      chatbot: chatbot ?? this.chatbot,
    );
  }

  static AppConfig get defaultConfig => AppConfig(
        theme: AppThemePreset.blue,
        general: const GeneralConfig(
          companyName: 'Nexus InfoTech',
          heroTitle: 'Tecnologia que Impulsiona o Futuro',
          heroSubtitle:
              'Transformamos desafios complexos em soluções digitais simples e eficientes para o seu negócio escalar com segurança.',
          heroImage:
              'https://images.unsplash.com/photo-1519389950473-47ba0277781c?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80',
          aboutText:
              'Somos uma consultoria de TI focada em resultados. Nossa missão é modernizar infraestruturas legadas e implementar soluções de nuvem seguras.',
          footerText: '© 2025 Nexus InfoTech. Inovação e Excelência.',
        ),
        contact: const ContactConfig(
          address: 'Av. Faria Lima, 2000 - São Paulo, SP',
          phone: '(11) 98888-7777',
          email: 'contato@nexus.tech',
          hours: 'Seg - Sex: 09:00 - 18:00',
        ),
        services: const [
          ServiceModel(
            id: 1,
            title: 'Suporte Gerenciado',
            description:
                'Monitoramento 24/7 e helpdesk para garantir que sua equipe nunca pare.',
            icon: Icons.monitor,
          ),
          ServiceModel(
            id: 2,
            title: 'Cloud Computing',
            description:
                'Migração e gestão de servidores na AWS, Azure e Google Cloud.',
            icon: Icons.cloud,
          ),
          ServiceModel(
            id: 3,
            title: 'Cibersegurança',
            description:
                'Pentests, firewalls e conformidade LGPD para blindar seus dados.',
            icon: Icons.security,
          ),
          ServiceModel(
            id: 4,
            title: 'Desenvolvimento Ágil',
            description:
                'Fábrica de software para web e mobile com tecnologias modernas.',
            icon: Icons.code,
          ),
        ],
        chatbot: const ChatbotConfig(
          botName: 'Nexus AI',
          welcomeMessage:
              'Olá! Como posso ajudar a modernizar sua empresa hoje?',
          flow: [
            ChatbotFlowStep(
              id: 'start',
              message: 'Olá! Como posso ajudar você hoje?',
              options: [
                ChatbotFlowOption(
                  label: 'Horário de funcionamento',
                  nextId: 'horario',
                ),
                ChatbotFlowOption(
                  label: 'Serviços oferecidos',
                  nextId: 'servicos',
                ),
                ChatbotFlowOption(
                  label: 'Solicitar orçamento',
                  nextId: 'orcamento',
                ),
              ],
            ),
            ChatbotFlowStep(
              id: 'horario',
              message: 'Estamos abertos de Segunda a Sexta, das 09h às 18h.',
              options: [
                ChatbotFlowOption(
                  label: 'Voltar ao início',
                  nextId: 'start',
                ),
                ChatbotFlowOption(
                  label: 'Ver serviços',
                  nextId: 'servicos',
                ),
              ],
            ),
            ChatbotFlowStep(
              id: 'servicos',
              message:
                  'Trabalhamos com Suporte Gerenciado, Cloud Computing, Cibersegurança e Desenvolvimento Ágil.',
              options: [
                ChatbotFlowOption(
                  label: 'Voltar ao início',
                  nextId: 'start',
                ),
                ChatbotFlowOption(
                  label: 'Solicitar orçamento',
                  nextId: 'orcamento',
                ),
              ],
            ),
            ChatbotFlowStep(
              id: 'orcamento',
              message:
                  'Nossos projetos são personalizados. Um consultor entrará em contato com você em breve!',
              options: [
                ChatbotFlowOption(
                  label: 'Voltar ao início',
                  nextId: 'start',
                ),
              ],
            ),
          ],
        ),
      );
}

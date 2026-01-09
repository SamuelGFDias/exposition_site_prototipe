# Site de Exposição - Flutter

Migração completa do projeto React (proposta.jsx) para Flutter com arquitetura robusta.

## 🏗️ Arquitetura

### **Go Router** (Navegação)
Sistema de rotas com proteção de autenticação:
- `/` - Site público
- `/login` - Login administrativo
- `/admin` - Painel administrativo (protegido)
- `/admin/general`, `/admin/services`, `/admin/contact`, `/admin/chatbot` - Sub-rotas

### **Riverpod** (Gerenciamento de Estado)
Providers organizados:
- `appConfigProvider` - Configurações gerais do site
- `authProvider` - Estado de autenticação
- `chatProvider` - Estado do chatbot
- `routerProvider` - Instância do GoRouter

### **Estrutura de Pastas**
```
lib/
├── core/
│   ├── models/           # Modelos de dados
│   │   ├── app_config.dart
│   │   ├── theme_config.dart
│   │   ├── service_model.dart
│   │   └── chat_message.dart
│   ├── providers/        # State management
│   │   ├── config_provider.dart
│   │   ├── auth_provider.dart
│   │   └── chat_provider.dart
│   └── router/          # Navegação
│       └── app_router.dart
├── features/
│   ├── public/          # Site público
│   │   ├── screens/
│   │   │   └── public_site_screen.dart
│   │   └── widgets/
│   │       ├── public_navbar.dart
│   │       ├── hero_section.dart
│   │       ├── services_section.dart
│   │       ├── about_section.dart
│   │       ├── contact_section.dart
│   │       ├── footer_section.dart
│   │       └── chat_widget.dart
│   └── admin/           # Painel administrativo
│       ├── screens/
│       │   ├── admin_login_screen.dart
│       │   └── admin_panel_screen.dart
│       └── widgets/
│           ├── general_tab.dart
│           ├── services_tab.dart
│           ├── contact_tab.dart
│           └── chatbot_tab.dart
└── main.dart
```

## 🎨 Funcionalidades

### Site Público
- **Hero Section** com imagem de fundo e CTAs
- **Seções:**
  - Serviços (4 cards com hover effects)
  - Sobre Nós (texto + imagem)
  - Contato (informações + formulário)
  - Footer
- **Chatbot AI** flutuante com FAQ inteligente
- **Navbar responsiva** com scroll detection
- **Navegação suave** entre seções

### Painel Administrativo
- **Login protegido** (admin/123)
- **Abas de configuração:**
  1. **Geral & Tema** - 5 temas de cores + textos principais
  2. **Serviços** - Editar títulos e descrições
  3. **Contato** - Atualizar informações
  4. **Chatbot** - Configurar mensagens
- **Sidebar** com navegação por abas
- **Salvar configurações** em tempo real

## 🎯 Temas Disponíveis
1. **Ocean Blue** (Padrão)
2. **Eco Emerald**
3. **Digital Violet**
4. **Berry Rose**
5. **Solar Amber**

## 🚀 Como Executar

```bash
# Instalar dependências
flutter pub get

# Executar em modo web
flutter run -d chrome

# Build para produção
flutter build web
```

## 📦 Dependências Principais
- `flutter_riverpod` ^2.6.1 - State management
- `go_router` ^14.6.2 - Navegação
- `cached_network_image` ^3.4.1 - Imagens com cache
- `flutter_animate` ^4.5.0 - Animações

## 🔐 Credenciais Admin
- **Usuário:** admin
- **Senha:** 123

## 📱 Responsividade
- **Mobile First** design
- **Breakpoints:**
  - Mobile: < 768px
  - Tablet: 768px - 1024px
  - Desktop: > 1024px

## 🔄 Migração React → Flutter

### Hooks React → Riverpod
- `useState` → `StateNotifier`
- `useEffect` → `ref.listen` / `ref.watch`
- `useMemo` → `Provider` computed values
- `useRef` → `ScrollController` / `TextEditingController`

### Componentes
- Todos os componentes React foram convertidos para Widgets Flutter
- Mantida a mesma estrutura visual e UX
- Melhorias de performance com `const` constructors

### Roteamento
- React Router → GoRouter
- Proteção de rotas implementada com redirect
- Deep linking suportado

## 🎨 Personalização

### Adicionar Novo Tema
```dart
// Em theme_config.dart
AppThemePreset.newTheme: ThemeConfig(
  preset: AppThemePreset.newTheme,
  name: 'New Theme',
  primaryColor: Color(0xFF123456),
  textColor: Color(0xFF654321),
  bgLightColor: Color(0xFFF0F0F0),
),
```

### Adicionar Nova Seção
1. Criar widget em `features/public/widgets/`
2. Adicionar ao `public_site_screen.dart`
3. Atualizar navbar se necessário

## 📈 Performance
- **Lazy loading** de imagens
- **Const constructors** onde possível
- **Provider caching** automático
- **Tree shaking** no build

## 🔧 Próximos Passos
- [ ] Integrar com backend real
- [ ] Adicionar animações com flutter_animate
- [ ] Implementar analytics
- [ ] Testes unitários e de widget
- [ ] CI/CD pipeline

---
**Desenvolvido com Flutter 💙**

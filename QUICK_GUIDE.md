# 🚀 Guia Rápido - Site Exposição Flutter

## ⚡ Comandos Essenciais

### Desenvolvimento
```bash
# Rodar em modo debug (hot reload)
flutter run -d chrome

# Rodar com web-server específico
flutter run -d web-server --web-port 8080

# Rodar com hot reload mais rápido
flutter run -d chrome --web-renderer html
```

### Build
```bash
# Build de produção (otimizado)
flutter build web --release

# Build com renderizador específico
flutter build web --web-renderer canvaskit

# Build sem tree-shaking de ícones
flutter build web --no-tree-shake-icons
```

### Manutenção
```bash
# Verificar erros
flutter analyze

# Formatar código
flutter format lib/

# Limpar cache
flutter clean

# Atualizar dependências
flutter pub get
flutter pub upgrade
```

## 🎯 Estrutura de Navegação

### URLs Disponíveis
- `http://localhost:PORT/` - Home pública
- `http://localhost:PORT/login` - Login admin
- `http://localhost:PORT/admin` - Dashboard (requer login)
- `http://localhost:PORT/admin/general` - Config geral
- `http://localhost:PORT/admin/services` - Editar serviços
- `http://localhost:PORT/admin/contact` - Config contato
- `http://localhost:PORT/admin/chatbot` - Config chatbot

## 🔐 Autenticação

### Credenciais Padrão
```
Usuário: admin
Senha: 123
```

### Alterar Credenciais
Edite: `lib/core/providers/auth_provider.dart`
```dart
bool login(String username, String password) {
  if (username == 'NOVO_USER' && password == 'NOVA_SENHA') {
    // ...
  }
}
```

## 🎨 Personalização

### Adicionar Novo Tema
1. Edite `lib/core/models/theme_config.dart`
2. Adicione novo enum em `AppThemePreset`
3. Adicione config no map `presets`

```dart
AppThemePreset.cyan: ThemeConfig(
  preset: AppThemePreset.cyan,
  name: 'Cyber Cyan',
  primaryColor: Color(0xFF06B6D4),
  textColor: Color(0xFF0E7490),
  bgLightColor: Color(0xFFECFEFF),
),
```

### Adicionar Serviço
Edite `lib/core/models/app_config.dart` em `defaultConfig`:

```dart
ServiceModel(
  id: 5,
  title: 'Novo Serviço',
  description: 'Descrição aqui',
  icon: Icons.rocket_launch,
),
```

### Alterar FAQ do Chatbot
Em `lib/core/models/app_config.dart`:

```dart
ChatbotFAQ(
  id: 4,
  keywords: ['palavra1', 'palavra2'],
  answer: 'Resposta aqui',
),
```

## 📱 Testes

### Testar Responsividade
```bash
# Desktop
flutter run -d chrome

# Mobile simulation
flutter run -d chrome --web-browser-flag="--window-size=375,812"

# Tablet simulation  
flutter run -d chrome --web-browser-flag="--window-size=768,1024"
```

## 🐛 Debug

### Ver logs detalhados
```bash
flutter run -d chrome --verbose
```

### DevTools
```bash
flutter pub global activate devtools
flutter pub global run devtools
```

## 📦 Deploy

### Build Otimizado
```bash
flutter build web \
  --release \
  --web-renderer canvaskit \
  --base-href /
```

### Deploy para Firebase Hosting
```bash
firebase init hosting
firebase deploy
```

### Deploy para GitHub Pages
1. Build: `flutter build web --base-href "/repo-name/"`
2. Copie `build/web` para branch `gh-pages`
3. Configure no GitHub Settings

## 🔧 Troubleshooting

### Erro: Provider não encontrado
```bash
flutter clean
flutter pub get
flutter run
```

### Erro: Rota não funciona
Verifique `lib/core/router/app_router.dart`

### Imagens não carregam
- Verifique URLs em `app_config.dart`
- Teste conexão internet
- Use URLs diretas sem redirect

## 📊 Performance

### Analisar bundle size
```bash
flutter build web --analyze-size
```

### Otimizar imagens
Use `cached_network_image` (já implementado)

### Lazy loading
Widgets são carregados sob demanda via GoRouter

## 🎓 Recursos de Aprendizado

### Documentação Oficial
- [Flutter Web](https://flutter.dev/web)
- [Riverpod](https://riverpod.dev)
- [GoRouter](https://pub.dev/packages/go_router)

### Exemplos neste projeto
- State management: `lib/core/providers/`
- Routing: `lib/core/router/app_router.dart`
- Widgets reutilizáveis: `lib/features/*/widgets/`

## 💡 Dicas

1. **Use const sempre que possível** - Melhor performance
2. **Provider.select** - Para otimizar rebuilds
3. **Keys** - Use GlobalKey para scroll navigation
4. **Async/Await** - No chatbot e futuras APIs

## 🚀 Próximas Melhorias

- [ ] Adicionar backend real (Firebase/Supabase)
- [ ] Implementar analytics
- [ ] Adicionar mais animações
- [ ] Testes automatizados
- [ ] PWA features (offline, push notifications)
- [ ] Multi-idioma (i18n)

---

**Documentação completa em:** `MIGRATION_README.md`  
**Resumo da migração em:** `MIGRATION_SUMMARY.md`

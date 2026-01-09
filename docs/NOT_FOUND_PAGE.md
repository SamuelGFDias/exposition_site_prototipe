# 🚫 Página 404 - Not Found

## ✨ Design Minimalista e Moderno

Página de erro 404 com design clean e animações suaves quando o usuário acessa uma rota não mapeada.

## 🎨 Características

### Visual
- **404 Grande** com gradiente dinâmico baseado no tema
- **Efeito de sombra** com stroke outline
- **Ícone circular** com animação de entrada
- **Cores adaptativas** seguindo o tema selecionado no admin
- **Tipografia hierárquica** clara e legível

### Animações
1. **404 Number** - Escala com efeito elastic (800ms)
2. **Ícone** - Fade in + slide up (1000ms)  
3. **Título** - Fade in + slide up (1200ms)
4. **Descrição** - Fade in (1400ms)
5. **Botões** - Fade in + slide up (1600ms)
6. **Branding** - Fade in sutil (1800ms)

### Responsividade
- **Mobile** (< 768px): Layout compacto, fonte 120px
- **Desktop** (≥ 768px): Layout espaçoso, fonte 180px

## 🔧 Funcionalidades

### Botões de Ação
1. **Voltar ao Início** (primário)
   - Cor do tema atual
   - Ícone de casa
   - Redireciona para `/`

2. **Voltar** (secundário)
   - Outlined button
   - Usa `context.canPop()` para voltar ou ir para home
   - Borda com cor do tema

### Integração com Sistema
- ✅ Usa Riverpod para acessar config global
- ✅ Respeita tema selecionado no admin
- ✅ Mostra nome da empresa dinamicamente
- ✅ Usa GoRouter para navegação

## 📍 Como Acessar

Qualquer rota não mapeada exibirá esta página:
- `http://localhost:PORT/rota-invalida`
- `http://localhost:PORT/qualquer-coisa`
- `http://localhost:PORT/admin/nao-existe`

## 🎯 Implementação Técnica

### Configuração no Router
```dart
// lib/core/router/app_router.dart
GoRouter(
  errorBuilder: (context, state) => const NotFoundScreen(),
  // ...
)
```

### Localização
```
lib/features/error/screens/not_found_screen.dart
```

## 🎨 Customização

### Alterar Mensagem
Edite em `not_found_screen.dart`:
```dart
Text('Página Não Encontrada'), // Título
Text('A página que você está procurando não existe...'), // Descrição
```

### Alterar Ícone
```dart
Icon(Icons.explore_off_rounded) // Linha ~115
// Trocar por: search_off, error_outline, sentiment_dissatisfied, etc.
```

### Ajustar Animações
```dart
duration: const Duration(milliseconds: 800), // Velocidade
curve: Curves.elasticOut, // Tipo de easing
```

## 🎭 Variações de Ícones Sugeridos

```dart
Icons.explore_off_rounded    // Padrão - Exploração desativada
Icons.search_off             // Busca desativada
Icons.error_outline          // Erro outline
Icons.sentiment_dissatisfied // Emoji triste
Icons.cloud_off              // Cloud desconectada
Icons.block                  // Bloqueado
Icons.warning_amber_rounded  // Aviso
Icons.help_outline           // Ajuda
```

## 🚀 Para Testar

```bash
# 1. Rodar aplicação
flutter run -d chrome

# 2. Acessar rota inválida
http://localhost:PORT/pagina-inexistente

# 3. Verificar:
# - Animações sequenciais
# - Responsividade
# - Navegação dos botões
# - Cores do tema atual
```

---

**Arquivo:** `lib/features/error/screens/not_found_screen.dart`  
**Status:** ✅ Implementado  
**Features:** Animações, Responsivo, Integrado com temas

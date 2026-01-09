# Migração do Sistema de Chatbot

## Resumo
Sistema de chatbot migrado de **FAQ baseado em keywords** para **Fluxo Conversacional baseado em Steps e Opções**.

## Mudanças Realizadas

### 1. **Modelos de Dados** (`lib/core/models/app_config.dart`)

#### Novos Modelos Criados:

**`ChatbotFlowOption`**
```dart
class ChatbotFlowOption {
  final String label;      // Texto exibido no botão
  final String nextId;     // ID do próximo passo
  
  // Métodos: copyWith(), toJson(), fromJson()
}
```

**`ChatbotFlowStep`**
```dart
class ChatbotFlowStep {
  final String id;                          // Identificador único
  final String message;                     // Mensagem do bot
  final List<ChatbotFlowOption> options;    // Opções/botões disponíveis
  
  // Métodos: copyWith(), toJson(), fromJson()
}
```

#### Modelo Atualizado:

**`ChatbotConfig`**
- ❌ **ANTES:** `List<ChatbotFAQ> faq`
- ✅ **AGORA:** `List<ChatbotFlowStep> flow`

### 2. **Provider** (`lib/core/providers/chat_provider.dart`)

#### ChatState Atualizado:
```dart
class ChatState {
  final List<ChatMessage> messages;
  final bool isTyping;
  final bool isOpen;
  final String? currentStepId;  // ✅ NOVO: rastreia passo atual
}
```

#### Métodos do ChatNotifier:

**Removido:**
- ❌ `sendMessage(String text)` - input de texto livre
- ❌ `_getResponse(String input)` - busca por keywords

**Adicionado:**
- ✅ `selectOption(ChatbotFlowOption option)` - seleciona opção e avança no fluxo
- ✅ `getCurrentStep()` - retorna o passo atual baseado no ID
- ✅ `_initializeChat()` atualizado para iniciar no step "start"

### 3. **Widget de Chat** (`lib/features/public/widgets/chat_widget.dart`)

#### Interface Atualizada:

**Removido:**
- ❌ Campo de texto para digitação livre
- ❌ Botão de enviar mensagem
- ❌ `TextEditingController`
- ❌ Método `_sendMessage()`

**Adicionado:**
- ✅ Método `_buildOptions()` que renderiza botões de opções
- ✅ Botões estilizados com borda arredondada e ícone de seta
- ✅ Opções aparecem abaixo das mensagens
- ✅ Cada botão chama `selectOption()` ao ser clicado

#### Layout:
```
┌────────────────────────────┐
│  Header do Chat            │
├────────────────────────────┤
│                            │
│  [Mensagens do Chat]       │
│  - Bot: Mensagem...        │
│  - User: Escolha...        │
│  - Bot: Resposta...        │
│                            │
│  ┌──────────────────────┐  │
│  │ ⟶ Opção 1         →  │  │ ← Botões
│  └──────────────────────┘  │
│  ┌──────────────────────┐  │
│  │ ⟶ Opção 2         →  │  │
│  └──────────────────────┘  │
└────────────────────────────┘
```

### 4. **Editor de Fluxo** (`lib/features/admin/widgets/chatbot_tab.dart`)

Interface completa para criar e editar o fluxo conversacional:

- **Adicionar/Remover Steps**
- **Editar ID, mensagem de cada step**
- **Adicionar/Remover opções em cada step**
- **Configurar label e nextId de cada opção**
- **Validação visual do step "start"**
- **Interface drag-free (sem arrastar, apenas edição inline)**

## Fluxo Padrão Implementado

```
start
├─→ "Horário de funcionamento" → horario
├─→ "Serviços oferecidos" → servicos
└─→ "Solicitar orçamento" → orcamento

horario
├─→ "Voltar ao início" → start
└─→ "Ver serviços" → servicos

servicos
├─→ "Voltar ao início" → start
└─→ "Solicitar orçamento" → orcamento

orcamento
└─→ "Voltar ao início" → start
```

## Como Funciona

### Fluxo do Usuário:
1. Usuário abre o chat
2. Bot mostra mensagem do step "start"
3. Bot exibe botões com as opções disponíveis
4. Usuário clica em um botão
5. Sistema registra a escolha como mensagem do usuário
6. Bot carrega o próximo step baseado no `nextId` da opção
7. Bot exibe a mensagem do novo step
8. Repete o processo

### Exemplo de Interação:
```
🤖 Bot: Olá! Como posso ajudar você hoje?
   [Horário de funcionamento →]
   [Serviços oferecidos →]
   [Solicitar orçamento →]

👤 User: [clica em "Serviços oferecidos"]

🤖 Bot: Trabalhamos com Suporte Gerenciado, Cloud Computing...
   [Voltar ao início →]
   [Solicitar orçamento →]
```

## Vantagens do Novo Sistema

1. **UX Melhor**: Botões são mais intuitivos que digitação
2. **Zero Erros**: Usuário não pode digitar algo inválido
3. **Fluxo Controlado**: Admin define exatamente o caminho da conversa
4. **Escalável**: Fácil adicionar novos passos e ramificações
5. **Visual**: Editor gráfico intuitivo no painel admin
6. **Flexível**: Permite criar árvores de decisão complexas
7. **Mobile-Friendly**: Botões funcionam melhor em touch screens

## Status

✅ Modelos criados e testados
✅ Provider migrado e funcional
✅ Widget de chat atualizado com botões
✅ Editor de fluxo completo no admin
✅ Fluxo padrão implementado
✅ Código analisa sem erros críticos
⚠️  13 warnings sobre `withOpacity` deprecado (não crítico)

## Próximos Passos (Opcional)

- [ ] Corrigir warnings de `withOpacity` (trocar por `withValues`)
- [ ] Adicionar animações nas transições de steps
- [ ] Implementar persistência do histórico de conversa
- [ ] Adicionar suporte a múltiplas conversas simultâneas
- [ ] Implementar preview do fluxo no editor

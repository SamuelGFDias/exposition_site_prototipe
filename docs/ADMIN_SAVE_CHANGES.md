# Mudanças no Painel de Administração

## Resumo
1. **Implementado sistema de salvamento individual por seção** no painel administrativo
2. **Migrado sistema de chatbot de FAQ para Fluxo Conversacional** baseado em steps e opções

## Mudanças Implementadas

### PARTE 1: Sistema de Salvamento Individual

#### 1. **AdminPanelScreen** (`lib/features/admin/screens/admin_panel_screen.dart`)

**Removido:**
- Estado local `_localConfig` que mantinha uma cópia da configuração
- Método `_handleSave()` que salvava tudo de uma vez
- Botão "Salvar Tudo" no header do painel
- Import não utilizado de `AppConfig`

**Modificado:**
- Cada tab agora recebe `initialConfig` (do provider) e um callback `onSave`
- O callback `onSave` atualiza o provider e mostra um SnackBar específico para cada seção
- Mensagens de sucesso personalizadas por seção:
  - "Configurações gerais salvas!"
  - "Serviços salvos!"
  - "Informações de contato salvas!"
  - "Configurações do chatbot salvas!"

#### 2. **GeneralTab, ServicesTab, ContactTab, ChatbotTab**

**Convertido de StatelessWidget para StatefulWidget:**
- Mantém estado local `_config` com as alterações não salvas
- Flag `_hasChanges` para controlar quando o botão de salvar deve estar ativo

**Adicionado:**
- Método `_updateConfig()` que atualiza o estado local e marca `_hasChanges = true`
- Método `_handleSave()` que chama o callback `onSave` e reseta `_hasChanges`
- Botão "Salvar Alterações" fixado no rodapé da aba
- Botão desabilitado (esmaecido) quando não há mudanças
- Import de `ThemeConfig` para estilizar o botão

**Interface:**
```dart
Column(
  children: [
    Expanded(child: ListView(...)),  // Conteúdo rolável
    Divider(),
    Padding(
      child: ElevatedButton(
        onPressed: _hasChanges ? _handleSave : null,  // Desabilita se não há mudanças
        ...
      ),
    ),
  ],
)
```

### PARTE 2: Sistema de Fluxo Conversacional do Chatbot

#### 1. **Novos Modelos** (`lib/core/models/app_config.dart`)

**Adicionado `ChatbotFlowOption`:**
```dart
class ChatbotFlowOption {
  final String label;      // Texto do botão de opção
  final String nextId;     // ID do próximo passo
  
  // Métodos: copyWith(), toJson(), fromJson()
}
```

**Adicionado `ChatbotFlowStep`:**
```dart
class ChatbotFlowStep {
  final String id;                          // Identificador único do passo
  final String message;                     // Mensagem do bot
  final List<ChatbotFlowOption> options;    // Opções de resposta (botões)
  
  // Métodos: copyWith(), toJson(), fromJson()
}
```

**Modificado `ChatbotConfig`:**
- **ANTES:** Sistema baseado em FAQ (keywords + answer)
  ```dart
  class ChatbotConfig {
    final String botName;
    final String welcomeMessage;
    final List<ChatbotFAQ> faq;  // ❌ Removido
  }
  ```

- **AGORA:** Sistema baseado em fluxo conversacional
  ```dart
  class ChatbotConfig {
    final String botName;
    final String welcomeMessage;
    final List<ChatbotFlowStep> flow;  // ✅ Novo
  }
  ```

**Removido `ChatbotFAQ`:**
- Antiga classe para sistema FAQ foi mantida mas não é mais usada

**Fluxo Padrão:**
O sistema agora vem com um fluxo conversacional de exemplo com 4 passos:
- `start`: Mensagem inicial com 3 opções (horário, serviços, orçamento)
- `horario`: Informa horário de funcionamento
- `servicos`: Lista os serviços oferecidos
- `orcamento`: Mensagem final sobre orçamento

#### 2. **ChatbotTab Completamente Reescrito** (`lib/features/admin/widgets/chatbot_tab.dart`)

**Recursos do Editor de Fluxo:**

1. **Gerenciamento de Passos:**
   - Botão "Novo Passo" para adicionar steps
   - Cada step tem: ID único, mensagem do bot, lista de opções
   - Step com ID "start" é obrigatório e não pode ser deletado
   - Badge visual verde para identificar o passo inicial

2. **Gerenciamento de Opções:**
   - Botão "+ Add Opção" em cada step
   - Cada opção tem: texto do botão (label) + ID de destino (nextId)
   - Remove opções individualmente
   - Interface visual com ícone de seta (→) mostrando navegação

3. **Interface Visual:**
   - Card amarelo com dica importante sobre ID "start"
   - Campos organizados: ID do Passo (1/3) + Mensagem (2/3)
   - Seção de opções separada com fundo branco
   - Ícone de subdirectory mostrando hierarquia das opções
   - Campos monospace para IDs (melhor leitura)

4. **Métodos de Manipulação:**
   ```dart
   _addFlowStep()                           // Adiciona novo passo
   _removeFlowStep(index)                   // Remove passo
   _updateFlowStep(index, step)             // Atualiza passo
   _addOptionToStep(stepIndex)              // Adiciona opção ao passo
   _removeOption(stepIndex, optIndex)       // Remove opção
   _updateOption(stepIndex, optIndex, opt)  // Atualiza opção
   ```

## Comportamento Final

### Salvamento:
1. ✅ Usuário faz alterações em uma aba específica
2. ✅ Botão "Salvar Alterações" aparece esmaecido no rodapé
3. ✅ Ao fazer qualquer alteração, o botão se habilita
4. ✅ Usuário clica para salvar apenas aquela seção
5. ✅ Após salvar, botão volta ao estado desabilitado
6. ✅ Feedback específico por seção via SnackBar

### Chatbot:
1. ✅ Sistema baseado em fluxo de conversa (não mais FAQ)
2. ✅ Editor visual de steps e opções
3. ✅ Navegação entre passos através de IDs
4. ✅ Opções renderizam como botões para o usuário
5. ✅ Fluxo sempre começa pelo step "start"
6. ✅ Interface intuitiva para criar conversações complexas

## Vantagens

### Salvamento:
1. **Salvamento Granular**: Não perde mudanças de outras seções
2. **Feedback Visual Claro**: Botão esmaecido indica que não há mudanças
3. **Mensagens Específicas**: Cada seção tem confirmação própria
4. **Melhor UX**: Usuário sabe exatamente o que está salvando

### Chatbot:
1. **Fluxibilidade**: Cria conversas ramificadas e complexas
2. **UX Melhor**: Botões são mais intuitivos que digitação livre
3. **Controle Total**: Admin define todo o fluxo da conversa
4. **Escalável**: Fácil adicionar novos passos e opções
5. **Visual**: Interface gráfica para construir o fluxo

## Testado

✅ Código analisa sem erros (`flutter analyze`)
✅ Estrutura de estado correta em cada tab
✅ Botões de salvar individuais funcionando
✅ Sistema de habilitação/desabilitação implementado
✅ Novos modelos de chatbot criados (FlowStep, FlowOption)
✅ Editor de fluxo completo no ChatbotTab
✅ Compatibilidade mantida com sistema de themes

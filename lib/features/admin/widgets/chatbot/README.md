# Componentes do Chatbot Tab

Esta pasta contém os componentes modulares do editor de fluxo de chatbot.

## Estrutura de Arquivos

```
chatbot/
├── chatbot_header.dart         # Cabeçalho com título e botões de ação
├── chatbot_info_banner.dart    # Banner informativo amarelo
├── chatbot_settings.dart       # Configurações gerais (nome do bot)
├── flow_step_card.dart         # Card de um passo individual do fluxo
└── flow_step_option.dart       # Opção dentro de um passo (botão de resposta)
```

## Hierarquia de Componentes

```
ChatbotTab (chatbot_tab.dart)
│
├─ ChatbotHeader
│  ├─ Título + Descrição
│  ├─ Botão "Ver Diagrama" → FlowVisualizerModal
│  └─ Botão "Novo Passo"
│
├─ ChatbotInfoBanner
│  └─ Dica sobre ID "start"
│
├─ ChatbotSettings
│  └─ TextField para nome do bot
│
└─ FlowStepCard (para cada passo)
   ├─ Header
   │  ├─ Badge "INÍCIO" (se isStart)
   │  ├─ Número do passo
   │  ├─ ID do passo
   │  └─ Botões de ação (mover, duplicar, excluir)
   │
   └─ Body
      ├─ Campo ID (se não for start)
      ├─ Campo Mensagem
      └─ FlowStepOption (para cada opção)
         ├─ Campo "Texto do Botão"
         ├─ Dropdown "Próximo Passo"
         └─ Botão excluir
```

## Responsabilidades

### ChatbotHeader
- Exibe título e descrição
- Botão para visualizar diagrama (abre modal fullscreen)
- Botão para adicionar novo passo
- Layout responsivo (mobile vs desktop)

### ChatbotInfoBanner
- Banner informativo estático
- Explica a importância do ID "start"

### ChatbotSettings
- Configurações gerais do chatbot
- Atualmente apenas o nome do bot

### FlowStepCard
- Representa um passo completo do fluxo
- Gerencia ID, mensagem e lista de opções
- Botões de ação: mover, duplicar, excluir
- Badge especial para o passo inicial ("start")

### FlowStepOption
- Representa uma opção de resposta dentro de um passo
- Label do botão + dropdown para próximo passo
- Layout responsivo (vertical no mobile, horizontal no desktop)

## Fluxo de Dados

Todos os componentes são **stateless** e recebem:
- **Dados** via props
- **Callbacks** para notificar mudanças

O estado é gerenciado pelo `ChatbotTab` (pai), que:
1. Recebe callbacks dos componentes filhos
2. Atualiza o `AppConfig`
3. Notifica o pai (`AdminPanel`) via `onSave`

## Benefícios da Componentização

✅ **Manutenibilidade**: Cada arquivo tem < 400 linhas
✅ **Reusabilidade**: Componentes podem ser usados em outros contextos
✅ **Testabilidade**: Fácil de testar isoladamente
✅ **Legibilidade**: Código organizado e autoexplicativo
✅ **Performance**: Widgets pequenos = rebuilds eficientes

## Exemplo de Uso

```dart
// No ChatbotTab
FlowStepCard(
  step: step,
  stepIndex: index,
  isStart: step.id == 'start',
  allSteps: _config.chatbot.flow,
  themeConfig: themeConfig,
  isMobile: isMobile,
  onMessageChanged: (value) => _updateFlowStep(...),
  onIdChanged: (value) => _updateFlowStep(...),
  onAddOption: () => _addOptionToStep(index),
  // ... outros callbacks
);
```

## Próximos Passos

- [ ] Adicionar testes unitários para cada componente
- [ ] Extrair lógica de negócio para um controller/provider
- [ ] Adicionar validação de IDs únicos
- [ ] Implementar drag & drop para reordenar passos

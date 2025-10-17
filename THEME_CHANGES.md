# Mudanças no Tema do App - Preto e Branco

## Resumo das Alterações

O app foi completamente padronizado para usar apenas cores **preto e branco**, removendo todas as cores coloridas (especialmente rosa/pink) que existiam anteriormente.

## Arquivos Modificados

### 1. Configuração Global de Cores
- **Criado**: `lib/config/colors.dart`
  - Define todas as cores do app de forma centralizada
  - Cores primárias: preto, cinza escuro, cinza médio
  - Cores de fundo: branco
  - Cores de texto: preto e cinza
  - Gradientes em tons de preto/cinza

### 2. Tema Principal
- **Modificado**: `lib/theme/app_theme.dart`
  - Atualizado para usar as cores globais
  - Adicionado tema completo do Material Design
  - Estilos de botões, cards, inputs padronizados
  - Sombras e elevações ajustadas

### 3. Aplicação Principal
- **Modificado**: `lib/main.dart`
  - Simplificado para usar o tema completo do AppTheme
  - Removido código duplicado de configuração de tema

### 4. Páginas Atualizadas
- **Modificado**: `lib/home_page.dart`
  - Removidas cores rosa (#FFB6C1) dos gradientes
  - Substituídas por tons de cinza
  - Notificações agora usam fundo preto

- **Modificado**: `lib/produtos_page.dart`
  - Botões e ícones agora usam preto ao invés de verde/teal
  - Mantida consistência visual

- **Modificado**: `lib/profile_page.dart`
  - Removidas todas as cores rosa
  - Botões e bordas agora em preto
  - SnackBars com fundo preto

## Cores Utilizadas

### Principais
- **Preto**: `Colors.black` - Cor primária
- **Cinza Escuro**: `Color(0xFF424242)` - Cor secundária
- **Cinza Médio**: `Color(0xFF757575)` - Cor de destaque

### Fundos
- **Branco**: `Colors.white` - Fundo principal
- **Cinza Claro**: `Colors.grey[50]` - Fundo alternativo

### Textos
- **Preto**: `Colors.black` - Texto principal
- **Cinza**: `Color(0xFF757575)` - Texto secundário
- **Cinza Claro**: `Color(0xFF9E9E9E)` - Texto de apoio

## Benefícios da Padronização

1. **Consistência Visual**: Todo o app agora segue o mesmo padrão de cores
2. **Elegância**: O esquema preto e branco oferece um visual mais elegante e profissional
3. **Legibilidade**: Alto contraste entre preto e branco melhora a legibilidade
4. **Manutenibilidade**: Cores centralizadas facilitam futuras mudanças
5. **Acessibilidade**: Melhor contraste para usuários com deficiências visuais

## Como Usar

Para aplicar cores em novas páginas, importe e use:

```dart
import '../config/colors.dart';

// Usar cores
backgroundColor: AppColors.background,
textColor: AppColors.textPrimary,
buttonColor: AppColors.primary,
```

Ou use o tema completo:
```dart
import '../theme/app_theme.dart';

// Usar estilos predefinidos
style: AppTheme.primaryButtonStyle,
decoration: AppTheme.cardDecoration,
```
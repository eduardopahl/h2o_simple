# H2O Simple - Guia de Testes

Este documento explica como executar e entender os diferentes tipos de testes no projeto H2O Simple.

## 📁 Estrutura de Testes

```
test/
├── widget_test.dart          # Testes principais do app
├── helpers/
│   └── test_helpers.dart     # Utilitários para testes
├── unit/                     # Testes unitários
│   ├── user_profile_test.dart
│   └── hydration_calculator_service_test.dart
├── widget/                   # Testes de widgets
│   ├── water_progress_display_test.dart
│   └── floating_add_buttons_test.dart
└── integration/              # Testes de integração
    └── app_integration_test.dart
```

## 🚀 Como Executar os Testes

### Executar todos os testes:
```bash
flutter test
```

### Executar testes específicos:
```bash
# Testes unitários
flutter test test/unit/

# Testes de widgets
flutter test test/widget/

# Testes de integração
flutter test test/integration/

# Teste específico
flutter test test/unit/user_profile_test.dart
```

### Executar testes com coverage:
```bash
flutter test --coverage
```

### Executar testes em modo verboso:
```bash
flutter test --reporter=expanded
```

## 📊 Tipos de Testes

### 1. **Testes Unitários** (`test/unit/`)
- **Propósito**: Testar lógica de negócio isolada
- **Foco**: Entidades, serviços, calculadoras
- **Exemplos**:
  - `UserProfile`: Criação, validação, cálculos
  - `HydrationCalculatorService`: Cálculos de meta de hidratação

### 2. **Testes de Widget** (`test/widget/`)
- **Propósito**: Testar componentes de UI isoladamente
- **Foco**: Renderização, interações, estados
- **Exemplos**:
  - `WaterProgressDisplay`: Exibição de progresso, animações
  - `FloatingAddButtons`: Expansão, callbacks, navegação

### 3. **Testes de Integração** (`test/integration/`)
- **Propósito**: Testar fluxos completos do usuário
- **Foco**: Navegação, estados globais, performance
- **Exemplos**:
  - Fluxo completo do primeiro uso
  - Navegação entre abas
  - Mudanças de idioma/tema

## 🛠️ Utilitários de Teste

### `TestHelper` (`test/helpers/test_helpers.dart`)
Fornece métodos úteis para criação de widgets de teste:

```dart
// Criar app de teste com localização
TestHelper.createTestApp(
  child: MeuWidget(),
  locale: Locale('pt'),
)

// Criar dados mock
TestHelper.createMockWaterIntake(amount: 250)
TestHelper.createMockWaterIntakes(count: 5)
```

### `TestMatchers`
Matchers customizados para validações específicas:

```dart
expect(find.text('250ml'), TestMatchers.hasWaterAmount(250));
expect(widget, TestMatchers.containsText('Meta atingida'));
```

### `WidgetTesterExtensions`
Extensões para facilitar interações:

```dart
await tester.tapByKey('add_button');
await tester.enterTextByKey('amount_field', '500');
await tester.scrollUntilVisible(find.text('Item'));
```

## ✅ Boas Práticas

### 1. **Estrutura AAA (Arrange-Act-Assert)**
```dart
test('should calculate daily goal correctly', () {
  // Arrange
  const weightKg = 70.0;
  const expectedGoal = 2450;

  // Act
  final result = service.calculateDailyGoal(weightKg);

  // Assert
  expect(result, equals(expectedGoal));
});
```

### 2. **Nomes Descritivos**
- ✅ `should show error message when weight is invalid`
- ❌ `test_weight_validation`

### 3. **Testes Independentes**
- Cada teste deve poder rodar isoladamente
- Use `setUp()` e `tearDown()` quando necessário
- Não dependa da ordem de execução

### 4. **Mock e Stubs**
```dart
// Para testes unitários
final mockRepository = MockWaterIntakeRepository();
when(mockRepository.getTodayIntakes()).thenReturn([]);

// Para testes de widget
final widget = TestHelper.createTestApp(
  overrides: [
    waterIntakeRepositoryProvider.overrideWithValue(mockRepository),
  ],
  child: MyWidget(),
);
```

## 🐛 Debugging de Testes

### Ver estrutura de widgets:
```dart
debugDumpApp(); // No teste
```

### Capturar exceções:
```dart
expect(tester.takeException(), isNull);
```

### Logs de testes:
```dart
print('Current widget tree:');
print(tester.allWidgets.map((w) => w.runtimeType).toList());
```

## 📈 Métricas e Coverage

### Verificar coverage:
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Metas de Coverage:
- **Unitários**: >90%
- **Widgets**: >80%
- **Integração**: >70%

## 🔧 Configuração CI/CD

### GitHub Actions exemplo:
```yaml
- name: Run tests
  run: flutter test --coverage

- name: Upload coverage
  uses: codecov/codecov-action@v1
  with:
    file: coverage/lcov.info
```

## 📝 Adicionando Novos Testes

### Para um novo serviço:
1. Criar arquivo em `test/unit/nome_service_test.dart`
2. Testar todos os métodos públicos
3. Incluir casos extremos e de erro

### Para um novo widget:
1. Criar arquivo em `test/widget/nome_widget_test.dart`
2. Testar renderização e interações
3. Verificar estados diferentes

### Para novo fluxo:
1. Criar arquivo em `test/integration/nome_fluxo_test.dart`
2. Simular jornada completa do usuário
3. Verificar persistência de estado

## 🎯 Checklist de Qualidade

- [ ] Todos os testes passam
- [ ] Coverage >80% no código principal
- [ ] Nomes de teste são descritivos
- [ ] Casos extremos são testados
- [ ] Testes são rápidos (<1s cada)
- [ ] Sem dependências externas em testes unitários
- [ ] Mocks são usados apropriadamente

---

## 📞 Suporte

Para dúvidas sobre testes:
1. Verifique este README
2. Consulte exemplos em arquivos existentes
3. Revise documentação do Flutter Testing
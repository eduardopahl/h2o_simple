// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'H2OSync';

  @override
  String get welcomeTitle => 'Bem-vindo ao H2OSync!';

  @override
  String get letsPersonalize => 'Vamos personalizar sua experiência!';

  @override
  String get helpYouStayHydrated =>
      'Para ajudá-lo a manter uma hidratação saudável, vamos configurar:';

  @override
  String get personalizedGoal => 'Meta personalizada';

  @override
  String get basedOnWeightAge =>
      'Baseada em seu peso, idade e nível de atividade';

  @override
  String get smartReminders => 'Lembretes inteligentes';

  @override
  String get notificationsToKeepHydrated =>
      'Notificações para manter você hidratado';

  @override
  String get tracking => 'Acompanhamento';

  @override
  String get monitorDailyProgress => 'Monitore seu progresso diário';

  @override
  String get personalData => 'Dados pessoais';

  @override
  String get toCalculateIdealGoal =>
      'Para calcular sua meta de hidratação ideal';

  @override
  String get weightKg => 'Peso (kg)';

  @override
  String get kg => 'kg';

  @override
  String get age => 'Idade';

  @override
  String get years => 'anos';

  @override
  String get gender => 'Gênero';

  @override
  String get male => 'Masculino';

  @override
  String get female => 'Feminino';

  @override
  String get activityLevel => 'Nível de atividade';

  @override
  String get sedentary => 'Sedentário';

  @override
  String get light => 'Leve (1-3x/semana)';

  @override
  String get moderate => 'Moderado (3-5x/semana)';

  @override
  String get intense => 'Intenso (6-7x/semana)';

  @override
  String get extreme => 'Extremo (2x/dia)';

  @override
  String get hydrationGoal => 'Meta de hidratação';

  @override
  String get personalizedGoalRecommended => 'Meta personalizada (recomendado)';

  @override
  String perDay(String amount) {
    return '${amount}ml por dia';
  }

  @override
  String get setGoalManually => 'Definir meta manualmente';

  @override
  String get goalMl => 'Meta (ml)';

  @override
  String get ml => 'ml';

  @override
  String get recommendedRange => 'Recomendado: 1500ml - 3000ml';

  @override
  String get hydrationReminders => 'Lembretes de hidratação';

  @override
  String get receiveSmartReminders =>
      'Receba lembretes inteligentes para beber água ao longo do dia';

  @override
  String get customizeSchedule =>
      'Você poderá personalizar os horários e intervalos nas configurações.';

  @override
  String get notNow => 'Agora não';

  @override
  String get allowNotifications => 'Permitir Notificações';

  @override
  String get back => 'Voltar';

  @override
  String get next => 'Próximo';

  @override
  String get finish => 'Finalizar';

  @override
  String get settings => 'Configurações';

  @override
  String get dailyGoal => 'Meta Diária';

  @override
  String get volumeUnit => 'Unidade de Volume';

  @override
  String get darkMode => 'Modo Escuro';

  @override
  String get enabled => 'Ativado';

  @override
  String get disabled => 'Desativado';

  @override
  String get notifications => 'Notificações';

  @override
  String get about => 'Sobre';

  @override
  String get aboutH2OSimple => 'Sobre o H2OSync';

  @override
  String get version => 'Versão';

  @override
  String get data => 'Dados';

  @override
  String get resetData => 'Resetar Dados';

  @override
  String get deleteAllSavedData => 'Apagar todos os dados salvos';

  @override
  String get selectUnit => 'Selecionar Unidade';

  @override
  String get milliliters => 'Mililitros';

  @override
  String get fluidOunces => 'Onças Fluidas';

  @override
  String get symbol => 'Símbolo';

  @override
  String get cancel => 'Cancelar';

  @override
  String unitChangedTo(String unit) {
    return 'Unidade alterada para $unit';
  }

  @override
  String get changeDailyGoal => 'Alterar Meta Diária';

  @override
  String get recommendedDaily => 'Recomendado: 2000ml - 2500ml por dia';

  @override
  String get save => 'Salvar';

  @override
  String goalChangedTo(int amount) {
    return 'Meta alterada para ${amount}ml';
  }

  @override
  String get confirmResetData => 'Resetar Dados';

  @override
  String get resetWarningMessage =>
      'Tem certeza que deseja resetar todos os dados? Esta ação não pode ser desfeita.';

  @override
  String get reset => 'Resetar';

  @override
  String get dataResetSuccessfully => 'Dados resetados com sucesso';

  @override
  String get customAmount => 'Quantidade Personalizada';

  @override
  String get enterValidAmount => 'Digite uma quantidade válida';

  @override
  String get enterValueBetween => 'Digite um valor entre 1 e 9999 ml';

  @override
  String get add => 'Adicionar';

  @override
  String get congratulations => '🎉 Parabéns!';

  @override
  String get goalAchievedMessage =>
      'Você alcançou sua meta de hidratação diária!\\n\\nSeu corpo agradece! 💧';

  @override
  String get continueText => 'Continuar';

  @override
  String get prepositionOf => 'de';

  @override
  String remaining(int amount) {
    return 'Faltam ${amount}ml';
  }

  @override
  String get extra => 'extra';

  @override
  String get custom => 'Personalizado';

  @override
  String get lbs => 'lbs';

  @override
  String get flOz => 'fl oz';

  @override
  String get history => 'Histórico';

  @override
  String get daily => 'Diário';

  @override
  String get notificationSettings => 'Configurações de Notificação';

  @override
  String get intervalBetweenNotifications => 'Intervalo entre notificações:';

  @override
  String get everyHour => 'A cada hora';

  @override
  String everyXHours(int hours) {
    return 'A cada $hours horas';
  }

  @override
  String get startTime => 'Horário de início:';

  @override
  String get endTime => 'Horário de fim:';

  @override
  String get sendTestNotification => 'Enviar Notificação de Teste';

  @override
  String get close => 'Fechar';

  @override
  String get averagePerRecord => 'Média por registro:';

  @override
  String get h2oSimpleDescription =>
      'App para acompanhar seu consumo diário de água e manter uma hidratação saudável.';

  @override
  String get developedWithFlutter => 'Desenvolvido com Flutter 💙';

  @override
  String get selectLanguage => 'Selecionar Idioma';

  @override
  String get languageChanged => 'Idioma alterado com sucesso';

  @override
  String get resetDataConfirmation =>
      'Tem certeza que deseja resetar todos os dados? Esta ação não pode ser desfeita.';

  @override
  String get loading => 'Carregando H2OSync...';

  @override
  String get waterReminders => 'Lembretes para beber água';

  @override
  String get notificationPermissionDenied =>
      'Permissão para notificações negada';

  @override
  String get aboutApp => 'Sobre o App';

  @override
  String get appInfo => 'Informações e créditos';

  @override
  String get resetAllData => 'Resetar Dados';

  @override
  String get appVersion => 'H2OSync v1.0.0';

  @override
  String get lightActivity => 'Leve (1-3x/semana)';

  @override
  String get moderateActivity => 'Moderado (3-5x/semana)';

  @override
  String get intenseActivity => 'Intenso (6-7x/semana)';

  @override
  String get extremeActivity => 'Extremo (2x/dia)';

  @override
  String get customGoalRecommended => 'Meta personalizada (recomendado)';

  @override
  String mlPerDay(int amount) {
    return '${amount}ml por dia';
  }

  @override
  String get tryAgain => 'Tentar novamente';

  @override
  String errorLoadingData(String error) {
    return 'Erro ao carregar dados: $error';
  }

  @override
  String get welcomeToH2O => 'Bem-vindo ao H2OSync!';

  @override
  String get noRecordsThisDay => 'Nenhum registro neste dia';

  @override
  String get dataResetSuccess => 'Dados resetados com sucesso';

  @override
  String get invalidAmount => 'Por favor, insira uma quantidade válida';

  @override
  String get amountTooSmall => 'A quantidade deve ser maior que 0ml';

  @override
  String get notificationsEnabled => 'Notificações ativadas com sucesso';

  @override
  String get notificationsNotAvailable =>
      'Notificações não estão disponíveis neste dispositivo';

  @override
  String get errorEnablingNotifications => 'Erro ao ativar notificações';

  @override
  String setupCompleteWithGoal(int goal) {
    return '✅ Configuração concluída! Meta: ${goal}ml/dia';
  }

  @override
  String setupCompleteManual(int goal) {
    return '⚙️ Configuração concluída! Meta: ${goal}ml/dia';
  }

  @override
  String errorSavingSettings(String error) {
    return 'Erro ao salvar configurações: $error';
  }

  @override
  String confirmDelete(String itemName) {
    return 'Deseja realmente excluir $itemName?';
  }

  @override
  String get errorLoadingHydrationData =>
      'Erro ao carregar dados de hidratação';

  @override
  String get errorAddingWaterIntake => 'Erro ao adicionar consumo de água';

  @override
  String get errorRemovingWaterIntake => 'Erro ao remover consumo de água';

  @override
  String get errorCheckingNotifications => 'Erro ao verificar notificações';

  @override
  String get confirmDeletion => 'Confirmar exclusão';

  @override
  String get delete => 'Excluir';

  @override
  String get confirmReset => 'Confirmar reset';

  @override
  String get resetConfirmMessage =>
      'Esta ação irá apagar permanentemente todos os dados. Deseja continuar?';

  @override
  String get today => 'Hoje';

  @override
  String get day => 'Dia';

  @override
  String get week => 'Semana';

  @override
  String get month => 'Mês';

  @override
  String get goalAchieved => '🎉 Meta atingida!';

  @override
  String get goalCompleted => '🎉 Meta Alcançada!';

  @override
  String goalCompletedMessage(int amount) {
    return 'Parabéns! Você atingiu sua meta diária. Continue mantendo essa excelente hidratação!';
  }

  @override
  String get weeklyAchievement => '🗓️ Sucesso Semanal!';

  @override
  String weeklyAchievementMessage(int days) {
    return 'Incrível! Você completou sua meta de hidratação $days dias esta semana. Você está criando um hábito saudável!';
  }

  @override
  String get streakMilestone => '🔥 Marco de Sequência!';

  @override
  String streakMilestoneMessage(int days) {
    return 'Incrível! Você manteve sua sequência de hidratação por $days dias consecutivos. Você é um campeão da hidratação!';
  }

  @override
  String get adLabel => 'Anúncio';

  @override
  String get smartHydrationBottle => 'Garrafa Inteligente HydroTech';

  @override
  String get hydrationSupplements => 'Suplementos Hidratação+';

  @override
  String get premiumFitWaterApp => 'App Premium FitWater';

  @override
  String get hydrationProducts => 'Produtos para Hidratação';

  @override
  String get monitorAutomatically => 'Monitore automaticamente sem esforço';

  @override
  String get naturalElectrolytes => 'Eletrólitos naturais para o dia todo';

  @override
  String get advancedFeaturesNoAds => 'Recursos avançados sem anúncios';

  @override
  String get improveDailyHydration => 'Melhore sua hidratação diária';

  @override
  String get totalConsumed => 'Total consumido:';

  @override
  String get todayHydration => 'Hidratação de hoje';

  @override
  String ofTarget(int target) {
    return 'de ${target}ml';
  }

  @override
  String get confirm => 'Confirmar';

  @override
  String get amountMl => 'Quantidade (ml)';

  @override
  String get customizeNotificationSettings =>
      'Você poderá personalizar os horários e intervalos nas configurações.';

  @override
  String get welcomeToH2OSimple => 'Bem-vindo ao H2OSync!';

  @override
  String get letsCustomizeExperience => 'Vamos personalizar sua experiência!';

  @override
  String get helpMaintainHealthyHydration =>
      'Para ajudá-lo a manter uma hidratação saudável, vamos configurar:';

  @override
  String get basedOnWeightAgeActivity =>
      'Baseada em seu peso, idade e nível de atividade';

  @override
  String get intelligentReminders => 'Lembretes inteligentes';

  @override
  String get ageYears => 'Idade';

  @override
  String get receiveIntelligentReminders =>
      'Receba lembretes inteligentes para beber água ao longo do dia';

  @override
  String get goalMlLabel => 'Meta (ml)';

  @override
  String get recommendedDailyGoal => 'Recomendado: 2000ml - 2500ml por dia';

  @override
  String get adultRecommendation =>
      'A meta recomendada para adultos é de 2-3 litros por dia.';

  @override
  String get confirmDeleteWaterRecord =>
      'Deseja realmente excluir este registro de consumo de água?';

  @override
  String get testNotificationTitle => 'H2OSync - Teste';

  @override
  String get testNotificationBody =>
      '💧 Esta é uma notificação de teste! Suas notificações estão funcionando.';

  @override
  String get everyHourInterval => 'A cada hora';

  @override
  String everyXHoursInterval(int hours) {
    return 'A cada $hours horas';
  }

  @override
  String fromToSchedule(String startTime, String endTime) {
    return 'Das $startTime às $endTime';
  }

  @override
  String get yesterday => 'Ontem';

  @override
  String get monShort => 'Seg';

  @override
  String get tueShort => 'Ter';

  @override
  String get wedShort => 'Qua';

  @override
  String get thuShort => 'Qui';

  @override
  String get friShort => 'Sex';

  @override
  String get satShort => 'Sáb';

  @override
  String get sunShort => 'Dom';

  @override
  String get dailyConsumption => 'Consumo do Dia';

  @override
  String get weeklyConsumption => 'Consumo Semanal';

  @override
  String get monthlyConsumption => 'Consumo Mensal';

  @override
  String get weekLabel => 'Semana';

  @override
  String get daysLabel => 'Dias';

  @override
  String get mlUnit => 'ml';

  @override
  String extraAmount(int amount) {
    return '+${amount}ml extra';
  }

  @override
  String get removeAds => 'Remover Anúncios';

  @override
  String get premiumFeatures => 'Recursos Premium';

  @override
  String get removeAdsDescription =>
      'Remova todos os anúncios para uma experiência mais fluida';

  @override
  String get purchaseRemoveAds => 'Comprar - Remover Anúncios';

  @override
  String get removeAdsForever =>
      'Remova todos os anúncios permanentemente por apenas:';

  @override
  String get buyNow => 'Comprar Agora';

  @override
  String get restorePurchases => 'Restaurar Compras';

  @override
  String get purchaseSuccess =>
      'Compra realizada com sucesso! Os anúncios foram removidos.';

  @override
  String get purchaseError => 'Erro ao processar a compra. Tente novamente.';

  @override
  String get restoreSuccess => 'Compras restauradas com sucesso!';

  @override
  String get restoreError => 'Nenhuma compra encontrada para restaurar.';

  @override
  String get purchaseNotAvailable => 'Compras não disponíveis no momento.';

  @override
  String get premiumUser => 'Usuário Premium';

  @override
  String get thanksForSupport => 'Obrigado pelo seu apoio! 💙';

  @override
  String get independentDeveloper => 'Desenvolvedor Independente';

  @override
  String get supportMessage =>
      'Sua compra me ajuda muito a continuar desenvolvendo e melhorando o app! 🙏\n\nComo desenvolvedor independente, cada apoio faz a diferença para manter o H2OSync sempre atualizado.';

  @override
  String get oneTimePayment => 'Pagamento único';

  @override
  String get purchaseThankYou =>
      'Obrigado pelo apoio! Anúncios removidos com sucesso! 🎉';

  @override
  String get processingPurchase => 'Processando compra...';

  @override
  String get dataResetError => 'Erro ao resetar dados. Tente novamente.';
}

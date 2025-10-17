import 'package:flutter/material.dart';
// Firebase removido temporariamente devido a problemas de permissão
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
import 'login_page.dart';
import 'cadastro_page.dart';
import 'forgot_password_page.dart';
import 'sobre_atelie_page.dart';
import 'home_page.dart';
import 'localizacao_page.dart';
import 'agradecimento_page.dart';
import 'encomendas_page.dart';
import 'bottom_navigation.dart';
import 'produtos_page.dart';
import 'feedbacks_page.dart';
import 'agendamentos_page.dart';
import 'chat_page.dart';
import 'user_service.dart';
import 'notificacoes_page.dart';
import 'enviar_feedback_page.dart';
import 'theme/app_theme.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(); // Removido temporariamente
  runApp(AteliePanoFinoApp());
}


class AteliePanoFinoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ateliê Pano Fino',  // Título do app
      theme: AppTheme.theme,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/cadastro': (context) => CadastroPage(),
        '/forgot-password': (context) => ForgotPasswordPage(),
        '/sobre-atelie': (context) => SobreAteliePage(),
        '/home': (context) => MainNavigation(initialIndex: 0),
        '/localizacao': (context) => MainNavigation(initialIndex: 3),
        '/agradecimento': (context) => AgradecimentoPage(),
        '/encomendas': (context) => MainNavigation(initialIndex: 1),
        '/produtos': (context) => ProdutosPage(),

        '/feedbacks': (context) => FeedbacksPage(),
        '/agendamentos': (context) => MainNavigation(initialIndex: 2),
        '/chat': (context) => MainNavigation(initialIndex: 3),
        '/notificacoes': (context) => NotificacoesPage(),
        '/enviar-feedback': (context) => EnviarFeedbackPage(),
      },
      debugShowCheckedModeBanner: false,  // Remove a faixa de debug
    );
  }
}

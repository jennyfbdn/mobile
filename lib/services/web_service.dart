import 'package:url_launcher/url_launcher.dart';

class WebService {
  static const String _webUrl = 'http://localhost:5173'; // URL do site web

  // Abrir site web
  static Future<void> openWebsite() async {
    final Uri url = Uri.parse(_webUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Não foi possível abrir o site: $_webUrl';
    }
  }

  // Abrir página específica do site
  static Future<void> openWebPage(String page) async {
    final Uri url = Uri.parse('$_webUrl/$page');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Não foi possível abrir a página: $page';
    }
  }

  // Abrir login do admin no site
  static Future<void> openAdminLogin() async {
    await openWebPage('admin-login');
  }

  // Abrir catálogo de produtos no site
  static Future<void> openProductCatalog() async {
    await openWebPage('produtos');
  }

  // Abrir contato no site
  static Future<void> openContact() async {
    await openWebPage('contato');
  }
}
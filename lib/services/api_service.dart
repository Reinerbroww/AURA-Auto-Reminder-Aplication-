import 'package:url_launcher/url_launcher.dart';

class ApiService {
  static bool isYouTube(String url) =>
      url.contains('youtube.com') || url.contains('youtu.be');

  static bool isZoom(String url) =>
      url.contains('zoom.us') || url.contains('zoom.com');

  static Future<void> bukaLink(String url) async {
    final uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Tidak bisa membuka link: $url');
    }
  }
}

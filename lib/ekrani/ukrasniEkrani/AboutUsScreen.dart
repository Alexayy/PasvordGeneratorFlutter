import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('O nama'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'PupinCrypt',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Šta je PupinCrypt?',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'PupinCrypt je seminarski rad iz oblasti generatora lozinki za kurs Mobilnih tehnologija. Ova aplikacija je vaš pouzdani partner u generisanju snažnih lozinki i njihovom efikasnom upravljanju.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            _buildSeparator(),
            const Text(
              'Ovaj rad je izveo:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Aleksa Cakić, apsolvent Tehničkog fakulteta u Zrenjaninu, Mihajlo Pupin. Ovaj projekat je savršen spoj tehničkog znanja i kreativnosti, sa UI i UX dizajnom koji drži stvari jednostavnim, ali efektivnim, poštujući psihološke principe čitljivosti i interakcije.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            _buildSeparator(),
            const Text(
              'Tehnologije koje su korišćene:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              '- Flutter & Dart\n- Firebase/Firestore\n- TailorBrands za logo i logotip\n- MaterialUI za UI/UX',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            _buildSeparator(),
            const Text(
              'O Aleksiju:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Često ga kolege opisuju kao C4 bombu, a ove 4 \'C\' su: Charismatic, Curious, Creative and Charming. Na srpskom, to se može prevesti samo kao "savrsena osoba" (uz osmeh na licu, naravno). Pored toga što je tech-entuzijasta, Aleksa je i strastveni muzičar. Sviranje gitare i bas gitare, kao i stvaranje muzike, su njegove velike ljubavi. U slobodno vreme, Aleksa svira i producira heavy metal, punk i post-rock. A kada nije zauzet muzikom, voli da se bavi animacijom i kreiranjem igara, kao i audio programiranjem.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            _buildSeparator(),
            const Text(
              'Lični portfolio:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8.0),
            const SizedBox(height: 8.0),
            _buildPortfolioItem(Icons.video_library, 'YouTube: @Lekizza'),
            _buildPortfolioItem(Icons.code, 'GitHub: Alexayy'),
            _buildPortfolioItem(Icons.layers, 'GitLab: Alexayy'),
            _buildPortfolioItem(Icons.gamepad, 'Itch.io: askaelfrost.itch.io'),
            _buildPortfolioItem(Icons.music_note, 'Soundcloud: Lorelei Frost '),
            _buildPortfolioItem(Icons.work, 'LinkedIn: aleksa-cakic-b8a426184'),
            _buildPortfolioItem(Icons.chat, 'Discord: #slaanesh2896'),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolioItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 20.0),
          const SizedBox(width: 8.0),
          Text(text, style: const TextStyle(fontSize: 16.0)),
        ],
      ),
    );
  }

  Widget _buildSeparator() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      height: 1.0,
      width: double.infinity,
      color: Colors.grey.shade300,
    );
  }
}

import 'package:flutter/material.dart';

void main() => runApp(const Pelis420HDApp());

class Pelis420HDApp extends StatelessWidget {
  const Pelis420HDApp({super.key});

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFF101014);
    const accent = Color(0xFFE50914);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pelis420 HD',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: accent,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pelis420 HD',
            style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            tooltip: 'Buscar',
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            tooltip: 'Perfil',
            onPressed: () {},
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          Container(
            height: 300,
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF48202A), Color(0xFF17171D)],
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('TU PRÓXIMA HISTORIA EMPIEZA AQUÍ',
                    style: TextStyle(letterSpacing: 1.2, fontSize: 11)),
                SizedBox(height: 8),
                Text('Pelis420 HD',
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Películas, series y anime en un solo lugar.'),
                SizedBox(height: 16),
                _FeaturePill(),
              ],
            ),
          ),
          const _Shelf(title: 'Seguir viendo'),
          const _Shelf(title: 'Películas populares'),
          const _Shelf(title: 'Series'),
          const _Shelf(title: 'Anime'),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Inicio'),
          NavigationDestination(icon: Icon(Icons.explore_outlined), label: 'Explorar'),
          NavigationDestination(icon: Icon(Icons.download_outlined), label: 'Descargas'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Mi lista'),
        ],
        selectedIndex: 0,
        onDestinationSelected: (_) {},
      ),
    );
  }
}

class _FeaturePill extends StatelessWidget {
  const _FeaturePill();

  @override
  Widget build(BuildContext context) => FilledButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.play_arrow),
        label: const Text('Explorar catálogo'),
      );
}

class _Shelf extends StatelessWidget {
  const _Shelf({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 16, bottom: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            SizedBox(
              height: 130,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) => Container(
                  width: 190,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [Colors.blueGrey.shade800, Colors.blueGrey.shade900],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.all(12),
                  child: Text('Título ${index + 1}'),
                ),
              ),
            ),
          ],
        ),
      );
}

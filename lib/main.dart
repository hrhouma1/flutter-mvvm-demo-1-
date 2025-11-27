import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/home_page.dart';
import 'viewmodels/home_view_model.dart';
import 'data/article_repository.dart';

/// Point d'entrée de l'application
/// On configure ici le Provider (système de gestion d'état)
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider permet d'injecter plusieurs dépendances
    return MultiProvider(
      providers: [
        // On crée le Repository (accès aux données)
        Provider<ArticleRepository>(
          create: (_) => ArticleRepository(),
        ),
        
        // On crée le ViewModel et on lui donne le Repository
        ChangeNotifierProvider<HomeViewModel>(
          create: (context) => HomeViewModel(
            repository: context.read<ArticleRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'MVVM Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}


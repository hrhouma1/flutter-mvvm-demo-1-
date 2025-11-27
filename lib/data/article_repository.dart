import '../models/article.dart';

/// REPOSITORY : Responsable de l'accès aux données
/// 
/// C'est ici qu'on irait chercher les données :
/// - API REST (HTTP)
/// - Base de données locale (SQLite, Hive)
/// - Cache, fichiers, etc.
/// 
/// Pour la démo, on simule avec des données en dur.
class ArticleRepository {
  
  /// Simule un appel API qui prend du temps
  Future<List<Article>> getArticles() async {
    // Simulation d'un délai réseau (1.5 secondes)
    await Future.delayed(const Duration(milliseconds: 1500));

    // Données simulées (normalement, on ferait un http.get(...))
    return [
      Article(
        id: 1,
        titre: 'Introduction à Flutter',
        description: 'Flutter est un framework open-source créé par Google pour créer des applications mobiles, web et desktop.',
        auteur: 'Marie Dupont',
        datePublication: DateTime(2024, 1, 15),
      ),
      Article(
        id: 2,
        titre: 'Qu\'est-ce que MVVM ?',
        description: 'MVVM (Model-View-ViewModel) est un pattern architectural qui sépare l\'interface utilisateur de la logique métier.',
        auteur: 'Jean Martin',
        datePublication: DateTime(2024, 2, 20),
      ),
      Article(
        id: 3,
        titre: 'Provider vs Bloc',
        description: 'Comparaison entre deux solutions populaires de gestion d\'état en Flutter : Provider et Bloc.',
        auteur: 'Sophie Leroy',
        datePublication: DateTime(2024, 3, 10),
      ),
      Article(
        id: 4,
        titre: 'Les widgets en Flutter',
        description: 'Tout en Flutter est un widget : découvrez les widgets StatelessWidget et StatefulWidget.',
        auteur: 'Pierre Bernard',
        datePublication: DateTime(2024, 4, 5),
      ),
      Article(
        id: 5,
        titre: 'Navigation et routes',
        description: 'Apprenez à naviguer entre les écrans avec Navigator et les routes nommées.',
        auteur: 'Marie Dupont',
        datePublication: DateTime(2024, 5, 18),
      ),
    ];
  }

  /// Simule la récupération d'un article par son ID
  Future<Article?> getArticleById(int id) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    final articles = await getArticles();
    try {
      return articles.firstWhere((article) => article.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Simule l'ajout d'un nouvel article
  Future<bool> addArticle(Article article) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    // Dans la vraie vie : http.post(...)
    return true;
  }
}


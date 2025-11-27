import 'package:flutter/foundation.dart';
import '../models/article.dart';
import '../data/article_repository.dart';

/// VIEWMODEL : Le "cerveau" de l'écran HomePage
/// 
/// Responsabilités :
/// 1. Contenir l'ÉTAT (liste d'articles, chargement, erreurs)
/// 2. Contenir la LOGIQUE (que faire quand on clique, comment charger)
/// 3. Communiquer avec le MODEL (via le Repository)
/// 4. Notifier la VIEW quand l'état change (via notifyListeners)
/// 
/// La VIEW ne fait QUE afficher et appeler des méthodes du ViewModel.
class HomeViewModel extends ChangeNotifier {
  final ArticleRepository repository;

  // ========== ÉTAT (privé) ==========
  List<Article> _articles = [];
  bool _isLoading = false;
  String? _errorMessage;

  // ========== GETTERS (publics pour la View) ==========
  
  /// Liste des articles à afficher
  List<Article> get articles => _articles;
  
  /// Indique si on est en train de charger
  bool get isLoading => _isLoading;
  
  /// Message d'erreur s'il y en a un
  String? get errorMessage => _errorMessage;
  
  /// Indique si on a des articles
  bool get hasArticles => _articles.isNotEmpty;

  // ========== CONSTRUCTEUR ==========
  
  HomeViewModel({required this.repository}) {
    // Au démarrage, on charge automatiquement les articles
    loadArticles();
  }

  // ========== MÉTHODES (logique appelée par la View) ==========

  /// Charge la liste d'articles depuis le Repository
  Future<void> loadArticles() async {
    // 1. On met isLoading à true
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Prévient la View de se reconstruire

    try {
      // 2. On demande les données au Repository
      _articles = await repository.getArticles();
      
      // 3. Succès : on a les articles
      _errorMessage = null;
    } catch (e) {
      // 4. En cas d'erreur, on stocke le message
      _errorMessage = 'Erreur lors du chargement : $e';
      _articles = [];
    } finally {
      // 5. On arrête le chargement
      _isLoading = false;
      notifyListeners(); // Prévient la View de se reconstruire
    }
  }

  /// Rafraîchit la liste (pull-to-refresh)
  Future<void> refresh() async {
    await loadArticles();
  }

  /// Filtre les articles par auteur (exemple de logique métier)
  List<Article> getArticlesByAuthor(String auteur) {
    return _articles
        .where((article) => article.auteur.toLowerCase().contains(auteur.toLowerCase()))
        .toList();
  }

  /// Compte le nombre d'articles par auteur
  Map<String, int> getArticleCountByAuthor() {
    final Map<String, int> counts = {};
    for (var article in _articles) {
      counts[article.auteur] = (counts[article.auteur] ?? 0) + 1;
    }
    return counts;
  }

  /// Simule l'ajout d'un article
  Future<void> addArticle(Article article) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await repository.addArticle(article);
      if (success) {
        // On recharge la liste après ajout
        await loadArticles();
      }
    } catch (e) {
      _errorMessage = 'Erreur lors de l\'ajout : $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Efface le message d'erreur
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}


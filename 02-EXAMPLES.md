# 📝 Exemples de code MVVM

Ce fichier contient des **exemples pratiques** pour te montrer comment étendre cette application.

---

## 1. Ajouter un nouveau champ à Article

### Étape 1 : Modifier le Model

**Fichier : `lib/models/article.dart`**

```dart
class Article {
  final int id;
  final String titre;
  final String description;
  final String auteur;
  final DateTime datePublication;
  final int nombreLikes; // ✨ NOUVEAU CHAMP

  Article({
    required this.id,
    required this.titre,
    required this.description,
    required this.auteur,
    required this.datePublication,
    required this.nombreLikes, // ✨ AJOUT
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] as int,
      titre: json['titre'] as String,
      description: json['description'] as String,
      auteur: json['auteur'] as String,
      datePublication: DateTime.parse(json['datePublication'] as String),
      nombreLikes: json['nombreLikes'] as int, // ✨ AJOUT
    );
  }
}
```

### Étape 2 : Mettre à jour le Repository

**Fichier : `lib/data/article_repository.dart`**

```dart
Article(
  id: 1,
  titre: 'Introduction à Flutter',
  description: '...',
  auteur: 'Marie Dupont',
  datePublication: DateTime(2024, 1, 15),
  nombreLikes: 42, // ✨ AJOUT
),
```

### Étape 3 : Afficher dans la View

**Fichier : `lib/ui/home_page.dart`**

Dans `_ArticleCard`, ajoute :

```dart
// Après le Row avec l'auteur et la date
Row(
  children: [
    Icon(Icons.favorite, size: 16, color: Colors.red),
    const SizedBox(width: 4),
    Text('${article.nombreLikes} likes'),
  ],
),
```

---

## 2. Ajouter un filtre de recherche

### Étape 1 : Ajouter l'état dans le ViewModel

**Fichier : `lib/viewmodels/home_view_model.dart`**

```dart
class HomeViewModel extends ChangeNotifier {
  // ... code existant ...
  
  String _searchQuery = '';
  
  String get searchQuery => _searchQuery;
  
  List<Article> get filteredArticles {
    if (_searchQuery.isEmpty) {
      return _articles;
    }
    return _articles.where((article) {
      return article.titre.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             article.description.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }
  
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
  
  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }
}
```

### Étape 2 : Ajouter le champ de recherche dans la View

**Fichier : `lib/ui/home_page.dart`**

```dart
return Scaffold(
  appBar: AppBar(
    title: const Text('📚 Articles MVVM'),
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          onChanged: viewModel.updateSearchQuery,
          decoration: InputDecoration(
            hintText: 'Rechercher...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: viewModel.searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: viewModel.clearSearch,
                  )
                : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    ),
  ),
  body: _buildBody(context, viewModel),
  // ...
);
```

### Étape 3 : Utiliser la liste filtrée

Dans `_buildBody`, remplace :

```dart
itemCount: viewModel.articles.length,
```

Par :

```dart
itemCount: viewModel.filteredArticles.length,
```

Et :

```dart
final article = viewModel.articles[index];
```

Par :

```dart
final article = viewModel.filteredArticles[index];
```

---

## 3. Ajouter un système de favoris

### Étape 1 : Ajouter l'état dans le ViewModel

**Fichier : `lib/viewmodels/home_view_model.dart`**

```dart
class HomeViewModel extends ChangeNotifier {
  // ... code existant ...
  
  final Set<int> _favoriteIds = {};
  
  Set<int> get favoriteIds => _favoriteIds;
  
  bool isFavorite(int articleId) {
    return _favoriteIds.contains(articleId);
  }
  
  void toggleFavorite(int articleId) {
    if (_favoriteIds.contains(articleId)) {
      _favoriteIds.remove(articleId);
    } else {
      _favoriteIds.add(articleId);
    }
    notifyListeners();
  }
  
  List<Article> get favoriteArticles {
    return _articles.where((article) => _favoriteIds.contains(article.id)).toList();
  }
}
```

### Étape 2 : Ajouter le bouton dans la View

**Fichier : `lib/ui/home_page.dart`**

Dans `_ArticleCard`, modifie le `InkWell` :

```dart
child: Stack(
  children: [
    Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        // ... contenu existant ...
      ),
    ),
    // ✨ NOUVEAU : Bouton favori
    Positioned(
      top: 8,
      right: 8,
      child: Consumer<HomeViewModel>(
        builder: (context, vm, _) {
          final isFav = vm.isFavorite(article.id);
          return IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? Colors.red : Colors.grey,
            ),
            onPressed: () => vm.toggleFavorite(article.id),
          );
        },
      ),
    ),
  ],
),
```

---

## 4. Ajouter un tri (par date, par auteur...)

### Dans le ViewModel

**Fichier : `lib/viewmodels/home_view_model.dart`**

```dart
enum SortType { date, titre, auteur }

class HomeViewModel extends ChangeNotifier {
  // ... code existant ...
  
  SortType _sortType = SortType.date;
  
  SortType get sortType => _sortType;
  
  List<Article> get sortedArticles {
    final list = List<Article>.from(_articles);
    
    switch (_sortType) {
      case SortType.date:
        list.sort((a, b) => b.datePublication.compareTo(a.datePublication));
        break;
      case SortType.titre:
        list.sort((a, b) => a.titre.compareTo(b.titre));
        break;
      case SortType.auteur:
        list.sort((a, b) => a.auteur.compareTo(b.auteur));
        break;
    }
    
    return list;
  }
  
  void changeSortType(SortType type) {
    _sortType = type;
    notifyListeners();
  }
}
```

### Dans la View

**Fichier : `lib/ui/home_page.dart`**

```dart
actions: [
  PopupMenuButton<SortType>(
    icon: const Icon(Icons.sort),
    onSelected: viewModel.changeSortType,
    itemBuilder: (context) => [
      const PopupMenuItem(
        value: SortType.date,
        child: Text('Trier par date'),
      ),
      const PopupMenuItem(
        value: SortType.titre,
        child: Text('Trier par titre'),
      ),
      const PopupMenuItem(
        value: SortType.auteur,
        child: Text('Trier par auteur'),
      ),
    ],
  ),
],
```

Et dans le ListView :

```dart
itemCount: viewModel.sortedArticles.length,
itemBuilder: (context, index) {
  final article = viewModel.sortedArticles[index];
  return _ArticleCard(article: article);
},
```

---

## 5. Ajouter une vraie API REST

### Fichier : `lib/data/article_repository.dart`

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class ArticleRepository {
  final String baseUrl = 'https://api.example.com';
  
  Future<List<Article>> getArticles() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/articles'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Article.fromJson(json)).toList();
      } else {
        throw Exception('Erreur HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur réseau : $e');
    }
  }
  
  Future<bool> addArticle(Article article) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/articles'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(article.toJson()),
      );
      
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }
}
```

---

## 6. Ajouter une base de données locale (Hive)

### Étape 1 : Ajouter les dépendances

**Fichier : `pubspec.yaml`**

```yaml
dependencies:
  hive: ^2.2.3
  hive_flutter: ^1.1.0

dev_dependencies:
  hive_generator: ^2.0.1
  build_runner: ^2.4.6
```

### Étape 2 : Préparer le Model

**Fichier : `lib/models/article.dart`**

```dart
import 'package:hive/hive.dart';

part 'article.g.dart'; // Fichier généré

@HiveType(typeId: 0)
class Article {
  @HiveField(0)
  final int id;
  
  @HiveField(1)
  final String titre;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final String auteur;
  
  @HiveField(4)
  final DateTime datePublication;
  
  // ... reste du code
}
```

### Étape 3 : Générer le code

```bash
flutter packages pub run build_runner build
```

### Étape 4 : Initialiser Hive

**Fichier : `lib/main.dart`**

```dart
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  Hive.registerAdapter(ArticleAdapter());
  await Hive.openBox<Article>('articles');
  
  runApp(const MyApp());
}
```

### Étape 5 : Utiliser Hive dans le Repository

**Fichier : `lib/data/article_repository.dart`**

```dart
class ArticleRepository {
  final Box<Article> _box = Hive.box<Article>('articles');
  
  Future<List<Article>> getArticles() async {
    if (_box.isEmpty) {
      // Charger depuis l'API et sauvegarder
      final articles = await _fetchFromAPI();
      for (var article in articles) {
        await _box.put(article.id, article);
      }
      return articles;
    } else {
      // Retourner depuis le cache local
      return _box.values.toList();
    }
  }
  
  Future<bool> addArticle(Article article) async {
    await _box.put(article.id, article);
    return true;
  }
  
  Future<void> clearCache() async {
    await _box.clear();
  }
}
```

---

## 7. Ajouter des tests unitaires

### Fichier : `test/home_view_model_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_exemplemvvm/viewmodels/home_view_model.dart';
import 'package:mobile_exemplemvvm/data/article_repository.dart';

void main() {
  group('HomeViewModel', () {
    late HomeViewModel viewModel;
    late ArticleRepository repository;
    
    setUp(() {
      repository = ArticleRepository();
      viewModel = HomeViewModel(repository: repository);
    });
    
    test('initial state est loading', () {
      expect(viewModel.isLoading, true);
    });
    
    test('loadArticles charge 5 articles', () async {
      await viewModel.loadArticles();
      
      expect(viewModel.articles.length, 5);
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, null);
    });
    
    test('getArticlesByAuthor filtre correctement', () async {
      await viewModel.loadArticles();
      
      final articles = viewModel.getArticlesByAuthor('Marie Dupont');
      
      expect(articles.length, 2);
      expect(articles.every((a) => a.auteur == 'Marie Dupont'), true);
    });
  });
}
```

### Lancer les tests

```bash
flutter test
```

---

## 8. Ressources

-  [README.md](README.md)
-  [ARCHITECTURE.md](ARCHITECTURE.md)
-  [QUICKSTART.md](QUICKSTART.md)

---

Bon codage !


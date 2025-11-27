#  Architecture MVVM - Guide détaillé

## Vue d'ensemble

Ce document explique en détail comment l'architecture MVVM est implémentée dans ce projet Flutter.

---

## 1. Schéma général

```text
┌───────────────────────────────────────────────────────────────┐
│                      PRÉSENTATION (UI)                        │
│  ┌─────────────────────────────────────────────────────────┐  │
│  │                    home_page.dart                       │  │
│  │              (StatelessWidget / View)                   │  │
│  │                                                         │  │
│  │  - Affiche l'interface                                  │  │
│  │  - Réagit aux clics                                     │  │
│  │  - N'a PAS de logique métier                            │  │
│  └────────────────────┬────────────────────────────────────┘  │
│                       │                                       │
│                       │ context.watch<HomeViewModel>()        │
│                       │ (écoute les changements)              │
│                       ↓                                       │
└───────────────────────────────────────────────────────────────┘

┌───────────────────────────────────────────────────────────────┐
│                    LOGIQUE (ViewModel)                        │
│  ┌─────────────────────────────────────────────────────────┐  │
│  │              home_view_model.dart                       │  │
│  │           (ChangeNotifier / ViewModel)                  │  │
│  │                                                         │  │
│  │  État privé :                                           │  │
│  │    • _articles: List<Article>                           │  │
│  │    • _isLoading: bool                                   │  │
│  │    • _errorMessage: String?                             │  │
│  │                                                         │  │
│  │  Getters publics :                                      │  │
│  │    • articles (lecture seule)                           │  │
│  │    • isLoading (lecture seule)                          │  │
│  │    • errorMessage (lecture seule)                       │  │
│  │                                                         │  │
│  │  Méthodes :                                             │  │
│  │    • loadArticles()                                     │  │
│  │    • refresh()                                          │  │
│  │    • addArticle()                                       │  │
│  │    • getArticlesByAuthor()                              │  │
│  └────────────────────┬────────────────────────────────────┘  │
│                       │                                       │
│                       │ repository.getArticles()              │
│                       │ (demande les données)                 │
│                       ↓                                       │
└───────────────────────────────────────────────────────────────┘

┌───────────────────────────────────────────────────────────────┐
│                      DONNÉES (Model)                          │
│  ┌─────────────────────────────────────────────────────────┐  │
│  │              article_repository.dart                    │  │
│  │                  (Repository)                           │  │
│  │                                                         │  │
│  │  • getArticles(): Future<List<Article>>                │  │
│  │  • getArticleById(id): Future<Article?>                │  │
│  │  • addArticle(article): Future<bool>                   │  │
│  │                                                         │  │
│  │  → Simule un appel API (Future.delayed)                │  │
│  │  → Dans la vraie vie : http.get(...)                   │  │
│  └────────────────────┬────────────────────────────────────┘  │
│                       │                                       │
│  ┌────────────────────┴────────────────────────────────────┐  │
│  │                  article.dart                           │  │
│  │                (Classe de données)                      │  │
│  │                                                         │  │
│  │  class Article {                                        │  │
│  │    final int id;                                        │  │
│  │    final String titre;                                  │  │
│  │    final String description;                            │  │
│  │    final String auteur;                                 │  │
│  │    final DateTime datePublication;                      │  │
│  │  }                                                      │  │
│  └─────────────────────────────────────────────────────────┘  │
└───────────────────────────────────────────────────────────────┘
```

---

## 2. Flux de données détaillé

### Scénario : Chargement initial de la liste

```text
┌─────────┐
│ DÉPART  │
└────┬────┘
     │
     ↓
┌─────────────────────────────────────────────┐
│ 1. main.dart démarre l'application          │
│    • Crée ArticleRepository                 │
│    • Crée HomeViewModel(repository)         │
│    • Le constructeur appelle loadArticles() │
└────┬────────────────────────────────────────┘
     │
     ↓
┌─────────────────────────────────────────────┐
│ 2. HomeViewModel.loadArticles()             │
│    • _isLoading = true                      │
│    • notifyListeners() ──────────┐          │
└────┬──────────────────────────────┼─────────┘
     │                               │
     │                               ↓
     │                    ┌──────────────────┐
     │                    │ View se rebuild  │
     │                    │ Affiche spinner  │
     │                    └──────────────────┘
     ↓
┌─────────────────────────────────────────────┐
│ 3. repository.getArticles()                 │
│    • Future.delayed(1,5s) (simule réseau)   │
│    • Retourne List<Article> (5 articles)    │
└────┬────────────────────────────────────────┘
     │
     ↓
┌─────────────────────────────────────────────┐
│ 4. HomeViewModel reçoit les données         │
│    • _articles = [...résultats...]          │
│    • _isLoading = false                     │
│    • notifyListeners() ──────────┐          │
└────┬──────────────────────────────┼─────────┘
     │                               │
     │                               ↓
     │                    ┌──────────────────┐
     │                    │ View se rebuild  │
     │                    │ Affiche liste    │
     │                    └──────────────────┘
     ↓
┌─────────┐
│   FIN   │
└─────────┘
```

---

## 3. Qui fait quoi ?

### 📱 VIEW (home_page.dart)

**Responsabilités :**
-  Afficher les widgets (Scaffold, ListView, Card, etc.)
-  Capter les interactions (onPressed, onTap, pull-to-refresh)
-  Appeler les méthodes du ViewModel
-  Écouter les changements du ViewModel (`context.watch`)

**Interdictions :**
- ❌ Modifier directement des variables d'état
- ❌ Contenir de la logique métier (calculs, conditions complexes)
- ❌ Faire des appels réseau ou DB
- ❌ Connaître l'existence du Repository

**Exemple :**
```dart
// ✅ BON
final viewModel = context.watch<HomeViewModel>();
ElevatedButton(
  onPressed: viewModel.loadArticles, // Appelle le ViewModel
  child: Text('Charger'),
)

// ❌ MAUVAIS
int articleCount = fetchFromAPI(); // Logique dans la View !
```

---

###  VIEWMODEL (home_view_model.dart)

**Responsabilités :**
-  Contenir l'état (variables privées avec `_`)
-  Exposer l'état (getters publics)
-  Contenir la logique métier
-  Appeler le Repository pour les données
-  Notifier la View via `notifyListeners()`

**Interdictions :**
- ❌ Connaître Flutter (pas de `BuildContext`, `Widget`, etc.)
- ❌ Importer des fichiers de `ui/`
- ❌ Avoir des méthodes qui retournent des Widgets

**Exemple :**
```dart
// ✅ BON
class HomeViewModel extends ChangeNotifier {
  List<Article> _articles = [];
  List<Article> get articles => _articles;
  
  Future<void> loadArticles() async {
    _articles = await repository.getArticles();
    notifyListeners();
  }
}

// ❌ MAUVAIS
class HomeViewModel {
  Widget buildList() { // ViewModel ne doit PAS retourner de Widget !
    return ListView(...);
  }
}
```

---

###  MODEL (article.dart + article_repository.dart)

**Responsabilités :**
-  Définir les classes de données (Article, User, Produit...)
-  Accéder aux sources de données (API, DB, fichiers)
-  Parser les réponses (JSON → objet Dart)
-  Gérer les erreurs réseau/DB

**Interdictions :**
- ❌ Connaître Flutter
- ❌ Connaître le ViewModel
- ❌ Gérer de l'état global
- ❌ Appeler `notifyListeners()`

**Exemple :**
```dart
// ✅ BON (classe pure)
class Article {
  final int id;
  final String titre;
  
  Article({required this.id, required this.titre});
  
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(id: json['id'], titre: json['titre']);
  }
}

// ✅ BON (repository)
class ArticleRepository {
  Future<List<Article>> getArticles() async {
    final response = await http.get('https://api.example.com/articles');
    return (json.decode(response.body) as List)
        .map((e) => Article.fromJson(e))
        .toList();
  }
}
```

---

## 4. Gestion d'état avec Provider

### Configuration dans `main.dart`

```dart
MultiProvider(
  providers: [
    // 1. On crée le Repository (pas de ChangeNotifier)
    Provider<ArticleRepository>(
      create: (_) => ArticleRepository(),
    ),
    
    // 2. On crée le ViewModel (ChangeNotifier)
    //    et on injecte le Repository
    ChangeNotifierProvider<HomeViewModel>(
      create: (context) => HomeViewModel(
        repository: context.read<ArticleRepository>(),
      ),
    ),
  ],
  child: MaterialApp(...),
)
```

### Utilisation dans la View

```dart
// Écouter les changements (rebuild automatique)
final viewModel = context.watch<HomeViewModel>();

// Lire une seule fois (pas de rebuild)
final viewModel = context.read<HomeViewModel>();

// Écouter UN champ spécifique seulement
final isLoading = context.select((HomeViewModel vm) => vm.isLoading);
```

---

## 5. Avantages de MVVM

###  Testabilité

Le ViewModel peut être testé **sans Flutter** :

```dart
test('loadArticles charge 5 articles', () async {
  // Arrange
  final mockRepo = MockArticleRepository();
  final viewModel = HomeViewModel(repository: mockRepo);
  
  // Act
  await viewModel.loadArticles();
  
  // Assert
  expect(viewModel.articles.length, 5);
  expect(viewModel.isLoading, false);
});
```

###  Séparation des responsabilités

Chaque fichier a **un rôle clair** :
- `home_page.dart` → affichage
- `home_view_model.dart` → logique
- `article_repository.dart` → données

###  Réutilisabilité

Le même ViewModel peut être utilisé par :
- Une app mobile (Android/iOS)
- Une app web
- Une app desktop (Windows/macOS/Linux)

###  Maintenabilité

Facile de modifier :
- L'UI sans toucher à la logique
- La logique sans toucher à l'UI
- La source de données sans toucher au reste

---

## 6. Erreurs courantes à éviter

### ❌ 1. Logique dans la View

```dart
// MAUVAIS
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final articles = fetchArticlesFromAPI(); // ❌ Logique dans la View !
    return ListView(...);
  }
}
```

### ❌ 2. ViewModel qui connaît Flutter

```dart
// MAUVAIS
class HomeViewModel extends ChangeNotifier {
  Widget buildCard(BuildContext context) { // ❌ ViewModel avec Widget !
    return Card(...);
  }
}
```

### ❌ 3. Modifier l'état directement

```dart
// MAUVAIS
final viewModel = context.watch<HomeViewModel>();
viewModel.articles.add(newArticle); // ❌ Modification directe !

// BON
viewModel.addArticle(newArticle); // ✅ Méthode du ViewModel
```

### ❌ 4. Oublier notifyListeners()

```dart
// MAUVAIS
void addArticle(Article article) {
  _articles.add(article);
  // ❌ Oubli de notifyListeners() → la View ne se rebuild pas !
}

// BON
void addArticle(Article article) {
  _articles.add(article);
  notifyListeners(); // ✅
}
```

---

## 7. Checklist MVVM

Avant de valider ton code, vérifie :

- [ ] La **View** ne contient que des widgets et des appels au ViewModel
- [ ] Le **ViewModel** n'importe rien de `package:flutter`
- [ ] Le **Model** est une classe pure (pas de `ChangeNotifier`)
- [ ] Le **Repository** retourne des `Future<T>` (async)
- [ ] Tous les états sont privés (`_variable`) dans le ViewModel
- [ ] Des getters publics exposent l'état en lecture seule
- [ ] `notifyListeners()` est appelé après chaque modification d'état
- [ ] La View utilise `context.watch` pour écouter le ViewModel

---

## 8. Conclusion

MVVM en Flutter, c'est simple :

```text
View demande → ViewModel exécute → Model fournit
View écoute ← ViewModel notifie ← Model répond
```

**Règle d'or : chaque couche ne parle qu'à la couche en dessous.**

View → ViewModel → Model

(Jamais View → Model directement !)


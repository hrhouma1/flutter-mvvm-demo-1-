#  Exemple MVVM Flutter - Démo Pédagogique

Ce projet est une **démo pédagogique** qui illustre l'architecture **MVVM** (Model-View-ViewModel) en Flutter de manière simple et concrète.

---

##  Objectif

Montrer **comment organiser une application Flutter** en séparant :
- **Vue** (interface utilisateur)
- **ViewModel** (logique métier)
- **Model** (données)

---

##  Architecture MVVM

```text
┌─────────────┐      ┌──────────────┐      ┌─────────────┐
│    VIEW     │ ───> │  VIEWMODEL   │ ───> │    MODEL    │
│  (Widget)   │      │  (logique)   │      │  (données)  │
└─────────────┘      └──────────────┘      └─────────────┘
       ↑                     ↑                     │
       │                     │                     ↓
       └─────────────────────┴─────────── (Repository, API)
```

### Les 3 couches

| Couche | Rôle | Fichiers |
|--------|------|----------|
| **VIEW** | Afficher l'interface<br>Capter les interactions | `lib/ui/home_page.dart` |
| **VIEWMODEL** | Contenir l'état<br>Gérer la logique | `lib/viewmodels/home_view_model.dart` |
| **MODEL** | Définir les données<br>Accéder aux sources | `lib/models/article.dart`<br>`lib/data/article_repository.dart` |

---

##  Structure du projet

```text
lib/
├── main.dart                      # Point d'entrée + configuration Provider
├── models/
│   └── article.dart               # MODEL : classe de données Article
├── data/
│   └── article_repository.dart    # MODEL : accès aux données (API simulée)
├── viewmodels/
│   └── home_view_model.dart       # VIEWMODEL : état + logique
└── ui/
    └── home_page.dart             # VIEW : interface utilisateur
```

---

##  Flux de données

### Exemple : Chargement de la liste d'articles

```text
1. [VIEW] HomePage démarre
         ↓
2. [VIEWMODEL] HomeViewModel.loadArticles() est appelé
         ↓
3. [VIEWMODEL] Met isLoading = true → notifyListeners()
         ↓
4. [VIEW] Se reconstruit et affiche le spinner
         ↓
5. [VIEWMODEL] Appelle repository.getArticles()
         ↓
6. [MODEL] ArticleRepository simule un appel API (1,5s)
         ↓
7. [MODEL] Retourne List<Article>
         ↓
8. [VIEWMODEL] Reçoit les données, met isLoading = false → notifyListeners()
         ↓
9. [VIEW] Se reconstruit et affiche la liste
```

---

##  Explication des fichiers clés

### 1. `models/article.dart` (MODEL)

```dart
class Article {
  final int id;
  final String titre;
  final String description;
  // ...
}
```

**Rôle** : Classe pure de données. Pas de logique, juste des propriétés.

---

### 2. `data/article_repository.dart` (MODEL)

```dart
class ArticleRepository {
  Future<List<Article>> getArticles() async {
    // Simule un appel API
    await Future.delayed(Duration(milliseconds: 1500));
    return [ /* données */ ];
  }
}
```

**Rôle** : Accéder aux données (API, DB). Ici, on simule avec des données en dur.

---

### 3. `viewmodels/home_view_model.dart` (VIEWMODEL)

```dart
class HomeViewModel extends ChangeNotifier {
  List<Article> _articles = [];
  bool _isLoading = false;
  
  List<Article> get articles => _articles;
  bool get isLoading => _isLoading;
  
  Future<void> loadArticles() async {
    _isLoading = true;
    notifyListeners(); // Prévient la View
    
    _articles = await repository.getArticles();
    
    _isLoading = false;
    notifyListeners(); // Prévient la View
  }
}
```

**Rôle** : Le "cerveau" de l'écran.
- Contient l'état (`_articles`, `_isLoading`)
- Contient la logique (`loadArticles()`)
- Notifie la View via `notifyListeners()`

---

### 4. `ui/home_page.dart` (VIEW)

```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();
    
    if (viewModel.isLoading) {
      return CircularProgressIndicator();
    }
    
    return ListView.builder(
      itemCount: viewModel.articles.length,
      itemBuilder: (context, index) {
        return ArticleCard(viewModel.articles[index]);
      },
    );
  }
}
```

**Rôle** : Afficher l'interface.
- **Ne contient PAS de logique métier**
- Écoute le ViewModel via `context.watch<HomeViewModel>()`
- Se reconstruit automatiquement quand le ViewModel change

---

##  Installation et lancement

### Prérequis
- Flutter SDK (≥ 3.0.0)
- Dart

### Commandes

```bash
# 1. Installer les dépendances
flutter pub get

# 2. Lancer l'application
flutter run
```

---

##  Fonctionnalités de la démo

-  **Affichage de la liste** d'articles avec loader
-  **Pull-to-refresh** (glisser vers le bas)
-  **Gestion d'erreurs** avec bouton de réessai
-  **Statistiques** (nombre d'articles par auteur)
-  **État vide** (quand aucun article)
-  **Cards cliquables** (détails en popup)

---

##  Principes MVVM appliqués

###  Séparation des responsabilités

- **View** : affiche, ne calcule rien
- **ViewModel** : calcule, ne connaît pas les widgets
- **Model** : données pures

###  Testabilité

Le ViewModel peut être testé **sans Flutter** :

```dart
test('loadArticles charge les données', () async {
  final repo = MockArticleRepository();
  final vm = HomeViewModel(repository: repo);
  
  await vm.loadArticles();
  
  expect(vm.articles.length, 5);
  expect(vm.isLoading, false);
});
```

###  Réutilisabilité

Le même ViewModel peut être utilisé par plusieurs Views (mobile, web, desktop).

---

##  Technologies utilisées

- **Flutter** : Framework UI
- **Provider** : Gestion d'état (liaison View ↔ ViewModel)
- **ChangeNotifier** : Notification de changements d'état

---

##  Pour aller plus loin

### Améliorations possibles

1. **Vraie API** : Remplacer les données simulées par `http.get()`
2. **Base de données locale** : Ajouter SQLite ou Hive
3. **Navigation** : Page de détails séparée
4. **Formulaire d'ajout** : Créer un vrai formulaire avec validation
5. **Tests unitaires** : Tester le ViewModel
6. **Injection de dépendances** : Utiliser GetIt ou Riverpod

### Ressources

- [Documentation Flutter](https://flutter.dev/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [Architecture Guide](https://docs.flutter.dev/development/data-and-backend/state-mgmt/intro)

---

##  Résumé en une phrase

> **La View demande au ViewModel, le ViewModel demande au Model.**
> 
> **Quand le Model répond, le ViewModel notifie la View, qui se reconstruit.**

---

##  Auteur

Exemple pédagogique créé pour illustrer MVVM en Flutter.

---

##  Licence

Libre d'utilisation pour l'apprentissage.


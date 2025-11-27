# 🚀 Guide de démarrage rapide

## 1. Installer les dépendances

```bash
flutter pub get
```

Cette commande télécharge tous les packages nécessaires (Provider, HTTP, etc.).

---

## 2. Lancer l'application

### Sur un émulateur/simulateur

```bash
flutter run
```

### Sur un appareil physique

1. Connecte ton téléphone en USB
2. Active le mode développeur
3. Lance :

```bash
flutter run
```

### Sur Chrome (web)

```bash
flutter run -d chrome
```

---

## 3. Structure du projet (rappel)

```text
lib/
├── main.dart                   # Point d'entrée
├── models/
│   └── article.dart            # Classe Article
├── data/
│   └── article_repository.dart # Accès aux données
├── viewmodels/
│   └── home_view_model.dart    # Logique + état
└── ui/
    └── home_page.dart          # Interface
```

---

## 4. Fonctionnalités disponibles

### ✅ À tester dans l'app

1. **Chargement initial**
   - Au démarrage, tu verras un spinner pendant 1,5 seconde
   - Ensuite, 5 articles s'affichent

2. **Pull-to-refresh**
   - Glisse vers le bas pour rafraîchir
   - Le spinner réapparaît

3. **Détails d'un article**
   - Clique sur une carte
   - Une popup s'ouvre avec les détails

4. **Statistiques**
   - Clique sur l'icône 📊 en haut à droite
   - Voir le nombre d'articles par auteur

5. **Bouton d'ajout**
   - Clique sur le bouton ➕ (en bas à droite)
   - Message de démo (pas de vrai formulaire dans cette démo)

---

## 5. Modifier le code

### Ajouter un article à la liste

Ouvre `lib/data/article_repository.dart` et ajoute un article dans la liste retournée par `getArticles()` :

```dart
Article(
  id: 6,
  titre: 'Mon nouvel article',
  description: 'Description de mon article',
  auteur: 'Ton nom',
  datePublication: DateTime.now(),
),
```

Sauvegarde et relance l'app → tu verras 6 articles au lieu de 5.

---

### Changer la couleur du thème

Ouvre `lib/main.dart` et change :

```dart
theme: ThemeData(
  primarySwatch: Colors.purple, // Change blue en purple
  useMaterial3: true,
),
```

---

## 6. Commandes utiles

### Vérifier qu'il n'y a pas d'erreurs

```bash
flutter analyze
```

### Formater le code automatiquement

```bash
dart format lib/
```

### Nettoyer le cache (si problème)

```bash
flutter clean
flutter pub get
```

---

## 7. Comprendre le flux MVVM

### Exemple : Rafraîchir la liste

1. Tu glisses vers le bas (**View** : `RefreshIndicator`)
2. Ça appelle `viewModel.refresh()` (**View → ViewModel**)
3. Le ViewModel met `_isLoading = true` et appelle `notifyListeners()` (**ViewModel**)
4. La View affiche le spinner (**ViewModel → View**)
5. Le ViewModel demande les données : `repository.getArticles()` (**ViewModel → Model**)
6. Le Repository simule un délai et retourne la liste (**Model**)
7. Le ViewModel reçoit les données, met à jour `_articles` et appelle `notifyListeners()` (**ViewModel**)
8. La View se reconstruit avec la nouvelle liste (**ViewModel → View**)

---

## 8. FAQ

### ❓ "Je ne vois pas de changement après modification"

1. Vérifie que tu as bien sauvegardé le fichier
2. Appuie sur `r` dans le terminal pour hot reload
3. Ou appuie sur `R` pour hot restart (redémarre l'app)

### ❓ "Erreur : package not found"

Lance :

```bash
flutter pub get
```

### ❓ "Comment déboguer ?"

1. Ajoute `print('debug: $variable');` dans ton code
2. Ou utilise le débogueur de VS Code / Android Studio

### ❓ "Je veux ajouter une vraie API"

Remplace dans `article_repository.dart` :

```dart
Future<List<Article>> getArticles() async {
  await Future.delayed(const Duration(milliseconds: 1500));
  return [ /* liste en dur */ ];
}
```

Par :

```dart
Future<List<Article>> getArticles() async {
  final response = await http.get(
    Uri.parse('https://api.example.com/articles'),
  );
  
  if (response.statusCode == 200) {
    final List json = jsonDecode(response.body);
    return json.map((e) => Article.fromJson(e)).toList();
  } else {
    throw Exception('Erreur API');
  }
}
```

---

## 9. Prochaines étapes

Une fois que tu as compris cette démo, tu peux :

1. **Ajouter une vraie API REST**
2. **Créer une page de détails séparée** (navigation)
3. **Ajouter un formulaire d'ajout d'article**
4. **Implémenter une base de données locale** (SQLite, Hive)
5. **Écrire des tests unitaires** pour le ViewModel
6. **Ajouter un système d'authentification**

---

## 10. Ressources

- 📖 [README.md](README.md) : Vue d'ensemble
- 🏗️ [ARCHITECTURE.md](ARCHITECTURE.md) : Architecture détaillée
- 🌐 [Documentation Flutter](https://flutter.dev)
- 📦 [Package Provider](https://pub.dev/packages/provider)

---

Bon apprentissage ! 🎉


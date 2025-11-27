# Quiz MVVM - Testez vos connaissances !

> **Quiz complet pour vérifier votre compréhension de l'architecture MVVM en Flutter**

---

## Instructions

- **50 questions** réparties en 5 sections
- Chaque question a une seule bonne réponse (sauf mention contraire)
- Les réponses sont à la fin du document
- Prenez votre temps et réfléchissez bien !

---

## Section 1 : Concepts de base (10 questions)

### Question 1
Que signifie l'acronyme MVVM ?

A) Model-View-ViewMethod  
B) Model-View-ViewModel  
C) Module-View-ViewModel  
D) Model-Variable-ViewModel  

---

### Question 2
Quelle est la principale responsabilité de la **View** dans MVVM ?

A) Gérer la logique métier  
B) Faire des appels API  
C) Afficher l'interface utilisateur  
D) Stocker les données  

---

### Question 3
Le **ViewModel** doit-il connaître la **View** ?

A) Oui, il doit avoir une référence directe  
B) Non, il ne doit pas importer de fichiers UI  
C) Oui, mais seulement pour les widgets simples  
D) Ça dépend de la situation  

---

### Question 4
Dans notre projet, quel fichier représente le **Model** ?

A) `home_page.dart`  
B) `main.dart`  
C) `article.dart`  
D) `home_view_model.dart`  

---

### Question 5
À quoi sert `notifyListeners()` ?

A) À prévenir la View qu'il y a des changements  
B) À envoyer des données à l'API  
C) À créer de nouveaux widgets  
D) À parser du JSON  

---

### Question 6
Quelle classe doit hériter le ViewModel ?

A) `StatelessWidget`  
B) `StatefulWidget`  
C) `ChangeNotifier`  
D) `InheritedWidget`  

---

### Question 7
Dans MVVM, qui fait les appels API ?

A) La View  
B) Le ViewModel  
C) Le Repository (Model)  
D) Le Widget principal  

---

### Question 8
Quelle méthode utilise-t-on pour écouter les changements du ViewModel dans la View ?

A) `context.read<HomeViewModel>()`  
B) `context.watch<HomeViewModel>()`  
C) `context.listen<HomeViewModel>()`  
D) `context.notify<HomeViewModel>()`  

---

### Question 9
Les variables d'état dans le ViewModel doivent-elles être publiques ou privées ?

A) Publiques (sans underscore)  
B) Privées (avec underscore _)  
C) Ça dépend du cas  
D) Les deux en même temps  

---

### Question 10
Quel est l'avantage principal de MVVM ?

A) Ça rend le code plus long  
B) Ça mélange tout dans un seul fichier  
C) Ça sépare les responsabilités et facilite les tests  
D) Ça permet d'éviter d'utiliser Flutter  

---

## Section 2 : Architecture et structure (10 questions)

### Question 11
Dans quelle couche se trouve `article_repository.dart` ?

A) View  
B) ViewModel  
C) Model  
D) Controller  

---

### Question 12
Complétez : View → ? → Model

A) Controller  
B) ViewModel  
C) Service  
D) Manager  

---

### Question 13
Quel type de widget est généralement utilisé pour la View en MVVM ?

A) `StatefulWidget` obligatoirement  
B) `StatelessWidget` avec Provider  
C) `InheritedWidget`  
D) Aucun widget spécifique  

---

### Question 14
Dans notre projet, où se trouve la logique métier ?

A) `lib/ui/home_page.dart`  
B) `lib/viewmodels/home_view_model.dart`  
C) `lib/models/article.dart`  
D) `lib/main.dart`  

---

### Question 15
Que contient le dossier `lib/data/` ?

A) Les widgets  
B) Les ViewModels  
C) Le Repository (accès aux données)  
D) Les tests  

---

### Question 16
Quel package utilise-t-on pour la gestion d'état dans ce projet ?

A) Bloc  
B) GetX  
C) Provider  
D) Redux  

---

### Question 17
Où configure-t-on le Provider dans l'application ?

A) Dans chaque widget  
B) Dans `main.dart`  
C) Dans le ViewModel  
D) Dans le Repository  

---

### Question 18
Le flux de données dans MVVM est :

A) Bidirectionnel entre toutes les couches  
B) Unidirectionnel View → ViewModel → Model  
C) Chaotique et non défini  
D) Circulaire Model → View → Model  

---

### Question 19
Combien de ViewModels peut avoir une application Flutter ?

A) Un seul obligatoirement  
B) Exactement trois  
C) Autant que nécessaire (un par écran généralement)  
D) Aucun, ce n'est pas obligatoire  

---

### Question 20
Dans notre projet, qui appelle `repository.getArticles()` ?

A) `HomePage` (View)  
B) `HomeViewModel` (ViewModel)  
C) `Article` (Model)  
D) `main.dart`  

---

## Section 3 : Code et implémentation (15 questions)

### Question 21
Ce code est-il correct pour un ViewModel ?

```dart
class HomeViewModel extends ChangeNotifier {
  Widget buildCard() {
    return Card(...);
  }
}
```

A) Oui, c'est parfait  
B) Non, un ViewModel ne doit pas retourner de Widget  
C) Oui, mais seulement pour les petits widgets  
D) Ça dépend de la situation  

---

### Question 22
Comment expose-t-on une variable privée du ViewModel à la View ?

A) On la rend publique directement  
B) On crée un getter public  
C) On utilise une fonction static  
D) On la passe dans le constructeur  

---

### Question 23
Ce code est-il correct ?

```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final articles = http.get('api.com/articles');
    return ListView(...);
  }
}
```

A) Oui, c'est la bonne façon de faire  
B) Non, la View ne doit pas faire d'appels API  
C) Oui, mais seulement pour les petites apps  
D) Non, il faut utiliser `async/await`  

---

### Question 24
Dans le ViewModel, quand doit-on appeler `notifyListeners()` ?

A) Jamais  
B) Après chaque modification d'état  
C) Seulement au démarrage  
D) Une fois par seconde  

---

### Question 25
Quel est le problème avec ce code ?

```dart
class Article extends ChangeNotifier {
  String titre;
  String auteur;
}
```

A) Il n'y a aucun problème  
B) Le Model ne doit pas hériter de ChangeNotifier  
C) Il manque le mot-clé `final`  
D) Les variables doivent être privées  

---

### Question 26
Comment injecte-t-on le Repository dans le ViewModel ?

A) Via le constructeur  
B) Via une variable globale  
C) On ne l'injecte pas  
D) Via un singleton  

---

### Question 27
Dans la View, que fait `context.read<HomeViewModel>()` ?

A) Lit le ViewModel et rebuild automatiquement  
B) Lit le ViewModel une seule fois sans rebuild  
C) Écrit dans le ViewModel  
D) Supprime le ViewModel  

---

### Question 28
Ce getter est-il correct dans le ViewModel ?

```dart
List<Article> get articles => _articles;
```

A) Oui  
B) Non, il faut retourner une copie  
C) Non, il faut un setter aussi  
D) Non, il doit être privé  

---

### Question 29
Où doit-on mettre la méthode `fromJson()` ?

A) Dans la View  
B) Dans le ViewModel  
C) Dans le Model (classe Article)  
D) Dans le Repository  

---

### Question 30
Ce code est-il correct pour un Repository ?

```dart
class ArticleRepository {
  Future<List<Article>> getArticles() async {
    notifyListeners();
    return await api.get();
  }
}
```

A) Oui, c'est parfait  
B) Non, le Repository ne doit pas appeler notifyListeners  
C) Oui, mais seulement pour les gros projets  
D) Non, il faut utiliser `await` différemment  

---

### Question 31
Comment gère-t-on les erreurs dans le ViewModel ?

A) On ne les gère pas  
B) On les affiche directement dans des AlertDialog  
C) On stocke le message d'erreur dans une variable et on notifie la View  
D) On arrête l'application  

---

### Question 32
Quelle est la bonne façon de créer un Provider dans `main.dart` ?

A) `Provider<HomeViewModel>(...)`  
B) `ChangeNotifierProvider<HomeViewModel>(...)`  
C) `StreamProvider<HomeViewModel>(...)`  
D) `FutureProvider<HomeViewModel>(...)`  

---

### Question 33
Dans notre projet, `_isLoading` est :

A) Une variable publique de la View  
B) Une variable privée du ViewModel  
C) Une méthode du Repository  
D) Un widget Flutter  

---

### Question 34
Comment fait-on pour rafraîchir la liste avec pull-to-refresh ?

A) On appelle directement `repository.getArticles()`  
B) On appelle `viewModel.refresh()` qui gère tout  
C) On redémarre l'application  
D) On recrée le widget  

---

### Question 35
Ce code est-il optimal ?

```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();
    final isLoading = context.watch<HomeViewModel>().isLoading;
    return ...;
  }
}
```

A) Oui, c'est parfait  
B) Non, on fait deux `watch` inutilement  
C) Oui, mais seulement en production  
D) Non, il faut utiliser `read` au lieu de `watch`  

---

## Section 4 : Bonnes pratiques (10 questions)

### Question 36
Doit-on importer `package:flutter/material.dart` dans le ViewModel ?

A) Oui, obligatoirement  
B) Non, le ViewModel doit être indépendant de Flutter  
C) Seulement pour les icônes  
D) Ça dépend du projet  

---

### Question 37
Comment teste-t-on un ViewModel ?

A) On ne peut pas le tester  
B) Avec des tests unitaires sans Flutter  
C) Seulement avec des tests d'intégration  
D) En lançant l'application manuellement  

---

### Question 38
Quelle est la meilleure pratique pour nommer les variables privées ?

A) `maVariable`  
B) `_maVariable`  
C) `private_maVariable`  
D) `MAVARIABLE`  

---

### Question 39
Où doit-on gérer le cache local (SQLite, Hive) ?

A) Dans la View  
B) Dans le ViewModel  
C) Dans le Repository (Model)  
D) Dans `main.dart`  

---

### Question 40
Comment organise-t-on les fichiers dans un gros projet MVVM ?

A) Tout dans `lib/`  
B) Par fonctionnalité : `features/auth/`, `features/home/`  
C) Tous les ViewModels ensemble, toutes les Views ensemble  
D) Ça n'a pas d'importance  

---

### Question 41
Doit-on utiliser des variables globales pour partager des données ?

A) Oui, c'est la meilleure solution  
B) Non, on utilise Provider/ViewModel  
C) Seulement pour les constantes  
D) Oui, mais seulement en développement  

---

### Question 42
Comment gère-t-on la navigation dans MVVM ?

A) Le ViewModel fait `Navigator.push()`  
B) La View gère la navigation, le ViewModel peut signaler quand naviguer  
C) Le Model gère tout  
D) On n'utilise pas de navigation  

---

### Question 43
Combien de responsabilités doit avoir un ViewModel ?

A) Autant que possible  
B) Une seule (principe de responsabilité unique)  
C) Exactement trois  
D) Aucune limite  

---

### Question 44
Comment partage-t-on un ViewModel entre plusieurs écrans ?

A) On le recrée à chaque fois  
B) On utilise le même Provider au-dessus des deux écrans  
C) On utilise une variable globale  
D) C'est impossible  

---

### Question 45
Quelle est la meilleure pratique pour les fonctions asynchrones dans le ViewModel ?

A) Bloquer l'UI pendant l'attente  
B) Utiliser `async/await` et mettre à jour `isLoading`  
C) Ne jamais utiliser d'async  
D) Utiliser des `Timer`  

---

## Section 5 : Situations pratiques (5 questions)

### Question 46
Vous voulez ajouter un filtre de recherche. Où mettez-vous la logique de filtrage ?

A) Dans la View (`home_page.dart`)  
B) Dans le ViewModel (`home_view_model.dart`)  
C) Dans le Model (`article.dart`)  
D) Dans `main.dart`  

---

### Question 47
Un utilisateur clique sur "Ajouter aux favoris". Quel est le bon flux ?

A) View → API directement  
B) View → ViewModel → Repository → API  
C) View → Model → ViewModel  
D) View → main.dart → API  

---

### Question 48
Vous avez une erreur réseau. Où capturez-vous l'exception ?

A) Dans la View  
B) Dans le Repository, puis transmise au ViewModel  
C) Dans `main.dart`  
D) Nulle part  

---

### Question 49
Vous voulez afficher un `SnackBar` après une action. Qui décide quand l'afficher ?

A) Le ViewModel avec une variable `showSnackBar`  
B) La View qui écoute un callback ou état du ViewModel  
C) Le Repository directement  
D) Un Timer global  

---

### Question 50
Vous voulez réutiliser la logique de chargement d'articles pour une app web. Que faites-vous ?

A) Vous réécrivez tout  
B) Vous réutilisez le ViewModel et le Repository  
C) C'est impossible  
D) Vous copiez-collez le code de la View  

---

---

# RÉPONSES

## Section 1 : Concepts de base

1. **B** - Model-View-ViewModel
2. **C** - Afficher l'interface utilisateur
3. **B** - Non, il ne doit pas importer de fichiers UI
4. **C** - `article.dart`
5. **A** - À prévenir la View qu'il y a des changements
6. **C** - `ChangeNotifier`
7. **C** - Le Repository (Model)
8. **B** - `context.watch<HomeViewModel>()`
9. **B** - Privées (avec underscore _)
10. **C** - Ça sépare les responsabilités et facilite les tests

**Score Section 1 : __ / 10**

---

## Section 2 : Architecture et structure

11. **C** - Model
12. **B** - ViewModel
13. **B** - `StatelessWidget` avec Provider
14. **B** - `lib/viewmodels/home_view_model.dart`
15. **C** - Le Repository (accès aux données)
16. **C** - Provider
17. **B** - Dans `main.dart`
18. **B** - Unidirectionnel View → ViewModel → Model
19. **C** - Autant que nécessaire (un par écran généralement)
20. **B** - `HomeViewModel` (ViewModel)

**Score Section 2 : __ / 10**

---

## Section 3 : Code et implémentation

21. **B** - Non, un ViewModel ne doit pas retourner de Widget
22. **B** - On crée un getter public
23. **B** - Non, la View ne doit pas faire d'appels API
24. **B** - Après chaque modification d'état
25. **B** - Le Model ne doit pas hériter de ChangeNotifier
26. **A** - Via le constructeur
27. **B** - Lit le ViewModel une seule fois sans rebuild
28. **A** - Oui
29. **C** - Dans le Model (classe Article)
30. **B** - Non, le Repository ne doit pas appeler notifyListeners
31. **C** - On stocke le message d'erreur dans une variable et on notifie la View
32. **B** - `ChangeNotifierProvider<HomeViewModel>(...)`
33. **B** - Une variable privée du ViewModel
34. **B** - On appelle `viewModel.refresh()` qui gère tout
35. **B** - Non, on fait deux `watch` inutilement

**Score Section 3 : __ / 15**

---

## Section 4 : Bonnes pratiques

36. **B** - Non, le ViewModel doit être indépendant de Flutter
37. **B** - Avec des tests unitaires sans Flutter
38. **B** - `_maVariable`
39. **C** - Dans le Repository (Model)
40. **B** - Par fonctionnalité : `features/auth/`, `features/home/`
41. **B** - Non, on utilise Provider/ViewModel
42. **B** - La View gère la navigation, le ViewModel peut signaler quand naviguer
43. **B** - Une seule (principe de responsabilité unique)
44. **B** - On utilise le même Provider au-dessus des deux écrans
45. **B** - Utiliser `async/await` et mettre à jour `isLoading`

**Score Section 4 : __ / 10**

---

## Section 5 : Situations pratiques

46. **B** - Dans le ViewModel (`home_view_model.dart`)
47. **B** - View → ViewModel → Repository → API
48. **B** - Dans le Repository, puis transmise au ViewModel
49. **B** - La View qui écoute un callback ou état du ViewModel
50. **B** - Vous réutilisez le ViewModel et le Repository

**Score Section 5 : __ / 5**

---

---

# Évaluation de votre score

## Score total : __ / 50

### 45-50 : Expert MVVM
Félicitations ! Vous maîtrisez parfaitement l'architecture MVVM en Flutter. Vous êtes prêt à l'utiliser dans des projets professionnels !

### 35-44 : Avancé
Très bien ! Vous avez une bonne compréhension de MVVM. Quelques petites révisions sur les points manqués et vous serez expert !

### 25-34 : Intermédiaire
Bon début ! Vous comprenez les bases, mais il reste quelques concepts à approfondir. Relisez la documentation et refaites le quiz.

### 15-24 : Débutant
Vous avez les bases mais il faut encore travailler. Prenez le temps de lire les documents d'architecture et de faire des exercices pratiques.

### 0-14 : À revoir
Pas de panique ! Commencez par le README.md et le 03-MVVM-EXPLIQUE.md. Prenez votre temps pour comprendre chaque concept avant de refaire le quiz.

---

## Analyse par section

Notez vos résultats pour chaque section :

| Section | Score | Niveau |
|---------|-------|--------|
| 1. Concepts de base | __ / 10 | ___ |
| 2. Architecture | __ / 10 | ___ |
| 3. Code | __ / 15 | ___ |
| 4. Bonnes pratiques | __ / 10 | ___ |
| 5. Situations pratiques | __ / 5 | ___ |

**Votre point faible :** ___________________

**Recommandation :** ___________________

---

## Que faire après le quiz ?

### Si vous avez réussi (35+)
- Implémentez les exemples du fichier `02-EXAMPLES.md`
- Créez votre propre projet MVVM
- Ajoutez des fonctionnalités avancées (filtres, favoris, etc.)

### Si vous devez réviser (< 35)
- Relisez le `03-MVVM-EXPLIQUE.md` (avec les diagrammes)
- Étudiez le code existant dans `lib/`
- Comparez le bon et le mauvais code dans `01-ARCHITECTURE.md`
- Refaites le quiz dans quelques jours

---

## Questions fréquentes sur les erreurs

### Pourquoi le ViewModel ne doit pas importer Flutter ?
Pour pouvoir le tester sans lancer Flutter et le réutiliser sur d'autres plateformes (web, desktop).

### Pourquoi pas de logique dans la View ?
Ça rend le code difficile à tester et impossible à réutiliser.

### Pourquoi utiliser des getters au lieu de variables publiques ?
Pour contrôler l'accès et éviter les modifications directes de l'état.

### Pourquoi le Repository ne fait pas `notifyListeners()` ?
Seul le ViewModel doit notifier la View. Le Repository ne connaît pas le concept de notification.

---

## Ressources pour approfondir

- [README.md](README.md) - Vue d'ensemble
- [01-ARCHITECTURE.md](01-ARCHITECTURE.md) - Architecture détaillée
- [02-EXAMPLES.md](02-EXAMPLES.md) - Exemples pratiques
- [03-MVVM-EXPLIQUE.md](03-MVVM-EXPLIQUE.md) - Diagrammes visuels
- [QUICKSTART.md](QUICKSTART.md) - Démarrage rapide

---

**Bon courage et bon apprentissage !**

**N'oubliez pas : La pratique est la clé de la maîtrise !**

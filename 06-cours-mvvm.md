## 1. C’est quoi MVVM ?

MVVM = **M**odel – **V**iew – **V**iew**M**odel.

Tu peux le voir comme 3 boîtes :

```text
+--------+      +-----------+      +--------+
|  VIEW  | ---> | VIEWMODEL | ---> | MODEL  |
| (UI)   |      | (cerveau) |      | (data) |
+--------+      +-----------+      +--------+
```

* **VIEW**
  → Les widgets que tu vois à l’écran (Text, Button, ListView, etc.).

* **VIEWMODEL**
  → Le “cerveau” de l’écran :
  il contient l’état et la logique (que faire quand on clique, quoi afficher).

* **MODEL**
  → Les données “pures” :
  classes Dart (User, Article, Produit), accès à l’API, base de données, etc.

Idée clé :
**La VIEW ne fait presque pas de logique. Elle demande tout au VIEWMODEL.**



## 2. Version dessin



```mermaid
graph TD

View --> ViewModel --> Model
Model --> ViewModel --> View
```



## 3. Exemple concret très simple (compteur)

On fait un **compteur** façon MVVM.

### 3.1. MODEL (ici très simple)

Ici, on n’a même pas besoin de vraie class Model.
On va juste imaginer que le “nombre” c’est la donnée.



### 3.2. VIEWMODEL : le cerveau du compteur

```dart
// lib/viewmodels/counter_view_model.dart
import 'package:flutter/foundation.dart';

class CounterViewModel extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners(); // prévient la Vue que ça a changé
  }

  void reset() {
    _count = 0;
    notifyListeners();
  }
}
```

* `_count` : l’état interne.
* `count` : ce que la VIEW peut lire.
* `increment()` / `reset()` : la logique.
* `notifyListeners()` : “hé, Vue, reconstruis-toi”.



### 3.3. VIEW : l’écran qui affiche le compteur

Avec `ChangeNotifierProvider` (package `provider`), par exemple :

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/counter_view_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CounterViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const CounterPage(),
    );
  }
}

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CounterViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('MVVM simple')),
      body: Center(
        child: Text(
          'Valeur : ${vm.count}',
          style: const TextStyle(fontSize: 30),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: vm.increment, // on appelle le ViewModel
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: vm.reset,
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
```

Points importants :

* La **Vue ne change pas directement** la variable `count`.
* La Vue **appelle des fonctions** du ViewModel (`vm.increment()`, `vm.reset()`).
* Le ViewModel met à jour l’état et appelle `notifyListeners()`.
* Grâce à `context.watch<CounterViewModel>()`, la Vue se reconstruit automatiquement.



## 4. Ce qu’il faut retenir

1. **VIEW**
   → Widgets (écrans)
   → affiche ce que le ViewModel lui donne.

2. **VIEWMODEL**
   → contient l’état + la logique (méthodes)
   → parle au Model si besoin.

3. **MODEL**
   → les données (classes, API, DB, fichiers, etc.)

En Flutter, souvent tu fais :

```text
ui/          → VIEW
viewmodels/  → VIEWMODEL
models/      → MODEL
data/        → repositories, services API
```

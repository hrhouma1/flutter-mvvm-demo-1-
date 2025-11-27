# MVVM Expliqué avec des Diagrammes

> **Guide ultra-visuel pour comprendre MVVM en Flutter**

---

##  Table des matières

1. [MVVM en 3 images simples](#1-mvvm-en-3-images-simples)
2. [L'architecture dans notre code](#2-larchitecture-dans-notre-code)
3. [Le flux de données complet](#3-le-flux-de-données-complet)
4. [Exemple concret : Charger des articles](#4-exemple-concret--charger-des-articles)
5. [Qui appelle qui ?](#5-qui-appelle-qui-)
6. [Où est quoi dans le code ?](#6-où-est-quoi-dans-le-code-)
7. [Les 3 règles d'or](#7-les-3-règles-dor)

---

## 1. MVVM en 3 images simples

###  Vue d'ensemble

```mermaid
graph LR
    A[👤 USER] -->|clique, tape| B[VIEW]
    B -->|appelle méthode| C[ VIEWMODEL]
    C -->|demande données| D[ MODEL]
    D -->|retourne données| C
    C -->|notifie changement| B
    B -->|affiche| A
    
    style A fill:#e1f5ff
    style B fill:#fff4e1
    style C fill:#ffe1f5
    style D fill:#e1ffe1
```

###  Le cycle complet

```mermaid
sequenceDiagram
    participant U as  Utilisateur
    participant V as  View
    participant VM as  ViewModel
    participant M as  Model

    U->>V: Clique sur "Charger"
    V->>VM: loadArticles()
    VM->>VM: isLoading = true
    VM->>V: notifyListeners()
    V->>U: Affiche spinner
    VM->>M: getArticles()
    M-->>VM: List<Article>
    VM->>VM: articles = liste
    VM->>VM: isLoading = false
    VM->>V: notifyListeners()
    V->>U: Affiche la liste
```

###  Architecture en couches

```mermaid
graph TD
    subgraph UI[" PRÉSENTATION (UI)"]
        V1[home_page.dart]
        V2[article_card.dart]
    end
    
    subgraph LOGIC[" LOGIQUE (ViewModel)"]
        VM1[home_view_model.dart]
    end
    
    subgraph DATA[" DONNÉES (Model)"]
        M1[article.dart]
        M2[article_repository.dart]
    end
    
    subgraph EXTERNAL[" EXTERNE"]
        API[API REST]
        DB[(Base de données)]
    end
    
    V1 --> VM1
    V2 --> VM1
    VM1 --> M1
    VM1 --> M2
    M2 --> API
    M2 --> DB
    
    style UI fill:#fff4e1
    style LOGIC fill:#ffe1f5
    style DATA fill:#e1ffe1
    style EXTERNAL fill:#e1f5ff
```

---

## 2. L'architecture dans notre code

###  Structure des fichiers

```mermaid
graph TD
    ROOT[lib/]
    
    ROOT --> MAIN[main.dart<br/> Point d'entrée]
    
    ROOT --> UI[ui/]
    UI --> HP[home_page.dart<br/> VIEW]
    
    ROOT --> VM[viewmodels/]
    VM --> HVM[home_view_model.dart<br/> VIEWMODEL]
    
    ROOT --> MODELS[models/]
    MODELS --> ART[article.dart<br/> MODEL]
    
    ROOT --> DATA[data/]
    DATA --> REPO[article_repository.dart<br/> REPOSITORY]
    
    style MAIN fill:#ffd700
    style HP fill:#fff4e1
    style HVM fill:#ffe1f5
    style ART fill:#e1ffe1
    style REPO fill:#e1ffe1
```

###  Responsabilités de chaque fichier

```mermaid
mindmap
  root((MVVM<br/>Flutter))
    VIEW
      home_page.dart
        Afficher widgets
        Capter clics
        Écouter ViewModel
        Se reconstruire
    VIEWMODEL
      home_view_model.dart
        Contenir l'état
        Logique métier
        Appeler Repository
        Notifier la View
    MODEL
      article.dart
        Définir la structure
        Parser JSON
        Données pures
      article_repository.dart
        Accès API
        Accès DB
        Cache local
```

---

## 3. Le flux de données complet

###  Flux bidirectionnel

```mermaid
flowchart TB
    subgraph "📱 VIEW (home_page.dart)"
        UI[Interface utilisateur<br/>Widgets Flutter]
    end
    
    subgraph " VIEWMODEL (home_view_model.dart)"
        STATE[État privé<br/>_articles, _isLoading]
        GETTERS[Getters publics<br/>articles, isLoading]
        METHODS[Méthodes<br/>loadArticles, refresh]
    end
    
    subgraph " MODEL"
        ARTICLE[article.dart<br/>Classe de données]
        REPO[article_repository.dart<br/>Accès données]
    end
    
    UI -->|context.watch| GETTERS
    UI -->|appelle| METHODS
    METHODS -->|met à jour| STATE
    STATE -->|expose via| GETTERS
    METHODS -->|demande| REPO
    REPO -->|retourne| ARTICLE
    ARTICLE -->|stocké dans| STATE
    STATE -->|notifyListeners| UI
    
    style UI fill:#fff4e1
    style STATE fill:#ffe1f5
    style GETTERS fill:#ffe1f5
    style METHODS fill:#ffe1f5
    style ARTICLE fill:#e1ffe1
    style REPO fill:#e1ffe1
```

### 📊 Communication entre couches

```mermaid
graph LR
    subgraph V[" "]
        V1[" VIEW<br/><br/>Je veux afficher<br/>des articles"]
    end
    
    subgraph VM[" "]
        V2[" VIEWMODEL<br/><br/>Je vais les chercher<br/>et te prévenir"]
    end
    
    subgraph M[" "]
        V3[" MODEL<br/><br/>Voici les données<br/>de l'API"]
    end
    
    V1 -->|"Donne-moi<br/>les articles"| V2
    V2 -->|"Va chercher<br/>les données"| V3
    V3 -->|"Voilà la liste"| V2
    V2 -->|"Données prêtes !<br/>(notifyListeners)"| V1
    
    style V1 fill:#fff4e1
    style V2 fill:#ffe1f5
    style V3 fill:#e1ffe1
```

---

## 4. Exemple concret : Charger des articles

###  Scénario étape par étape

```mermaid
sequenceDiagram
    autonumber
    participant UI as  HomePage<br/>(View)
    participant VM as  HomeViewModel<br/>(ViewModel)
    participant Repo as  ArticleRepository<br/>(Model)
    participant API as  API<br/>(externe)

    Note over UI,API: L'app démarre

    UI->>VM: Construction du ViewModel
    activate VM
    VM->>VM: loadArticles() appelé<br/>dans le constructeur
    VM->>VM: _isLoading = true
    VM->>UI: notifyListeners()
    deactivate VM
    
    activate UI
    Note over UI:  Rebuild automatique
    UI->>UI: Affiche CircularProgressIndicator
    deactivate UI
    
    activate VM
    VM->>Repo: getArticles()
    deactivate VM
    
    activate Repo
    Repo->>API: Simulation de requête HTTP<br/>(Future.delayed 1.5s)
    activate API
    API-->>Repo: Données JSON simulées
    deactivate API
    Repo->>Repo: Parse les données
    Repo-->>VM: List<Article> (5 articles)
    deactivate Repo
    
    activate VM
    VM->>VM: _articles = liste reçue
    VM->>VM: _isLoading = false
    VM->>UI: notifyListeners()
    deactivate VM
    
    activate UI
    Note over UI:  Rebuild automatique
    UI->>UI: Affiche ListView avec les articles
    deactivate UI
```

###  Code correspondant à chaque étape

```mermaid
flowchart TD
    START([App démarre]) --> STEP1
    
    STEP1["<b>1. main.dart</b><br/>ChangeNotifierProvider<br/>create: HomeViewModel()"]
    
    STEP1 --> STEP2["<b>2. home_view_model.dart</b><br/>Constructeur appelé<br/>loadArticles() lancé"]
    
    STEP2 --> STEP3["<b>3. home_view_model.dart</b><br/>_isLoading = true<br/>notifyListeners()"]
    
    STEP3 --> STEP4["<b>4. home_page.dart</b><br/>build() appelé<br/>if (viewModel.isLoading)<br/>→ CircularProgressIndicator"]
    
    STEP4 --> STEP5["<b>5. home_view_model.dart</b><br/>await repository.getArticles()"]
    
    STEP5 --> STEP6["<b>6. article_repository.dart</b><br/>Future.delayed(1.5s)<br/>return liste d'articles"]
    
    STEP6 --> STEP7["<b>7. home_view_model.dart</b><br/>_articles = résultat<br/>_isLoading = false<br/>notifyListeners()"]
    
    STEP7 --> STEP8["<b>8. home_page.dart</b><br/>build() appelé<br/>ListView.builder(articles)"]
    
    STEP8 --> END([Articles affichés])
    
    style START fill:#ffd700
    style STEP1 fill:#ffd700
    style STEP4 fill:#fff4e1
    style STEP8 fill:#fff4e1
    style STEP2 fill:#ffe1f5
    style STEP3 fill:#ffe1f5
    style STEP5 fill:#ffe1f5
    style STEP7 fill:#ffe1f5
    style STEP6 fill:#e1ffe1
    style END fill:#90EE90
```

---

## 5. Qui appelle qui ?

###  Diagramme d'appels de méthodes

```mermaid
graph TB
    subgraph " home_page.dart (VIEW)"
        BUILD[build method]
        WATCH["context.watch<HomeViewModel>()"]
        ONPRESS["FloatingActionButton<br/>onPressed: vm.refresh"]
    end
    
    subgraph " home_view_model.dart (VIEWMODEL)"
        CONSTRUCTOR[Constructeur]
        LOAD[loadArticles method]
        REFRESH[refresh method]
        NOTIFY[notifyListeners method]
        STATE["État: _articles, _isLoading"]
        GETTERS["Getters: articles, isLoading"]
    end
    
    subgraph " article_repository.dart (MODEL)"
        GET[getArticles method]
        PARSE["Parse et retourne<br/>List<Article>"]
    end
    
    BUILD --> WATCH
    WATCH --> GETTERS
    ONPRESS --> REFRESH
    
    CONSTRUCTOR --> LOAD
    REFRESH --> LOAD
    LOAD --> GET
    GET --> PARSE
    PARSE --> LOAD
    LOAD --> STATE
    LOAD --> NOTIFY
    NOTIFY --> BUILD
    STATE --> GETTERS
    
    style BUILD fill:#fff4e1
    style WATCH fill:#fff4e1
    style ONPRESS fill:#fff4e1
    style CONSTRUCTOR fill:#ffe1f5
    style LOAD fill:#ffe1f5
    style REFRESH fill:#ffe1f5
    style NOTIFY fill:#ffe1f5
    style STATE fill:#ffe1f5
    style GETTERS fill:#ffe1f5
    style GET fill:#e1ffe1
    style PARSE fill:#e1ffe1
```

### 🔗 Dépendances entre fichiers

```mermaid
graph LR
    subgraph MAIN["main.dart"]
        M[Configure Provider<br/>Lance l'app]
    end
    
    subgraph VIEW["home_page.dart"]
        V[Affiche UI<br/>Utilise ViewModel]
    end
    
    subgraph VM["home_view_model.dart"]
        V2[Gère l'état<br/>Utilise Repository]
    end
    
    subgraph REPO["article_repository.dart"]
        R[Fournit données<br/>Utilise Article]
    end
    
    subgraph MODEL["article.dart"]
        A[Définit structure]
    end
    
    M -->|crée| V
    M -->|crée| V2
    M -->|crée| R
    
    V -->|importe| V2
    V2 -->|importe| R
    V2 -->|importe| A
    R -->|importe| A
    
    style M fill:#ffd700
    style V fill:#fff4e1
    style V2 fill:#ffe1f5
    style R fill:#e1ffe1
    style A fill:#e1ffe1
```

---

## 6. Où est quoi dans le code ?

###  Cartographie complète

```mermaid
graph TB
    subgraph " VIEW = UI/INTERFACE"
        V1["home_page.dart<br/><br/> Widgets (Scaffold, ListView)<br/> context.watch<br/> Appelle vm.loadArticles<br/><br/> PAS de logique métier<br/> PAS de _variables privées<br/> PAS d'appel direct au Repository"]
    end
    
    subgraph " VIEWMODEL = CERVEAU"
        VM1["home_view_model.dart<br/><br/> État privé (_articles, _isLoading)<br/> Getters publics (articles, isLoading)<br/> Méthodes métier (loadArticles)<br/> notifyListeners<br/> extends ChangeNotifier<br/><br/> PAS de import flutter/material<br/> PAS de Widget<br/> PAS de BuildContext"]
    end
    
    subgraph " MODEL = DONNÉES"
        M1["article.dart<br/><br/> Classe pure<br/> Propriétés final<br/> fromJson / toJson<br/><br/> PAS de logique<br/> PAS de ChangeNotifier"]
        
        M2["article_repository.dart<br/><br/> Future<List<Article>><br/> Appels API/DB<br/> Gestion erreurs<br/><br/> PAS de notifyListeners<br/> PAS d'état global"]
    end
    
    V1 -->|utilise| VM1
    VM1 -->|utilise| M1
    VM1 -->|utilise| M2
    M2 -->|retourne| M1
    
    style V1 fill:#fff4e1
    style VM1 fill:#ffe1f5
    style M1 fill:#e1ffe1
    style M2 fill:#e1ffe1
```

###  Contenu de chaque fichier (simplifié)

```mermaid
classDiagram
    class HomePage {
         VIEW
        +build(context) Widget
        +_buildBody() Widget
        -context.watch~HomeViewModel~()
    }
    
    class HomeViewModel {
         VIEWMODEL
        -_articles List~Article~
        -_isLoading bool
        -_errorMessage String?
        +articles List~Article~
        +isLoading bool
        +loadArticles() Future~void~
        +refresh() Future~void~
        +notifyListeners() void
    }
    
    class ArticleRepository {
         REPOSITORY
        +getArticles() Future~List~Article~~
        +getArticleById(id) Future~Article?~
        +addArticle(article) Future~bool~
    }
    
    class Article {
         MODEL
        +id int
        +titre String
        +description String
        +auteur String
        +datePublication DateTime
        +fromJson(json) Article
        +toJson() Map
    }
    
    HomePage ..> HomeViewModel : utilise
    HomeViewModel ..> ArticleRepository : utilise
    HomeViewModel ..> Article : manipule
    ArticleRepository ..> Article : retourne
```

---

## 7. Les 3 règles d'or

###  Règle 1 : La View est BÊTE

```mermaid
flowchart LR
    subgraph GOOD["✅ BON"]
        G1["View appelle<br/>vm.loadArticles()"]
        G2["View affiche<br/>vm.articles"]
    end
    
    subgraph BAD["❌ MAUVAIS"]
        B1["View fait<br/>http.get()"]
        B2["View calcule<br/>des statistiques"]
    end
    
    style GOOD fill:#90EE90
    style BAD fill:#FFB6C6
```

**En code :**

```dart
// ✅ BON
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();
    
    if (vm.isLoading) return CircularProgressIndicator();
    return ListView.builder(itemCount: vm.articles.length, ...);
  }
}

// ❌ MAUVAIS
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final articles = http.get('api.com/articles'); // ❌ Logique dans la View !
    final count = articles.where((a) => a.likes > 10).length; // ❌ Calcul dans la View !
    return ListView(...);
  }
}
```

---

###  Règle 2 : Le ViewModel ne connaît PAS Flutter

```mermaid
flowchart LR
    subgraph GOOD["✅ BON"]
        G1["ViewModel retourne<br/>List&lt;Article&gt;"]
        G2["ViewModel retourne<br/>bool, String, int"]
    end
    
    subgraph BAD["❌ MAUVAIS"]
        B1["ViewModel retourne<br/>Widget"]
        B2["ViewModel utilise<br/>BuildContext"]
    end
    
    style GOOD fill:#90EE90
    style BAD fill:#FFB6C6
```

**En code :**

```dart
// ✅ BON
class HomeViewModel extends ChangeNotifier {
  List<Article> get articles => _articles;
  bool get isLoading => _isLoading;
  
  Future<void> loadArticles() async { ... }
}

// ❌ MAUVAIS
class HomeViewModel extends ChangeNotifier {
  Widget buildArticleCard(BuildContext context) { // ❌ Widget dans ViewModel !
    return Card(...);
  }
  
  void showDialog(BuildContext context) { // ❌ BuildContext dans ViewModel !
    showDialog(...);
  }
}
```

---

###  Règle 3 : Le flux est UNIDIRECTIONNEL

```mermaid
flowchart TB
    USER[" UTILISATEUR"]
    VIEW[" VIEW"]
    VM[" VIEWMODEL"]
    MODEL[" MODEL"]
    
    USER -->|"1. Clique"| VIEW
    VIEW -->|"2. Appelle méthode"| VM
    VM -->|"3. Demande données"| MODEL
    MODEL -->|"4. Retourne données"| VM
    VM -->|"5. notifyListeners"| VIEW
    VIEW -->|"6. Affiche"| USER
    
    style USER fill:#e1f5ff
    style VIEW fill:#fff4e1
    style VM fill:#ffe1f5
    style MODEL fill:#e1ffe1
```

**Interdits :**
- ❌ View → Model directement (sauter le ViewModel)
- ❌ Model → View directement (le Model ne connaît pas la View)
- ❌ Model → ViewModel (pas de notifyListeners dans le Model)

---

## 8. Comparaison : Avec et sans MVVM

### 🔴 SANS MVVM (tout mélangé)

```mermaid
graph TD
    WIDGET["HomePage<br/><br/>• Widgets<br/>• Logique<br/>• Appels API<br/>• État<br/>• Calculs<br/><br/>😵 TOUT MÉLANGÉ"]
    
    API[("API")]
    DB[("DB")]
    
    WIDGET <--> API
    WIDGET <--> DB
    
    style WIDGET fill:#FFB6C6
```

**Problèmes :**
- ❌ Difficile à tester
- ❌ Difficile à maintenir
- ❌ Impossible de réutiliser la logique
- ❌ Code "spaghetti"

---

###  AVEC MVVM (séparé)

```mermaid
graph TD
    subgraph CLEAN[" PROPRE ET ORGANISÉ"]
        VIEW[" View<br/>Juste l'affichage"]
        VM[" ViewModel<br/>Toute la logique"]
        MODEL[" Model<br/>Les données"]
    end
    
    API[("API")]
    DB[("DB")]
    
    VIEW --> VM
    VM --> MODEL
    MODEL --> API
    MODEL --> DB
    
    style VIEW fill:#fff4e1
    style VM fill:#ffe1f5
    style MODEL fill:#e1ffe1
    style CLEAN fill:#90EE90
```

**Avantages :**
-  Facile à tester (chaque couche séparément)
-  Facile à maintenir (responsabilités claires)
-  Réutilisable (même ViewModel pour mobile/web/desktop)
-  Code propre et lisible

---

## 9. Récapitulatif visuel final

```mermaid
mindmap
  root((MVVM<br/>en Flutter))
     VIEW
      Fichiers
        home_page.dart
      Rôle
        Afficher
        Écouter ViewModel
        Capter interactions
      Outils
        StatelessWidget
        context.watch
        Widgets Flutter
      Règles
        PAS de logique
        PAS d'appels API
        PAS de calculs
     VIEWMODEL
      Fichiers
        home_view_model.dart
      Rôle
        Contenir l'état
        Gérer la logique
        Notifier la View
      Outils
        ChangeNotifier
        notifyListeners
        Getters/Setters
      Règles
        PAS de Widgets
        PAS de BuildContext
        PAS d'import Flutter
     MODEL
      Fichiers
        article.dart
        article_repository.dart
      Rôle
        Définir données
        Accéder API/DB
        Parser JSON
      Outils
        Classes Dart pures
        Future async/await
        fromJson/toJson
      Règles
        PAS de notifyListeners
        PAS d'état global
        PAS de ViewModel
```

---

## 10. Aide-mémoire (Cheat Sheet)

|  Question |  View |  ViewModel |  Model |
|------------|---------|--------------|----------|
| **Où mettre les widgets ?** | ✅ Oui | ❌ Non | ❌ Non |
| **Où mettre l'état ?** | ❌ Non | ✅ Oui (_variables) | ❌ Non |
| **Où mettre la logique ?** | ❌ Non | ✅ Oui (méthodes) | ❌ Non |
| **Où appeler l'API ?** | ❌ Non | ❌ Non | ✅ Oui (Repository) |
| **Où parser le JSON ?** | ❌ Non | ❌ Non | ✅ Oui (fromJson) |
| **Où utiliser notifyListeners ?** | ❌ Non | ✅ Oui | ❌ Non |
| **Où utiliser context.watch ?** | ✅ Oui | ❌ Non | ❌ Non |
| **Testable sans Flutter ?** | ❌ Non | ✅ Oui | ✅ Oui |

---

##  Conclusion

MVVM, c'est comme une équipe :

```mermaid
graph LR
    A[" View<br/>Le présentateur<br/><i>Affiche ce qu'on lui dit</i>"]
    B[" ViewModel<br/>Le chef d'orchestre<br/><i>Coordonne tout</i>"]
    C[" Model<br/>Le fournisseur<br/><i>Apporte les données</i>"]
    
    A -.->|demande| B
    B -.->|commande| C
    C -.->|livre| B
    B -.->|prévient| A
    
    style A fill:#fff4e1
    style B fill:#ffe1f5
    style C fill:#e1ffe1
```

**Chacun son job, tout est clair !** 

---

##  Pour aller plus loin

-  [README.md](README.md) - Vue d'ensemble du projet
-  [01-ARCHITECTURE.md](01-ARCHITECTURE.md) - Guide détaillé
-  [02-EXAMPLES.md](02-EXAMPLES.md) - Exemples pratiques
-  [QUICKSTART.md](QUICKSTART.md) - Démarrage rapide

---

**Créé avec  pour apprendre MVVM en Flutter**


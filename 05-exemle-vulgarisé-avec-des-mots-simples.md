### 1. MVVM = 3 trucs seulement

```text
+--------+      +-----------+      +--------+
|  Vue   | ---> | ViewModel | ---> |  Modèle|
| (UI)   |      | (logique) |      | (data) |
+--------+      +-----------+      +--------+
```

* **Vue** : ce que l’utilisateur voit (écran, boutons, textes).
* **ViewModel** : le “cerveau” de l’écran (quoi afficher, quoi faire).
* **Modèle** : les données (un `User`, un `Article`, etc.).

---

### 2. Exemple concret Flutter (un seul écran)

```text
+-------------------------+
|  HomePage (Widget)      |  <-- Vue
+------------+------------+
             |
             v
+-------------------------+
| HomeViewModel           |  <-- ViewModel
| - listeArticles         |
| - chargerArticles()     |
+------------+------------+
             |
             v
+-------------------------+
| Article (class)         |  <-- Modèle
| ArticleRepository       |
+-------------------------+
```

---

### 3. Comment ça se parle 

1. **HomePage** = écran → affiche la liste.
2. Elle demande à **HomeViewModel** :
   « Donne-moi la liste d’articles ».
3. **HomeViewModel** demande au **Modèle** (repository, classes) les données.
4. Quand il reçoit la liste, il prévient la **Vue**.
5. La **Vue** se reconstruit avec les nouvelles données.

---

### 4. Mini structure de projet

```text
lib/
  ui/
    home_page.dart        // Vue (Widget)
  viewmodels/
    home_view_model.dart  // ViewModel
  models/
    article.dart          // Modèle (données)
```


/// MODEL : Classe de données représentant un Article
/// 
/// Cette classe est PURE : elle ne contient que des données,
/// pas de logique métier ni d'accès à l'UI.
class Article {
  final int id;
  final String titre;
  final String description;
  final String auteur;
  final DateTime datePublication;

  Article({
    required this.id,
    required this.titre,
    required this.description,
    required this.auteur,
    required this.datePublication,
  });

  /// Factory pour créer un Article depuis un JSON
  /// (utile quand on reçoit des données d'une API)
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] as int,
      titre: json['titre'] as String,
      description: json['description'] as String,
      auteur: json['auteur'] as String,
      datePublication: DateTime.parse(json['datePublication'] as String),
    );
  }

  /// Convertir un Article en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'description': description,
      'auteur': auteur,
      'datePublication': datePublication.toIso8601String(),
    };
  }
}


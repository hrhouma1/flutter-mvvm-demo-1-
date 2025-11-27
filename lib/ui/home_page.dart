import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/home_view_model.dart';
import '../models/article.dart';

/// VIEW : Interface utilisateur de la page d'accueil
/// 
/// Responsabilités :
/// 1. AFFICHER ce que le ViewModel lui donne
/// 2. RÉAGIR aux interactions utilisateur
/// 3. APPELER les méthodes du ViewModel (jamais modifier directement les données)
/// 
/// La View ne contient PAS de logique métier.
/// Elle est BÊTE : elle affiche et transmet les events au ViewModel.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // On récupère le ViewModel grâce à Provider
    // context.watch = on écoute les changements (rebuild automatique)
    final viewModel = context.watch<HomeViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('📚 Articles MVVM'),
        elevation: 2,
        actions: [
          // Bouton pour afficher les stats
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => _showStats(context, viewModel),
            tooltip: 'Statistiques',
          ),
        ],
      ),
      body: _buildBody(context, viewModel),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddArticleDialog(context, viewModel),
        child: const Icon(Icons.add),
        tooltip: 'Ajouter un article',
      ),
    );
  }

  /// Construit le corps de la page selon l'état du ViewModel
  Widget _buildBody(BuildContext context, HomeViewModel viewModel) {
    // 1. Si on charge, on affiche un spinner
    if (viewModel.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Chargement des articles...'),
          ],
        ),
      );
    }

    // 2. Si erreur, on affiche un message
    if (viewModel.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                viewModel.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: viewModel.loadArticles,
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }

    // 3. Si pas d'articles, on affiche un message vide
    if (!viewModel.hasArticles) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.article_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Aucun article disponible'),
          ],
        ),
      );
    }

    // 4. Sinon, on affiche la liste avec pull-to-refresh
    return RefreshIndicator(
      onRefresh: viewModel.refresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: viewModel.articles.length,
        itemBuilder: (context, index) {
          final article = viewModel.articles[index];
          return _ArticleCard(article: article);
        },
      ),
    );
  }

  /// Affiche un dialogue avec les statistiques
  void _showStats(BuildContext context, HomeViewModel viewModel) {
    final stats = viewModel.getArticleCountByAuthor();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('📊 Statistiques'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total d\'articles : ${viewModel.articles.length}'),
            const SizedBox(height: 16),
            const Text('Articles par auteur :', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...stats.entries.map((entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text('• ${entry.key} : ${entry.value}'),
            )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  /// Affiche un dialogue pour ajouter un article (simplifié)
  void _showAddArticleDialog(BuildContext context, HomeViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('➕ Ajouter un article'),
        content: const Text(
          'Fonctionnalité de démo :\n\n'
          'Dans une vraie app, il y aurait un formulaire ici.\n\n'
          'Le principe reste le même : la View collecte les données '
          'et appelle viewModel.addArticle().',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

/// Widget réutilisable pour afficher un article
class _ArticleCard extends StatelessWidget {
  final Article article;

  const _ArticleCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 2,
      child: InkWell(
        onTap: () => _showArticleDetails(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre
              Text(
                article.titre,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              // Description
              Text(
                article.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              
              // Auteur et date
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    article.auteur,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const Spacer(),
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(article.datePublication),
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Affiche les détails d'un article
  void _showArticleDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(article.titre),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(article.description),
              const SizedBox(height: 16),
              Text(
                'Auteur : ${article.auteur}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Date : ${_formatDate(article.datePublication)}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  /// Formate une date en français
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}


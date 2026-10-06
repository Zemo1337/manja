import 'dart:io';

import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/database.dart';

class RecipePhoto extends StatelessWidget {
  const RecipePhoto({super.key, required this.recipe, this.cacheWidth, this.fit = BoxFit.cover});

  final Recipe recipe;
  final int? cacheWidth;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final path = recipe.photoPath;
    if (path == null) return RecipeInitial(name: recipe.name);
    return Image.file(
      AppScope.of(context).photos.file(path),
      fit: fit,
      cacheWidth: cacheWidth,
      errorBuilder: (_, _, _) => RecipeInitial(name: recipe.name),
    );
  }
}

class PickedPhoto extends StatelessWidget {
  const PickedPhoto({super.key, required this.file, this.fit = BoxFit.cover});

  final File file;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) =>
      Image.file(file, fit: fit, errorBuilder: (_, _, _) => const Center(child: Icon(Icons.broken_image_outlined)));
}

class RecipeInitial extends StatelessWidget {
  const RecipeInitial({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ColoredBox(
      color: scheme.primaryContainer,
      child: Center(
        child: Text(
          name.isEmpty ? '?' : name.characters.first.toUpperCase(),
          style: TextStyle(color: scheme.onPrimaryContainer, fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

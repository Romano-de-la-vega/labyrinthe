# Labyrinthe 3D

Ce dépôt contient un exemple minimal de jeu de labyrinthe 3D en vue du dessus.

- `src/maze_generator.py` : génération procédurale du labyrinthe en Python
  (algorithme de backtracking récursif). Le script produit une grille JSON
  pouvant être importée dans un moteur de jeu.
- `godot/` : scripts GDScript pour Godot 4 permettant de créer le joueur,
  le labyrinthe et l'interface (timer et message de victoire).

Pour tester la génération Python :

```bash
python src/maze_generator.py
```

Les scripts GDScript supposent l'existence d'actions d'entrée :
`move_forward`, `move_back`, `move_left`, `move_right` et `restart`.
Elles peuvent être mappées respectivement aux touches Z, S, Q, D (ou
flèches) et R dans le projet Godot.

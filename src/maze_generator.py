"""Maze generator using recursive backtracking.

This module provides a Maze class which can generate a maze grid using
recursive backtracking. The grid can be exported to JSON for consumption
by other engines like Godot.
"""

from __future__ import annotations
from dataclasses import dataclass
from typing import List, Tuple, Dict
import json
import random


@dataclass
class Cell:
    x: int
    y: int
    walls: Dict[str, bool]

    def __init__(self, x: int, y: int) -> None:
        self.x = x
        self.y = y
        # Each cell starts with walls on all sides
        self.walls = {"N": True, "S": True, "E": True, "W": True}

    def knock_down(self, other: "Cell") -> None:
        dx = other.x - self.x
        dy = other.y - self.y
        if dx == 1:
            self.walls["E"] = False
            other.walls["W"] = False
        elif dx == -1:
            self.walls["W"] = False
            other.walls["E"] = False
        elif dy == 1:
            self.walls["S"] = False
            other.walls["N"] = False
        elif dy == -1:
            self.walls["N"] = False
            other.walls["S"] = False


class Maze:
    """Generates and stores a maze grid."""

    def __init__(self, width: int, height: int) -> None:
        self.width = width
        self.height = height
        self.grid: List[List[Cell]] = [
            [Cell(x, y) for x in range(width)] for y in range(height)
        ]

    def generate(self, start: Tuple[int, int] = (0, 0)) -> None:
        """Generate the maze starting from the given cell."""
        stack = []
        x, y = start
        stack.append(self.grid[y][x])
        visited = {start}

        while stack:
            current = stack[-1]
            neighbors = self._unvisited_neighbors(current, visited)
            if neighbors:
                nxt = random.choice(neighbors)
                current.knock_down(nxt)
                stack.append(nxt)
                visited.add((nxt.x, nxt.y))
            else:
                stack.pop()

    def _unvisited_neighbors(self, cell: Cell, visited: set) -> List[Cell]:
        neighbors = []
        directions = [(0, -1), (1, 0), (0, 1), (-1, 0)]
        for dx, dy in directions:
            nx, ny = cell.x + dx, cell.y + dy
            if 0 <= nx < self.width and 0 <= ny < self.height and (nx, ny) not in visited:
                neighbors.append(self.grid[ny][nx])
        return neighbors

    def to_grid(self) -> List[List[int]]:
        """Convert the maze to a simple integer grid.

        0 represents a path and 1 represents a wall.
        This grid doubles the size to account for walls between cells.
        """
        grid_width = self.width * 2 + 1
        grid_height = self.height * 2 + 1
        result = [[1] * grid_width for _ in range(grid_height)]

        for y in range(self.height):
            for x in range(self.width):
                cx, cy = x * 2 + 1, y * 2 + 1
                result[cy][cx] = 0
                cell = self.grid[y][x]
                if not cell.walls["N"]:
                    result[cy - 1][cx] = 0
                if not cell.walls["S"]:
                    result[cy + 1][cx] = 0
                if not cell.walls["E"]:
                    result[cy][cx + 1] = 0
                if not cell.walls["W"]:
                    result[cy][cx - 1] = 0
        return result

    def to_json(self) -> str:
        """Export the maze grid to JSON."""
        return json.dumps(self.to_grid())


if __name__ == "__main__":
    random.seed(0)
    maze = Maze(5, 5)
    maze.generate()
    print(maze.to_json())

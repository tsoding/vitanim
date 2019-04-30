import sdl2/sdl
import grid

type Cell* = enum
  Dead, Alive

proc toColor(cell: Cell): Color =
  case cell
  of Dead:
    Color(r: 0, g: 0, b: 0, a: 255)
  of Alive:
    Color(r: 255, g: 0, b: 0, a: 255)

proc render*[W, H: static[int]](grid: Grid[W, H, Cell], renderer: Renderer) =
  grid.map(toColor).render(renderer)

proc neighbors[W, H: static[int]](grid: Grid[W, H, Cell], i, j: int): int =
  for dj in -1..1:
    for di in -1..1:
      if (dj != 0 or di != 0) and
         0 <= i + di and i + di < W and
         0 <= j + dj and j + dj < H and
         grid[i + di][j + dj] == Alive:
        inc result

proc next[W, H: static[int]](grid: Grid[W, H, Cell], i, j: int): Cell =
  let ns = neighbors(grid, i, j)
  case grid[i][j]
  of Dead:
    if ns == 3: Alive else: Dead
  of Alive:
    if 2 <= ns and ns <= 3: Alive else: Dead

proc next*[W, H: static[int]](grid: Grid[W, H, Cell]): Grid[W, H, Cell] =
  for j in 0..<H:
    for i in 0..<W:
      result[i][j] = grid.next(i, j)

proc `not`*(cell: Cell): Cell =
  case cell:
    of Alive: Dead
    of Dead: Alive

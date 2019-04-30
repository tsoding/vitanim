import sdl2
import grid

type Cell = enum
  Dead, Alive

proc toColor(cell: Cell): Color =
  case cell
  of Dead:
    (r: uint8(0), g: uint8(0), b: uint8(0), a: uint8(255))
  of Alive:
    (r: uint8(255), g: uint8(0), b: uint8(0), a: uint8(255))

proc render[W, H: static[int]](grid: Grid[W, H, Cell], renderer: RendererPtr) =
  grid.map(toColor).render(renderer)

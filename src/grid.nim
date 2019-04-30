import sdl2/sdl

type Grid*[W, H: static[int], T] = array[H, array[W, T]]

proc render*[W, H: static[int]](grid: Grid[W, H, Color], renderer: Renderer) =
  var rect: Rect
  renderer.renderGetViewport(addr rect)
  let
    cellWidth = rect.w.float / W.float
    cellHeight = rect.h.float / H.float
  for j in 0..<H:
    for i in 0..<W:
      var rect = Rect(x: (i.float * cellWidth).cint, y: (j.float * cellHeight).cint,
                      w: cellWidth.cint, h: cellHeight.cint)
      discard renderer.setRenderDrawColor grid[i][j]
      discard renderer.renderFillRect(addr rect)

proc checkPattern*[W, H: static[int], T](a, b: T): Grid[W, H, T] =
  for j in 0..<H:
    for i in 0..<W:
      if (i + j) mod 2 == 0:
        result[i][j] = a
      else:
        result[i][j] = b

proc fill*[W, H: static[int], T](value: T): Grid[W, H, T] =
  for j in 0..<H:
    for i in 0..<W:
      result[i][j] = value

proc sparse*[W, H: static[int], T](default: T, xs: seq[(int, int, T)]): Grid[W, H, T] =
  result = fill[W, H, T](default)
  for x in xs:
    let (i, j, value) = x
    result[i][j] = value

proc map*[W, H: static[int], T, U](grid: Grid[W, H, T], f: proc(t: T): U): Grid[W, H, U] =
  for j in 0..<H:
    for i in 0..<W:
      result[i][j] = f(grid[i][j])

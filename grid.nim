import sdl2

type Grid*[W, H: static[int], T] =
  array[0 .. H - 1, array[0 .. W - 1, T]]

proc render*[W, H: static[int]](grid: Grid[W, H, Color], renderer: RendererPtr) =
  var rect: Rect
  renderer.getViewPort(rect)
  let cellWidth = rect.w.float / W.float
  let cellHeight = rect.h.float / H.float
  for j in 0..H-1:
    for i in 0..W-1:
      var cell: Rect = (x: (i.float * cellWidth).cint, y: (j.float * cellHeight).cint,
                        w: cellWidth.cint, h: cellHeight.cint)
      renderer.setDrawColor(
        grid[i][j].r, grid[i][j].g, grid[i][j].b,
        grid[i][j].a)
      renderer.fillRect(cell)

proc checkPattern*[W, H: static[int], T](a: T, b: T): Grid[W, H, T] =
  for j in 0 .. H - 1:
    for i in 0 .. W - 1:
      if (i + j) mod 2 == 0:
        result[i][j] = a
      else:
        result[i][j] = b

proc fill*[W, H: static[int], T](value: T): Grid[W, H, T] =
  for j in 0..H-1:
    for i in 0..W-1:
      result[i][j] = value

proc sparse*[W, H: static[int], T](default: T, xs: seq[(int, int, T)]): Grid[W, H, T] =
  result = fill[W, H, T](default)
  for x in xs:
    let (i, j, value) = x
    result[i][j] = value

proc map*[W, H: static[int], T, U](grid: Grid[W, H, T], f: proc(t: T): U): Grid[W, H, U] =
  for j in 0..H-1:
    for i in 0..W-1:
      result[i][j] = f(grid[i][j])

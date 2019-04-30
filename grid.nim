import sdl2

type Grid*[W, H: static[int]] =
  array[0 .. H - 1, array[0 .. W - 1, Color]]

proc render*[W, H: static[int]](grid: Grid[W, H], renderer: RendererPtr) =
  # TODO: how to just initialize this with default value?
  var rect: Rect = (x: cint(0), y: cint(0), w: cint(50), h: cint(50))
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

proc checkPattern*[W, H: static[int]](a: Color, b: Color): Grid[W, H] =
  for j in 0 .. H - 1:
    for i in 0 .. W - 1:
      if (i + j) mod 2 == 0:
        result[i][j] = a
      else:
        result[i][j] = b

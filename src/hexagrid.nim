import sdl2/sdl
import sequtils
import math

proc neighbors*(cell : (int, int)): seq[tuple[x, y: int]] =
  let (x, y) = cell
  result = @[(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)]
  if x mod 2 == 0:
    result = concat(result, @[(x + 1, y + 1), (x - 1, y + 1)])
  else:
    result = concat(result, @[(x + 1, y - 1), (x - 1, y - 1)])

proc drawRegularPolygon*(renderer: Renderer, center: tuple[x, y: float], radius: float, n: int, a = 0.0) =
  let angle = 2.0 * PI / n.float
  for i in 0..<n:
    let x0 = cos(i.float * angle + a) * radius + center.x
    let y0 = sin(i.float * angle + a) * radius + center.y
    let x1 = cos((i + 1).float * angle + a) * radius + center.x
    let y1 = sin((i + 1).float * angle + a) * radius + center.y
    discard renderer.renderDrawLine(x0.cint, y0.cint, x1.cint, y1.cint)

# TODO: drawHexagrid does not stick cells together
proc drawHexagrid*(renderer: Renderer, W, H: int) =
  var rect: Rect
  renderer.renderGetViewport(addr rect)
  let radius = rect.w.float / W.float
  let halfRadius = radius * 0.5
  for y in 0..<H:
    for x in 0..<W:
      if x mod 2 == 0:
        renderer.drawRegularPolygon((x.float * radius + halfRadius, y.float * radius + halfRadius), halfRadius, 6)
      else:
        renderer.drawRegularPolygon((x.float * radius + halfRadius, y.float * radius + radius), halfRadius, 6)


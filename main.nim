import sdl2

type Grid[W, H: static[int]] =
  array[0 .. H - 1, array[0 .. W - 1, Color]]

proc render[W, H: static[int]](grid: Grid[W, H], renderer: RendererPtr) =
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

proc limitFrameRate(frameTime: var uint32, targetFramePeriod: uint32) =
  let now = getTicks()
  if frameTime > now:
    delay(frameTime - now)
  frameTime += targetFramePeriod

proc checkPattern[W, H: static[int]](a: Color, b: Color): Grid[W, H] =
  for j in 0 .. H - 1:
    for i in 0 .. W - 1:
      if (i + j) mod 2 == 0:
        result[i][j] = a
      else:
        result[i][j] = b

const red: Color = (r: uint8(255), g: uint8(0), b: uint8(0), a: uint8(255))
const black: Color = (r: uint8(0), g: uint8(0), b: uint8(0), a: uint8(255))
const gameGrid = checkPattern[10, 10](red, black)

proc main() =
  sdl2.init(INIT_EVERYTHING)
  defer: sdl2.quit()

  var screenWidth: cint = 640
  var screenHeight: cint = 480

  var window = createWindow(
    "Vitanim", 100, 100,
    screenWidth, screenHeight,
    SDL_WINDOW_SHOWN or SDL_WINDOW_RESIZABLE)
  defer: destroy(window)

  var renderer = createRenderer(window, -1, 0)
  defer: destroy(renderer)

  let targetFramePeriod: uint32 = 20
  var frameTime: uint32 = 0

  var evt = sdl2.defaultEvent
  var runGame = true

  while runGame:
    while pollEvent(evt):
      # TODO: can we just use case here 4Head
      if evt.kind == QuitEvent:
        runGame = false
        break

    renderer.setDrawColor(0, 0, 0, 255)
    renderer.clear()
    gameGrid.render(renderer)
    renderer.present()
    limitFrameRate(frameTime, targetFramePeriod)

when isMainModule: main()

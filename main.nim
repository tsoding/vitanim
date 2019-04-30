import sdl2
import grid
import conway

proc limitFrameRate(frameTime: var uint32, targetFramePeriod: uint32) =
  let now = getTicks()
  if frameTime > now:
    delay(frameTime - now)
  frameTime += targetFramePeriod

const red: Color = (r: uint8(255), g: uint8(0), b: uint8(0), a: uint8(255))
const black: Color = (r: uint8(0), g: uint8(0), b: uint8(0), a: uint8(255))

proc main() =
  sdl2.init(INIT_EVERYTHING)
  defer: sdl2.quit()

  var screenWidth: cint = 640
  var screenHeight: cint = 480
  var gameGrid = sparse[10, 10, Cell](
    Dead, @[(1, 0, Alive), (2, 1, Alive), (0, 2, Alive), (1, 2, Alive), (2, 2, Alive)])

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
      case evt.kind:
        of QuitEvent:
          runGame = false
        of MouseButtonDown:
          gameGrid = gameGrid.next()
        else:
          discard

    renderer.setDrawColor(0, 0, 0, 255)
    renderer.clear()
    gameGrid.render(renderer)
    renderer.present()
    limitFrameRate(frameTime, targetFramePeriod)

when isMainModule: main()

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
const gameGrid = checkPattern[100, 100, Color](red, black)

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

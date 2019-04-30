import sdl2
import grid
import conway

proc limitFrameRate(frameTime: var uint32, targetFramePeriod: uint32) =
  let now = getTicks()
  if frameTime > now:
    delay(frameTime - now)
  frameTime += targetFramePeriod

proc main() =
  sdl2.init(INIT_EVERYTHING)
  defer: sdl2.quit()

  const gridWidth = 20
  const gridHeight = 20

  var screenWidth: cint = 640
  var screenHeight: cint = 480
  var gameGrid = sparse[gridWidth, gridHeight, Cell](
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
        # TODO: there is no way to clean the field
        of MouseButtonDown:
          var button = cast[MouseButtonEventPtr](addr(evt))
          case button.button:
            of 1:
                var rect: Rect
                renderer.getViewPort(rect)
                let cellWidth = rect.w.float / gridWidth.float
                let cellHeight = rect.h.float / gridHeight.float
                let i = (button.x.float / cellWidth).int
                let j = (button.y.float / cellHeight).int
                gameGrid[i][j] = not gameGrid[i][j]
            of 3:
              gameGrid = gameGrid.next()
            else: discard
        else: discard

    renderer.setDrawColor(0, 0, 0, 255)
    renderer.clear()
    gameGrid.render(renderer)
    renderer.present()
    limitFrameRate(frameTime, targetFramePeriod)

when isMainModule: main()

import sdl2/sdl
import grid, conway, hexagrid

proc limitFrameRate(frameTime: var uint32, targetFramePeriod: uint32) =
  let now = getTicks()
  if frameTime > now:
    delay(frameTime - now)
  frameTime += targetFramePeriod

proc main() =
  discard sdl.init(INIT_EVERYTHING)
  defer: sdl.quit()

  const
    gridWidth = 20
    gridHeight = 20

  var
    screenWidth: cint = 640
    screenHeight: cint = 480
    gameGrid = sparse[gridWidth, gridHeight, Cell](Dead,
      @[(1, 0, Alive), (2, 1, Alive), (0, 2, Alive), (1, 2, Alive), (2, 2, Alive)])

    window = createWindow(
      "Vitanim", 100, 100,
      screenWidth, screenHeight,
      WINDOW_SHOWN or WINDOW_RESIZABLE)
  defer: destroyWindow(window)

  var renderer = createRenderer(window, -1, 0)
  defer: destroyRenderer(renderer)

  let targetFramePeriod: uint32 = 20
  var frameTime: uint32 = 0

  var runGame = true

  while runGame:
    for event in events():
      case event.kind:
        of Quit:
          runGame = false
        of MouseButtonDown:
          let event = event.button
          case event.button:
            of 1:
              var rect: Rect
              renderer.renderGetViewport(addr rect)
              let
                cellWidth = rect.w.float / gridWidth.float
                cellHeight = rect.h.float / gridHeight.float
                i = (event.x.float / cellWidth).int
                j = (event.y.float / cellHeight).int
              gameGrid[i][j] = not gameGrid[i][j]
            of 3:
              gameGrid = gameGrid.next()
            else: discard
        of KeyDown:
          let event = event.key
          case event.keysym.sym:
            of K_F:
              gameGrid = fill[gridWidth, gridHeight, Cell](Dead)
            else: discard
        else: discard

    discard renderer.setRenderDrawColor Color(a: 255)
    discard renderer.renderClear()
    discard renderer.setRenderDrawColor(Color(r: 255, a: 255))
    renderer.drawRegularPolygon((screenWidth.float * 0.5, screenHeight.float * 0.5), 100.0, 6)
    # gameGrid.render(renderer)
    renderer.renderPresent()
    limitFrameRate(frameTime, targetFramePeriod)

when isMainModule:
  main()

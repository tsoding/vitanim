import sequtils

proc neighbors*(cell : (int, int)): seq[tuple[x, y: int]] =
  let (x, y) = cell
  result = @[(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)]
  if x mod 2 == 0:
    result = concat(result, @[(x + 1, y + 1), (x - 1, y + 1)])
  else:
    result = concat(result, @[(x + 1, y - 1), (x - 1, y - 1)])

# 盤面情報
SIDE = 8 # 一辺の長さ 
ASIDE = SIDE + 2 # 局面用配列の一辺 緩衝地帯分２を足す Side for array, add 2
BOARDSIZE = ASIDE * ASIDE # ボードの大きさ　Size of board
UP = (-ASIDE)
DOWN = ASIDE
RIGHT = 1
LEFT = (-1)
# Piece number
B = 1 # BLACK 1
W = 2 # WHITE 2
N = 3 # 番兵 Sentinel (out of board) 3
BLACK_TURN = 0 
WHITE_TURN = 1
PASSMOVE = 99
MOVENUM = 32
# マクロ群
def x (pos)
  pos % ASIDE
end
def y (pos)
  pos / ASIDE
end
def turncolor (turn)
  turn + 1
end
def opponent (turn)
  !turn
end
# true, false
TRUE = 1
FALSE = 0
# AI
INFINITY = 1000 # 十分大きい数を無限大として扱う
SEARCH_LIMIT_DEPTH = 128 # 探索深さの上限
# MODE
module MODE
  NORMAL = 0
  HANDICAP = 1
  WEAK = 2
  REVOLUTION = 3
end
# GUI
WINDOW_SIZE_X = 640
WINDOW_SIZE_Y = 480

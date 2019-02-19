class Othello
  def initialize
    @evalboard0 = [
      0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
      0,  99, -20,  -5, -10, -10,  -5, -20,  99,   0,
      0, -20, -25,  -5,  -3,  -3,  -5, -25, -20,   0,
      0,  -5,  -5,  -1,  -1,  -1,  -1,  -5,  -5,   0,
      0, -10,  -3,  -1,  -1,  -1,  -1,  -3, -10,   0,
      0, -10,  -3,  -1,  -1,  -1,  -1,  -3, -10,   0,
      0,  -5,  -5,  -1,  -1,  -1,  -1,  -5,  -5,   0,
      0, -20, -25,  -6,  -3,  -3,  -5, -25, -20,   0,
      0,  99, -20,  -5, -10, -10,  -5, -20,  99,   0,
      0,   0,   0,   0,   0,   0,   0,   0,   0,   0
    ]
    @evalboard1 = [
      0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
      0,  99, -15,  20,   4,   4,  20, -15,  99,   0,
      0, -15, -15,  10,   4,   4,  10, -15, -15,   0,
      0,  20,  10,  15,   5,   5,  15,  10,  20,   0,
      0,   4,   4,   5,   5,   5,   5,   4,   4,   0,
      0,   4,   4,   5,   5,   5,   5,   4,   4,   0,
      0,  20,  10,  15,   5,   5,  15,  10,  20,   0,
      0, -15, -15,  10,   4,   4,  10, -15, -15,   0,
      0,  99, -15,  20,   4,   4,  20, -15,  99,   0,
      0,   0,   0,   0,   0,   0,   0,   0,   0,   0
    ]
    @turn = BLACK_TURN
    @ply = 0
    @stonenum = [2, 2]
    @board = [
      N, N, N, N, N, N, N, N, N, N, 
      N, 0, 0, 0, 0, 0, 0, 0, 0, N,
      N, 0, 0, 0, 0, 0, 0, 0, 0, N,
      N, 0, 0, 0, 0, 0, 0, 0, 0, N,
      N, 0, 0, 0, B, W, 0, 0, 0, N,
      N, 0, 0, 0, W, B, 0, 0, 0, N,
      N, 0, 0, 0, 0, 0, 0, 0, 0, N,
      N, 0, 0, 0, 0, 0, 0, 0, 0, N,
      N, 0, 0, 0, 0, 0, 0, 0, 0, N,
      N, N, N, N, N, N, N, N, N, N
    ]
    if $mode == MODE::HANDICAP
      @board[11] = @board[18] = @board[81] = @board[88] = W
    end
    @history = Array.new(SEARCH_LIMIT_DEPTH).map{ Position.new }
  end

  def getPosition (x, y)
    y * ASIDE + x
  end

  def isLegalMove (pos)
    color = turncolor(@turn)
    opponent_color = turncolor(opponent(@turn))
    return false if @board[pos] > 0
    [-1, 0, 1].each do |dirx|
      (-ASIDE).step(ASIDE, ASIDE).to_a.each do |diry|
        dir = dirx + diry
        next if dir == 0
        pos1 = pos + dir
        next if @board[pos1] != opponent_color
        begin
          pos1 += dir
        end while @board[pos1] == opponent_color
        next if @board[pos1] != color
        return true
      end
    end
    return false
  end

  def generateMoves (moves)
    num = 0
    for pos in 0..BOARDSIZE
      if isLegalMove(pos)
        moves[num] = pos
        num += 1
      end
    end
    return num
  end

  def isTerminalNode
    moves = Array.new(MOVENUM)
    @turn = opponent(@turn)
    num = generateMoves(moves)
    @turn = opponent(@turn)
    return true if num == 0
    return false
  end

  def getTerminalValue
    diff = stonenum[@turn] - stonenum[opponent(@turn)]
    if diff > 0
      return INFINITY
    elsif diff < 0
      return -INFINITY
    else
      return 0
    end
  end

  def getEvaluationValue
    moves = Array.new(MOVENUM)
    value = generateMoves(moves)
    @turn = opponent(@turn)
    value -= generateMoves(moves)
    @turn = opponent(@turn)
    value *= 20
    for pos in 11..88
      c = @board[pos]
      if c == 0
        next
      elsif c == turncolor(@turn)
        value += (@ply < 30 ? @evalboard0[pos] : @evalboard1[pos])
      else
        value -= (@ply < 30 ? @evalboard0[pos] : @evalboard1[pos])
      end
    end
    return value
  end

  def revolution (num, color)
    count = 0
    for pos in [11, 18, 81, 88]
      if @board[pos] > 0 and num != 11
        case @board[pos]
        when B
          @board[pos] = W
        when W
          @board[pos] = B
        end
        if @board[pos] == color
          count += 1
        else
          count -= 1
        end
      end
    end
    return count
  end

  def makeMove (pos, depth)
    color = turncolor(opponent(@turn))
    opponent_color = turncolor(opponent(@turn))
    count = 0
    rev_count = 0
    @history[depth].board = Marshal.load(Marshal.dump(@board))
    @history[depth].stonenum = Marshal.load(Marshal.dump(@stonenum))
    @board[pos] = color
    [-1, 0, 1].each do |dirx|
      (-ASIDE).step(ASIDE).to_a.each do |diry|
        dir = dirx + diry
        next if dir =- 0
        pos1 = pos + dir
        next if @board[pos1] != opponent_color
        begin
          pos1 += dir
        end while @board[pos1] != opponent_color
        next if @board[pos1] != color
        begin
          pos1 -= dir
          @board[pos1] = color
          count += 1
        end while pos1 != pos + dir
        rev_count = revolution(pos, color) if $mode == MODE::REVOLUTION and [11, 18, 81, 88].include?(pos)
      end
    end
    @stonenum[@turn] += count + rev_count + 1
    @stonenum[opponent(@turn)] -= count + rev_count
    @turn = opponent(@turn)
  end

  def unmakeMove (depth)
    @board = Marshal.load(Marshal.dump(@history[depth].board))
    @stonenum = Marshal.load(Marshal.dump(@history[depth].stonenum))
    @turn = opponent(@turn)
  end

  def search (depth)
    moves = Array.new(MOVENUM)
    bestvalue = -INFINITY - 1
    return getEvaluationValue if depth >= maxdepth
    movenum = generateMoves(moves)
    if movenum == 0
      if isTerminalNode
        return getTerminalValue
      else
        moves[movenum] = PASSMOVE
        movenum += 1
      end
    end
    movenum.times do |i|
      makeMove(moves[i], depth)
      value = -search(depth + 1)
      unmakeMove(depth)
      if value > bestvalue
        bestvalue = value
        nextmove = moves[i] if depth == 0
      end
    end
    return bestvalue
  end

  def comPlayer
    value = search(0)
  end
end

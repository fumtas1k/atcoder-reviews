# -
# ABC482/E
# 木の直径
# 木の中心
# 数え上げ

N = gets.to_i
edges = Array.new(N) { [] }
(N - 1).times do
  u, v = gets.split.map(&:to_i).map(&:pred)
  edges[u] << v
  edges[v] << u
end
C = gets.split.map(&:to_i)

# 最遠頂点と、そこまでの経路を復元するための親を返す。
bfs = ->(start) do
  parent = [-1] * N
  parent[start] = start
  queue = [start]
  last = start
  until queue.empty?
    pos = queue.shift
    last = pos
    edges[pos].each do |to|
      next unless parent[to] == -1
      parent[to] = pos
      queue << to
    end
  end
  [last, parent]
end

s, = bfs.(0)
t, parent = bfs.(s)
path = [t]
path << parent[path[-1]] until path[-1] == s
diameter = path.size - 1

# pre 側には進まず、start から距離 limit の頂点を色別に数える。
count_colors = ->(start, pre, limit) do
  counts = Hash.new(0)
  stack = [[start, pre, 0]]
  until stack.empty?
    pos, from, depth = stack.pop
    if depth == limit
      counts[C[pos]] += 1
      next
    end
    edges[pos].each do |to|
      next if to == from
      stack << [to, pos, depth + 1]
    end
  end
  counts
end

half = diameter / 2
ans = 0
if diameter.odd?
  # 中央の辺の左右から、同色の頂点を1つずつ選ぶ。
  left, right = path[half], path[half + 1]
  left_counts = count_colors.(left, right, half)
  right_counts = count_colors.(right, left, half)
  left_counts.each { |color, cnt| ans += cnt * right_counts[color] }
else
  # 中心から異なる枝へ進んだ頂点どうしを組み合わせる。
  center = path[half]
  total = Hash.new(0)
  edges[center].each do |to|
    counts = count_colors.(to, center, half - 1)
    counts.each { |color, cnt| ans += cnt * total[color] }
    counts.each { |color, cnt| total[color] += cnt }
  end
end
puts ans

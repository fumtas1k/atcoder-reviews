# -
# ABC479/E
# 部分木への加算（全体に足して部分木から引く）
# BFS 順で葉から集計・根から伝播

N = gets.to_i
edges = Array.new(N) { [] }
(1...N).each do |i|
  a, b = gets.split.map(&:to_i).map(&:pred)
  edges[a] << [b, i]
  edges[b] << [a, i]
end

# 頂点 0 を根にした BFS 順。peg[v] は v から親へ伸びる辺の番号
par = [-1] * N
peg = [0] * N
seq = [0]
seq.each do |pos|
  edges[pos].each do |nex, i|
    next if nex == par[pos]
    par[nex] = pos
    peg[nex] = i
    seq << nex
  end
end

# 葉から部分木の大きさを求め、辺ごとの加算を子側の頂点に置く
size = [1] * N
x = [0] * N
seq.reverse_each do |pos|
  break if pos.zero?
  size[par[pos]] += size[pos]
  if size[pos] * 2 < N
    # 親側が大きい: 全体に足して（根に置く）、部分木から引く
    x[0] += peg[pos]
    x[pos] -= peg[pos]
  else
    x[pos] += peg[pos]
  end
end

# 根から葉へ流す
seq.each do |pos|
  next if pos.zero?
  x[pos] += x[par[pos]]
end

puts x.join(" ")

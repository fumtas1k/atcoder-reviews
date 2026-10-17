# -
# ABC478/E
# 強連結成分分解
# トポロジカルソート
require "ac-library-rb/scc"
include AcLibraryRb

N, Q = gets.split.map(&:to_i)
TUV = Array.new(Q) { gets.split.map(&:to_i).then { [_1, _2 - 1, _3 - 1] } }

scc = SCC.new(N)
TUV.each { |_, u, v| scc.add_edge(u, v) }

# groups はトポロジカル順（辺 u -> v があれば u の成分が v の成分以前）
ans = [0] * N
scc.scc.each.with_index(1) do |group, i|
  group.each { ans[it] = i }
end

# 同じ成分は全員同じ値にするしかないので、その中に < があれば矛盾
if TUV.any? { |t, u, v| t == 1 && ans[u] == ans[v] }
  puts "No"
  exit
end

puts "Yes"
puts ans.join(" ")

# -
# ABC479/D
# 最初の一手で場合分け
# セグメント木（累積 min で足りる）
require "set"
require "rbtree"
require "ac-library-rb/dsu"
require "ac-library-rb/segtree"
require "ac-library-rb/priority_queue"
require "ac-library-rb/fenwick_tree"
include AcLibraryRb

# 指定された座標がグリッド（二次元配列）の範囲内に収まっているかを判定します。
#
# @param r [Integer] 行番号（Row index）
# @param c [Integer] 列番号（Column index）
# @param h [Integer] グリッドの高さ（総行数 / Height）
# @param w [Integer] グリッドの幅（総列数 / Width）
# @return [Boolean] 範囲内であれば `true`、範囲外であれば `false`
def inside?(r, c, h, w)
  0 <= r && r < h && 0 <= c && c < w
end

# 条件を満たす境界値を二分探索（バイナリサーチ）によって求めます。
#
# @param ng [Integer] 条件を満たさない（または満たす）探索の開始点の一方
# @param ok [Integer] 条件を満たす（または満たさない）探索の開始点の他方
# @yieldparam mid [Integer] 現在探索中の判定対象となる中央値
# @yieldreturn [Boolean] `mid` が条件を満たしている（`ok` 側に属する）場合は `true`、満たしていない（`ng` 側に属する）場合は `false`
# @return [Integer] 条件を満たす（または満たさない）境界の `ok` 側の値
def bsearch(ng, ok)
  while (ok - ng).abs > 1
    mid = (ok + ng) / 2
    yield(mid) ? ok = mid : ng = mid
  end
  ok
end

# MOD = 998244353
MOD = 10 ** 9 + 7
INF = 1 << 60

N, Q = gets.split.map(&:to_i)
L = [INF, *gets.split.map(&:to_i)]
R = gets.split.map(&:to_i) << INF
lmin = SegTree.new(L, INF) { |x,y| [x,y].min }
rmin = SegTree.new(R, INF) { |x,y| [x,y].min }


ans = []
Q.times do |i|
  s, t = gets.split.map(&:to_i).map(&:pred)
  res = if s < t
    [R[s], L[s] + rmin.prod(0, s)].min
  else
    [L[s], R[s] + lmin.prod(s+1, N)].min
  end
  ans << res
end

puts ans
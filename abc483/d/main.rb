# -
# ABC483/D
# 累積和
# 前後からの累積 min/max（後ろ側は座標 0 から出発したときの相対値）

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

N = gets.to_i
A = gets.split.map(&:to_i)

# rmin[i], rmax[i]: 座標 0 から A[i], A[i+1], ... の順に動いたときに通る座標の最小・最大
rmin = [0] * (N + 1)
rmax = [0] * (N + 1)
(N - 1).downto(0) do |i|
  rmin[i] = [0, A[i] + rmin[i + 1]].min
  rmax[i] = [0, A[i] + rmax[i + 1]].max
end

ans = rmax[0] - rmin[0] + 1 # どれも反転しない場合
pos = 0                     # A[0...i] まで動いた後の座標
lmin = lmax = 0             # そこまでに通った座標の最小・最大
A.each_with_index do |a, i|
  flipped = pos - a # A[i] を反転して動いた後の座標
  lo = [lmin, flipped + rmin[i + 1]].min
  hi = [lmax, flipped + rmax[i + 1]].max
  ans = [ans, hi - lo + 1].max
  pos += a
  lmin = [lmin, pos].min
  lmax = [lmax, pos].max
end

puts ans

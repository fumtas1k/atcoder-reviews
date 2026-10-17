# -
# ABC480/D
# 累積和（累積和の累積和）
# 二分探索

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
A = gets.split.map(&:to_i)
csum = A.reduce([0]) {|acc, a| acc << acc[-1] + a }
ccsum = csum.reduce([0]) {|acc, x| acc << acc[-1] + x }
ccsum.shift
ccnt = N.times.reduce([0]) {|acc, x| acc << acc[-1] + x + 1 }

calc = -> x do
  idx = (ccnt.bsearch_index { it > x } || ccnt.size) - 1
  remain = x - ccnt[idx]
  ccsum[idx] + csum[remain]
end

ans = []
Q.times do
  l, r = gets.split.map(&:to_i)
  ans << calc[r] - calc[l - 1]
end

puts ans
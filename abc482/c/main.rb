# -
# ABC482/C
# ソート
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

H, W, N, Q = gets.split.map(&:to_i)
RC = Array.new(N) { gets.split.map(&:to_i).map(&:pred) }
UD = RC.sort_by(&:first)
LR = RC.sort_by(&:last)


ans = []
Q.times do
  case gets.split.map(&:to_i).map(&:pred)
  in [0, u, d]
    up = UD.bsearch_index { it[0] >= u } || N
    down = UD.bsearch_index { it[0] > d } || N
    ans << down - up
  in [1, l, r]
    left = LR.bsearch_index { it[1] >= l } || N
    right = LR.bsearch_index { it[1] > r } || N
    ans << right - left
  end
end

puts ans

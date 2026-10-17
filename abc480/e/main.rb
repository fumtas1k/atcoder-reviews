# -
# ABC480/E
# 全探索:全列挙
# 上界を示して全探索（長さは高々 19）
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

N = gets.to_i

ans = 0
(1..10**6).each do |a|
  break if a * (a + 1) * (a + 2) > N
  m = 3
  # 公差 1 でも積が N を超える長さになったら終わり
  while (0...m).reduce(1) { |acc, i| acc * (a + i) } <= N
    x = (1..10**9).bsearch { |d| (0...m).reduce(1) { |acc, i| acc * (a + i * d) } > N }
    ans += x - 1
    m += 1
  end
end

puts ans

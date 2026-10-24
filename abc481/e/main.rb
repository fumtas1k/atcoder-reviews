# -
# ABC481/E
# 偏角ソート
# 尺取り法（円環を 2 周分並べる）

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

Point = Struct.new(:x, :y) do
  def cross(other)
    x * other.y - y * other.x
  end

  # 180度回転対称な上半分にあるかどうか
  def up?
    y.positive? || (y.zero? && x.positive?)
  end

  # 反時計回りに小さい順
  def <=>(other)
    if up? != other.up?
      up? ? -1 : 1
    else
      c = cross(other)
      return 0 if c.zero?
      c.positive? ? -1 : 1
    end
  end
end

gets.to_i.times do
  n = gets.to_i
  points = Array.new(n) { Point.new(*gets.split.map(&:to_i)) }.sort
  # 円環を切り開いて 2 周分並べる
  points2 = points + points
  ans = 0
  r = 0
  n.times do |i|
    # points2[i] から反時計回りに 180 度を超える最初の位置
    r += 1 while r < i + n && points2[i].cross(points2[r]) >= 0
    ans = [ans, r - i].max
  end
  puts ans
end

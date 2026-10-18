# atcoder/ のうち review.md があるコンテストを丸ごとコピーし、README.md の一覧を作り直す。
# サンプル（tests/）は問題文の一部なので公開しない。
require "json"

SRC = File.expand_path("../atcoder", __dir__)
DST = __dir__

contests = Dir.glob("#{SRC}/*/review.md").map { File.basename(File.dirname(it)) }.sort

contests.each do |id|
  system("rsync", "-a", "--delete", "--exclude", "tests/", "--exclude", ".DS_Store",
         "#{SRC}/#{id}/", "#{DST}/#{id}/", exception: true)
end

# 「4 完（…） / 暫定 2762 位 / rated / パフォーマンス 1302 / レート 1053 → 1080」を列に分ける
def result_columns(line)
  solved, *rest = line.split(" / ").map(&:strip)
  place = rest.find { it.include?("位") }
  perf = rest.find { it.start_with?("パフォーマンス") }&.delete_prefix("パフォーマンス ")
  rating = rest.find { it.start_with?("レート") }&.delete_prefix("レート ")
  rating ||= rest.find { it.start_with?("参加前レート") }&.then { "#{it.delete_prefix("参加前レート ")} → 未確定" }
  [solved, place, perf || "未確定", rating].map { it || "-" }
end

rows = contests.reverse.map do |id|
  title = JSON.parse(File.read("#{DST}/#{id}/contest.acc.json")).dig("contest", "title")
  lines = File.readlines("#{DST}/#{id}/review.md", chomp: true)
  i = lines.index("## 結果")
  result = i && lines[(i + 1)..].find { !it.strip.empty? }
  cols = result ? result_columns(result) : ["-"] * 4
  "| [#{title}](#{id}/review.md) | #{cols.join(" | ")} |"
end

File.write("#{DST}/README.md", <<~MD)
  # AtCoder 振り返り

  コンテスト後の振り返りと、Ruby の解答コードです。各コンテストのフォルダに `review.md` と問題ごとの `main.rb` があります。

  | コンテスト | 結果 | 順位 | パフォーマンス | レート |
  |---|---|---|---|---|
  #{rows.join("\n")}
MD

puts "synced: #{contests.join(", ")}"

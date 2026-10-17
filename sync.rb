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

rows = contests.reverse.map do |id|
  title = JSON.parse(File.read("#{DST}/#{id}/contest.acc.json")).dig("contest", "title")
  lines = File.readlines("#{DST}/#{id}/review.md", chomp: true)
  i = lines.index("## 結果")
  result = i && lines[(i + 1)..].find { !it.strip.empty? }
  "- [#{title}](#{id}/review.md) — #{result}"
end

File.write("#{DST}/README.md", <<~MD)
  # AtCoder 振り返り

  コンテスト後の振り返りと、Ruby の解答コードです。各コンテストのフォルダに `review.md` と問題ごとの `main.rb` があります。

  #{rows.join("\n")}
MD

puts "synced: #{contests.join(", ")}"

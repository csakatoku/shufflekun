# Description:
#   ポットごとにいい感じにシャッフルしてくれるボット
#
#
shuffle = require('shuffle-array')

module.exports = (robot) ->

  robot.hear /(.*)/i, (res) ->
    lines = res.match.input.split("\n")

    pots = []
    itemCount = 0

    for line in lines[1..]
      pot = (x for x in line.split(",") when x.length > 0)
      if pot.length is 0
        continue

      pots.push(shuffle(pot))
      itemCount += pot.length

    if itemCount is 0
      res.reply([
        "改行の後にカンマ区切りで候補を入れてね！複数回改行するとポットを増やせるよ！",
        "例1。3グループに分ける。",
        "```",
        "@shufflekun: 3",
        "a,b,c,d,e",
        "```",
        "例2。2つのポットから3グループに分ける。",
        "```",
        "@shufflekun: 3",
        "a,b,c,d,e",
        "1,2,3",
        "```",
        "例3。ポットの数の分だけグループ分け。",
        "```",
        "@shufflekun:",
        "a,b,c,d,e",
        "A,B,C,D,E",
        "1,2,3",
        "```",
      ].join("\n"))
      return

    match = lines[0].match(/(\d+)$/)
    if match?
      groupCount = ~~match[1]
    else
      groupCount = 0

    groupCount = Math.max(groupCount, pots.length)

    result = {}
    for pot in pots
      for item, idx in pot
        group = idx % groupCount
        (result[group] or (result[group] = [])).push(item)

    buf = []
    for group in [0..groupCount - 1]
      items = result[group]
      buf.push("グループ#{group + 1}: #{items.join(', ')}")

    res.send(buf.join("\n"))

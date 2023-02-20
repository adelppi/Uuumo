---

marp: true
theme: uncover
style: |
  section {
    justify-content: normal;
  }
  section.lead {
    justify-content: center;
    text-align: center;
  }

---
<!-- _class: lead -->

# SuumoAPIのアプリ化🏡
###### T3 豊田 アディール

---

# 目標📝

- 物件の絞り込みに立地も考慮したい
$\Longrightarrow\,$物件と同時に**周辺地図が見られるUI設計**

$\,$

- 相談相手が欲しい
$\Longrightarrow\,$相談相手がいないなら**作れば良い**$\quad\:\,\,\,\,\,\,\,\,\,\,$

---
<!-- _class: lead -->

# 成果物✅

---

# 仕組み⚙
\
![width:1125](./images/figure1.png)

---

# 仕組み⚙
\
![width:1125](./images/figure1.png)

###### :link:http://127.0.0.1:2500/rents/?city=%E5%8D%83%E4%BB%A3%E7%94%B0%E5%8C%BA&layout=3LDK&rent=400000&walkDistance=10%E5%88%86%E4%BB%A5%E5%86%85

---

# APIサーバ🌐
PythonでWeb開発できる**Flask**を用いた
```json
アプリ側での取得例:

{
  "title":      "ローズハウス御茶ノ水",
  "address":    "東京都千代田区外神田8",
  "rent":       219000,
  "layout":     "1LDK",
  "age":        "築17年",
  "station":    "ＪＲ中央線/御茶ノ水駅 歩8分",
  "coordinate": [139.759079, 35.696491]
}
```

---

# アプリ🛠

$\,$
* 全くPythonじゃない
* ### ゴリゴリの**Swift**

---

# まとめ📊
\
\
SuumoのWebサイトの**機能を補い**つつ、現代らしく**AIの手も借りながら**物件を探す方法を作ることができた。

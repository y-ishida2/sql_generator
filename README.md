# sql_generator
### how to use
1. table_data にテーブルデータを記入
2. run.rb を叩く（usage: $ ruby run.rb <file_name>）
3. created_sql にsqlファイルが作成される

### yml雛形
- table_name: <table_name>
- counts: <レコード数>
- bulk_counts: <1クエリあたりのレコード数>
- columns:
  - column_name:
    - method_name: <method_name>
    - arg: <arg>
  - column_name:
    - method_name: <method_name>
    - arg: <arg>

- method_name
  - return
  - random_char
    - ランダムな英数字を生成(引数は文字数)
  - random_hiragana
    - ランダムなひらがなを生成(引数は文字数)
  - serial_num
    - auto_incrementな数字を生成(引数は初期値)
  - serial_char
    - 末尾にauto_incrementな数値付きの文字列を生成(引数は文字列)
  - serial_date_day
    - 1日ずつ増加のDateクラスを生成(引数は初期日)
  - serial_date_month
    - 1ヶ月ずつ増加のDateクラスを生成(引数は初期日)
  - serial_date_year
    - 1年ずつ増加のDateクラスを生成(引数は初期日)
  - serial_timestamp_second
    - 1秒ずつ増加のTimeクラスを生成(引数は初期日)
  - serial_timestamp_minite
    - 1分ずつ増加のTimeクラスを生成(引数は初期日)
  - serial_timestamp_hour
    - 1時間ずつ増加のTimeクラスを生成(引数は初期日)
  - serial_timestamp_day
    - 1日ずつ増加のTimeクラスを生成(引数は初期日)

#### メソッドの詳しい使い方は`sample.yml`参照


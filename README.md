# sql_generator
### how to use
1. table_info にテーブルデータを記入（雛形はcoming soon）
2. run.rb を叩く（usage: $ ruby run.rb <file_name>）
3. created_sql にsqlファイルが作成される

### yml雛形
table_name: <table_name>
counts: <レコード数>
columns:
  column_name:
    - method_name
    - arg
  column_name:
    - method_name
    - arg
  column_name:
    - method_name
    - arg

- method_name
  - random_char
    - ランダムな英数字を生成(引数は文字数)
  - random_hiragana
    - ランダムなひらがなを生成(引数は文字数)
  - serial_num
    - auto_incrementな数字を生成(引数は初期値)



##### 一旦残しておく
columns:
  column_name: value
  column_name: value
  column_name: value

- value
  - ランダムな英数字を生成
    - random(文字数)
  - ランダムなひらがなを生成
    - hiragana(文字数)
  - auto_incrementな数字を生成
    - serial_num(初期値)


require 'yaml'
require 'date'
require 'time'

class SqlGenerator
  def initialize(file_name)
    unless File.exist?("./table_data/#{file_name}")
      raise 'ファイル名が正しくありません。'
    end

    table_data = YAML.load_file("./table_data/#{file_name}")
    @table_name = table_data['table_name']
    @record_counts = table_data['counts']
    @bulk_counts = table_data['bulk_counts']
    @columns_keys = table_data['columns'].keys.join(', ')
    @columns_values = table_data['columns'].values
  end

  def generate_file
    File.open("./created_sql/#{@table_name}.sql", "w+") do |f|
      generate_sql(f)
    end
    puts "sql_fileが作られました！"
  end

  private

  def generate_sql(f)
    record_counts = []
    (@record_counts / @bulk_counts).times { record_counts << @bulk_counts }
    record_counts << @record_counts % @bulk_counts if @record_counts % @bulk_counts != 0

    index = 0
    for bulk_counts in record_counts do
      f.print("INSERT INTO #{@table_name} (#{@columns_keys}) VALUES ")
      bulk_counts.times do |i|
        f.print("(#{generate_value(index)})".gsub(/[\[\]]/, '').gsub(/"/, '\''))
        i == bulk_counts - 1 ? f.puts(';') : f.print(', ')
        index += 1
      end
    end
  end

  def generate_value(i)
    @columns_values.map do |value|
      send(value['method_name'], value['arg'], i)
    end
  end

  def return(value, i)
    value
  end

  def random_char(size, i)
    character = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
    (0...size).map { character[rand(character.size)] }.join
  end

  def random_hiragana(size, i)
    hiragana = 'あいうえおかきくけこさしすせそたちつてとなにぬねのはひふヘほまみむめもやゆよらりるれろわをん'.split('')
    (0...size).map { hiragana[rand(hiragana.size)] }.join
  end

  def serial_num(ini, i)
    ini + i
  end

  def serial_char(str, i)
    "#{str}_#{i + 1}"
  end

  def serial_date_day(start, i)
    start = Date.parse(start)
    (start + i).to_s
  end

  def serial_date_month(start, i)
    start = Date.parse(start)
    (start >> i).to_s
  end

  def serial_date_year(start, i)
    start = Date.parse(start)
    (start >> 12 * i).to_s
  end

  def serial_timestamp_second(start, i)
    start = Time.parse(start)
    (start + i).to_s
  end

  def serial_timestamp_minite(start, i)
    start = Time.parse(start)
    (start + 60 * i).to_s
  end

  def serial_timestamp_hour(start, i)
    start = Time.parse(start)
    (start + (60 * 60) * i).to_s
  end

  def serial_timestamp_day(start, i)
    start = Time.parse(start)
    (start + (24 * 60 * 60) * i).to_s
  end
end

if __FILE__ == $0
  unless ARGV.size == 1
    puts 'usage: $ ruby run.rb <file_name>'
    exit!
  end

  begin
    start_time = Time.now
    SqlGenerator.new(ARGV[0]).generate_file
    puts "処理時間 => #{Time.now - start_time}s"
  rescue => e
    puts 'エラーが発生しました。'
    puts e.message
  end
end


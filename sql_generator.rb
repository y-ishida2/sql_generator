require 'yaml'
require 'date'
require 'time'

class SqlGenerator
  attr_reader :number_of, :bulk

  def initialize(file_name)
    @base_dir = __dir__
    table_data = YAML.load_file("#{@base_dir}/table_data/#{file_name}")
    @table_name = File.basename(file_name, '.*')
    @number_of = table_data['number_of']
    @bulk = table_data['bulk']
    @columns_keys = table_data['columns'].keys.join(', ')
    @columns_values = table_data['columns'].values
  end

  def generate_file
    File.open("#{@base_dir}/created_sql/#{@table_name}.sql", "w") do |f|
      index = 0
      for size in value_sizes_per_bulk do
        f.print(generate_insert_front_part)
        size.times do |i|
          f.print(generate_insert_value_part(index))
          i == size - 1 ? f.puts(';') : f.print(', ')
          index += 1
          progress_bar(index)
        end
      end
    end
    puts " (Done)"
  end

  private

  def progress_bar(i)
    progress =  i * 100 / @number_of
    progress_bar = "#" * progress
    print "\r[#{progress_bar.ljust(100, ".")}] #{progress}%"
  end

  def value_sizes_per_bulk
    sizes = []
    (@number_of / @bulk).times { sizes << @bulk }
    sizes << @number_of % @bulk if @number_of % @bulk != 0
    sizes
  end

  def generate_insert_front_part
    "INSERT INTO #{@table_name} (#{@columns_keys}) VALUES "
  end

  def generate_insert_value_part(i)
    values = @columns_values.map do |value|
      send(value['type'], value['parameter'], i)
    end
    "(\'#{values.join('\', \'')}\')"
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

  def serial_timestamp_minute(start, i)
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
    puts 'usage: $ ruby sql_generator.rb <file_name>'
    exit!
  end

  begin
    start_time = Time.now
    sql_generator = SqlGenerator.new(ARGV[0])
    sql_generator.generate_file
    puts "[ 処理時間 => #{(Time.now - start_time).round(3)}s, レコード数 => #{sql_generator.number_of}, バルクサイズ => #{sql_generator.bulk} ]"
  rescue => e
    puts 'エラーが発生しました。'
    puts e.message
  end
end


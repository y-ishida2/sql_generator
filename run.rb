require 'yaml'
require 'securerandom'

class SqlGenerator
  def initialize(file_name)
    unless File.exist?("./table_data/#{file_name}")
      raise 'ファイル名が正しくありません。'
    end

    table_data = YAML.load_file("./table_data/#{file_name}")
    begin
      @table_name = table_data['table_name']
      @record_counts = table_data['counts']
      @columns_keys = table_data['columns'].keys.join(', ')
      @columns_values = table_data['columns'].values
    rescue
      raise 'table_dataの形式が正しくありません。'
    end
  end

  def generate_file
    File.open("./created_sql/#{@table_name}.sql", "w") do |f|
      @record_counts.times do |i|
        f.puts(generate_sql(i))
      end
    end
    puts "sql_fileが作られました！"
  end

  private

  def generate_sql(i)
    # columns_values = []
    # @columns_values.each do |value|
    #   columns_values << send(value[0], value[1], i)
    # end
    # p columns_values
    # "INSERT INTO #{@table_name} (#{@columns_keys}) VALUES (#{columns_values});\n".gsub(/[\[\]]/, '').gsub(/"/, '\'')

    columns_values = @columns_values.map do |value|
      send(value['method_name'], value['arg'], i)
    end
    "INSERT INTO #{@table_name} (#{@columns_keys}) VALUES (#{columns_values});\n".gsub(/[\[\]]/, '').gsub(/"/, '\'')
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

  def return(value, i)
    value
  end

  def serial_date(start, i)
    (start + i).to_s
    # (start >> i).to_s
  end

  def serial_timestamp(start, i)
    start + i
  end

  def serial_timestamp_day(start, i)
    start + i
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


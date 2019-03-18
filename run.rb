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
      f.puts(generate_sql)
    end
    puts "sql_fileが作られました！"
  end

  private

  def generate_sql
    str = ''
    @record_counts.times do |i|
      columns_values = []
      @columns_values.each do |value|
        columns_values << send(value[0], value[1], i)
      end
      str << "INSERT INTO #{@table_name} (#{@columns_keys}) VALUES (#{columns_values});\n".gsub(/[\[\]]/, '').gsub(/"/, '\'')
    end
    str

    # str = ''
    # @record_counts.times do |i|
    #   columns_values = []
    #   @columns_values.each do |value|
    #     if value.kind_of?(String)
    #       case value
    #       when /random/
    #         size = value.match(/\d+/)[0].to_i
    #         # value = SecureRandom.alphanumeric(size)
    #         value = random_char(size)
    #       when /serial_num/
    #         ini = value.match(/\d+/)[0].to_i
    #         value = ini + i
    #       when /hiragana/
    #         size = value.match(/\d+/)[0].to_i
    #         value = random_hiragana(size)
    #       end
    #     end
    #     columns_values << value
    #   end
    #   str << "INSERT INTO #{@table_name} (#{@columns_keys}) VALUES (#{columns_values});\n".gsub(/[\[\]]/, '').gsub(/"/, '\'')
    # end
    # str
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
end

if __FILE__ == $0
  unless ARGV.size == 1
    puts 'usage: $ ruby run.rb <file_name>'
    exit!
  end

  begin
    SqlGenerator.new(ARGV[0]).generate_file
  rescue => e
    puts 'エラーが発生しました。'
    puts e.message
  end
end


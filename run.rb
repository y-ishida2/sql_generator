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
      @columns_values = table_data['columns'].values.to_s.gsub(/[\[\]]/, '').gsub(/"/, '\'')
      @columns_values_test = table_data['columns'].values
    rescue
      raise 'table_dataの形式が正しくありません。'
    end
  end

  def generate_file
    File.open("./created_sql/#{@table_name}.sql", "w") do |f|
      f.puts(generate_sql)
    end
    puts "sql_fileが作られました！"
    # random_str
  end

  private

  def random_str
    str = ''
    @record_counts.times do
      @columns_values_test[0] = SecureRandom.alphanumeric(10)
      str << "INSERT INTO #{@table_name} (#{@columns_keys}) VALUES (#{@columns_values_test});\n".gsub(/[\[\]]/, '').gsub(/"/, '\'')
    end
    puts str
  end

  def generate_sql
    # "INSERT INTO #{@table_name} (#{@columns_keys}) VALUES (#{@columns_values});\n" * @record_counts

    ### random_str
    str = ''
    @record_counts.times do
      @columns_values_test[0] = SecureRandom.alphanumeric(10)
      str << "INSERT INTO #{@table_name} (#{@columns_keys}) VALUES (#{@columns_values_test});\n".gsub(/[\[\]]/, '').gsub(/"/, '\'')
    end
    str

    ### times
    # str = ''
    # @record_counts.times do
    #   str << "INSERT INTO #{@table_name} (#{@columns_keys}) VALUES (#{@columns_values});\n"
    # end
    # str

    ### each
    # str = ''
    # (1..@record_counts).each do
    #   str << "INSERT INTO #{@table_name} (#{@columns_keys}) VALUES (#{@columns_values});\n"
    # end
    # str

    ### 初期値が欲しい時
    # str = ''
    # ini = 10
    # (ini..@record_counts+ini-1).each do
    #   str << "INSERT INTO #{@table_name} (#{@columns_keys}) VALUES (#{@columns_values});\n"
    # end
    # str
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
    puts e.message
  end
end


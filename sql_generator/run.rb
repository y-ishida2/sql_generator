require 'yaml'

class SqlGenerator
  def initialize(file_name)
    unless File.exist?("./table_data/#{file_name}")
      raise 'ファイル名が正しくありません。'
    end

    table_data = YAML.load_file("./table_data/#{file_name}")

    begin
      @table_name = table_data['table_name']
      @table_counts = table_data['counts']
      @columns_keys = table_data['columns'].keys.join(', ')
      @columns_values = table_data['columns'].values.to_s.gsub(/[\[\]]/, '').gsub(/"/, '\'')
    rescue
      raise 'table_dataの形式が正しくありません。'
    end

    # puts "begin======================================"
    # puts table_data['columns'].values
    # puts table_data['columns'].values.to_s
    # puts table_data['columns'].values.to_s.gsub(/[\[\]]/, '')
    # puts table_data['columns'].values.to_s.gsub(/[\[\]]/, '').gsub(/"/, '\'')
    # puts "end======================================"
  end

  def generate_sql
    "INSERT INTO #{@table_name} (#{@columns_keys}) VALUES (#{@columns_values});\n" * @table_counts
  end

  def generate_file
    File.open("./created_sql/#{@table_name}.sql", "w") do |f|
      f.puts(self.generate_sql)
    end
    puts "sql_fileが作られました！"
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


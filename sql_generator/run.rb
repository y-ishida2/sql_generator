require 'yaml'

class SqlGenerator
  def initialize(file_name)
    unless File.exist?("./table_data/#{file_name}")
      puts 'ファイル名が正しくありません。'
      exit!
    end
    table_data = YAML.load_file("./table_data/#{file_name}")
    @table_name = table_data['table_name']
    @table_counts = table_data['counts']
    @columns_keys = table_data['columns'].keys.join(', ')
    puts "begin======================================"
    puts table_data['columns'].values
    puts table_data['columns'].values.join(",")
    puts table_data['columns'].values.join("','")
    puts table_data['columns'].values.gsub("'","''")
    puts table_data['columns'].values.to_s
    puts "end======================================"
    @columns_values = table_data['columns'].values.to_s
  rescue
    puts "table_dataの形式が正しくありません。"
    exit!
  end

  def generate_sql
    #"INSERT INTO #{@table_name} ('column_name_1', 'column_name_2') VALUES ('hoge', 'piyo');\n" *
    #@table_counts
    "INSERT INTO #{@table_name} (#{@columns_keys}) VALUES (#{@columns_values});\n" * @table_counts
  end

  def generate_file
    File.open("./created_sql/#{@table_name}.sql", "w") do |f|
      f.puts(self.generate_sql)
    end
  end
end

if __FILE__ == $0
  unless ARGV.size == 1
    puts 'usage: $ ruby run.rb <file_name>'
    exit!
  end
 #  unless File.exist?("./table_data/#{ARGV[0]}")
 #    puts 'ファイル名が正しくありません。'
 #    exit!
 #  end
  SqlGenerator.new(ARGV[0]).generate_file

#   if ARGV.size != 1
#     puts 'usage: $ ruby run.rb <file_name>'
#     exit!
#   elsif File.exist?("./table_data/#{ARGV[0]}")
#     SqlGenerator.new(ARGV[0]).generate_file
#   else
#     puts 'ファイル名が正しくありません。'
#     exit!
#   end
end


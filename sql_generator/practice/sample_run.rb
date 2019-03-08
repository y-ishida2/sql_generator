require 'yaml'

class SqlGenerator
  def initialize(file_name)
    table_data = YAML.load_file("./table_info/#{file_name}")
    @table_name = table_data['table_name']
  end

  def generate_sql
    "INSERT INTO #{@table_name} VALUES ('hoge', 'piyo');"
  end

  def touch_file
    File.open("./created_sql/#{@table_name}.sql", "w") do |f|
      f.puts(self.generate_sql)
    end
  end
end

sql_generator = SqlGenerator.new(ARGV[0])
sql_generator.touch_file


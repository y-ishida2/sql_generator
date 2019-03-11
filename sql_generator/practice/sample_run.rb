require 'yaml'

class SqlGenerator
  def initialize(file_name)
    table_data = YAML.load_file("./table_data/#{file_name}")
    @table_name = table_data['table_name']
  end

  def generate_sql
    "INSERT INTO #{@table_name} ('column_name_1', 'column_name_2') VALUES ('hoge', 'piyo');"
  end

  def generate_file
    File.open("./created_sql/#{@table_name}.sql", "w") do |f|
      f.puts(self.generate_sql)
    end
  end
end

sql_generator = SqlGenerator.new(ARGV[0])
sql_generator.generate_file


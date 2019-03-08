class SqlGenerator
  def initialize
    @table_name = 'sample_table'
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

sql_generator = SqlGenerator.new()
sql_generator.touch_file


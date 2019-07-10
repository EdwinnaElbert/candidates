require_relative 'client'

class Cleaner
  attr_accessor :table_name, :column_name

  def initialize(table_name  = "hle_dev_test_maryna_dozhdova",
                 column_name = "clean_name")
    @table_name = table_name
    @column_name = column_name
    @erroneus_result = []

    @client = Client.new.call
  end

  def call
    @client.query("UPDATE #{@table_name} \
                   SET #{@column_name} \
                   = NULL")
    @client.query("DELETE FROM #{@table_name} \
                   WHERE id = 0")
  end
end

Cleaner.new().call

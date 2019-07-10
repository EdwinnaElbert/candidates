require_relative 'client'

class Test
  attr_accessor :table_name, :column_name, :from, :to, :condition

  def initialize(table_name  = "hle_dev_test_maryna_dozhdova",
                 column_name = "clean_name")
    @table_name = table_name
    @column_name = column_name
    @erroneus_result = []

    @client = Client.new.call
  end

  def call
    nulls
    slashes
    commas
    periods
    puts @erroneus_result.each_with_object(Hash.new(0)) { |word, counts| counts[word] += 1 }
  end

  def nulls
    result = @client.query("SELECT #{@column_name} \
                            FROM #{@table_name} \
                            WHERE #{@column_name} IS NULL")
                    .each do |r|
                      @erroneus_result << r
                    end
  end

  def slashes
    result = @client.query("SELECT #{@column_name} \
                            FROM #{@table_name} \
                            WHERE #{@column_name} LIKE '%/%'")
                    .each do |r|
                      @erroneus_result << r
                    end
  end

  def commas
    result = @client.query("SELECT #{@column_name} \
                            FROM #{@table_name} \
                            WHERE #{@column_name} LIKE '%,%'")
                    .each do |r|
                      @erroneus_result << r
                    end
  end

  def periods
    result = @client.query("SELECT #{@column_name} \
                            FROM #{@table_name} \
                            WHERE #{@column_name} LIKE '%.%'")
                    .each do |r|
                      @erroneus_result << r
                    end
  end
end

Test.new().call

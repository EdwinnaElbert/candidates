require_relative 'client'

class Updater
  attr_accessor :table_name, :data

  def initialize(table_name = "hle_dev_test_maryna_dozhdova",
                 column_name,
                 data)
    @table_name  = table_name
    @column_name = column_name
    @data        = data

    @client = Client.new.call
  end

  def update_all
    @data.each do |k|
      q = "UPDATE hle_dev_test_maryna_dozhdova \
           SET clean_name = '#{@client.escape(k[1])}',\
           sentence = 'The candidate is running for the #{@client.escape(k[1])} office.'
           WHERE id = #{k[0]}"
      p q
      @client.query(q)
    end
  end
end

require_relative "updater"
require_relative "client"

class CleanName
  def initialize
    @client = Client.new.call
    @query  = @client.query("SELECT * FROM hle_dev_test_maryna_dozhdova")
    @data   = []
  end

  def call
    @query.each do |v|
      r = v["candidate_office_name"]
      next if r.nil?
      r = replace_co_with_county(r)
      r = lcase(r, '/')
      r = lcase(r, ',')
      r = slash_handler(r)
      r = parenthesis_instead_comma(r).gsub(',', '')
      r = replace_hwy(r)
      r = replace_twp(r)
      r = remove_county_county(r)
      r = replace_and(r)
      r = remove_double_bar(r)
      r = remove_period(r)

      @data << [v["id"], r.strip]
    end

    Updater.new(nil, 'clean_name', @data).update_all
  end

private
  # Twp Trustee/NewTrier Twp -> twp trustee/NewTrier Twp
  # Twp Trustee, NewTrier Twp -> twp trustee, NewTrier Twp
  def lcase(r, condition)
    splitted_by_condition = r.split(condition)
    return r if splitted_by_condition.size.zero? || splitted_by_condition.size == 1
    "#{splitted_by_condition.first.downcase}#{condition}#{splitted_by_condition.last}"
  end

  def slash_handler(r)
    splitted_by_slash = r.split('/')
    return r if splitted_by_slash.size.zero?
    splitted_by_slash.each(&:strip).compact!
    return splitted_by_slash.reverse.join(' ') if splitted_by_slash.size == 2

    "#{splitted_by_slash[2]} #{splitted_by_slash[0].downcase} and #{splitted_by_slash[1]}"
  end

  def remove_county_county(r)
    r.gsub('County county', '')
  end

  def replace_co_with_county(r)
    r.gsub(/Co$/, 'County')
  end

  def parenthesis_instead_comma(r)
    splitted_by_comma = r.split(', ')
    return r if splitted_by_comma.size <= 1
    "#{splitted_by_comma[0]} (#{splitted_by_comma[1]})"
  end

  def replace_twp(r)
    r.gsub('twp', 'township').gsub('twp', '').gsub('Twp', '')
  end

  def replace_hwy(r)
    r.gsub('hwy', 'highway').gsub('hwy', '')
  end

  def replace_and(r)
    r.gsub(/and $/, '').gsub(/and \)$/, '')
  end

  def remove_double_bar(r)
    r.gsub(/  /, ' ')
  end

  def remove_period(r)
    r.gsub('Westchester. ', 'Westchester ').gsub(' . ', ' ').gsub('.$', '')
  end
end

CleanName.new().call

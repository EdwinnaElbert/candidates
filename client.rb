require "mysql2"
require_relative "env"

class Client
  def initialize
    raise StandardError "Environment variable is missing or empty" unless envvar_present?
    @db_host  = HOST
    @db_user  = USER
    @db_pass  = PASS
    @db_name =  DB
  end

  def call
    Mysql2::Client.new(host: @db_host,
                       username: @db_user,
                       password: @db_pass,
                       database: @db_name)
  end

  def envvar_present?
    HOST && USER && PASS && DB
  end
end

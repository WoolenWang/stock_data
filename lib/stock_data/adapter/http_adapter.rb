# -*- encoding : utf-8 -*-

require 'stock_data/adapter'
require 'httpclient'
require 'httpclient/cookie'
require 'connection_pool'
require 'nokogiri'
require 'xpath'
module StockData
    class HttpAdapter < Adapter
        MAX_POOL = 2
        POOL_TIMEOUT = 30
        class << self
            attr_accessor :client_pool
            def method_missing(method,*args,&block)
                debug "need to invoke HttpAdapter method:#{method},with args:#{args}"
                self.instance_eval <<-THE_END
                    def #{method}(*args,&block)
                        self.get_pool.with do |one_connect|
                            one_connect.send :#{method},*args,&block
                        end
                    end
                THE_END
                self.get_pool.with do |one_connect|
                    one_connect.send method,*args,&block
                end
            end

            def get_html(url)
                the_data = ''
                self.get_pool.with do |one_connect|
                    the_data = one_connect.get(url).body.to_utf8
                end
                the_result = nil
                begin
                    if the_data.blank?
                        debug "get html data is blank:[#{the_data}]"
                    else
                        the_result = Nokogiri::HTML(the_data)
                    end
                rescue Exception=>e
                    warn 'parse html error::',e
                end
                the_result
            end

            def get_pool
                self.client_pool ||= ::ConnectionPool.new(:size => MAX_POOL, :timeout => POOL_TIMEOUT) do
                    HTTPClient.new
                end
            end
        end
    end
end

# -*- encoding : utf-8 -*-
require 'xpath'
module StockData
    class ThsWebSourceHandler
        include XPath
        include WoolenCommon::ToolLogger
        THS_WEB_URL = 'http://bbs.10jqka.com.cn/codelist.html'
        MARKET_TYPE = %w( sz sh fund )
        class << self
            attr_accessor :the_data

            def make_xpath(type=nil, &block)
                XPath.generate(&block).to_xpath(type)
            end

            def get_data(type = nil)
                debug 'start to get data'
                pull_source
                if type
                    case type
                        when :sz

                        else
                            warn "not support type:#{type}"
                    end
                end
            end

            def pull_source
                if self.the_data
                    debug "the data is already pull:#{self.the_data}"
                else
                    debug 'begin to pull source data'
                    result = HttpAdapter.get_html THS_WEB_URL
                    debug "同花顺数据目录返回数据是:\n#{result.body}"
                    self.the_data = handle_web_data(result)
                end
            end

            def handle_web_data(web_data)
                market_xpaths = {}
                MARKET_TYPE.each do |one_market_type|
                    market_xpaths[one_market_type] = make_xpath do |x|
                        x.descendant(:a).where(x.attr(:id) == 'sz').next_sibling.next_sibling.child
                    end
                end
                market_xpath_match = {}
                market_xpaths.each do |one_market_type,one_market_xpath|
                    market_xpath_match[one_market_type] = web_data.xpath one_market_xpath
                end
                debug "get the match data:#{market_xpath_match}"
                market_xpath_match
            end
        end
    end
end


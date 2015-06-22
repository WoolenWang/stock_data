# -*- encoding : utf-8 -*-

require 'stock_data/data_source/index_source'
require 'stock_data/data_source/index_source/handler/ths_web_source_handler'
require 'stock_data/adapter/http_adapter'
module StockData
    class ChinaIndexSource < IndexSource
        KNOWN_SOURCE = {
            '同花顺web' => ThsWebSourceHandler
        }

        class << self
            attr_accessor :known_source_data
            def get_all_data
                self.known_source_data ||= {}
                KNOWN_SOURCE.each do |key,value|
                    if self.known_source_data[key]
                        debug "the source [#{key}] is already has data"
                    else
                        self.known_source_data[key] = value.get_data
                    end
                end
            end

            def get_index
                ChinaIndexSource.get_all_data
                self.known_source_data
            end
        end


    end
end

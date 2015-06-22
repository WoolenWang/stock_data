# -*- encoding : utf-8 -*-
require 'stock_data/market'
require 'stock_data/data_source/index_source/china_index_source'
module StockData
    class ChinaMarket < Market
        COUNTRY_MARKET_TYPE = %w{ SZ SH }

        def get_stocks_source

        end

        def get_all_stocks_id_hash

        end

        def get_country_market_type
            COUNTRY_MARKET_TYPE
        end

        def get_country_market_index
            ChinaIndexSource.get_index
        end
    end
end

# -*- encoding : utf-8 -*-
require 'test/unit'
require 'stock_data'
require "#{File.join(File.dirname(__FILE__),'..','..','lib/stock_data/market/china_market')}"
class ChinaMarketTest < Test::Unit::TestCase

    # Called before every test method runs. Can be used
    # to set up fixture information.
    def setup
        @market_instance = StockData::ChinaMarket.new
    end

    # Called after every test method runs. Can be used to tear
    # down fixture information.

    def teardown
        # Do nothing
    end

    # 测试市场类型
    def test_get_country_market_type
        country_market_type = @market_instance.get_country_market_type
        assert_equal(2,country_market_type.length,'中国市场的类型有两种')
    end

    def test_get_country_market_index
        index = @market_instance.get_country_market_index
        assert_kind_of Hash,index,'返回的index是个hash'
    end
end

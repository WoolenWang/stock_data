require 'test/unit'
require 'xpath'
require 'stock_data'
class MyTest < Test::Unit::TestCase

    # Called before every test method runs. Can be used
    # to set up fixture information.
    def setup
        @html = Nokogiri::HTML File.read(File.expand_path '../data/codelist.html',File.dirname(__FILE__)).force_encoding 'GBK'
    end

    def xpath(type=nil, &block)
        @html.xpath XPath.generate(&block).to_xpath(type)
    end

    # Called after every test method runs. Can be used to tear
    # down fixture information.

    def teardown
        # Do nothing
    end

    def test_xpath_get_div
        results = xpath do |x|
            x.descendant(:div).where(x.attr(:class) == 'bbsilst_wei3')
        end
        assert_not_nil results.first,'should get the bbsilst_wei3'
    end

    def test_xpath_get_ul
        results = xpath do |x|
            x.descendant(:div).where(x.attr(:class) == 'bbsilst_wei3').child(:ul).child(:li)
        end
        # puts results.first.to_s
        # puts "the result length#{results.length}"
        # # 这里可以通过正则来取，但是没有很好区分市场
        # results.each do |one_node|
        #     puts "get one node::#{one_node.text.to_utf8}"
        # end
        assert_not_nil results.first,'should get the bbsilst_wei3'
    end

    def test_xpath_get_ul_try_next_sibling
        results = xpath do |x|
            x.descendant(:a).where(x.attr(:id) == 'sz').next_sibling.next_sibling.child
        end
        puts results.first.to_s
        puts "the result length#{results.length}"
        results.each do |one_node|
            puts "get one node::#{one_node.text.to_utf8}"
        end
        assert_not_nil results.first,'should get the bbsilst_wei3'
    end
end
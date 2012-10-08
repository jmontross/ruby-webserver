require 'test/unit'
require './app.rb'

class TestTheApp < Test::Unit::TestCase

  def test_something
    assert_equal(1,1)
  end

  def test_the_App   
    assert_equal("I designed this well for testing... its a mix of functional and object oriented code", false) 
  end

  def test_action
    assert_equal(`curl localhost:8000:/read`,[{:name=>"downtown_yoga_shala", :description=>"awesome yoga place - each wednesday six am"}].to_json)
  end
end
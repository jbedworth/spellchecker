require 'test_helper'

class SpellingControllerTest < ActionDispatch::IntegrationTest
  test "the truth" do
    assert true
  end

  test "validate the service responds to /spelling/Hello with 404 when dictionary is empty" do
    get "/spelling/Hello"
    assert_response 404, @response.body
  end

  test "validate the service responds to /spelling/Hello with 200 when dictionary contains hello" do
    DictionaryWord.create(:word => 'Hello')
    get '/spelling/Hello'
    assert_response 200, @response.body
  end

  test "validate the service responds to /spelling/BalloN with 200 when dictionary contains balloon, abalone, monster" do
    DictionaryWord.create([{:word => 'balloon'},{:word => 'abalone'},{:word => 'monster'}])
    get '/spelling/BalloN'
    assert_response 200, @response.body
  end

end

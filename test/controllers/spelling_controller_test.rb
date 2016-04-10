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
    result = response_body_as_json
    assert_equal true, result['correct']
  end

  test "validate the service responds to /spelling/Hllo (1 missing vowel) with 200 when dictionary contains hello" do
    DictionaryWord.create(:word => 'Hello')
    get '/spelling/Hllo'
    assert_response 200, @response.body
    result = response_body_as_json
    assert_equal false, result['correct']
    assert_equal 1, result['suggestions'].size
  end

  test "validate the service responds to /spelling/Hll (2 missing vowel) with 200 when dictionary contains hello" do
    DictionaryWord.create(:word => 'Hello')
    get '/spelling/Hll'
    assert_response 200, @response.body
    result = response_body_as_json
    assert_equal false, result['correct']
    assert_equal 1, result['suggestions'].size
  end

  test "validate the service responds to /spelling/Hellllooooo (repeating chars) with 200 when dictionary contains hello" do
    DictionaryWord.create(:word => 'Hello')
    get '/spelling/Hellllooooo'
    assert_response 200, @response.body
    result = response_body_as_json
    assert_equal false, result['correct']
    assert_equal 1, result['suggestions'].size
  end

  test "validate the service responds to /spelling/HeLlo (mixed casing) with 200 when dictionary contains hello" do
    DictionaryWord.create(:word => 'Hello')
    get '/spelling/HeLlo'
    assert_response 200, @response.body
    result = response_body_as_json
    assert_equal false, result['correct']
    assert_equal 1, result['suggestions'].size
  end

  test "validate the service responds to /spelling/ello (missing vowel) with 404 when dictionary contains hello" do
    DictionaryWord.create(:word => 'Hello')
    get '/spelling/ello'
    assert_response 404, @response.body
  end

  test "validate the service responds to /spelling/BalloN with 200 when dictionary contains balloon, abalone, billion" do
    DictionaryWord.create([{:word => 'balloon'},{:word => 'abalone'},{:word => 'billion'}])
    get '/spelling/BalloN'
    assert_response 200, @response.body
    result = response_body_as_json
    assert_equal false, result['correct']
    assert_equal 2, result['suggestions'].size
  end

  test "validate the service responds to /spelling/dul with 200 when dictionary contains dual, duel, duello, dull, dumb" do
    DictionaryWord.create([{:word => 'dual'},{:word => 'duel'},{:word => 'duello'},{:word => 'dumb'},{:word => 'dull'}])
    get '/spelling/dul'
    assert_response 200, @response.body
    result = response_body_as_json
    assert_equal false, result['correct']
    assert_equal 2, result['suggestions'].size
  end

  test "validate the service responds to /spelling/dulz with 404 when dictionary contains dual, duel, duello, dull, dumb" do
    DictionaryWord.create([{:word => 'dual'},{:word => 'duel'},{:word => 'duello'},{:word => 'dumb'},{:word => 'dull'}])
    get '/spelling/dulz'
    assert_response 404, @response.body
  end

  test "validate the service responds to /spelling/dua with 404 when dictionary contains dual, duel, aud, dude, dumb" do
    DictionaryWord.create([{:word => 'dual'},{:word => 'duel'},{:word => 'aud'},{:word => 'dumb'},{:word => 'dude'}])
    get '/spelling/dua'
    assert_response 404, @response.body
  end

end

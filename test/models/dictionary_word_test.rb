require 'test_helper'

class DictionaryWordTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end

  test "Adding a word to the dictonary" do
    word = DictionaryWord.create(:word => "Hello")
    assert word.word === "hello"
    assert word.hash_string === "hl"
  end

  test "Finding suggestions" do
    DictionaryWord.create([{:word => "Hello"}, {:word => "Hell"}, {:word => "Help"}])
    one = DictionaryWord.find_suggestions("HeLlLlLpPpP")
    assert one.count === 1
    assert one.first.word === "help"
    two = DictionaryWord.find_suggestions("heLLo")
    assert two.count === 2
    assert two.first.word === "hell"
    assert two.last.word === "hello"
    three = DictionaryWord.find_suggestions("HALL")
    assert three.count === 2
    assert two.first.word === "hell"
    assert two.last.word === "hello"
  end
end

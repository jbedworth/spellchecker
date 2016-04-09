require 'test_helper'

class DictionaryWordTest < ActiveSupport::TestCase
  test 'the truth' do
    assert true
  end

  test 'Adding a word to the dictonary' do
    result = DictionaryWord.create(:word => 'Hello')
    assert_equal 'hello', result.word
    assert_equal 'hl', result.hash_string
  end

  test 'Finding suggestions (negative) length and last part not matching' do
    DictionaryWord.create([{:word => 'Hello'}, {:word => 'Hell'}, {:word => 'Help'}])
    result = DictionaryWord.suggestions('Helicopter')
    assert_equal 0, result.count
  end
  test 'Finding suggestions (negative) : word completely not in dictionary' do
    DictionaryWord.create([{:word => 'Hello'}, {:word => 'Hell'}, {:word => 'Help'}])
    result = DictionaryWord.suggestions('Mortimer')
    assert_equal 0, result.count
  end
  test 'Finding suggestions (negative) : differs in repeating and ending' do
    DictionaryWord.create([{:word => 'Hello'}, {:word => 'Hell'}, {:word => 'Help'}])
    result = DictionaryWord.suggestions('Hellllping')
    assert_equal 0, result.count
  end
  test 'Finding suggestions (negative) : differs in repeating and beginning' do
    DictionaryWord.create([{:word => 'Hello'}, {:word => 'Hell'}, {:word => 'Help'}])
    result = DictionaryWord.suggestions('Jelllo')
    assert_equal 0, result.count
  end

  test 'Finding suggestions : differs in case and repeating cons' do
    DictionaryWord.create([{:word => 'Hello'}, {:word => 'Hell'}, {:word => 'Help'}])
    result = DictionaryWord.suggestions('HeLlLlLpPpP')
    assert_equal 1, result.count
    assert_equal 'help', result.first
  end
  test 'Finding suggestions : differs in mixed case and repeating vowel' do
    DictionaryWord.create([{:word => 'Hello'}, {:word => 'Hell'}, {:word => 'Help'}])
    result = DictionaryWord.suggestions('heLLoooo')
    assert_equal 1, result.count
    assert_equal 'hello', result.first
  end
  test 'Finding suggestions : differs in case and missing vowel' do
    DictionaryWord.create([{:word => 'Hall'}, {:word => 'Hell'}, {:word => 'Help'}])
    result = DictionaryWord.suggestions('hLL')
    assert_equal 2, result.count
    assert_equal 'hall', result.first
    assert_equal 'hell', result.last
  end


  test 'Looking up words : matches two for suggestions, exactly one for lookup, differs in UPPERCASE only' do
    DictionaryWord.create([{:word => 'Fort'}, {:word => 'Flirt'}, {:word => 'Fart'}, {:word => 'Flat'}, {:word => 'Fleet'}])
    result = DictionaryWord.lookup('FORT')
    assert_equal 1, result.count
    assert_equal 'fort', result.first.word
  end
  test 'Looking up words : matches two for suggestions, exactly one for lookup, differs in lowercase only' do
    DictionaryWord.create([{:word => 'Fort'}, {:word => 'Flirt'}, {:word => 'Fart'}, {:word => 'Flat'}, {:word => 'Fleet'}])
    result = DictionaryWord.lookup('fort')
    assert_equal 1, result.count
    assert_equal 'fort', result.first.word
  end
  test 'Looking up words : matches two for suggestions, exactly one for lookup, differs in Capitalized only' do
    DictionaryWord.create([{:word => 'Fort'}, {:word => 'Flirt'}, {:word => 'Fart'}, {:word => 'Flat'}, {:word => 'Fleet'}])
    result = DictionaryWord.lookup('Fort')
    assert_equal 1, result.count
    assert_equal 'fort', result.first.word
  end

  test 'Looking up words (negative) : Differs in cons at end of word' do
    DictionaryWord.create([{:word => 'Fort'}, {:word => 'Flirt'}, {:word => 'Fart'}, {:word => 'Flat'}, {:word => 'Fleet'}])
    result = DictionaryWord.lookup('Forts')
    assert_equal 0, result.count
  end
  test 'Looking up words (negative) : Differs in double vowel near start (ignored) and cons at end' do
    DictionaryWord.create([{:word => 'Fort'}, {:word => 'Flirt'}, {:word => 'Fart'}, {:word => 'Flat'}, {:word => 'Fleet'}])
    result = DictionaryWord.lookup('Foorts')
    assert_equal 0, result.count
  end
  test 'Looking up words (negative) : Differs in double vowel near start (ignored)' do
    DictionaryWord.create([{:word => 'Fort'}, {:word => 'Flirt'}, {:word => 'Fart'}, {:word => 'Flat'}, {:word => 'Fleet'}])
    result = DictionaryWord.lookup('Foort')
    assert_equal 0, result.count
  end

  test 'Looking up words (negative) : Differs in mixed case only' do
    DictionaryWord.create([{:word => 'Fort'}, {:word => 'Flirt'}, {:word => 'Fart'}, {:word => 'Flat'}, {:word => 'Fleet'}])
    result = DictionaryWord.lookup('FlIrT')
    assert_equal 0, result.count
  end

  test 'Ensure words that have repeating characters are marked as misspelled' do
    word = 'foooooorrrrrrrttttt'
    DictionaryWord.create([{:word => 'Fort'}, {:word => 'Flirt'}, {:word => 'Fart'}, {:word => 'Flat'}, {:word => 'Fleet'}])
    result = DictionaryWord.lookup(word)
    assert_equal 0, result.count
    result = DictionaryWord.suggestions(word)
    assert_equal 1, result.count
    assert_equal 'fort', result.first
  end

  test 'Ensure words that are missing one or more vowels are marked as misspelled' do
    word = 'Mssissipp'
    DictionaryWord.create([{:word => 'Mississippi'}, {:word => 'Missing'}, {:word => 'Miscalculation'}, {:word => 'Miscalibrated'}, {:word => 'Miss'}])
    result = DictionaryWord.lookup(word)
    assert_equal 0, result.count
    result = DictionaryWord.suggestions(word)
    assert_equal 1, result.count
    assert_equal 'mississippi', result.first
  end

end

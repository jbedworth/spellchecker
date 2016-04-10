require 'test_helper'

class SpellableTest < ActiveSupport::TestCase
  test 'the truth' do
    assert true
  end

  test 'creating a Spellable leaves casing on word attribute' do
    result = Spellable.new('WORD I WROTE')
    assert_equal 'WORD I WROTE', result.word
  end
  test 'creating a Spellable leaves apostrophe on word attribute' do
    result = Spellable.new("WORD'S I WROTE")
    assert_equal "WORD'S I WROTE", result.word
  end
  test 'creating a Spellable strips specials dupes vowels on word_hash attribute' do
    result = Spellable.new('WORD I WROTE')
    assert_equal 'wrdwrt', result.word_hash
  end
  test "creating a Spellable strips specials dupes vowels but leaves ' on word_hash attribute" do
    result = Spellable.new("WORD'S I WROTE")
    assert_equal "wrd'swrt", result.word_hash
  end
  test 'creating a Spellable strips specials vowels on word_hash attribute' do
    result = Spellable.new("mississippi")
    assert_equal 'msssspp', result.word_hash
  end

  test "Spellable can identify lowercase as is_lower_case?" do
    result = Spellable.new("lowercase")
    assert_equal true, result.is_lower_case?
  end
  test "Spellable doesn't identify UPPERCASE as is_lower_case?" do
    result = Spellable.new("UPPERCASE")
    assert_equal false, result.is_lower_case?
  end
  test "Spellable doesn't identify Titlecase as is_lower_case?" do
    result = Spellable.new("Titlecase")
    assert_equal false, result.is_lower_case?
  end
  test "Spellable doesn't identify mIxEdCaSe as is_lower_case?" do
    result = Spellable.new("mIxEdCaSe")
    assert_equal false, result.is_lower_case?
  end

  test "Spellable can identify UPPERCASE as is_upper_case?" do
    result = Spellable.new("UPPERCASE")
    assert_equal true, result.is_upper_case?
  end
  test "Spellable doesn't identify lowercase as is_upper_case?" do
    result = Spellable.new("lowercase")
    assert_equal false, result.is_upper_case?
  end
  test "Spellable doesn't identify Titlecase as is_upper_case?" do
    result = Spellable.new("Titlecase")
    assert_equal false, result.is_upper_case?
  end
  test "Spellable doesn't identify mIxEdCaSe as is_upper_case?" do
    result = Spellable.new("mIxEdCaSe")
    assert_equal false, result.is_upper_case?
  end

  test "Spellable can identify Titlecase as is_title_case?" do
    result = Spellable.new("Titlecase")
    assert_equal true, result.is_title_case?
  end
  test "Spellable doesn't identify lowercase as is_title_case?" do
    result = Spellable.new("lowercase")
    assert_equal false, result.is_title_case?
  end
  test "Spellable doesn't identify UPPERCASE as is_title_case?" do
    result = Spellable.new("UPPERCASE")
    assert_equal false, result.is_title_case?
  end
  test "Spellable doesn't identify mIxEdCaSe as is_title_case?" do
    result = Spellable.new("mIxEdCaSe")
    assert_equal false, result.is_title_case?
  end

  test "Spellable can identify mIxEdCaSe as is_mixed_case?" do
    result = Spellable.new("mIxEdCaSe")
    assert_equal true, result.is_mixed_case?
  end
  test "Spellable can identify AlmostTitleCase as is_mixed_case?" do
    result = Spellable.new("AlmostTitleCase")
    assert_equal true, result.is_mixed_case?
  end
  test "Spellable doesn't identify lowercase as is_mixed_case?" do
    result = Spellable.new("lowercase")
    assert_equal false, result.is_mixed_case?
  end
  test "Spellable doesn't identify UPPERCASE as is_mixed_case?" do
    result = Spellable.new("UPPERCASE")
    assert_equal false, result.is_mixed_case?
  end
  test "Spellable doesn't identify Titlecase as is_mixed_case?" do
    result = Spellable.new("Titlecase")
    assert_equal false, result.is_mixed_case?
  end

end

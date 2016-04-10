## The purpose of this class is to encapsulate a "spellable" (Spell-Checkable) word in our API.  There are
## utilities for basic word clean up, computing alpha search hashes and regex terms, and managing case
## sensitivity.  For such a simple, single purpose app, I could have left this in the model, but it feels
## better factored out here, and is also _slightly_ more convenient for use in the controller here. Plus,
## it was lighter weight to test this core functionality in isolation. And, I like the name, it makes code
## more legible.

class Spellable

  def initialize( string )
    @word = string
    @word_regex = Spellable.compute_regex( @word )
    @word_hash = Spellable.compute_hash( @word )
    @word_hash_regex = Spellable.compute_hash_regex( @word )
  end

  def word
    @word
  end

  def regex
    @word_regex
  end

  def word_hash
    @word_hash
  end

  def word_hash_regex
    @word_hash_regex
  end


  def search_term
    Spellable.clean_up_leading( @word.downcase )
  end

  def is_mixed_case?
    @mixedcase ||= ! is_lower_case? && ! is_title_case? && ! is_upper_case?
  end

  def is_lower_case?
    @lowercase ||= word.downcase === word
  end

  def is_title_case?
    # Assumption: Title case is indeed the only correct format for a properly spelled word
    @titlecase ||= word.titleize === word
  end

  def is_upper_case?
    @uppercase ||= word.upcase === word
  end

  def self.clean_up(string)
    # strip out all non alpha characters
    string.gsub(/[^a-z']/i, '')
  end

  private

  def self.clean_up_leading(string)
    # strip out all non-alpha characters at the front of the string, stopping at normal text
    string.gsub(/^\W+/, '')
  end

  def self.remove_vowels(string)
    # Assumption: For this project, we are considering 'y' to be a consonant
    string.gsub(/[aeiou]/, '')
  end

  # Compute 'magic' search term, that when combined with the vowel based hash search term,
  # yields suggestions that are only off by repeated characters, missing vowels, and casing
  # differences (and combinations of these) - we basically want the entire word, downcased
  # and squeezed of repeating characters, interjected with '%' symbols. When SQL LIKE clause
  # searches on this term, it ensures the unique letters of the word are all included in the
  # search. The drawback here is that it omits suggestions that are missing a letter that was
  # in the original word (e.g. Hello would be missed when searching for "ello" because of the
  # missing 'h'). Fortunately, this meets our explicit requirements for what constitutes a
  # misspelling perfectly.

  def self.compute_regex( string )
    _tmp = Spellable.clean_up( string ).downcase.squeeze
    '%' + _tmp.gsub(/(.{1})/, '\1%')
  end

  def self.compute_hash( string )
    Spellable.remove_vowels( Spellable.clean_up( string ).downcase )
  end

  def self.compute_hash_regex( string )
    _tmp = Spellable.remove_vowels( Spellable.clean_up( string ).downcase )
    _tmp.gsub(/(.)\1{1,}/, '\1+')
  end

end

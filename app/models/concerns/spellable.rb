## The purpose of this class is to encapsulate a "spellable" (Spell-Checkable) word in our API.  There are
## utilities for basic word clean up, computing alpha search hashes and regex terms, and managing case
## sensitivity.  For such a simple, single purpose app, I could have left this in the model, but it feels
## better factored out here, and is also _slightly_ more convenient for use in the controller here.

class Spellable

  def initialize( string )
    @word = Spellable.clean_up( string )
    _mini_word = @word.downcase.squeeze
    @word_hash = Spellable.remove_vowels( _mini_word )
    @regex = Spellable.compute_regex( _mini_word )
  end

  def word
    @word
  end

  def word_hash
    @word_hash
  end

  def regex
    @regex
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

  private

  def self.remove_vowels(string)
    # Assumption: For this project, we are considering 'y' to be a consonant
    string.gsub(/[aeiou]/, '')
  end

  # Compute 'magic' search term, that when combined with the vowel based hash search term,
  # yields suggestions that are only off by repeated characters, missing vowels, and casing
  # differences (and combinations of these) - we basically want the entire word, downcased
  # and squeezed of repeating characters, interjected with '%' symbols.

  def self.compute_regex( string )
    '%' + string.gsub(/(.{1})/, '\1%')
  end

  def self.clean_up(string)
    # Assumption: In the current word-set, we ignore all non-ascii alpha characters except
    # the apostrophe, which is used in our dictionary for at least one word.
    string.gsub(/[^a-z']/i, '')
  end

end

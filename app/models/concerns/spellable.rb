class Spellable

  def initialize(string)
    @word = Spellable.clean_up( string )
    _mini_word = @word.downcase.squeeze
    @word_hash = Spellable.remove_vowels( _mini_word )
    @vowels = Spellable.remove_consonants( _mini_word )
    @regex = Spellable.compute_regex( _mini_word )
  end

  def word
    @word
  end

  def word_hash
    @word_hash
  end

  def vowels
    @vowels
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

  # Title case is indeed the only correct format for a properly spelled word

  def is_title_case?
    @titlecase ||= word.titleize === word
  end

  def is_upper_case?
    @uppercase ||= word.upcase === word
  end

  # For this project, I am considering 'y' to not be a vowel

  def self.remove_consonants(string)
    string.gsub(/[^aeiou]/, '')
  end


  def self.remove_vowels(string)
    string.gsub(/[aeiou]/, '')
  end


  def boil_to_array
    @word.downcase.squeeze.scan(/\w/)
  end

  def has_consonants?( string )
    _n = Spellable.remove_vowels(string)
    _n.length > 0
  end

  def self.compute_regex( string )
    '%' + string.gsub(/(.{1})/, '\1%')
  end

  private

  # In the current word-set, we ignore all non-ascii alpha characters except the apostrophe, which
  # is used in our dictionary for at least one word.

  def self.clean_up(string)
    string.gsub(/[^a-z']/i, '')
  end

end

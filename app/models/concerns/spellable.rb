class Spellable

  def initialize(string)
    @word = Spellable.clean_up( string )
    @word_hash = Spellable.remove_vowels(@word.downcase).squeeze
  end

  def word
    @word
  end

  def word_hash
    @word_hash
  end

  def misspelled?

    # Rule 1 - correctly spelled words do not have extra repeating characters (TODO clarify repeating characters rule)

    # Rule 2 - correctly spelled words do not have mixed-up casing

    # Rule 3 - words that match words in our dictionary but are missing one or more vowels
  end

  def self.remove_vowels(string)
    string.gsub(/[aeiou]/, '')
  end

private

  def self.clean_up(string)
    string.gsub(/[^a-z]/i, '')
  end

end

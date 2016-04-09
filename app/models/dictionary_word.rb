require 'rest-client'

class DictionaryWord < ApplicationRecord

  default_scope -> { order(:word )}
  validates :word, presence: true, uniqueness: true
  before_save :_before_save

  # do basic clean up with Spellable and do a case-insensitive search for the cleaned up
  # word.  If we find it, the word is spelled correctly.

  def self.lookup( word )
    _lookup = Spellable.new( word )
    if _lookup.is_mixed_case?
      # never return a result for mixed case words even if they are in the dictionary
      DictionaryWord.none
    else
      # do a case-insensitive search for the word
      DictionaryWord.where( :word => _lookup.word.downcase )
    end
  end

  # our current rules are pretty explicit (and need to be reworked to cast a wider net if this were ever released)
  # The first term of the where clause includes words that have the same pattern of consonants, ignoring repeating
  # characters and vowels all together.  The second clause loosely pattern matches on the entire word, including
  # vowels, ensuring that words are only included if they are omitting vowels, and don't have any extra non-repeating
  # letters throwing things off.  Combined, these two clauses give us the ability to utilize the power of SQL to
  # implement spell checking, and since the database is relatively static and there is no notion of user dictionary,
  # we can add mirror/slave dbs at will.
  def self.suggestions( string )
    _lookup = Spellable.new( string )
    DictionaryWord.where('hash_string = :word_hash and word LIKE :regex',
                     word_hash: _lookup.word_hash, regex: _lookup.regex ).pluck(:word)
  end

  # Load the dictionary from the specified URL. Follow redirects, if we end up with
  # a 200 response, nuke the current dictionary and load from the site.  Assumes the format is
  # simply a plain text list of words.  Normally, I'd make this more resilient to
  # formatting and support other encodings, JSON data, XML, etc.

  def self.load_from( url = 'http://tinyurl.com/bvapsn7' )
    response = RestClient.get( url )
    if response.code == 200
      DictionaryWord.delete_all
      dictionary = response.body
      dictionary.each_line do |word|
        begin
          DictionaryWord.create(:word => word)
        rescue ActiveRecord::RecordNotUnique => e
          #could capture this dupe in a second table, but just skip it and move on...
          puts e.message
          puts "Duplicate Record Error (#{word} all ready exists in dictionary), non catastrophic. Continuing onward..."
        end
      end
    end
  end

private

  # Clean up dictonary_words entry before saving it, compute the suggestion search hash.

  def _before_save
    _t = Spellable.new( self.word )
    self.word = _t.word.downcase
    self.hash_string = _t.word_hash
  end

end

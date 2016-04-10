## This class represents our dictionary, and along with the controller, represents the majority of the logic in
## our little service.
##
## I would have just called it Dictionary, and had a class method for adding words, but, this is an
## ActionRecord model and that doesn't fit the Rails convention. So, DictionaryWord/dictionary_words it is...
##
## Also somewhat non-standard, I added a class method here for loading the dictionary from:
##    http://www-01.sil.org/linguistics/wordlists/english/wordlist/wordsEn.txt (tinyurl.com/bvapsn7)
## which is called in seed.rb.
## This allows rails developers who haven't had their coffee yet to set this app up on autopilot (who hasn't
## run rails db:init/create, db:seed half asleep?).  I like the convenience of having the load_from method
## live in this model, simply because this is the only table in our app, and having the knowledge of how to
## populate itself here, close to validations and what not, nice; even though it's more standard to just do
## it as a function in seed.rb.
##
## And, it feels funny writing so much comment text for such a small/simple app.  Normally, I feel well written
## code makes the best comments, and I reserve explicit comments for when I'm doing something tricksy.  There
## isn't much magic happening here, but since I'm the new guy I'm going to over-do the commenting thing.
##
## Finally, I sort of regret selecting word_hash as a field name, because it's not technically a numerical hash
## function that maps data of arbitrary size to data of fixed size, but it's close enough and does make this
## table behave sort of like a hash table, sort of.

require 'rest-client'

class DictionaryWord < ApplicationRecord

  default_scope -> { order(:word )}
  validates :word, presence: true, uniqueness: true
  before_save :_before_save

  # do basic clean up with Spellable and do a case-insensitive search for the cleaned up
  # word.  If we find it, the word is spelled correctly.

  def self.lookup( word )
    _lookup = Spellable.new( word )
    if _lookup.is_mixed_case? ## >> never return a result for mIxEd case words even if they are in the dictionary
      DictionaryWord.none
    else                      ## >> do a case-insensitive search for the word
      DictionaryWord.where( :word => _lookup.search_term )
    end
  end

  # Criteria: Return words in the dictionary that are correct spellings of the passed in 'string'.  This means find all
  #  words in the dictionary that differ _only_ in ways that are considered incorrect via our spelling rules.  The rules
  #  are:  (a) any repeating characters, (b) missing one or more vowels, (c) mixed casing, (d) any/all combinations of these.
  # We handle (c) mixed casing by making everything lower case and handling mixed case scenario in the lookup.
  # We handle (b) missing vowels by filtering them out of our hash.  We make sure they are only missing (not extra vowels)
  #  by including vowels in our word LIKE :regex clause.
  # We handle repeating consonants (a) (vowels don't matter because they can be missing) in our word hash search. The two
  # components of our query for suggestions are hash_string / word_hash and the whole word LIKE a regex term (noted above)
  # The DictionaryWord hash_string is computed by cleaning up, downcasing, and stripping vowels from the word.
  # The Spellable word_hash_regex is computed by cleaning up, downcasing, stripping vowels, and replacing repeating
  #  characters (x) with x+.  This is used in the SIMILAR TO query clause to match one or more of x in the word's hash_string.
  # For example, the DictonaryWord "Hello" hashes to "hll".  The Spellable term "Helllooo" hash_regex is "hl+" doing a
  # SIMILAR TO query on "hl+" matches "Hello"'s "hll" hash.  Adding the second LIKE clause ("%h%e%l%o%") ensures we aren't
  # getting things jumbled up and aren't considering terms with missing consonants.
  # This approach catches common mistakes (that we'd consider including if we wanted to make this a real product) like
  # including "Hello" as a correction for "Helo".  While this looks like a great suggestion, it's technically wrong because
  # "Hello" has two consonant 'l' and "Helo" only has one.  Finding a solution that filtered this out properly in SQL was
  # challenging, but not impossible.  This still may not be perfect (esp in non-english languages), but it handles every
  # case I have come up with so far.

  def self.suggestions( string )
    _lookup = Spellable.new( string )
    DictionaryWord.where('hash_string SIMILAR TO :word_hash AND word LIKE :regex',
                          word_hash: _lookup.word_hash_regex, regex: _lookup.regex ).pluck( :word )
  end

  # Load the dictionary from the specified URL. Follow redirects, if we end up with
  # a 200 response, nuke the current dictionary and load from the site.  Assumes the format is
  # simply a plain text list of words.  Normally, I'd make this more resilient to
  # formatting and support other encodings, JSON data, XML, etc.  However, keeping things simple
  # and moving right along:

  def self.load_from( url = 'http://tinyurl.com/bvapsn7' )
    response = RestClient.get( url )
    if response.code == 200
      DictionaryWord.delete_all
      dictionary = response.body
      dictionary.each_line do |word|
        begin
          DictionaryWord.create( :word => word )
        rescue ActiveRecord::RecordNotUnique => e
          #could capture this dupe in a second table, but just skip it and move on...
          puts e.message
          puts "Duplicate Record Error (#{ word } all ready exists in dictionary), non catastrophic. Continuing onward..."
        end
      end
    end
  end

private

  # Clean up dictonary_words entry before saving it, compute the suggestion search hash.

  def _before_save
    _t = Spellable.new( self.word )
    self.word = Spellable.clean_up( _t.word.downcase )
    self.hash_string = _t.word_hash
  end

end

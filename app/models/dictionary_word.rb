require 'rest-client'

class DictionaryWord < ApplicationRecord

  default_scope -> { order(:word )}
  validates :word, presence: true, uniqueness: true
  before_save :_before_save

  def self.find_word( string )
    _lookup = Spellable.new( string )
    DictionaryWord.where( :word => _lookup.word )
  end

  def self.find_suggestions( string )
    _lookup = Spellable.new( string )
    DictionaryWord.where( :hash_string => _lookup.word_hash )
  end

  def self.load
    response = RestClient.get 'http://tinyurl.com/bvapsn7'
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

  def _before_save
    _t = Spellable.new( self.word )
    self.word = _t.word.downcase
    self.hash_string = _t.word_hash
  end

end

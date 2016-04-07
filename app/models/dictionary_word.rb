class DictionaryWord < ApplicationRecord

  default_scope -> { order(:word )}
  validates :word, presence: true, uniqueness: true
  before_save :_before_save

  def self.find_suggestions( string )
    _lookup = Spellable.new( string )
    DictionaryWord.where( :hash_string => _lookup.word_hash )
  end

private

  def _before_save
    _t = Spellable.new( self.word )
    self.word = _t.word.downcase
    self.hash_string = _t.word_hash
  end

end

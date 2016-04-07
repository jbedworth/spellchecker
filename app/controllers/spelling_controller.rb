class SpellingController < ApplicationController

  # Actions

  def check_word
    # Generally, if the word is an exact match for a word in our dictionary, and it meets the following rules, it's correct
    # if it's not an exact match, or, it violates a rule, lookup suggestions.  If there aren't any, return 404.  If we find
    # some appropriate suggestions, return 200 and an array of suggestions.
    @word = params[:word]
    @spellable = Spellable.new(@word)
    @entry = DictionaryWord.find_by_word(@spellable.word)

  end
end

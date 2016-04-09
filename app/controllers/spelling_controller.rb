class SpellingController < ApplicationController

  # Actions

  def check_word
    # If the word is an exact match for a word in our dictionary, and it meets the following rules, it's correct.
    # If it's not an exact match, or, it violates a rule, lookup suggestions.  If there aren't any, return 404.  If we find
    # some appropriate suggestions, return 200 and an array of suggestions.
    @word = params[:word]
    @payload = {}
    @status_code = 404 # << Initialize to failure scenario
    @response_correct = false
    _spellable = Spellable.new(@word)
    @entry = DictionaryWord.lookup(_spellable.word)
    if @entry.count === 1 # << Found an exact match!!
      @status_code = 200
      @response_correct = true
      @payload = { correct: @response_correct }
    else # << No exact match, search for suggestions
      @suggestions = DictionaryWord.suggestions(_spellable.word)
      if @suggestions.any?
        @status_code = 200
        _response_correct = false
        @payload = { correct: @response_correct, suggestions: @suggestions }
      end
    end
    render :json => @payload, :status => @status_code
  end
end

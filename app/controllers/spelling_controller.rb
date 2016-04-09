class SpellingController < ApplicationController

  # Actions

  def check_word
    # Generally, if the word is an exact match for a word in our dictionary, and it meets the following rules, it's correct
    # if it's not an exact match, or, it violates a rule, lookup suggestions.  If there aren't any, return 404.  If we find
    # some appropriate suggestions, return 200 and an array of suggestions.
    @word = params[:word]
    _payload = {}
    _status_code = 404
    _response_correct = false
    _spellable = Spellable.new(@word)
    @entry = DictionaryWord.lookup(_spellable.word)
    if @entry.count === 1
      _status_code = 200
      _response_correct = true
      _payload = { correct: _response_correct }
    else
      @suggestions = DictionaryWord.suggestions(_spellable.word)
      if @suggestions.any?
        _status_code = 200
        _response_correct = false
        _payload = { correct: _response_correct, suggestions: @suggestions }
      end
    end

    render :json => _payload, :status => _status_code
  end
end

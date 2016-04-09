class SpellingController < ApplicationController
  def check_word
    # If the word is an exact match for a word in our dictionary, and it meets the following rules, it's correct.
    # If it's not an exact match, or, it violates a rule, lookup suggestions.  If there aren't any, return 404.  If we find
    # some appropriate suggestions, return 200 and an array of suggestions.
    # TODO the spec says to not return a response body at all if the response is 404, check if my standard is ok
    #  My thought is, if we get this far (aka the api call is allowed and valid), we should return at the very least
    #  an empty response body, which differentiates from a blocked, disallowed, or invalid "truly unreachable" 404.
    @word = params[:word]
    @payload = {}               # << Initialize to an empty object
    @status_code = 404          # << Initialize to failure scenario
    @response_correct = false   # << Initialize to false - not correct
    unless @word.nil?
      _spellable = Spellable.new( @word )
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
    end
    render :json => @payload, :status => @status_code
  end
end

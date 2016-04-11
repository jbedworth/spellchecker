## Very straightforward controller for our service.  If we are passed in a word, check to see if it is an exact
## match for an item in our dictionary.  If it is, return 200/correct:true JSON.  If no exact match exists, check to
## see if there are any potential corrections in our dictionary.  If so, return 200/correct:false and the array.
## Otherwise, return 404.

class SpellingController < ApplicationController
  def check_word
    @word = params[:word]
    @status = 404
    @json = nil
    unless @word.nil?
      @entry = DictionaryWord.lookup( @word )
      if @entry.count === 1
        # << Found an exact match. Word is correct! Set status 200 and set correct:true in JSON
        @status = 200
        @json = { correct: true }
      else # << No exact match, search for suggestions
        @suggestions = DictionaryWord.suggestions( @word )
        if @suggestions.any?
          # We found some word suggestions, return them in our JSON and set status 200
          @status = 200
          @json = { correct: false, suggestions: @suggestions }
        end
      end
    end
    if @json.nil?
      # if no JSON, just return the status
      render :status => @status
    else
      # return both the json and the status
      render :json => @json, :status => @status
    end
  end
end

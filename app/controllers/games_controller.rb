require 'net/http'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
  end

  def score
    @letters = params[:info].split(//)
    @question = params[:question].upcase
    if check_false?
      @response = "Sorry but #{@question} can't be built out of #{@letters.join(', ')}"
    else
      sorry_resp = "Sorry but #{@question} does not seem to be a valid English word..."
      congrats_resp = "Congratulations! #{@question} is a valid English word!"
      @response = data_parse ? congrats_resp : sorry_resp
    end
  end

  def check_false?
    invalidity = false
    letter_check = @letters
    @question.split(//).each do |letter|
      if letter_check.include?(letter)
        letter_check.delete_at(letter_check.index(letter))
      else
        invalidity = true
      end
    end
    invalidity
  end

  def data_parse
    data = JSON.parse(Net::HTTP.get(URI("https://wagon-dictionary.herokuapp.com/#{@question}")))
    data[:found]
  end
end

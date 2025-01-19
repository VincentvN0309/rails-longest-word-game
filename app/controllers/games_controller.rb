require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array('A'..'Z').sample(10)
     puts "Generated letters: #{@letters.inspect}"
  end

  def score
    @letters = params[:letters].split
    @word = params[:word].upcase

    if !word_in_grid?(@word, @letters)
      @message = "Sorry, #{@word} can't be built out of #{@letters.join(', ')}."
    elsif !valid_english_word?(@word)
      @message = "Sorry, #{@word} is not a valid English word."
    else
      @message = "Congratulations! #{@word} is a valid word!"
      session[:total_score] ||= 0
      session[:total_score] += @word.length
    end
  end

  private

  def word_in_grid?(word, grid)
    word.chars.all? { |char| word.count(char) <= grid.count(char) }
  end

  def valid_english_word?(word)
    url = "https://api.dictionaryapi.dev/api/v2/entries/en/#{word}"
    JSON.parse(URI.open(url).read).is_a?(Array) rescue false
  end
end

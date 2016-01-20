class Game < ActiveRecord::Base
  belongs_to :player
  has_many :guesses, :dependent => :destroy

  before_validation :fill_word_to_guess

  validates :word_to_guess, presence: true, on: :create
  validates :number_of_lives, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :player, presence: true

  attr_writer :custom_word

  def guessed_letters
    guesses.map(&:letter)
  end

  def custom_word
    @custom_word || true
  end

  def censored_word
    if game_over?
      word_to_guess.chars
    else
      word_to_guess.chars.map do |letter|
        guessed_letters.include?(letter) ? letter : nil
      end
    end
  end

  def won?
    word_to_guess.chars.all? do |letter|
      guessed_letters.include?(letter.downcase)
    end
  end

  def out_of_lives?
    number_of_lives_remaining == 0
  end

  def lost?
    !won? && out_of_lives?
  end

  def game_over?
    won? || lost?
  end

  def incorrect_guesses
    guessed_letters - word_to_guess.chars
  end

  def number_of_lives_remaining
    [number_of_lives - incorrect_guesses.length, 0].max
  end

  private

  def fill_word_to_guess
    write_attribute(:word_to_guess, GenerateRandomWord.new.call) if !custom_word || word_to_guess.blank?
  end
end

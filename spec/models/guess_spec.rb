require 'rails_helper'

RSpec.describe Guess, type: :model do
  let(:letter) { "a" }
  let(:game) { Game.create(word_to_guess: "word", number_of_lives: 5, user: User.create!(name: "Jordane", email: "foo@bar.com")) }
  subject(:guess) { Guess.new(letter: letter, game: game) }

  context "when creating a new guess" do
    let(:letter) { "" }
    it { is_expected.to_not be_valid }
  end

  context "when making a guess with a letter that isn't in the alphabet" do
    let(:letter) { "!" }
    it { is_expected.to_not be_valid }
  end

  context "when making a guess with a word instead of a letter" do
    let(:letter) { "abc" }
    it { is_expected.to_not be_valid }
  end

  context "when making a unique guess" do
    let(:letter) { "a" }
    it { is_expected.to be_valid }
  end
end

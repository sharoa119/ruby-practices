# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'game'
require_relative 'shot'
require_relative 'frame'

class GameTest < Minitest::Test
  def test_score1
    game = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
    assert_equal 139, game.total_score
  end

  def test_score2
    game = Game.new("6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X")
    assert_equal 164, game.total_score
  end

  def test_score3
    game = Game.new("0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4")
    assert_equal 107, game.total_score
  end

  def test_score4
    game = Game.new("6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0")
    assert_equal 134, game.total_score
  end

  def test_perfect_game
    game = Game.new("X,X,X,X,X,X,X,X,X,X,X,X")
    assert_equal 300, game.total_score
  end
end

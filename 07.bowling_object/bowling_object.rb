#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'game'

score = ARGV[0]
game = Game.new(score)
game.play
puts game.total_score

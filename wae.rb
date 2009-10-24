require 'rubygems'
require 'treetop'
require 'polyglot'

Treetop.load "waeg"

class Runtime
  def initialize
    @wae = WaeParser.new
  end

  def start
    while true
      print 'WAE > '
      input = gets.chomp
      puts @wae.parse(input).eval
    end
  end

end

Runtime.new.start

$:.unshift File.join(File.dirname(__FILE__))

require 'test/unit'
require 'rubygems'
require 'treetop'

Treetop.load "waeg"


class Wae_Grammar_Test < Test::Unit::TestCase


  def setup
    @parser = WaeParser.new
  end #setup

  def test_num
    assert(@parser.parse('0'))
    assert(@parser.parse('90876'))
    assert_equal 0, @parser.parse('0').eval
    assert_equal 90210, @parser.parse('90210').eval
    assert_not_equal 987, @parser.parse('234').eval
  end

  def test_id
    assert_equal 2, @parser.parse('x').eval({'x' => 2})
  end

  def test_negop
    assert(@parser.parse('-x'))
    assert_equal -5, @parser.parse('-5').eval
    assert_equal -5, @parser.parse('-x').eval({'x' => 5})
  end

  def test_sumop
    assert(@parser.parse('{ + x {- 3 -4} }'))
    assert_equal 7, @parser.parse('{ + 2 5 }').eval
    assert_equal 11, @parser.parse('--{+{-3-4}{ +--5{+ 2 -3}}}').eval
    assert_equal 4, @parser.parse('{ + x 2}').eval({'x' => 2})
    assert_equal 2, @parser.parse('{+ 3 x}').eval({'x' => -1})
  end

  def test_with
    assert(@parser.parse('{with {x 2} { + {with {y {with {z {+ 3 4}} z}}{+yz}} x}}'))
    assert_equal 8, @parser.parse('{with { x 8 } x}').eval
    assert_equal 14, @parser.parse('{+ {with { x 8 } x} 6}').eval
    assert(@parser.parse('{+ {with { x 3 } x} {with {y 2} y}}'))
    assert_equal 5, @parser.parse('{+ {with { x 3 } x} {with {y 2} y}}')
#  assert_equal 6, @parser.parse('{with {x 2} { + x {with { y 4} y}}}').eval
  end

end

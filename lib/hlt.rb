#!/usr/bin/env ruby

# file: hlt.rb

require 'line-tree'

class Hlt

  attr_reader :to_html

  def initialize(s)
    a = s.scan(/^\[([^\]]+)\]\n/).map(&:first)
    s2 = s.gsub(/\n\[[^\]]+\]\n/, " !CODE\n")
    raw_html = LineTree.new(s2).to_xml
    html = raw_html.gsub('!CODE').with_index do |x,i| 
      "\n" + a[i].lines.map{|x| "\n%s%s\n" % [' ' * 4,x]}.join
    end
    @to_html = Rexle.new(html).xml pretty: true
  end

end

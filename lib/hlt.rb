#!/usr/bin/env ruby

# file: hlt.rb

require 'line-tree'

class Hlt

  attr_reader :to_html

  def initialize(raw_s)
    # strip out lines which are blank or only contain a comment
    s = raw_s.lines.to_a.reject!{|x| x[/(^\s+#)|(^\s*$)/] }.join
    # strip out the text from the line containing a comment
    s.gsub!(/((^#\s|\s#\s).*)/,'').strip if s[/((^#\s|\s#\s).*)/]
    a = s.scan(/^\[([^\]]+)\]\n/).map(&:first)
    s2 = s.gsub(/\n\[[^\]]+\]\n/, " !CODE\n")
    raw_html = LineTree.new(s2).to_xml
    html = raw_html.gsub('!CODE').with_index do |x,i| 
      "\n\n" + a[i].lines.map{|x| ' ' * 4 + x}.join + "\n"
    end
    @to_html = Rexle.new(html).xml pretty: true
  end

end

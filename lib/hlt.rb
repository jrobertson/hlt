#!/usr/bin/env ruby

# file: hlt.rb

require 'line-tree'

class Hlt

  attr_reader :to_html

  def initialize(raw_s)

    # strip out lines which are blank or only contain a comment
    #s = raw_s.lines.to_a.reject!{|x| x[/(^\s+\#\s)|(^\s*$)/] }
    s = raw_s

    # strip out the text from the line containing a comment
    s.gsub!(/((^#\s|\s#\s).*)/,'').strip if s[/((^#\s|\s#\s).*)/]
    a = s.scan(/^\[([^\]]+)\]\n/).map(&:first)
    s.gsub!(/\n\[[^\]]+\]\n/, " !CODE\n")

    s2 = s.lines.to_a.map!{|line| 

      hash = "(\s+\{[^\}]+\})?"
      line.sub(/^\s+(\w+)?(?:[\.#]\w+){1,}#{hash}/) do |x| 

        raw_attrs = x.slice!(/\{.*\}/)
        attrs = raw_attrs[1..-2] if raw_attrs

        a2 = []
        tag = x[/((?:^|\s+)\w*)#/,1] || 'div'
        tag += 'div' if tag.strip.empty?

        x.sub(/(?:\.\w+){1,}/) do |x2|
          a = x2[/(?:\.\w+){1,}/].split('.')
          a.shift
          a2 << "class: '%s'" % a.join(' ')
        end

        x.sub(/#\w+/) {|x2| a2 << "id: '%s'" % x2[1..-1] }

        a2 << attrs if attrs
        "%s {%s}" % [tag, a2.join(', ')]

      end
    }.join

    raw_html = LineTree.new(s2).to_xml
    html = raw_html.gsub('!CODE').with_index do |x,i| 
      "\n\n" + a[i].lines.map{|x| ' ' * 4 + x}.join + "\n"
    end
    @to_html = Rexle.new(html).xml pretty: true
  end

end
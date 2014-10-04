#!/usr/bin/env ruby

# file: hlt.rb

require 'line-tree'
require 'rdiscount'

class Hlt

  attr_reader :to_html

  def initialize(raw_s)

    # strip out lines which are blank or only contain a comment
    #s = raw_s.lines.to_a.reject!{|x| x[/(^\s+\#\s)|(^\s*$)/] }

    s, markdown = fetch_markdown raw_s

    #s = raw_s
    # strip out the text from the line containing a comment
    s.gsub!(/((^#\s|\s#\s).*)/,'').strip if s[/((^#\s|\s#\s).*)/]
    a_code = s.scan(/^\[([^\]]+)\]\n/).map(&:first)
    s.gsub!(/\n\[[^\]]+\]\n/, " !CODE\n")

    s2 = s.lines.to_a.map!{|line| 

      hash = "(\s*\{[^\}]+\})?"

      r = line.sub(/^\s+(\w+)?(?:[\.#]\w+){1,}#{hash}/) do |x| 

        raw_attrs = x.slice!(/\{.*\}/)
        attrs = raw_attrs[1..-2] if raw_attrs

        a2 = []
        tag = x[/(^\s*\w*)[#\.]/,1] || 'div'
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

      r
    }.join


    raw_html = LineTree.new(s2).to_xml

    html = raw_html.gsub('!CODE').with_index do |x,i| 
      "\n\n" + a_code[i].lines.map{|x| ' ' * 4 + x}.join + "\n"
    end

    markdown.each.with_index do |x,i|
      html.sub!(/<markdown:#{i}\/>/, RDiscount.new(x).to_html
        .gsub(/<(\w+)>{style:\s*['"]([^'"]+)[^\}]+\}/,'<\1 style=\'\2\'>'))
    end

    @to_html = Rexle.new(html).xml pretty: true

  end

  def fetch_markdown(raw_s)

    # any lines which are in the context of markdown which only contain
    # a new line character will have spaces inserted into them

    prev_line = ''
    s = raw_s.lines.map {|line|
      line = prev_line.to_s + "\n" if line == "\n"
      prev_line = line[/^\s+/]
      line
    }.join

    index, spaces, md_spaces = 0, 0, 0
    state = :default
    markdown = []

    s2 = s.lines.map do |line|
      
      if state == :markdown then
        
        spaces = line[/^\s+/].to_s.length
        
        if spaces > md_spaces then
          markdown[index] << line[(md_spaces + 2)..-1]
          line = ''
        else
          markdown[index].strip!
          index += 1
          state = :default
          
          r = line[/^(\s+)markdown:/,1]

          if r then  

            state = :markdown 
            md_spaces = r.length    

            line.sub!(/markdown:/,'\0' + index.to_s)
            markdown[index] = ''
          end
        end                

      else

        r = line[/^(\s+)markdown:/,1]

        if r then  

          state = :markdown 
          md_spaces = r.length    

          line.sub!(/markdown:/,'\0' + index.to_s)
          markdown[index] = ''
        end
      end

      line

    end

    [s2.join, markdown]
  end

end

#!/usr/bin/env ruby

# file: hlt.rb


require 'martile'
require 'rexle-builder'


class Hlt
  using ColouredText

  attr_reader :to_html, :to_doc

  def initialize(raw_s, pretty: true, declaration: true, style: true,
                 nocomment: true,  debug: false)


    @debug = debug
    # strip out lines which are blank or only contain a comment
    #s = raw_s.lines.to_a.reject!{|x| x[/(^\s+\#\s)|(^\s*$)/] }

    raw_s.strip!

    s2, martile = fetch_martile raw_s
    puts 'martile: ' + martile.inspect if @debug
    s, xml_list = filter_xml(s2)

    #s = raw_s
    # strip out the text from the line containing a comment
    s.gsub!(/((^#\s|\s#\s).*)/,'').strip if s[/((^#\s|\s#\s).*)/]
    puts ('s: ' + s.inspect).debug if @debug
    a_code = s.scan(/^\[([^\]]+)\]\B/).map(&:first)
    puts ('a_code: ' + a_code.inspect).debug if @debug
    s.gsub!(/\n\[[^\]]+\]\B/, " !CODE\n")

    s2 = s.lines.to_a.map!{|line|

      hash = "(\s*\{[^\}]+\})?"

      line.prepend '  '

      line.sub!(/^(\s*)\w+: /,'\0' + "\n" + '\1')

      r = line.sub(/^\s*(\w+)?(?:[\.#]\w+){1,}#{hash}/) do |x|

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
    }

    s2.unshift "root\n"
    s3 = s2.join.gsub(/^(\s*)-\s+/,'\1templatecode ').\
                                       gsub(/^(\s*)=\s+/,'\1templateoutput ')

    puts ('s3: ' + s3.inspect).debug if @debug

    raw_html = LineTree.new(*s3, ignore_non_element: false, debug: debug).to_xml
    puts ('raw_html: ' + raw_html.inspect).debug if @debug

    html = raw_html.gsub('!CODE').with_index do |x,i|
      "\n\n" + a_code[i].lines.map{|x| ' ' * 4 + x}.join + "\n"
    end

    martile.each.with_index do |x,i|

      if @debug then
        puts ('i: ' + i.inspect).debug
        puts ('x: ' + x.inspect).debug
        puts ('html: ' + html.inspect).debug
      end

      html.sub!(/<mar(tile|kdown):#{i.to_s}\/>/, RDiscount.new(\
                  Martile.new(x).to_s).to_html\
            .gsub(/<(\w+)>\s*{style:\s*['"]([^'"]+)[^\}]+\}/,\
                  '<\1 style=\'\2\'>'))
    end

    puts ('html_: ' + html.inspect).debug if @debug

    doc = Rexle.new(html)

    xml_list.each.with_index do |xml,i|
      e = doc.root.element('//xml:' + i.to_s)
      e.insert_before Rexle.new(xml).root
      e.delete
    end

    # remove the style attributes from the document if style == false
    #
    if style == false then
      doc.root.xpath('//.[@style]').each do |e|
        unless e.attributes[:style][/^clear:/] then
          e.attributes.delete :style
        end
      end
    end


    @doc = doc
    h = {declaration: declaration, pretty: pretty, style: style}
    html = doc.root.xpath('*'){|x| x.xml(h)}.join("\n")

    time = Time.now
    timestamp = time.strftime("#{ordinalize(time.day)} %B %Y @ %H:%M")

    unless nocomment
      comment = "\n  <!-- Generated by Hlt-site_builder on the %s -->\n" % timestamp
      html.sub!(/(?=<\/html>)/, comment)
    end

    @to_html = html

  end

  def render(locals: {})

    variables = locals.map do |key, value|
      "#{key} = locals['#{key}']"
    end

    s = "xml = RexleBuilder.new\n"
    s <<  scanbuild(@doc.to_a)

    a = eval variables.join("\n") + "\n" + s

    Rexle.new(a).element('root/.')

  end

  def to_doc()
    @doc
  end

  private

  def filter_xml(s)

    n = s =~ /</
    return [s,[]] unless n

    end_pos = s.length - (s =~ />[^>]+$/)


    i = 0
    xml = []

    while n do

      a = RexleParser.new(s[n..-(end_pos)]).to_a

      doc = if a[0].length > 3 then
        Rexle.new(['root', {}, '', *a])
      else
        Rexle.new(['root', {}, '', a])
      end

      s2 = doc.root.element('*').xml

      xml << s2
      s.sub!(s2, "xml:#{i.to_s}")
      i += 1

      n = s =~ /</
    end

    [s, xml]

  end

  def fetch_martile(raw_s)

    # any lines which are in the context of martile which only contain
    # a new line character will have spaces inserted into them

    prev_line = ''
    s = raw_s.lines.map {|line|
      line = prev_line.to_s + "\n" if line == "\n"
      prev_line = line[/^\s+/]
      line
    }.join

    index, spaces, md_spaces = 0, 0, 0
    state = :default
    martile = []

    s2 = s.lines.map do |line|

      puts ('line: ' + line.inspect).debug if @debug

      if state == :martile then

        spaces = line[/^\s+/].to_s.length

        if spaces > md_spaces then
          martile[index] << line[(md_spaces + 2)..-1]
          line = ''
        else
          martile[index].strip!
          index += 1
          state = :default

          r = line[/^(\s+)martile:/,1]

          if r then

            state = :martile
            md_spaces = r.length

            line.sub!(/mar(kdown|tile):/,'\0' + index.to_s)
            martile[index] = ''
          end
        end

      else

        r = line[/^(\s+)mar(kdown|tile):/,1]

        if r then

          state = :martile
          md_spaces = r.length
          line.sub!(/mar(kdown|tile):/,'\0' + index.to_s)

          martile[index] = ''
        end
      end

      puts ('line: ' + line.inspect).debug if @debug
      line

    end

    [s2.join, martile]
  end

  def ordinalize(n)
    n.to_s + ( (10...20).include?(n) ? 'th' :
               %w{ th st nd rd th th th th th th }[n % 10] )
  end


  def v(x)

    if x then
      var = x[/^=\s+(.*)/,1]
      var ? var : x.inspect
    end

  end

  def scanbuild(x, indent=0)

    name, attributes, *remaining = x

    children = remaining.shift
    text = ''


    if children.is_a? Array then
      nested = scanbuild(children, indent+1)
    elsif children
      text = children
    end

    pad = '  ' * indent


    s2 = if children.is_a? Array then
      if name == 'templatecode' then
        "%s%s" % [pad, text]
      else
        "%sxml.%s(%s,%s) do\n%s" % \
                                  [pad, name, attributes.to_s, v(text), nested]
      end
    else
      if name == 'templatecode' then
        "%s%s" % [pad, text]
      else
        '  ' * indent + "xml.%s(%s,%s)" % [name, attributes.to_s, v(text)]
      end
    end

    while remaining.any? do
      children = remaining.shift
      if children and children.is_a? Array then
        s2 << "\n" + scanbuild(children, indent+1)
      end
    end

    s2 << "\n%send" % [pad] if children.is_a?(Array) or name == 'templatecode'

    s2
  end


end

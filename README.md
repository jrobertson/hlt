# What's new in the the Hlt gem version 0.5.0

The Hlt#render method is still under development, however you can see that the Sliml template can now include code statements prefixed by a dash (-) symbol. Although the code statements currently cannot be executed they are at least identified as code statements in the intermediate output.

    require 'hlt'


    s =<<S
    html {lang: 'en'}
      head
        title Testing 1 2 3
        meta {charset: 'utf-8'}
      body
        table
        - for item in bank['transactions'] do
          tr
            - for field in item
              td = field

    S

    hlt = Hlt.new(s)
    puts hlt.render


Output:

<pre>
&lt;html lang='en'&gt;
  &lt;head&gt;
    &lt;title&gt;Testing 1 2 3&lt;/title&gt;
    &lt;meta charset='utf-8'/&gt;
  &lt;/head&gt;
  &lt;body&gt;
    &lt;table/&gt;
    &lt;templatecode&gt;for item in bank['transactions'] do&lt;/templatecode&gt;
    &lt;tr&gt;
      &lt;templatecode&gt;for field in item&lt;/templatecode&gt;
      &lt;td&gt;= field&lt;/td&gt;
    &lt;/tr&gt;
  &lt;/body&gt;
&lt;/html&gt;
</pre>

-----------------------

# Introducing the HTML Line Tree (HLT) gem

The HTML Line Tree (HLT) gem generates HTML from text in Line-Tree format. e.g.

    require 'hlt'

    s =<<S
    html {lang: 'en'}
      head
        title
        meta {charset: 'utf-8'}
        # link {rel: 'stylesheet', type: 'text/css', href: 'foo', media: 'screen'}
        # script {type: 'text/javascript', src: '123'}

      body
        script
    [
    // javascript goes here
    ]

    S

    Hlt.new(s).to_html

output:

    puts Hlt.new(s).to_html


    <?xml version='1.0' encoding='UTF-8'?>
    <html lang='en'>
      <head>
        <title></title>
        <meta charset='utf-8'></meta>
      </head>
      <body>
        <script>
        // javascript goes here

    </script>
      </body>
    </html>


## Resources

* [jrobertson/hlt](https://github.com/jrobertson/hlt)

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
        <meta charset='utf-8'>
          <link rel='stylesheet' type='text' href='foo' media='screen'></link>
          <script type='text' src='123'></script>
        </meta>
      </head>
      <body>
        <script>
        // javascript goes here

    </script>
      </body>
    </html>


## Resources

* [jrobertson/hlt](https://github.com/jrobertson/hlt)

# What's new in the Hlt gem version 0.5.1

    require 'hlt'

    s =<<S
    html {lang: 'en'}
      head
        title Testing 1 2 3
        meta {charset: 'utf-8'}
      body
        table {border: '1'}
          thead
            th Date
            th Type
            th Name
            th Credit
            th Debit
            th Balance
          - for item in bank['transactions'] do
            tr
              - for field in item
                td = field

    S

    hlt = Hlt.new(s)

    h = {"bank"=>{"balance"=>" - ", "transactions"=>[["22 Oct 2014", "POS", "5487 22OCT45 , W P SMITHS PLC , EDINBURGH GB", " - ", "0.89", "£225.43"], ["25 Oct 2014", "D/D", "JAFFACAKESDIRECT", " - ", "12.00", "£213.43"], ["1 Nov 2014", "D/D", "EDINBURGH SPORTS", " - ", "8.00", "£205.43"], ["2 Nov 2014", "BAC", "PAYPAL", "12.80", " - ", " - "]]}}

    puts hlt.render locals: h

Output:

<pre>
&lt;html lang='en'&gt;
  &lt;head&gt;
    &lt;title&gt;Testing 1 2 3&lt;/title&gt;
    &lt;meta charset='utf-8'/&gt;
  &lt;/head&gt;
  &lt;body&gt;
    &lt;table border='1'&gt;
      &lt;thead&gt;
        &lt;th&gt;Date&lt;/th&gt;
        &lt;th&gt;Type&lt;/th&gt;
        &lt;th&gt;Name&lt;/th&gt;
        &lt;th&gt;Credit&lt;/th&gt;
        &lt;th&gt;Debit&lt;/th&gt;
        &lt;th&gt;Balance&lt;/th&gt;
      &lt;/thead&gt;
      &lt;tr&gt;
        &lt;td&gt;22 Oct 2014&lt;/td&gt;
        &lt;td&gt;POS&lt;/td&gt;
        &lt;td&gt;5487 22OCT45 , W P SMITHS PLC , EDINBURGH GB&lt;/td&gt;
        &lt;td&gt; - &lt;/td&gt;
        &lt;td&gt;0.89&lt;/td&gt;
        &lt;td&gt;£225.43&lt;/td&gt;
      &lt;/tr&gt;
      &lt;tr&gt;
        &lt;td&gt;25 Oct 2014&lt;/td&gt;
        &lt;td&gt;D/D&lt;/td&gt;
        &lt;td&gt;JAFFACAKESDIRECT&lt;/td&gt;
        &lt;td&gt; - &lt;/td&gt;
        &lt;td&gt;12.00&lt;/td&gt;
        &lt;td&gt;£213.43&lt;/td&gt;
      &lt;/tr&gt;
      &lt;tr&gt;
        &lt;td&gt;1 Nov 2014&lt;/td&gt;
        &lt;td&gt;D/D&lt;/td&gt;
        &lt;td&gt;EDINBURGH SPORTS&lt;/td&gt;
        &lt;td&gt; - &lt;/td&gt;
        &lt;td&gt;8.00&lt;/td&gt;
        &lt;td&gt;£205.43&lt;/td&gt;
      &lt;/tr&gt;
      &lt;tr&gt;
        &lt;td&gt;2 Nov 2014&lt;/td&gt;
        &lt;td&gt;BAC&lt;/td&gt;
        &lt;td&gt;PAYPAL&lt;/td&gt;
        &lt;td&gt;12.80&lt;/td&gt;
        &lt;td&gt; - &lt;/td&gt;
        &lt;td&gt; - &lt;/td&gt;
      &lt;/tr&gt;
    &lt;/table&gt;
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

Strict equality [comparison](livescript-ops-comparison) [operators](livescript-ops) in [Livescript](livescript)

<div class="codeblock">
<pre class="leftcol">
\# LiveScript
2 + 4 == 6      #=> true
\boom is 'boom' #=> true

\boom != null   #=> true
2 + 2 is not 4  #=> false
0 + 1 isnt 1    #=> false
</pre>
<pre class="rightcol">
// Generated Javascript
2 + 4 === 6;
'boom' === 'boom';

'boom' !== null;
2 + 2 !== 4;
0 + 1 !== 1;
</pre>
<br style="clear: both">
<div>

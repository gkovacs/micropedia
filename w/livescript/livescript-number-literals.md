Number [literals](livescript-literals) in [Livescript](livescript)

<code>.4</code> is not valid, it must be preceded with a zero, eg <code>0.4</code>

<div class="codeblock">
<pre class="leftcol">
\# LiveScript
42
17.34
0.4
</pre>
<pre class="rightcol">
// Generated Javascript
42
17.34
0.4
</pre>
<br style="clear: both">
<div>

Underscores and appended letters are ignored

<div class="codeblock">
<pre class="leftcol">
\# LiveScript
64_000km
</pre>
<pre class="rightcol">
// Generated Javascript
64000
</pre>
<br style="clear: both">
<div>

Any base can be used from 2 to 36 using <code>~</code>

<div class="codeblock">
<pre class="leftcol">
\# LiveScript
6~12
2~1000
16~ff
</pre>
<pre class="rightcol">
// Generated Javascript
8
8
255
</pre>
<br style="clear: both">
<div>


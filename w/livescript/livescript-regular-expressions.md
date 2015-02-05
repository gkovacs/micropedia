Regular expression [literals](livescript-literals) in [Livescript](livescript)

Regular regex delineated with a single <code>/</code>.


<div class="codeblock">
<pre class="leftcol">
\# LiveScript
/moo/gi
</pre>
<pre class="rightcol">
// Generated Javascript
/moo/gi;
</pre>
<br style="clear: both">
<div>

Delineated with <code>//</code> - multiline, comments, spacing!


<div class="codeblock">
<pre class="leftcol">
\# LiveScript
//
| [!=]==?             # equality
| @@                  # constructor
| <\[(?:[\s\S]*?\]>)? # words
//g
</pre>
<pre class="rightcol">
// Generated Javascript
/|[!=]==?|@@|<\[(?:[\s\S]\*?\]>)?/g;
</pre>
<br style="clear: both">
<div>


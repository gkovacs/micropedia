Comment [literals](livescript-literals) in [Livescript](livescript)

Single line comments start off with a <code>#</code>. They are not passed through to the compiled output.

<pre>
# single line comment
</pre>

Multiline comments are preserved in the output.

<div class="codeblock">
<pre class="leftcol">
\# Livescript 
/\* multiline comments
   use this format and are preserved
   in the output unlike single line ones
\*/
</pre>
<pre class="rightcol">
// Generated Javascript
/\* multiline comments
   use this format and are preserved
   in the output unlike single line ones
\*/
</pre>
<br style="clear: both">
<div>
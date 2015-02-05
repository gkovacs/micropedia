Misc [literals](livescript-literals) in [Livescript](livescript)

Labels (useful for nested loops):

<div class="codeblock">
<pre class="leftcol">
\# LiveScript
:label 4 + 2
</pre>
<pre class="rightcol">
// Generated Javascript
label: {
  4 + 2;
}
</pre>
<br style="clear: both">
<div>

<code>constructor</code> shorthand.

<div class="codeblock">
<pre class="leftcol">
\# LiveScript
@@
@@x
x@@y
</pre>
<pre class="rightcol">
// Generated Javascript
constructor;
constructor.x;
x.constructor.y;
</pre>
<br style="clear: both">
<div>

Yaddayaddayadda - a placeholder:

<div class="codeblock">
<pre class="leftcol">
\# LiveScript
...
</pre>
<pre class="rightcol">
// Generated Javascript
throw Error('unimplemented');
</pre>
<br style="clear: both">
<div>
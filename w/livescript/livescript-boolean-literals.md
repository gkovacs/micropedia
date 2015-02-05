Boolean [literals](livescript-literals) in [Livescript](livescript)

Aliases as in CoffeeScript

<div class="codeblock">
<pre class="leftcol">
\# LiveScript
true
false
on
off
yes
no
</pre>
<pre class="rightcol">
// Generated Javascript
true
false
true
false
true
false
</pre>
<br style="clear: both">
<div>

In JavaScript, <code>undefined</code> can be redefined, so it is prudent to use the <code>void</code> operator which produces the undefined value, always.

<code>void</code> at the top level (not used as an expression) compiles to nothing.

(for use as a placeholder) - it must be used as a value to compile.

<div class="codeblock">
<pre class="leftcol">
\# Livescript 
void
x = void

null
</pre>
<pre class="rightcol">
// Generated Javascript
var x;
// void compiles to nothing here!
x = void 8;

null;
</pre>
<br style="clear: both">
<div>


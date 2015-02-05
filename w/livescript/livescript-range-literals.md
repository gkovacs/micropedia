Range [literals](livescript-literals) in [Livescript](livescript)

<code>to</code> means up to and including the number. <code>til</code> means up until but not including the number.

You can optionally add a <code>by</code> which defines the step of the range.

If you omit the first number, it is assumed to be <code>0</code>.

With number/string literals:

<div class="codeblock">
<pre class="leftcol">
\# LiveScript
[1 to 5]       #=> [1, 2, 3, 4, 5]
[1 til 5]      #=> [1, 2, 3, 4]
[1 to 10 by 2] #=> [1, 3, 7, 9]
[4 to 1]       #=> [4, 3, 2, 1]
[to 5]         #=> [0, 1, 2, 3, 4, 5]
[\A to \D]     #=> ['A', 'B', 'C', D']
</pre>
<pre class="rightcol">
// Generated Javascript
var i$;
[1, 2, 3, 4, 5];
[1, 2, 3, 4];
[1, 3, 5, 7, 9];
[4, 3, 2, 1];
[0, 1, 2, 3, 4, 5];
["A", "B", "C", "D"];
</pre>
<br style="clear: both">
<div>


With any expression - if your range uses expressions, and you want it to go downwards (ie. from a larger number to a smaller one) you must explicitly set <code>by -1</code>.

<div class="codeblock">
<pre class="leftcol">
\# LiveScript
x = 4
[1 to x]       #=> [1, 2, 3, 4]
[x to 0 by -1] #=> [4, 3, 2, 1, 0]
</pre>
<pre class="rightcol">
// Generated Javascript
var x, i$;
x = 4;
for (i$ = 1; i$ <= x; ++i$) {
  i$;
}
for (i$ = x; i$ >= 0; --i$) {
  i$;
}
</pre>
<br style="clear: both">
<div>


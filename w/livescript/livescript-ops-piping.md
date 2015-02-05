Piping is an [operator](livescript-ops) in [Livescript](livescript)

Instead of a series of nested function calls, you can pipe values in. <code>x |> f</code> and <code>f <| x</code> are equivalent to <code>f(x)</code>.

<div class="codeblock">
<pre class="leftcol">
\# LiveScript
x = [1 2 3] |> reverse |> head #=> 3


y = reverse <| [1 2 3] #=> [3,2,1]
</pre>
<pre class="rightcol">
// Generated Javascript
var x, y;
x = head(
reverse(
[1, 2, 3]));
y = reverse([1, 2, 3]);
</pre>
<br style="clear: both">
<div>


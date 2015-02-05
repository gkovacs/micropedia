Maximum and minimum are [comparison](livescript-ops-comparison) [operators](livescript-ops) in [Livescript](livescript)

Maximum operator <code>>?</code> returns the larger of the two operands.

Minimum operator <code><?</code> returns the smaller of the two operands.

<div class="codeblock">
<pre class="leftcol">
\# LiveScript
4 >? 8     #=> 8
9 - 5 <? 6 #=> 4
</pre>
<pre class="rightcol">
// Generated Javascript
var ref$;
4 > 8 ? 4 : 8;
(ref$ = 9 - 5) < 6 ? ref$ : 6;
</pre>
<br style="clear: both">
<div>
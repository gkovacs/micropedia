Object [literals](literals) in [Livescript](livescript)

Braces are optional:

<div class="codeblock">
<pre class="leftcol">
\# LiveScript

obj = {prop: 1, thing: 'moo'}



person =
  age:      23
  eye-color: 'green'
  height:   180cm

oneline = color: 'blue', heat: 4
</pre>
<pre class="rightcol">
// Generated Javascript
var obj, person, oneline;
obj = {
  prop: 1,
  thing: 'moo'
};
person = {
  age: 23,
  eyeColor: 'green',
  height: 180
};
oneline = {
  color: 'blue',
  heat: 4
};
</pre>
<br style="clear: both">
<div>

Dynamic keys:

<div class="codeblock">
<pre class="leftcol">
\# LiveScript
obj =
  "#variable": 234
  (person.eye-color): false
</pre>
<pre class="rightcol">
// Generated Javascript
var ref$, obj;
obj = (ref$ = {}, ref$[variable + ""] = 234, ref$[person.eyeColor] = false, ref$);
</pre>
<br style="clear: both">
<div>

Property setting shorthand - easily set properties with variables if you want the property name to be the same as the variable name.

<div class="codeblock">
<pre class="leftcol">
\# LiveScript
x = 1
y = 2
obj = {x, y}
</pre>
<pre class="rightcol">
// Generated Javascript
var x, y, obj;
x = 1;
y = 2;
obj = {
  x: x,
  y: y
};
</pre>
<br style="clear: both">
<div>

Flagging shorthand - easily set boolean properties.

<div class="codeblock">
<pre class="leftcol">
\# LiveScript
{+debug, -live}
</pre>
<pre class="rightcol">
// Generated Javascript
({
  debug: true,
  live: false
});
</pre>
<br style="clear: both">
<div>

This - no need to use a dot <code>.</code> to access properties.

<div class="codeblock">
<pre class="leftcol">
\# LiveScript
this
@
@location
</pre>
<pre class="rightcol">
// Generated Javascript
this;
this;
this.location;
</pre>
<br style="clear: both">
<div>



String [literals](livescript-literals) in [Livescript](livescript)

You can use double or single quotes

<div class="codeblock">
<pre class="leftcol">
\# LiveScript
'a string'
"a string"
</pre>
<pre class="rightcol">
// Generated Javascript
'a string';
"a string";
</pre>
<br style="clear: both">
<div>

Strings can be written with a preceding backslash instead of quotes. Backslash strings can't contain <code>, ; ] ) }</code> or whitespace.

<div class="codeblock">
<pre class="leftcol">
\# Livescript
"The answer is #{2 + 2}"
'As #{is}'

variable = "world"
"Hello #variable"
</pre>
<pre class="rightcol">
// Generated Javascript
var variable;
"The answer is " + (2 + 2);
'As #{is}';

variable = "world";
"Hello " + variable;
</pre>
<br style="clear: both">
<div>

Double quoted strings allow interpolation. Single quoted strings are passed through as-is. Simple variables can be interpolated without curly braces.

<div class="codeblock">
<pre class="leftcol">
\# Livescript
%"#x #y"
</pre>
<pre class="rightcol">
// Generated Javascript
[x, " ", y];
</pre>
<br style="clear: both">
<div>

Multiline strings (can also do the same but with double quotes for use with interpolation):

<div class="codeblock">
<pre class="leftcol">
\# Livescript
multiline = 'string can be multiline
            and go on and on
            beginning whitespace is
            ignored'
heredoc = '''
            string can be multiline
            with newlines
            and go on and on
            beginning whitespace is
            ignored
'''
</pre>
<pre class="rightcol">
// Generated Javascript
var multiline, heredoc;
multiline = 'string can be multiline and go on and on beginning whitespace is ignored';

heredoc = 'string can be multiline\nwith newlines\nand go on and on\nbeginning whitespace is\nignored';
</pre>
<br style="clear: both">
<div>


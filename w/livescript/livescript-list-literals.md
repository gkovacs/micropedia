List [literals](livescript-literals) in [Livescript](livescript)

<div class="codeblock">
<pre class="leftcol">
\# LiveScript
[1, person.age, 'French Fries']
</pre>
<pre class="rightcol">
// Generated Javascript
[1, person.age, 'French Fries'];
</pre>
<br style="clear: both">
<div>

Commas are not needed if the item preceding is not callable:

<div class="codeblock">
<pre class="leftcol">
\# LiveScript
[1 2 3 true void \word 'hello there']
</pre>
<pre class="rightcol">
// Generated Javascript
[1, 2, 3, true, void 8, 'word', 'hello there'];
</pre>
<br style="clear: both">
<div>

Implicit lists created with an indented block. They need at least two items for it to work. If you have only one item, you can add a yaddayaddayadda <code>...</code> to force the implicit list.

<div class="codeblock">
<pre class="leftcol">
\# LiveScript
my-list =
  32 + 1
  person.height
  'beautiful'

one-item =
  1
  ...
</pre>
<pre class="rightcol">
// Generated Javascript
var myList, oneItem;
myList = [32 + 1, person.height, 'beautiful'];



oneItem = [1];
</pre>
<br style="clear: both">
<div>

When implicitly listing, you can use an asterisk <code>*</code> to disambiguate implicit structures such as implicit objects and implicit lists. The asterisk does not denote an item of the list, but merely sets aside an implicit structure so that it is not muddled with the other ones being listed.

<div class="codeblock">
<pre class="leftcol">
\# LiveScript
tree =
  \* 1
    \* 2
      3
    4
  \* 5
    6
    \* 7
      8
      \* 9
        10
    11

obj-list =
  \* name: 'tessa'
    age:  23
  \* name: 'kendall'
    age:  19


obj =
  \* name: 'tessa'
    age:  23

obj-one-list =
  \* name: 'tessa'
    age:  23
  ...
</pre>
<pre class="rightcol">
// Generated Javascript
var tree, objList, obj, objOneList;
tree = [[1, [2, 3], 4], [5, 6, [7, 8, [9, 10]], 11]];









objList = [
  {
    name: 'tessa',
    age: 23
  }, {
    name: 'kendall',
    age: 19
  }
];
obj = {
  name: 'tessa',
  age: 23
};
objOneList = [{
  name: 'tessa',
  age: 23
}];
</pre>
<br style="clear: both">
<div>

[Lists of words](livescript-list-words-literal): <code><[list of words]></code>

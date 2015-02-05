Partial application of [operators](livescript-ops) in [Livescript](livescript)

You can partially apply operators and use them as functions

<div class="codeblock">
<pre class="leftcol">
\# LiveScript
(+ 2) 4         #=> 6
(*) 4 3         #=> 12

(not) true      #=> false
(in [1 to 3]) 2 #=> true
</pre>
<pre class="rightcol">
// Generated Javascript
(function(it){
  return it + 2;
})(4);
curry$(function(x$, y$){
  return x$ * y$;
})(4, 3);
not$(true);
(function(it){
  return it == 1 || it == 2 || it == 3;
})(2);
function curry$(f, bound){
  var context,
  _curry = function(args) {
    return f.length > 1 ? function(){
      var params = args ? args.concat() : [];
      context = bound ? context || this : this;
      return params.push.apply(params, arguments) <
          f.length && arguments.length ?
        _curry.call(context, params) : f.apply(context, params);
    } : f;
  };
  return _curry();
}
function not$(x){ return !x; }
</pre>
<br style="clear: both">
<div>


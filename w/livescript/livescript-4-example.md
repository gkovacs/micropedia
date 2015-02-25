Fill in this [LiveScript](http://livescript.net/) code to make this [function](http://livescript.net/#functions) compute the nth [fibonaccci number](http://en.wikipedia.org/wiki/Fibonacci_number)

<pre class="codelink" id="fibcode">
fib = (n) ->
  switch n
  | 0 => 1
  | 1 => 1
  <input id="inputcode" size="50"></input><button id="checkbutton">Check</button>

# The code below tests your fib function for correctness

input_output_pairs = [
  [0, 1]
  [1, 1]
  [2, 2]
  [3, 3]
  [4, 5]
  [5, 8]
]

for [input,output] in input_output_pairs
  if fib(input) != output
    throw new Error "fib(#input) should be #output but got #{fib(input)}"
</pre>

Having trouble? See [switch](http://livescript.net/#switch) and [recursion](http://en.wikipedia.org/wiki/Recursion)

<script src="lsc/livescript-4-example"></script>

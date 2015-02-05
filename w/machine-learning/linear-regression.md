Linear regression is a [supervised](supervised-learning) [learning algorithm](machine-learning) that solves the [regression problem](regression-algorithm) by fitting a line through the data.

Mathematically, we want to find good parameters (weights) θ for the [hypothesis function](hypothesis-function) h, which maps the input vector x to a continuous value h(x):

![linear-regression-fig1](png/linear-regression-fig1)

To find the parameters θ, we define a [cost function](cost-function) which tells us how far we are from the correct answer, and use [gradient descent](gradient-descent) to minimize the cost function on the [training data](training-data).

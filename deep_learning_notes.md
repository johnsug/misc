## Deep Learning Notes

series: https://www.youtube.com/watch?v=b99UVkWzYTQ

## Terminology

| Term | Definition |
|------|------------|
| propogation | direction of learning in the nets |
| forward prop | input layer: activations -> second layer: activations -> third layer: activations -> output layer (generated output) |
| backward prop | input layer (input) <- second layer: activations <- third layer: activations <- output layer: activations |
| weights | edges |
| bias | nodes |
| cost | generated output - actual output |
| training | process of improving accuracy; model is trained through process of tweaking weights and biases |
| gradient | rate at which cost changes with respect to the weight or bias |



## Why Use Deep Learning? (Pattern Complexity)

| Situation | Deep Learning Methods |
|-----------|-----------------------|
| unlabeled data^ | RBMs, Autoencoders |
| text processing | RNTN, recurrent net |
| immage recognition | DBN, convolutional net |
| object recognition | RNTN, convolutional net |
| speech recognition | recurrent net |

^ unlabled data problems include feature extraction, unsupervised learning, general pattern recognition
^^ RNTN = recursive neural tensor net

In general:
* for classification, use MPL/RELU/DBN
* for time series analysis, use recurrent net



## Why Did it Take So Long to Adopt DL?

* issues with back-prop, which can lead to vanishing/exploding gradient issues
  - large gradient => fast training
  - small gradient => slow learning
* layers are multiplicative; by the time we get to the early layers, we are left with slow/vanishing gradients, leading to long/impossible training times
  - early layers are responsible for finding the simple patterns and the basic building blocks (e.g., the edges)
  - if we get the early layers wrong, the entire prediction falls apart
* gradients are values between 0 and 1; multiplication always makes the gradient smaller
* back-prop issues meant training was always very slow and, inaccurate at best

Everything changed in 2006, due to the works fof Hinton, LeCun, and Bengio




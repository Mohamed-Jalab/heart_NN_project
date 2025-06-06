import 'dart:math';

abstract class Node {
  const Node();
  double get output;
}

class InputNeuron extends Node {
  final double value;
  const InputNeuron({required this.value});

  @override
  double get output => value;
}

class Neuron extends Node {
  final List<Node> inputs;
  List<double> weights = [];
  final String activation;
  late final double bias;
  Neuron({required this.inputs, required this.activation}) {
    double fieldOfWeights = 2.4 / inputs.length;
    for (int i = 0; i < inputs.length; i++) {
      double temp = 2 * fieldOfWeights * Random().nextDouble() - fieldOfWeights;
      print(temp);
      weights.add(temp);
    }
    bias = Random().nextBool() ? 1 : -1;

    //? last index for bias's weight
    weights.add(2 * fieldOfWeights * Random().nextDouble() - fieldOfWeights);
    print("bias weight: ${weights.last}");
    print("bias = $bias");
    print("=" * 50);
    print("finish weights");
    print("=" * 50);
  }

  @override
  double get output {
    double result = 0;
    for (int i = 0; i < weights.length - 1; i++) {
      result += inputs[i].output * weights[i];
      // print(
      //     "${inputs[i].output} * ${weights[i]} = ${weights[i] * inputs[i].output}");
    }
    result += bias * weights[weights.length - 1];
    switch (activation.toLowerCase()) {
      case "tanh":
        result = tanh(result);
        break;
      case "sigmoid":
        result = sigmoid(result);
        break;
      case "relu":
        result = ReLU(result);
        break;
      default:
        throw "'${activation}' not supported yet!";
    }
    return result;
  }
}

class Layer {
  final List<Neuron> neurons = [];

  /// here is [Node] because maybe this [Layer]
  /// is the first hidden [Layer] which it's need [InputNeuron]
  /// or not which it's need a [Neuron]
  final List<Node> inputs;
  final String activation;
  Layer(
      {required int numOfNeurons,
      required this.inputs,
      required this.activation}) {
    // assert(activations.length == )
    while (numOfNeurons-- != 0)
      neurons.add(Neuron(inputs: inputs, activation: activation));
  }
}

class NeuralNetwork {
  final List<InputNeuron> inputs = [];
  final List<Layer> layers = [];
  final List<String> activations;
  NeuralNetwork(
      {required this.activations,
      required List<double> inputValues,
      required List<int> neuronsOfEachLayer}) {
    assert(neuronsOfEachLayer.length == activations.length,
        "must be same length found ${neuronsOfEachLayer.length}, ${activations.length}");
    for (final value in inputValues) inputs.add(InputNeuron(value: value));

    for (int i = 0; i < neuronsOfEachLayer.length; i++) {
      print('\n================ layer ${i + 1} ================\n');
      if (i == 0)
        this.layers.add(Layer(
            inputs: inputs,
            numOfNeurons: neuronsOfEachLayer[i],
            activation: activations[i]));
      else
        this.layers.add(Layer(
            numOfNeurons: neuronsOfEachLayer[i],
            inputs: this.layers[i - 1].neurons,
            activation: activations[i]));
    }
  }

  /// this get method either returns on its output if the last [Layer] has just one [Neuron]
  /// or returns [List] of outputs for all [Neuron]s in last [Layer]
  Object get feedForward {
    if (layers.last.neurons.length == 1)
      return layers.last.neurons.first.output;
    List preOutput = [];
    for (final Neuron neuron in layers.last.neurons)
      preOutput.add(neuron.output);
    return preOutput;
  }
}

double ReLU(double input) {
  return max<double>(0, input);
}

double sigmoid(double input) {
  return 1 / (1 + exp(-input));
}

double tanh(double input) {
  double ex = exp(2 * input);
  return (ex - 1) / (ex + 1);
}

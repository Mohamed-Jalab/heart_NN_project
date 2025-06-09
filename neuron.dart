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
  final double learningRate;
  List<InputNeuron> inputs = [];
  late double actualOutput;
  final List<Layer> layers = [];
  final List<String> activations;
  NeuralNetwork(
      {this.learningRate = .1,
      required this.activations,
      required List<double> inputValues,
      required double outputValue,
      required List<int> neuronsOfEachLayer}) {
    assert(neuronsOfEachLayer.last == 1,
        "currently we unsupported more than 1 output neuron");
    assert(neuronsOfEachLayer.length == activations.length,
        "must be same length found ${neuronsOfEachLayer.length}, ${activations.length}");

    /// initial properties
    for (final value in inputValues) inputs.add(InputNeuron(value: value));
    actualOutput = outputValue;

    /// create [Layer]s
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

  /// this get method either
  /// returns on its output if the last [Layer] has just one [Neuron]
  /// or
  /// returns [List] of outputs for all [Neuron]s in last [Layer]
  Object get feedForward {
    if (layers.last.neurons.length == 1)
      return layers.last.neurons.first.output;
    List preOutput = [];
    for (final Neuron neuron in layers.last.neurons)
      preOutput.add(neuron.output);
    return preOutput;
  }

  /// this get method currently for single [Neuron] for output [Layer]
  /// we'll see later to develop to be more flexible with multi [Layer] for output
  List<List<double>> get backPropagation {
    double? out = double.tryParse(feedForward.toString());
    if (out == null) throw "feedForward isn't double try to casting to double";
    if (layers.last.neurons.length > 1)
      throw "currently we unsupported more than 1 output neuron";

    /// calculate
    double error = actualOutput - out;
    double gradientOut = out * (1 - out) * error;

    List<List<double>> gradientHiddens = [];

    for (int i = 0, j = layers.length - 2; i < layers.length - 1; i++, j--) {
      /// each row refers to his layer
      gradientHiddens.add([]);
      if (j == layers.length - 2)
        for (int k = 0; k < layers[j].neurons.length; k++) {
          double temp =
              layers[j].neurons[k].output * (1 - layers[j].neurons[k].output);
          double gradient =
              temp * gradientOut * layers[j + 1].neurons.first.weights[k];
          gradientHiddens.last.add(gradient);
        }
      // else
      //   for (int k = 0; k < layers[j].neurons.length; k++) {

      //     gradeintHiddens.last.add(gradient);
      //   }
    }
    // calc delta w
    
    print("gradient out : ${gradientOut}");
    return gradientHiddens;
  }
  // void get backPropagation {
  //   double? out = double.tryParse(feedForward.toString());
  //   if (out == null) throw "feedForward isn't double try to casting to double";
  //   if(layers.last.neurons.length > 1 ) throw "currently we unsupported more than 1 output neuron";
  //   /// calculate
  //   double error = actualOutput - out;
  //   double gradientOut = out * (1 - out) * error;

  //   List<List<double>> gradeintHiddens = [];
  //   for (int i = 0, j = layers.length - 1; i < layers.length - 1; i++, j--) {
  //     // add gradient layer
  //     gradeintHiddens.add([]);

  //     // add gradients to own layer
  //     for (int k = 0; k < layers[j].neurons.length; k++) {
  //       if (j == layers.length - 1) {
  //         double temp =
  //             layers[j].neurons[k].output * (1 - layers[j].neurons[k].output);
  //         double gradientHidden = temp * gradientOut;
  //         gradeintHiddens.last.add(gradientHidden);
  //       }
  //       else {
  //         double temp =
  //             layers[j].neurons[k].output * (1 - layers[j].neurons[k].output);
  //         double gradientHidden = 0;
  //         for (int z = 0 ; z < layers[j + 1].neurons.length; z++)
  //           gradientHidden += layers[j + 1].neurons[z].weights[k] * gradeintHiddens[i - 1][z];
  //         gradientHidden *= temp;
  //         gradeintHiddens.last.add(gradientHidden);
  //       }
  //     }
  //   }

  //   /// update weights
  //   for (int i = 0; i < layers.length - 1; i++) {
  //     for (int j = 0; j < layers[i].neurons.length; j++) {
  //       for (int k = 0; k < layers[i + 1].neurons.length; k++) {
  //         layers[i].neurons[j].weights[k] +=
  //             learningRate * gradeintHiddens[i][k] * layers[i + 1].neurons[k].output;

  //       }
  //     }
  //   }
  // }
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

import 'neuron.dart';

void main() {
  print("Hello World");
  List<double> inputs = [1.1, 2.4, 3.3];
  NeuralNetwork network = NeuralNetwork(
      inputValues: inputs,
      neuronsOfEachLayer: [2, 2, 1],
      activations: ["tanh", "tanh", "sigmoid"]);
  print(network.feedForward);
}

import 'dart:io';

import 'dataset_manager.dart';
import 'neuron.dart';

void main() {
  List<String> csvFile = File("heart.csv").readAsStringSync().split("\n");
  print(csvFile.length);
  print("remove : ${csvFile.removeAt(0)}"); //? remove the headers
  print(csvFile.length);
  List<List<Object>> csvProcessed =
      DatasetManager.createDataset(csvFile, logProcess: false);

  //? create dataset
  //? ---------------------
  //? includes output in last element of each row

  //? each row means single feature
  List<List<Object>> trainingSetFeatures = [];
  List<List<Object>> testSetFeatures = [];
  for (final List<Object> row in csvProcessed) {
    // print(row.sublist(0, 20));
    trainingSetFeatures.add(row.sublist(0, 730));
    testSetFeatures.add(row.sublist(730));
  }
  List<Object> trainingSetOutput = trainingSetFeatures.removeAt(11);
  List<Object> testSetOutput = testSetFeatures.removeAt(11);

  // for (int i = 0; i < 11; i++) print("==${trainingSetFeatures[i][15]}==");
  // print("==${trainingSetOutput[15]}==");
  print(csvFile.length);
  print(trainingSetFeatures.first.length + testSetFeatures.first.length);

  //   List<List>X, Y = [], []
  // for _ in range(11):
  //   X.append([])

  // len(trainingDataset) + len(testDataset)
  // print(DatasetManager.encode(csvFile));
  // print(DatasetManager.encode(["ATA", "None", "LOLO", "nothing", 'ATA']));
  // List<String> nums = ["hi", "43", "77"];
  // DatasetManager.encodeStrsToNums(nums);
  // print(nums);
  List<double> inputs = [for (int i = 0; i < 3; i++) 1];
  double output = 1;
  NeuralNetwork network = NeuralNetwork(
      inputValues: inputs,
      outputValue: output,
      neuronsOfEachLayer: [3, 1],
      activations: ["tanh", "sigmoid"]);
  // print(network.layers.first.neurons.first.output);
  print(network.feedForward);
  for (final Neuron neuron in network.layers[0].neurons) print(neuron.output);
  print(network.backPropagation);
//   for (var variable = 0; variable<10; variable++) {
//   network.backPropagation;
//   print(network.feedForward);
// }
}

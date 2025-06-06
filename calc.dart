void main() {
  print(calculate(
      weights: [0.1370774123352514, 0.39567929516382505, 0.7348906443746575],
      inputs: [-0.84918250318, 0.23036831562],
      bias: 1));
}
//! first Layer
// 0.5038979526038283,
// 1.502667322529111,
// -0.6960090669625631

double calculate(
    {required List<double> weights,
    required List<double> inputs,
    required double bias}) {
  double res = 0;

  for (int i = 0; i < weights.length - 1; i++) res += inputs[i] * weights[i];
  res += bias * weights.last;
  return res;
}

extension DoubleExtension on double {
  double addDegree(double degree) {
    final result = this + degree;
    if (result < 360) return result;
    return degree % 360;
  } 
  
  double subDegree(double degree) {
    final result = this - degree;
    if (result < 0) return result;
    return degree % 360;
  } 
}
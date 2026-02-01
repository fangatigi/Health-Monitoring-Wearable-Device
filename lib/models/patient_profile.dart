class PatientProfile {
  String name;
  int age;
  String gender;
  String bloodGroup;
  int hrMin;
  int hrMax;
  int spo2Min;
  double tempMax;

  PatientProfile({
    required this.name,
    required this.age,
    required this.gender,
    required this.bloodGroup,
    required this.hrMin,
    required this.hrMax,
    required this.spo2Min,
    required this.tempMax,
  });

  static PatientProfile defaultProfile() {
    return PatientProfile(
      name: "Patient",
      age: 21,
      gender: "Male",
      bloodGroup: "O+",
      hrMin: 50,
      hrMax: 120,
      spo2Min: 94,
      tempMax: 38.0,
    );
  }
}

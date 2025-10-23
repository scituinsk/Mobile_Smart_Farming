class ModulData {
  final int? temperature;
  final int? humidity;
  final int? battery;
  final int? waterLevel;

  ModulData({this.temperature, this.humidity, this.battery, this.waterLevel});

  factory ModulData.fromJson(Map<String, dynamic> json) {
    return ModulData(
      temperature: json["temperature_data"] as int,
      humidity: json["humidity_data"] as int,
      battery: json["battery_data"] as int,
      waterLevel: json["water_level_data"] as int,
    );
  }

  @override
  String toString() {
    return "DeviceData(temprature: $temperature, humidity: $humidity, battery: $battery, waterLevel: $waterLevel)";
  }
}

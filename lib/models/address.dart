class Address {
  String? name;
  String? phoneNumber;
  String? flatNumber;
  String? city;
  String? state;

  Address({
    this.name,
    this.phoneNumber,
    this.flatNumber,
    this.city,
    this.state,
  });

  Address.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    flatNumber = json['flatNumber'];
    city = json['city'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    data['phoneNumber'] = phoneNumber;
    data['flatNumber'] = flatNumber;
    data['city'] = city;
    data['state'] = state;

    return data;
  }
}

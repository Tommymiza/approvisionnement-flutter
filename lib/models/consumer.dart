class Consumer {
  final String id;
  final String name;
  final String image;
  final String email;
  final String phone;
  final List consommation;
  Consumer(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.image,
      required this.consommation});
  static Consumer fromJson(e, id) {
    return Consumer(
        id: id,
        name: e["name"],
        image: e["image"],
        consommation: e["consommation"],
        email: e["email"],
        phone: e["phone"]);
  }
}

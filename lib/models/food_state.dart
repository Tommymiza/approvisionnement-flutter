class FoodState {
  final String id;
  final String name;
  final String image;
  final String descri;
  final String unit;
  final int stock;

  FoodState(
      {required this.id,
      required this.name,
      required this.image,
      required this.descri,
      required this.unit,
      required this.stock});

  static FoodState fromJson(e, id) {
    return FoodState(
        id: id,
        descri: e["descri"],
        image: e["image"],
        name: e["name"],
        unit: e["unit"],
        stock: e["stock"]);
  }
}

class BillItem {
  final String id;
  String name;
  double price;
  int quantity;
  Set<String> assignedPersonIds;

  BillItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
    Set<String>? assignedPersonIds,
  }) : assignedPersonIds = assignedPersonIds ?? {};

  double get totalPrice => price * quantity;

  double shareForPerson(String personId) {
    if (!assignedPersonIds.contains(personId) || assignedPersonIds.isEmpty) {
      return 0.0;
    }
    return totalPrice / assignedPersonIds.length;
  }
}

class Corral {
  final String id;
  final String name;
  final String location;
  final int capacity;
  final String? notes;
  final String? imageUrl;
  final List<Batch> activeBatches;

  const Corral({
    required this.id,
    required this.name,
    required this.location,
    required this.capacity,
    this.notes,
    this.imageUrl,
    this.activeBatches = const [],
  });
}

class Batch {
  final String id;
  final String name;
  final int pigCount;

  const Batch({required this.id, required this.name, required this.pigCount});
}

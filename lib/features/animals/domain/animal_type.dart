enum AnimalType {
  breeding,
  fattening;

  String get displayName {
    switch (this) {
      case AnimalType.breeding:
        return 'Cría';
      case AnimalType.fattening:
        return 'Engorda';
    }
  }

  static AnimalType fromString(String value) {
    return AnimalType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => AnimalType.fattening,
    );
  }

  @override
  String toString() => name;
}

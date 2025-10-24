enum AnimalStatus {
  active('active'),
  sold('sold'),
  deceased('deceased'),
  removed('removed');

  final String value;
  const AnimalStatus(this.value);

  factory AnimalStatus.fromString(String value) {
    return AnimalStatus.values.firstWhere(
      (status) => status.value == value.toLowerCase(),
      orElse: () => AnimalStatus.active,
    );
  }

  @override
  String toString() => value;

  bool get canEdit => this == AnimalStatus.active;
  bool get canDelete => this == AnimalStatus.active;
  bool get isActive => this == AnimalStatus.active;
  bool get isTerminal =>
      this == AnimalStatus.deceased || this == AnimalStatus.sold;
}

import 'dart:convert';

class Model {
  int id;
  String column1;
  Model({
    required this.id,
    required this.column1,
  });

  Model copyWith({
    int? id,
    String? column1,
  }) {
    return Model(
      id: id ?? this.id,
      column1: column1 ?? this.column1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'column_1': column1,
    };
  }

  factory Model.fromMap(Map<String, dynamic> map) {
    return Model(
      id: map['id'],
      column1: map['column_1'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Model.fromJson(String source) => Model.fromMap(json.decode(source));

  @override
  String toString() => 'Model(id: $id, column1: $column1)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Model && other.id == id && other.column1 == column1;
  }

  @override
  int get hashCode => id.hashCode ^ column1.hashCode;
}

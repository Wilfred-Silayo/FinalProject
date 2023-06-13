
class University {
  final String id;
  final String name;
  final String description;
  final String apiUrl;
  University({
    required this.id,
    required this.name,
    required this.description,
    required this.apiUrl,
  });

  University copyWith({
    String? id,
    String? name,
    String? description,
    String? apiUrl,
  }) {
    return University(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      apiUrl: apiUrl ?? this.apiUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'id': id,
      'description': description,
      'apiUrl': apiUrl,
    };
  }

  factory University.fromMap(Map<String, dynamic> map) {
    return University(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      apiUrl: map['apiUrl'] as String,
    );
  }

  
  @override
  String toString() {
    return 'University(id: $id, name: $name, description: $description, apiUrl: $apiUrl)';
  }


}

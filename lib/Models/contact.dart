// lib/models/contact.dart

class Contact {
  int id;
  String name;
  String phoneNumber;
  bool isFavorite;

  Contact({required this.name, required this.phoneNumber, this.isFavorite = false, this.id = 0});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      isFavorite: map['isFavorite'] == 1,
    );
  }
}

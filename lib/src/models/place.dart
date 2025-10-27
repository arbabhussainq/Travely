class Place {
  final String placeId;
  final String name;
  final String? address;
  final double? rating;
  final String? photoUrl;
  final double? lat;
  final double? lng;
  final String? city;
  final String? description;

  Place({
    required this.placeId,
    required this.name,
    this.address,
    this.rating,
    this.photoUrl,
    this.lat,
    this.lng,
    this.city,
    this.description,
  });
}

class StationListModel {
  final List<String> name;
  final List<String> ImageUrl;
  final List<String> id;
  final List<String> address;
  final List<String> contact;
  final List<String> connectorType;
  final List<int> availability;

  StationListModel({
    this.name,
    this.ImageUrl,
    this.id,
    this.address,
    this.contact,
    this.connectorType,
    this.availability,
  });
}

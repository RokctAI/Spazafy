class TableModel {
  final String name;
  final int chairCount;
  final int tax;
  final String? shopSectionId;

  TableModel({
    required this.name,
    required this.chairCount,
    required this.tax,
    required this.shopSectionId,
  });

  Map<String, Object?> toJson() => {
        "name": name,
        "chair_count": chairCount,
        "tax": tax,
        "shop_section_id": shopSectionId
      };
}

class OfferingItemModel {
  // class constructor
  OfferingItemModel(this.id, this.image, this.title, this.description,
      this.isCheck, this.offeringPrice, this.offeringId);

  // class fields
  final int id;
  final String image;
  final String title;
  final String description;
  final bool isCheck;
  final double offeringPrice;
  final String offeringId;
}

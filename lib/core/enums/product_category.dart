enum ProductCategory {
  fruits('Meyveler'),
  vegetables('Sebzeler'),
  grains('Tahıllar'),
  legumes('Baklagiller'),
  nuts('Kuruyemişler'),
  dairy('Süt Ürünleri'),
  meat('Et Ürünleri'),
  honey('Bal ve Arı Ürünleri'),
  herbs('Tıbbi ve Aromatik Bitkiler'),
  other('Diğer');

  final String title;
  const ProductCategory(this.title);

  @override
  String toString() => title;

  static ProductCategory fromString(String value) {
    return ProductCategory.values.firstWhere(
      (category) => category.title.toLowerCase() == value.toLowerCase(),
      orElse: () => ProductCategory.other,
    );
  }
} 
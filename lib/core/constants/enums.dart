enum UserRole {
  farmer('Çiftçi'),
  buyer('Alıcı');

  final String label;
  const UserRole(this.label);
}

enum ListingType {
  sale('Satış İlanı'),
  purchase('Alım İlanı');

  final String label;
  const ListingType(this.label);
}

enum ListingStatus {
  active('Aktif'),
  passive('Pasif'),
  sold('Satıldı'),
  cancelled('İptal Edildi');

  final String label;
  const ListingStatus(this.label);
}

enum MessageStatus {
  sent('Gönderildi'),
  delivered('İletildi'),
  read('Okundu');

  final String label;
  const MessageStatus(this.label);
} 
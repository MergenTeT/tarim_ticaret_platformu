import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/base/base_view.dart';
import '../model/product_model.dart';
import '../../../features/auth/viewmodel/auth_viewmodel.dart';
import '../../../features/chat/view/chat_view.dart';

class ProductDetailView extends HookConsumerWidget {
  final ProductModel product;

  const ProductDetailView({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);

    return BaseView(
      title: product.isSellOffer ? 'Satılık Ürün' : 'Alım Talebi',
      actions: [
        IconButton(
          onPressed: () {
            // TODO: Favorilere ekle
          },
          icon: const Icon(Icons.favorite_border),
        ),
        IconButton(
          onPressed: () {
            // TODO: Paylaş
          },
          icon: const Icon(Icons.share),
        ),
      ],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // İlan türü etiketi
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: product.isSellOffer
                    ? Colors.green.withOpacity(0.1)
                    : Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                product.isSellOffer ? 'SATILIK' : 'ARANIYOR',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: product.isSellOffer ? Colors.green : Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Gap(16),
            // Başlık
            Text(
              product.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Gap(8),
            // Fiyat
            Row(
              children: [
                Text(
                  '₺${product.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  ' / ${product.unit}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const Gap(16),
            // Satıcı bilgileri
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(
                    product.sellerName[0].toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(product.sellerName),
                subtitle: Text(product.location ?? ''),
                trailing: authState.when(
                  data: (user) => user.id != product.sellerId
                      ? FilledButton.icon(
                          onPressed: () {
                            // Chat sayfasına git
                            context.push('/chat/${product.sellerId}');
                          },
                          icon: const Icon(Icons.message),
                          label: const Text('Mesaj Gönder'),
                        )
                      : null,
                  loading: () => const CircularProgressIndicator(),
                  error: (_, __) => null,
                ),
              ),
            ),
            const Gap(16),
            // Detaylar
            Text(
              'Detaylar',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Gap(8),
            // Miktar
            DetailRow(
              icon: Icons.shopping_bag_outlined,
              title: 'Miktar',
              value: '${product.quantity} ${product.unit}',
            ),
            const Gap(8),
            // Kategori
            DetailRow(
              icon: Icons.category_outlined,
              title: 'Kategori',
              value: product.category,
            ),
            const Gap(8),
            // Konum
            if (product.location != null) ...[
              DetailRow(
                icon: Icons.location_on_outlined,
                title: 'Konum',
                value: product.location!,
              ),
              const Gap(8),
            ],
            // Tarih
            DetailRow(
              icon: Icons.calendar_today_outlined,
              title: 'İlan Tarihi',
              value: _formatDate(product.createdAt),
            ),
            const Gap(16),
            // Açıklama
            Text(
              'Açıklama',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Gap(8),
            Text(product.description),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day}/${date.month}/${date.year}';
  }
}

class DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const DetailRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.outline,
        ),
        const Gap(8),
        Text(
          '$title:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
        const Gap(4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
} 
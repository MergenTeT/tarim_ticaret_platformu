import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Görsel Galerisi
            if (product.images.isNotEmpty)
              CarouselSlider(
                options: CarouselOptions(
                  height: 300,
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  enableInfiniteScroll: false,
                  autoPlay: false,
                ),
                items: product.images.map((imageUrl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                        ),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => const Center(
                            child: Icon(Icons.error),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              )
            else
              Container(
                height: 300,
                width: double.infinity,
                color: Colors.grey[100],
                child: const Icon(
                  Icons.image_not_supported_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
              ),

            // İlan Detayları
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // İlan Türü Etiketi
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: product.isSellOffer
                          ? Colors.green.withOpacity(0.1)
                          : Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      product.isSellOffer ? 'SATILIK' : 'ARANIYOR',
                      style: TextStyle(
                        color: product.isSellOffer ? Colors.green : Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Gap(16),

                  // Başlık ve Fiyat
                  Text(
                    product.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Gap(8),
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
                  const Gap(24),

                  // Özellikler Grid'i
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 2,
                    children: [
                      _buildFeatureCard(
                        context,
                        icon: Icons.shopping_bag_outlined,
                        title: 'Miktar',
                        value: '${product.quantity} ${product.unit}',
                      ),
                      _buildFeatureCard(
                        context,
                        icon: Icons.category_outlined,
                        title: 'Kategori',
                        value: product.category,
                      ),
                      if (product.location != null)
                        _buildFeatureCard(
                          context,
                          icon: Icons.location_on_outlined,
                          title: 'Konum',
                          value: product.location!,
                        ),
                      _buildFeatureCard(
                        context,
                        icon: Icons.calendar_today_outlined,
                        title: 'İlan Tarihi',
                        value: _formatDate(product.createdAt),
                      ),
                    ],
                  ),
                  const Gap(24),

                  // Açıklama
                  Text(
                    'Açıklama',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Gap(8),
                  Text(product.description),
                  const Gap(32),

                  // Satıcı Profili
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                child: Text(
                                  product.sellerName[0].toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const Gap(16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.sellerName,
                                      style: Theme.of(context).textTheme.titleLarge,
                                    ),
                                    if (product.location != null)
                                      Text(
                                        product.location!,
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              color: Colors.grey[600],
                                            ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Gap(16),
                          // Satıcı İstatistikleri
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatCard(
                                context,
                                icon: Icons.storefront_outlined,
                                title: 'Toplam İlan',
                                value: '24', // TODO: Gerçek veri eklenecek
                                color: Colors.blue,
                              ),
                              _buildStatCard(
                                context,
                                icon: Icons.verified_outlined,
                                title: 'Başarılı Satış',
                                value: '18', // TODO: Gerçek veri eklenecek
                                color: Colors.green,
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: List.generate(5, (index) {
                                      // TODO: Gerçek değerlendirme puanını kullan
                                      const rating = 4.8;
                                      return Icon(
                                        index < rating.floor()
                                            ? Icons.star_rounded
                                            : index < rating
                                                ? Icons.star_half_rounded
                                                : Icons.star_outline_rounded,
                                        color: Colors.amber,
                                        size: 20,
                                      );
                                    }),
                                  ),
                                  const Gap(4),
                                  Text(
                                    '4.8/5.0', // TODO: Gerçek veri eklenecek
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                  ),
                                  Text(
                                    'Değerlendirme',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Gap(24),
                          // Satıcı Rozet ve Başarıları
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildAchievementChip(
                                context,
                                icon: Icons.verified_user,
                                label: 'Onaylı Satıcı',
                                color: Colors.green,
                              ),
                              _buildAchievementChip(
                                context,
                                icon: Icons.speed,
                                label: 'Hızlı Teslimat',
                                color: Colors.orange,
                              ),
                              _buildAchievementChip(
                                context,
                                icon: Icons.thumb_up,
                                label: '%98 Olumlu',
                                color: Colors.blue,
                              ),
                            ],
                          ),
                          const Gap(24),
                          // Mesaj Gönder Butonu
                          authState.when(
                            data: (user) {
                              if (user.id.isEmpty) {
                                return SizedBox(
                                  width: double.infinity,
                                  child: FilledButton.icon(
                                    onPressed: () => context.go('/login'),
                                    icon: const Icon(Icons.login),
                                    label: const Text('Mesaj göndermek için giriş yapın'),
                                  ),
                                );
                              }
                              
                              return user.id != product.sellerId
                                ? SizedBox(
                                    width: double.infinity,
                                    child: FilledButton.icon(
                                      onPressed: () {
                                        context.push('/chat/${product.sellerId}');
                                      },
                                      icon: const Icon(Icons.message),
                                      label: const Text('Mesaj Gönder'),
                                    ),
                                  )
                                : const SizedBox.shrink();
                            },
                            loading: () => const Center(child: CircularProgressIndicator()),
                            error: (_, __) => const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const Gap(8),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
            ],
          ),
          const Gap(4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const Gap(8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }

  Widget _buildAchievementChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          const Gap(6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day}/${date.month}/${date.year}';
  }
} 
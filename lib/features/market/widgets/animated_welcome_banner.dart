import 'package:flutter/material.dart';
import 'dart:async';
import 'package:gap/gap.dart';

class AnimatedWelcomeBanner extends StatefulWidget {
  const AnimatedWelcomeBanner({super.key});

  @override
  State<AnimatedWelcomeBanner> createState() => _AnimatedWelcomeBannerState();
}

class _AnimatedWelcomeBannerState extends State<AnimatedWelcomeBanner> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;

  final List<Map<String, String>> _slogans = [
    {
      'title': 'Tarımın Dijital Pazarına Hoş Geldiniz',
      'subtitle': 'Taze, organik ve yerel ürünler burada!'
    },
    {
      'title': 'Üreticiden Tüketiciye Doğrudan Bağlantı',
      'subtitle': 'Aracısız tarım ticaretinin yeni adresi'
    },
    {
      'title': 'Kaliteli Ürün, Uygun Fiyat',
      'subtitle': 'En taze ürünler, en uygun fiyatlarla'
    },
    {
      'title': 'Güvenli Alışveriş, Güvenilir Platform',
      'subtitle': 'Sertifikalı üreticiler, garantili teslimat'
    },
    {
      'title': 'Tarımın Geleceği Burada Şekilleniyor',
      'subtitle': 'Modern tarım, dijital çözümler'
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_currentPage < _slogans.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primaryContainer,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Dekoratif arka plan desenleri
              Positioned(
                right: -20,
                top: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                left: -30,
                bottom: -30,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
                  ),
                ),
              ),
              // İçerik
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SizedBox(
                      height: 70,
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        itemCount: _slogans.length,
                        itemBuilder: (context, index) {
                          return AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: _currentPage == index ? 1.0 : 0.8,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _slogans[index]['title']!,
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        color: Theme.of(context).colorScheme.onPrimary,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.3,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Gap(2),
                                Text(
                                  _slogans[index]['subtitle']!,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.9),
                                        letterSpacing: 0.2,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const Gap(8),
                    // Sayfa göstergesi
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _slogans.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          width: _currentPage == index ? 18 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: _currentPage == index
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
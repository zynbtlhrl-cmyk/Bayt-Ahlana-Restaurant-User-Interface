import 'dart:async';
import 'package:flutter/material.dart';

class RestaurantAdsBanner extends StatefulWidget {
  const RestaurantAdsBanner({super.key});

  @override
  State<RestaurantAdsBanner> createState() => _RestaurantAdsBannerState();
}

class _RestaurantAdsBannerState extends State<RestaurantAdsBanner> {
  final PageController _pageController = PageController();

  Timer? _timer;
  int _currentPage = 0;
  bool _showFallback = false;

  final List<Map<String, String>> ads = [
    {
      'image':
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=1000&q=85',
      'title': 'أطيب الهمبركر',
      'subtitle': 'طعم لذيذ يستاهل التجربة',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1579751626657-72bc17010498?auto=format&fit=crop&w=1000&q=85',
      'title': 'بيتزا على ذوقك',
      'subtitle': 'نكهات شهية من بيت أهلنا',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=1000&q=85',
      'title': 'أكل بيتي طازج',
      'subtitle': 'محضّر بحب حتى تستمتع بكل لقمة',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1563805042-7684c019e1cb?auto=format&fit=crop&w=1000&q=85',
      'title': 'حلويات لذيذة',
      'subtitle': 'خلّي يومك أحلى ويانه',
    },
  ];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || _showFallback || !_pageController.hasClients) {
        return;
      }

      _currentPage = (_currentPage + 1) % ads.length;

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  void _imageFailed() {
    if (!mounted || _showFallback) return;

    setState(() {
      _showFallback = true;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showFallback) {
      return _fallbackCard();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: SizedBox(
        height: 190,
        child: PageView.builder(
          controller: _pageController,
          itemCount: ads.length,
          onPageChanged: (index) {
            _currentPage = index;
          },
          itemBuilder: (context, index) {
            final ad = ads[index];

            return Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  ad['image']!,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;

                    return Container(
                      color: const Color(0xFF39291D),
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        color: Color(0xFFE8C985),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _imageFailed();
                    });

                    return Container(color: const Color(0xFF39291D));
                  },
                ),

                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [
                        const Color(0xFF1C120D).withOpacity(0.90),
                        const Color(0xFF1C120D).withOpacity(0.45),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                Positioned(
                  right: 22,
                  top: 35,
                  left: 15,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'بيت أهلنا',
                        style: TextStyle(
                          color: Color(0xFFE8C985),
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        ad['title']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        ad['subtitle']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  bottom: 12,
                  left: 15,
                  child: Row(
                    children: List.generate(
                      ads.length,
                      (dotIndex) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: _currentPage == dotIndex ? 20 : 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: _currentPage == dotIndex
                              ? const Color(0xFFE8C985)
                              : Colors.white70,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _fallbackCard() {
    return Container(
      height: 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF39291D), Color(0xFF765237)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 25,
            top: 35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'أكل بيتي',
                  style: TextStyle(
                    color: Color(0xFFE8C985),
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'بطعم لا يُنسى',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 20,
            bottom: 15,
            child: Icon(
              Icons.restaurant_rounded,
              size: 100,
              color: Colors.white12,
            ),
          ),
        ],
      ),
    );
  }
}

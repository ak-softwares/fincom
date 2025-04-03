import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../../../../common/text/section_heading.dart';
import '../../../../../../utils/constants/sizes.dart';
import 'widgets/youtuber_single_banner.dart';

class YouTuberBanner extends StatelessWidget {
  const YouTuberBanner({super.key, required this.title,});

  final String title;
  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> assetImagePaths = [
      {
        'thumbnail'   : 'assets/images/youtube_banner/sk_thumbnail.jpg',
        'profilePic'  : 'assets/images/youtube_banner/sk_profile.jpg',
        'videoLink'   : 'https://youtu.be/-uj9iGpTnyA',
        'youtuberName': 'Sk electronics works',
        'subscriber'  : '850K subscribers',
      },
      {
        'thumbnail'   : 'assets/images/youtube_banner/hacker_thumbnail.jpg',
        'profilePic'  : 'assets/images/youtube_banner/hacker_profile.jpg',
        'videoLink'   : 'https://youtu.be/Om09o9s2kmE',
        'youtuberName': 'HACKER JP',
        'subscriber'  : '2.5M subscribers',
      },
      {
        'thumbnail'   : 'assets/images/youtube_banner/tkta_thumbnail.jpg',
        'profilePic'  : 'assets/images/youtube_banner/tkta_profile.jpg',
        'videoLink'   : 'https://youtu.be/T-MKZrgpmYA',
        'youtuberName': 'Ak technical Amrit',
        'subscriber'  : '100K subscribers',
      },
      {
        'thumbnail'   : 'assets/images/youtube_banner/hgm_thumbnail.jpg',
        'profilePic'  : 'assets/images/youtube_banner/hgm_profile.jpg',
        'videoLink'   : 'https://youtu.be/FBJa1sVxm_4',
        'youtuberName': 'Har Ghar Manufacturing',
        'subscriber'  : '40K subscribers',
      },
      {
        'thumbnail'   : 'assets/images/youtube_banner/thg_thumbnail1.jpg',
        'profilePic'  : 'assets/images/youtube_banner/thg_profile.jpg',
        'videoLink'   : 'https://youtu.be/frfVRur-UeE',
        'youtuberName': 'Tech Help & Guide',
        'subscriber'  : '300K subscribers',
      },
      {
        'thumbnail'   : 'assets/images/youtube_banner/tm_thumbnail.jpg',
        'profilePic'  : 'assets/images/youtube_banner/tm_profile.jpg',
        'videoLink'   : 'https://youtu.be/n7u14igB-o8',
        'youtuberName': 'Techno Mitra',
        'subscriber'  : '820K subscribers',
      },
      {
        'thumbnail'   : 'assets/images/youtube_banner/thg_thumbnail.jpg',
        'profilePic'  : 'assets/images/youtube_banner/thg_profile.jpg',
        'videoLink'   : 'https://youtu.be/e0SwMrOWt6k',
        'youtuberName': 'Tech Help & Guide',
        'subscriber'  : '300K subscribers',
      },
      {
        'thumbnail'   : 'assets/images/youtube_banner/ishu_thumbnail.jpg',
        'profilePic'  : 'assets/images/youtube_banner/ishu_profile.jpg',
        'videoLink'   : 'https://youtu.be/p7jr2claMOk',
        'youtuberName': 'ISHU EXPERIMENT',
        'subscriber'  : '164K subscribers',
      },
      {
        'thumbnail'   : 'assets/images/youtube_banner/skg_thumbnail.jpg',
        'profilePic'  : 'assets/images/youtube_banner/skg_profile.jpg',
        'videoLink'   : 'https://youtu.be/io9S9FH-TMM',
        'youtuberName': 'Sanjay Kumar Gupta',
        'subscriber'  : '550K subscribers',
      },
      {
        'thumbnail'   : 'assets/images/youtube_banner/at_thumbnail.jpg',
        'profilePic'  : 'assets/images/youtube_banner/at_profile.jpg',
        'videoLink'   : 'https://youtu.be/ylnhK3Uj5TE',
        'youtuberName': 'Ashu Mhr Technical',
        'subscriber'  : '32K subscribers',
      },
      {
        'thumbnail'   : 'assets/images/youtube_banner/ne_thumbnail.jpg',
        'profilePic'  : 'assets/images/youtube_banner/ne_profile.jpg',
        'videoLink'   : 'https://youtu.be/9ptGgebAJow',
        'youtuberName': 'Narottam Electronics',
        'subscriber'  : '112K subscribers',
      },
      {
        'thumbnail'   : 'assets/images/youtube_banner/skr_thumbnail.jpg',
        'profilePic'  : 'assets/images/youtube_banner/skr_profile.jpg',
        'videoLink'   : 'https://youtu.be/6lRxfvt1ghg',
        'youtuberName': 'SKR Electronics Lab',
        'subscriber'  : '30K subscribers',
      },
      {
        'thumbnail'   : 'assets/images/youtube_banner/sci_thumbnail.jpg',
        'profilePic'  : 'assets/images/youtube_banner/sci_profile.jpg',
        'videoLink'   : 'https://youtu.be/S-s50v-7AuE',
        'youtuberName': 'Sid Creative Ideas',
        'subscriber'  : '50K subscribers',
      },
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppSizes.sm),
          child: TSectionHeading(title: title),
        ),
        CarouselSlider(
          options: CarouselOptions(
            scrollPhysics: const BouncingScrollPhysics(),
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            viewportFraction: 0.8,
            aspectRatio: 1.45,
            // enableInfiniteScroll: false,
            // enlargeCenterPage: true,
          ),
          items: assetImagePaths.map((map) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
              child: YouTuberSingleBanner(
                thumbnail: map['thumbnail'] ?? '',
                profilePic: map['profilePic'] ?? '',
                youtubeChannelUrl: map['videoLink'] ?? '',
                youtuberName: map['youtuberName'] ?? '',
                subscriber: map['subscriber'] ?? '',
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}

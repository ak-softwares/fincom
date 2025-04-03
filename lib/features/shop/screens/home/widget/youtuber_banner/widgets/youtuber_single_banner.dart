import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../../../common/widgets/custom_shape/image/circular_image.dart';
import '../../../../../../../utils/constants/sizes.dart';


class YouTuberSingleBanner extends StatelessWidget {
  const YouTuberSingleBanner({super.key, required this.thumbnail, required this.profilePic, required this.youtubeChannelUrl, required this.youtuberName, required this.subscriber,});

  final String thumbnail;
  final String profilePic;
  final String youtubeChannelUrl;
  final String youtuberName;
  final String subscriber;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => launchUrlString(youtubeChannelUrl),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.defaultSpace),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TRoundedImage(
              fit: BoxFit.cover,
              image: thumbnail,
              height: 160,
              width: double.infinity,
              borderRadius: 10,
              isNetworkImage: false,
              padding: 0,
            ),
            const SizedBox(height: AppSizes.md),
            Row(
              children: [
                TRoundedImage(
                  fit: BoxFit.cover,
                  image: profilePic,
                  height: 40,
                  width: 40,
                  borderRadius: 55,
                  isNetworkImage: false,
                  padding: 0,
                ),
                const SizedBox(width: AppSizes.defaultSpace),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(youtuberName, style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 15)),
                    Text(subscriber, style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 11)),
                  ],
                ),
                // ListTile(
                //   leading: TRoundedImage(
                //     fit: BoxFit.cover,
                //     image: profilePic,
                //     height: 45,
                //     width: 45,
                //     borderRadius: 55,
                //     isNetworkImage: false,
                //     padding: 0,
                //   ),
                //   title: Text(youtuberName, style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 16)),
                //   subtitle: Text(subscriber, style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 13)),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

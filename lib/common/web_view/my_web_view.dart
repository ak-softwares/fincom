import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';

import '../../utils/constants/colors.dart';
import '../navigation_bar/appbar2.dart';

class MyWebViewController extends GetxController {
  final RxInt progress = 0.obs;
  final RxBool isLoading = true.obs;

  void updateProgress(int newProgress) {
    progress.value = newProgress;
  }

  void setLoading(bool loading) {
    isLoading.value = loading;
  }
}

class MyWebView extends StatelessWidget {
  const MyWebView({Key? key, this.title = '', required this.url}) : super(key: key);

  final String title;
  final String url;

  @override
  Widget build(BuildContext context) {
    final MyWebViewController myWebViewController = Get.put(MyWebViewController());

    final WebViewController webViewController = WebViewController();
    webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);
    webViewController.setBackgroundColor(const Color(0x00000000));
    webViewController.setNavigationDelegate(NavigationDelegate(
      onProgress: (int progress) {
        myWebViewController.updateProgress(progress);
      },
      onPageStarted: (String url) {
        myWebViewController.setLoading(true);
      },
      onPageFinished: (String url) {
        myWebViewController.setLoading(false);
      },
      onWebResourceError: (WebResourceError error) {},
      onNavigationRequest: (NavigationRequest request) {
        if (request.url.startsWith('https://www.youtube.com/')) {
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
    ));
    webViewController.loadRequest(Uri.parse(url));


    return PopScope(
      canPop: false, // This property disables the system-level back navigation
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        var isLastPage = await webViewController.canGoBack();
        if(isLastPage) {
          webViewController.goBack();
          // return false;
        }else {
          Get.back();
        }
        // return;
      },
      child: Scaffold(
        appBar: TAppBar2(titleText: title),
        body: RefreshIndicator(
          color: TColors.primaryColor,
          onRefresh: () async {
            // Reload the page here
            await webViewController.reload();
          },
          child: Obx(() {
            return Column(
              children: [
                myWebViewController.isLoading.value
                ? LinearProgressIndicator(
                    value: myWebViewController.progress.value / 100,
                    backgroundColor: Colors.grey,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  )
                : const SizedBox.shrink(),
                Expanded(child: WebViewWidget(controller: webViewController))
              ],
            );
          }),
        ),
      ),
    );

  }
}

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:web/provider.dart';

class WebScreen extends StatefulWidget {
  const WebScreen({Key? key}) : super(key: key);

  @override
  State<WebScreen> createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {


  WebProvider? wpT;
  WebProvider? wpF;


  TextEditingController txtsearch=TextEditingController();
  InAppWebViewController? webViewController;
  PullToRefreshController? pullToRefreshController;

  @override
  void initState() {
    super.initState();
    pullToRefreshController=PullToRefreshController(
      onRefresh:() {
        webViewController!.reload();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    wpF=Provider.of<WebProvider>(context,listen: false);
    wpT=Provider.of<WebProvider>(context,listen: true);
    return SafeArea(child: Scaffold(
      backgroundColor: Colors.black38,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 5.h,
                  width: 95.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white24
                  ),
                  child: TextField(
                    controller: txtsearch,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search Here.....",
                      hintStyle: TextStyle(color: Colors.grey.shade100),
                      prefixIcon: Icon(Icons.arrow_back,color: Colors.grey.shade100),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search_rounded,color: Colors.grey.shade100),
                        onPressed: () {
                          webViewController!.loadUrl(urlRequest: URLRequest(url: Uri.parse("https://www.google.com/search?q=${txtsearch.text}")));
                        },
                      )
                    ),
                  ),
                ),
              )
            ],
          ),
          LinearProgressIndicator(
            value: wpT!.p1,
            backgroundColor: Colors.lightBlue.shade100,
          ),
          Expanded(
            child: InAppWebView(
              initialUrlRequest:URLRequest(url: Uri.parse("https://www.google.com/")),
              onLoadStart: (controller, url) {
                webViewController = controller;
              },
              onLoadStop: (controller, url) {
                webViewController = controller;
                pullToRefreshController!.endRefreshing();
              },
              onLoadError: (controller, url, code, message) {},
              onProgressChanged: (controller, progress) {
                webViewController = controller;
                pullToRefreshController!.endRefreshing();

                wpF!.changprogress((progress/100).toDouble());
              },
              pullToRefreshController: pullToRefreshController,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () => webViewController!.goBack(),
                icon: Icon(Icons.arrow_back_rounded,color: Colors.grey.shade100),
                iconSize: 25,
                color: Colors.black87,
              ),
              IconButton(
                onPressed: () => webViewController!.reload(),
                icon: Icon(Icons.refresh_rounded,color: Colors.grey.shade100),
                iconSize: 25,
                color: Colors.black87,
              ),
              IconButton(
                onPressed: () => webViewController!.goForward(),
                icon: Icon(Icons.arrow_forward_rounded,color: Colors.grey.shade100),
                iconSize: 25,
                color: Colors.black87,
              ),
            ],
          ),
        ],
      ),
    ));
  }
}

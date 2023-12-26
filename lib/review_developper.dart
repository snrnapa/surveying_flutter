import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:surveying_app/components/drawer_helper.dart';
import 'package:surveying_app/components/title_text.dart';
import 'package:surveying_app/components/utils.dart';
import 'package:surveying_app/constants/review_constants.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ReviewDevelopper extends StatefulWidget {
  @override
  _ReviewDevelopperPageState createState() => _ReviewDevelopperPageState();
}

class _ReviewDevelopperPageState extends State<ReviewDevelopper> {
  List<Map<String, dynamic>> resultCardList = [];
  bool isLoading = false;
  var utils = Utils();

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("ReviewDevelopper"),
        ),
        body: SingleChildScrollView(
            child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TitleText(text: '開発者について'),
              IconButton(
                  onPressed: () => DrawerHelper.launchStoreReview(context),
                  icon: Icon(Icons.reviews)),
              Card(
                // color: Color.fromARGB(207, 28, 225, 163),
                child: Column(children: [
                  ListTile(
                    leading: Icon(Icons.developer_board),
                    title: Text("Developper Info"),
                    subtitle: Text(ReviewConstants.developperInfo),
                  ),
                  ListTile(
                    leading: Icon(Icons.adb),
                    title: Text("Technology"),
                    subtitle: Text(ReviewConstants.technology),
                  ),
                  ListTile(
                    leading: Icon(Icons.work),
                    title: Text("Career"),
                    subtitle: Text(ReviewConstants.career),
                  ),
                  ListTile(
                      leading: Icon(Icons.contact_mail),
                      title: Text("Contact・SNS"),
                      subtitle: Column(
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                    text: "Mail:  ",
                                    style: TextStyle(color: Colors.black)),
                                TextSpan(
                                    text: ReviewConstants.mail,
                                    style: const TextStyle(
                                        color: Colors.lightBlue),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        utils.openReviewMail();
                                      }),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                    text: "github:  ",
                                    style: TextStyle(color: Colors.black)),
                                TextSpan(
                                    text: ReviewConstants.githubUrl,
                                    style: const TextStyle(
                                        color: Colors.lightBlue),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        launchUrlString(
                                            ReviewConstants.githubUrl);
                                      }),
                              ],
                            ),
                          ),
                        ],
                      )),
                ]),
              ),
            ],
          ),
        )),
      ),
    );
  }
}

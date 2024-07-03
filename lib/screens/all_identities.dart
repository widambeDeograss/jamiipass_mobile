import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jamiipass_mobile/constants/custom_colors.dart';
import 'package:provider/provider.dart';

import '../api/identity_cache.dart';
import '../constants/app_constants.dart';
import '../providers/user_management_provider.dart';
import '../widgets/app_large_text.dart';
import '../widgets/app_small_text.dart';
import 'Identity_view.dart';
import 'share_start_scren.dart';

class IdentitiesScreen extends StatefulWidget {
  const IdentitiesScreen({Key? key}) : super(key: key);

  @override
  State<IdentitiesScreen> createState() => _IdentitiesScreenState();
}

class _IdentitiesScreenState extends State<IdentitiesScreen> {
  List<Map<String, dynamic>> identityData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final userAuthProvider =
        Provider.of<UserAuthProvider>(context, listen: false);
    dynamic user = userAuthProvider.authState.user.id;
    try {
      final data = await fetchIdentityData(
          "${AppConstants.apiBaseUrl}${AppConstants.getIdentitiesFromNtwork}?fcn=GetIdentitiesByUserID&&args=$user");
      setState(() {
        identityData = data;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
        msg: "Error: Failed to fetch data",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.buttonBackground,
      appBar: AppBar(
        backgroundColor: AppColors.buttonBackground,
        title: AppLargeText(
          text: "All Identities",
          size: 18,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: _buildIdenityShares(identityData),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.mainColor,
        tooltip: 'Share Ids',
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ShareIdFirstScreen()));
        },
        child: const Icon(Icons.share, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildIdenityShares(dynamic ids) {
    return ListView.builder(
      itemCount: ids.length,
      itemBuilder: (context, index) {
        final id = ids[index];

        return Column(
          children: [
            GestureDetector(
              onTap: () {
                 Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewIdentityFile(
                        transactionId: id['transactionId'],
                      )),
            );
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    // border: Border.all(width: 1, color: Colors.black54),
                    color: Colors.white),
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 20),
                          width: 30,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.buttonBackground,
                              image: DecorationImage(
                                  image: AssetImage(id['organization'] == "NIDA"
                                      ? "assets/nida.jpg"
                                      : id['organization'] == "NHIF"
                                          ? "assets/nhif.jpg"
                                          : id['organization'] == "DIT"
                                              ? "assets/dit.png"
                                              : id['organization'] == "RITA"
                                                  ? "assets/rita.jpeg"
                                                  : id['organization'] == "TRA"
                                                      ? "assets/tra.png"
                                                      : "assets/nida.jpg"),
                                  fit: BoxFit.cover)),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppLargeText(
                              text: "${id['documentNo']}",
                              size: 14,
                              color: AppColors.bigTextColor,
                            ),
                            AppSmallText(
                              text: "${id['organization']}",
                              size: 10,
                              color: AppColors.mainTextColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white,
                          border: Border.all(
                              width: 1, color: AppColors.buttonBackground)),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        );
      },
    );
  }
}

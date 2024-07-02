import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jamiipass_mobile/helper/id_history_helper.dart';
import 'package:jamiipass_mobile/screens/inactive_id_shares.dart';
import 'package:provider/provider.dart';

import '../api/api.dart';
import '../configs/langConfg/localization/localization_constants.dart';
import '../constants/app_constants.dart';
import '../constants/custom_colors.dart';
import '../providers/user_management_provider.dart';
import '../screens/active_identity_histry.dart';
import '../screens/id_history_dsc.dart';
import '../widgets/app_large_text.dart';
import '../widgets/app_small_text.dart';

class CorporateHomeScreen extends StatefulWidget {
  const CorporateHomeScreen({Key? key}) : super(key: key);

  @override
  State<CorporateHomeScreen> createState() => _CorporateHomeScreenState();
}

class _CorporateHomeScreenState extends State<CorporateHomeScreen> {
  List<IdHistory> identityShareHistories = [];
  List<IdHistory> identitiesSharedInactive  = [];
   bool isLoading = false;
  final List<Map<String, dynamic>> carouselItems = [
    {
      'precaution': 'Receive shared Identity with ease',
      'icon': Icons.add_card,
    },
    {
      'precaution': 'Manage shared Identities better',
      'icon': Icons.manage_search,
    },
    {
      'precaution': 'Scan and get the identities shared',
      'icon': Icons.document_scanner_outlined,
    },
  ];

  get data => null;

  _corporateLoadIdentities() async {
    final userAuthProvider =
        Provider.of<UserAuthProvider>(context, listen: false);
    dynamic token = userAuthProvider.authState.corporate.apiToken;

    setState(() {
      isLoading = true;
    });
    try {
      var res = await CallApi().authenticatedRequest({},
          AppConstants.apiBaseUrl + AppConstants.corpShareHistory,
          'get',
          token);
      print(res);
      var body = json.decode(res);
      IdHistoryList idList = IdHistoryHelper.filterIdHistory(body['data']);
      identityShareHistories = idList.activeIdHistory;
      identitiesSharedInactive =idList.inActiveIdHistory;
    } catch (error) {
      Fluttertoast.showToast(
          msg: "Error:Failing to get histories check network and try again",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 13.0);
      print(error);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _corporateLoadIdentities();
  }

  @override
  Widget build(BuildContext context) {
    final userAuthProvider =
        Provider.of<UserAuthProvider>(context, listen: false);
    final corp = userAuthProvider.authState.corporate;
    return Scaffold(
      backgroundColor: AppColors.buttonBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppLargeText(
                        text:
                            // ${getTranslated(context, "home_welcm").toString()},
                            "${corp.name}",
                        size: 20,
                      ),
                      AppSmallText(
                        text: getTranslated(context, "home_welcm_txt_corp")
                            .toString(),
                        size: 14,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                       width: 34,
                    height: 34,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.grey.withOpacity(0.5),
                            image: DecorationImage(image: 
                                corp.file == null ? const NetworkImage("https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg?t=st=1719906880~exp=1719910480~hmac=99c3f74ad8d7efd05f67d32f288897ebe28a16b877c7d1dd3159fecc2659c173&w=900") :NetworkImage("${AppConstants.mediaBaseUrl}/${corp.file}") ,
                              fit: BoxFit.cover
                            ),

                            ),
                        
                      ),
                      // IconButton.outlined(
                      //     onPressed: () => {},
                      //     style: ButtonStyle(
                      //         iconSize: MaterialStateProperty.all(20)),
                      //     icon: const Icon(Icons.notifications_active)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildCarousel(),
            const SizedBox(
              height: 20,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 150,
                    // Adjusted margin
                    width: MediaQuery.of(context).size.width *
                        0.45, // Used MediaQuery for device width
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 20),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.black,
                          ),
                          child: const Icon(
                            Icons.account_box_outlined,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppSmallText(
                                  text: getTranslated(
                                          context, "home_total_shared_active")
                                      .toString(),
                                  size: 10,
                                  color: AppColors.mainTextColor,
                                ),
                                AppLargeText(
                                  text:
                                      "${identityShareHistories.length} ${getTranslated(context, "identity").toString()}",
                                  size: 12,
                                  color: AppColors.bigTextColor,
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ActiveIdentityShareScreen()),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 5),
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 1,
                                        color: AppColors.buttonBackground)),
                                child: const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 150,
                    // Adjusted margin
                    width: MediaQuery.of(context).size.width *
                        0.45, // Used MediaQuery for device width
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 20),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: AppColors.accentColor,
                          ),
                          child: const Icon(
                            Icons.restore_from_trash,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppSmallText(
                                  text: getTranslated(
                                          context, "home_total_shared_inactive")
                                      .toString(),
                                  size: 12,
                                  color: AppColors.mainTextColor,
                                ),
                                AppLargeText(
                                  text:
                                      "${identitiesSharedInactive.length} ${getTranslated(context, "identity").toString()}",
                                  size: 10,
                                  color: AppColors.bigTextColor,
                                ),
                              ],
                            ),
                            GestureDetector(
                                  onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const InactiveIdentityShares()),
                            );
                          },
                              child: Container(
                                margin: const EdgeInsets.only(right: 5),
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 1,
                                        color: AppColors.buttonBackground)),
                                child: const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppLargeText(
                    text:
                        getTranslated(context, "home_your_ids_corp").toString(),
                    size: 13,
                    color: AppColors.bigTextColor,
                  ),
                  TextButton(
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ActiveIdentityShareScreen()),
                      ),
                    },
                    child: AppSmallText(
                      text: getTranslated(context, "home_view_btn").toString(),
                      size: 13,
                      color: AppColors.bigTextColor,
                    ),
                  )
                ],
              ),
            ),
            isLoading
                ? Center(
                    child: AppSmallText(
                      text: "Loading....",
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: _buildIdHistory(identityShareHistories),
                  )
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        viewportFraction: 0.8,
        enlargeCenterPage: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
      ),
      items: carouselItems.map((item) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              // margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item['icon'],
                      size: 40,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['precaution'],
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildIdHistory(List<IdHistory> ids) {
    final topThreeIds = ids.take(3).toList();
    return Column(
      children: topThreeIds.map((id) {
        return InkWell(
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => IdentityHistoryScreen(
                        identityHis: id,
                      )),
            ),
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.white),
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppLargeText(
                      text: "${id.firstName}  ${id.middleName} ${id.lastName}",
                      size: 14,
                      color: AppColors.bigTextColor,
                    ),
                    AppSmallText(
                      text: "${id.cards}",
                      size: 10,
                      color: AppColors.mainTextColor,
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
        );
      }).toList(),
    );
  }
}

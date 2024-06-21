import 'package:flutter/material.dart';
import 'package:jamiipass_mobile/constants/app_constants.dart';
import 'package:jamiipass_mobile/helper/id_history_helper.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../configs/langConfg/localization/localization_constants.dart';
import '../constants/custom_colors.dart';
import '../widgets/app_large_text.dart';
import '../widgets/app_small_text.dart';
import 'Identity_view.dart';

class IdentityHistoryScreen extends StatefulWidget {
  final IdHistory identityHis;
  const IdentityHistoryScreen({Key? key, required this.identityHis})
      : super(key: key);

  @override
  State<IdentityHistoryScreen> createState() => _IdentityHistoryScreenState();
}

class _IdentityHistoryScreenState extends State<IdentityHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.buttonBackground,
        appBar: AppBar(
          backgroundColor: AppColors.buttonBackground,
          title: AppLargeText(
            text:widget.identityHis.cards,
            size: 16,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      // color: AppColors.mainColor,
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.mainColor,
                            AppColors.mainTextColor
                          ])),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 20),
                                  width: 80,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColors.buttonBackground,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              AppConstants.mediaBaseUrl +
                                                  widget.identityHis.profile),
                                          fit: BoxFit.cover)),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppLargeText(
                                      text:
                                          "FIST NAME:   ${widget.identityHis.firstName}",
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                    AppLargeText(
                                      text:
                                          "LAST NAME:   ${widget.identityHis.lastName}",
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                    AppLargeText(
                                      text:
                                          "PHONE:   ${widget.identityHis.phone}",
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            QrImageView(
                              data: widget.identityHis.nida,
                              version: QrVersions.auto,
                              size: 80.0,
                            ),
                          ],
                        ),
                        AppLargeText(
                          text: widget.identityHis.nida,
                          size: 14,
                          color: Colors.white,
                        ),
                      ])),
              const SizedBox(
                height: 20,
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: _buildIdHistory(widget.identityHis.cardsArray))
            ],
          ),
        ));
  }

  Widget _buildIdHistory(List<String> ids) {
    final topThreeIds = ids.take(3).toList();
    return Column(
      children: topThreeIds.asMap().entries.map((entry) {
        int index = entry.key;
        String id = entry.value;

        // Check if hashArray has the required length
        if (index >= widget.identityHis.hashArray.length) {
          return SizedBox.shrink();
        }

        return InkWell(
          onTap: () {
            print(widget.identityHis.hashArray);
            // Handle the tap event here, if needed
             Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewIdentityFile(
                        transactionId: widget.identityHis.hashArray[index],
                      )),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 20),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.buttonBackground,
                          image: const DecorationImage(
                              image: AssetImage("asset/pdf_view.png"),
                              fit: BoxFit.cover)),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppLargeText(
                          text: id,
                          size: 14,
                          color: AppColors.bigTextColor,
                        ),
                        AppSmallText(
                          text: widget.identityHis.hashArray[index],
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
                      width: 1,
                      color: AppColors.buttonBackground,
                    ),
                  ),
                  child: const Icon(
                    Icons.remove_red_eye_outlined,
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

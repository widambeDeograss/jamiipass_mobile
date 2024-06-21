import 'package:flutter/material.dart';

import '../configs/langConfg/localization/localization_constants.dart';
import '../constants/custom_colors.dart';
import '../widgets/app_large_text.dart';
import '../widgets/app_small_text.dart';
import 'Identity_view.dart';

class ScannerResults extends StatefulWidget {
  final  scannerResults;
  const ScannerResults({super.key, this.scannerResults});

  @override
  State<ScannerResults> createState() => _ScannerResultsState();
}

class _ScannerResultsState extends State<ScannerResults> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.buttonBackground,
      appBar: AppBar(
        backgroundColor: AppColors.buttonBackground,
        title: AppLargeText(
          text: getTranslated(context, "scanner_results_title").toString(),
          size: 16,
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: _buildIdHistory(widget.scannerResults))

    );
  }

  // {
  // 'card': id['documentNo'],
  // 'trsId': id['transactionId'],
  // 'org': id['organization']
  // };

  Widget _buildIdHistory(List<dynamic> ids) {
    final topThreeIds = ids.take(3).toList();
    return Column(
      children: topThreeIds.map((id) {

        return InkWell(
          onTap: () {
            // Handle the tap event here, if needed
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewIdentityFile(
                    transactionId: id['trsId'],
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
                          image:  DecorationImage(
                              image: AssetImage(id['org'] == "NIDA"
                                  ? "assets/nida.jpg"
                                  : id['org'] == "NHIF"
                                  ? "assets/nhif.jpg"
                                  : id['org'] == "DIT"
                                  ? "assets/dit.png"
                                  : id['org'] == "RITA"
                                  ? "assets/rita.jpeg"
                                  : id['org'] == "TRA"
                                  ? "assets/tra.png"
                                  : "assets/nida.jpg"),
                              fit: BoxFit.cover)),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppLargeText(
                          text: id['card'],
                          size: 14,
                          color: AppColors.bigTextColor,
                        ),
                        AppSmallText(
                          text: id['trsId'],
                          size: 10,
                          color: AppColors.mainTextColor,
                        ),
                        AppSmallText(
                          text: id['org'],
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
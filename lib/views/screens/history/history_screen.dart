import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_scanner/cubit/history_cubit/history_state.dart';
import 'package:qr_scanner/models/qr_code.dart';
import 'package:qr_scanner/service/qr_code_service.dart';
import 'package:qr_scanner/utils/app_color.dart';
import 'package:qr_scanner/utils/app_route.dart';
import 'package:qr_scanner/views/widgets/custom_text.dart';

import '../../../cubit/history_cubit/history_cubit.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HistoryCubit(QrCodeService()),
      child: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              const Gap(80),
              Container(
                decoration: BoxDecoration(
                  color: AppColor.grey,
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 45),
                child: TabBar(
                  dividerHeight: 0,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: AppColor.yellow,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white,
                  labelStyle: const TextStyle(
                      fontSize: 19, fontWeight: FontWeight.bold),
                  unselectedLabelStyle: const TextStyle(fontSize: 19),
                  tabs: const [
                    Tab(child: CustomText(text: "Scan")),
                    Tab(child: CustomText(text: "Create")),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    BlocBuilder<HistoryCubit, HistoryState>(
                      builder: (context, state) =>
                          _buildQrCodeList(context, state.scannedQrCodes),
                    ),
                    BlocBuilder<HistoryCubit, HistoryState>(
                      builder: (context, state) =>
                          _buildQrCodeList(context, state.createdQrCodes),
                    ),
                  ],
                ),
              ),
              const Gap(kToolbarHeight * 2 - 10)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQrCodeList(BuildContext context, List<QrCodeModel> qrCodes) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45.0),
      child: qrCodes.isEmpty
          ? Lottie.asset("assets/lottie/empty.json")
          : ListView.builder(
              padding: const EdgeInsets.only(top: 20),
              itemCount: qrCodes.length,
              itemBuilder: (context, index) {
                final qrCode = qrCodes[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoute.resultScreen,
                        arguments: qrCode);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: AppColor.grey,
                          offset: Offset(0, 1),
                          blurRadius: 2,
                        )
                      ],
                      color: AppColor.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      visualDensity: VisualDensity.compact,
                      title: CustomText(
                        text: qrCode.content,
                        size: 17,
                      ),
                      subtitle: CustomText(
                        text: qrCode.formattedDate,
                        color: const Color(0xffA4A4A4),
                        size: 11,
                      ),
                      leading: SvgPicture.asset(
                        "assets/images/scan.svg",
                        height: 33,
                        width: 33,
                      ),
                      trailing: GestureDetector(
                        onTap: () {
                          context.read<HistoryCubit>().deleteQrCode(qrCode);
                        },
                        child: SvgPicture.asset(
                          'assets/images/delete.svg',
                          height: 24,
                          width: 24,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

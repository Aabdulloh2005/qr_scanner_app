import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_scanner/cubit/result_cubit.dart';
import 'package:qr_scanner/utils/app_color.dart';
import 'package:qr_scanner/views/widgets/button_widget.dart';
import 'package:qr_scanner/views/widgets/custom_appbar.dart';
import 'package:qr_scanner/views/widgets/custom_container.dart';
import 'package:qr_scanner/views/widgets/custom_text.dart';
import 'package:share_plus/share_plus.dart';

class ResultScreen extends StatelessWidget {
  final String result;

  const ResultScreen({
    Key? key,
    required this.result,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResultCubit(),
      child: Scaffold(
        appBar: CustomAppbar(
          title: "Result",
          leading: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              BlocBuilder<ResultCubit, bool>(
                builder: (context, state) {
                  return state
                      ? _buildResultView(context)
                      : _buildQrView(context);
                },
              ),
              const Gap(40),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultView(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      decoration: BoxDecoration(
        color: AppColor.grey,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: SvgPicture.asset(
              "assets/images/scan.svg",
              height: 50,
              width: 50,
            ),
            title: CustomText(text: "Data"),
            subtitle: CustomText(text: "16 dec 2022,9:30"),
          ),
          const Divider(
            height: 20,
            color: Color(0xff858585),
            thickness: 0.4,
          ),
          CustomText(
            text: result,
            size: 17,
            fontWeight: FontWeight.w500,
          ),
          TextButton(
            onPressed: () {
              context.read<ResultCubit>().onResult();
            },
            child: CustomText(
              text: "Show Qr Code",
              color: AppColor.yellow,
              size: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return Column(
      children: [
        CustomContainer(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          widget: ListTile(
            contentPadding: EdgeInsets.zero,
            title: CustomText(text: "Data"),
            subtitle: CustomText(text: result),
          ),
        ),
        GestureDetector(
          onTap: () {
            context.read<ResultCubit>().onResult();
          },
          child: Container(
            height: 210,
            width: 210,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColor.yellow, width: 3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: QrImageView(
              data: result,
              embeddedImageStyle:
                  const QrEmbeddedImageStyle(size: Size(45, 45)),
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: Colors.blue,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                color: Colors.blue,
                dataModuleShape: QrDataModuleShape.square,
              ),
              embeddedImage: const AssetImage("assets/images/telegram.png"),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildShareButton(context),
        const Gap(20),
        BlocBuilder<ResultCubit, bool>(
          builder: (context, state) {
            return state
                ? _buildCopyButton(context)
                : _buildSaveButton(context);
          },
        ),
      ],
    );
  }

  Widget _buildShareButton(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Share.share(result);
          },
          child: ButtonWidget(
            iconSize: 35,
            size: 60,
            color: AppColor.yellow,
            iconColor: AppColor.grey,
            icon: Icons.share,
          ),
        ),
        CustomText(text: "Share", size: 15),
      ],
    );
  }

  Widget _buildCopyButton(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: result)).then(
              (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColor.yellow,
                    duration: const Duration(seconds: 1),
                    content: CustomText(
                      text: "Copied to clipboard",
                      size: 16,
                    ),
                  ),
                );
              },
            );
          },
          child: ButtonWidget(
            iconSize: 35,
            size: 60,
            color: AppColor.yellow,
            iconColor: AppColor.grey,
            icon: Icons.copy_all_outlined,
          ),
        ),
        CustomText(text: "Copy", size: 15),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: ()  {},
          child: ButtonWidget(
            iconSize: 35,
            size: 60,
            color: AppColor.yellow,
            iconColor: AppColor.grey,
            icon: Icons.save,
          ),
        ),
        CustomText(text: "Save", size: 15),
      ],
    );
  }
}

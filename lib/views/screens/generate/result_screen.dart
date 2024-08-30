import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_scanner/models/qr_code.dart';
import 'package:qr_scanner/service/qr_code_save_service.dart';
import 'package:qr_scanner/utils/app_color.dart';
import 'package:qr_scanner/utils/helpers.dart';
import 'package:qr_scanner/views/widgets/button_widget.dart';
import 'package:qr_scanner/views/widgets/custom_appbar.dart';
import 'package:qr_scanner/views/widgets/custom_container.dart';
import 'package:qr_scanner/views/widgets/custom_text.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../cubit/result_cubit.dart';

class ResultScreen extends StatefulWidget {
  final QrCodeModel qrCode;

  const ResultScreen({
    super.key,
    required this.qrCode,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final GlobalKey qrKey = GlobalKey();

  final screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResultCubit(),
      child: Scaffold(
        appBar: const CustomAppbar(
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SizedBox(
            width: double.infinity,
            child: FloatingActionButton(
              backgroundColor: AppColor.yellow,
              onPressed: _openUrl,
              child: const CustomText(
                text: "Open",
                color: AppColor.black,
                fontWeight: FontWeight.w700,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openUrl() async {
    if (await canLaunchUrlString(widget.qrCode.content)) {
      await launchUrlString(widget.qrCode.content);
    } else {
      if (mounted) {
        Helpers.showSnackBar(context, "Could not launch the URL");
      }
    }
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
            title: const CustomText(text: "Data"),
            subtitle: const CustomText(text: "16 dec 2022,9:30"),
          ),
          const Divider(
            height: 20,
            color: Color(0xff858585),
            thickness: 0.4,
          ),
          CustomText(
            text: widget.qrCode.content,
            size: 17,
            fontWeight: FontWeight.w500,
          ),
          TextButton(
            onPressed: () {
              context.read<ResultCubit>().onResult();
            },
            child: const CustomText(
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
            title: const CustomText(text: "Data"),
            subtitle: CustomText(text: widget.qrCode.content),
          ),
        ),
        GestureDetector(
          onTap: () {
            context.read<ResultCubit>().onResult();
          },
          child: Screenshot(
            controller: screenshotController,
            child: RepaintBoundary(
              key: qrKey,
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
                  data: widget.qrCode.content,
                  embeddedImageStyle:
                      const QrEmbeddedImageStyle(size: Size(45, 45)),
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: Colors.black,
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    color: Colors.black,
                    dataModuleShape: QrDataModuleShape.square,
                  ),
                ),
              ),
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
            Share.share(widget.qrCode.content);
          },
          child: const ButtonWidget(
            iconSize: 35,
            size: 60,
            color: AppColor.yellow,
            iconColor: AppColor.grey,
            icon: Icons.share,
          ),
        ),
        const CustomText(text: "Share", size: 15),
      ],
    );
  }

  Widget _buildCopyButton(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: widget.qrCode.content)).then(
              (value) {
                if (context.mounted) {
                  Helpers.showSnackBar(context, "Copied to clipboard");
                }
              },
            );
          },
          child: const ButtonWidget(
            iconSize: 35,
            size: 60,
            color: AppColor.yellow,
            iconColor: AppColor.grey,
            icon: Icons.copy_all_outlined,
          ),
        ),
        const CustomText(text: "Copy", size: 15),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            final saved = await QrCodeSaveService.generateAndSaveQRCode(
              screenshotController: screenshotController,
            );
            if (context.mounted) {
              Helpers.showSnackBar(
                context,
                saved ? "QR Code saved to gallery" : "Failed to save QR Code",
              );
            }
          },
          child: const ButtonWidget(
            iconSize: 35,
            size: 60,
            color: AppColor.yellow,
            iconColor: AppColor.grey,
            icon: Icons.save,
          ),
        ),
        const CustomText(text: "Save", size: 15),
      ],
    );
  }
}

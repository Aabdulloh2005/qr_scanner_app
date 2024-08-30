import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_scanner/cubit/generate_cubit/generate_cubit.dart';
import 'package:qr_scanner/models/qr_code.dart';
import 'package:qr_scanner/service/qr_code_service.dart';

import '../../../cubit/generate_cubit/generate_state.dart';
import '../../../utils/utils.dart';
import '../../widgets/widgets.dart';

class GenerateScreen extends StatelessWidget {
  final String icon;
  final String label;
  final String baseUrl;

  const GenerateScreen({
    super.key,
    required this.icon,
    required this.label,
    required this.baseUrl,
  });

  TextInputType _getKeyboardType() {
    switch (icon) {
      case 'wathsApp':
      case 'telephone':
        return TextInputType.phone;
      case 'email':
        return TextInputType.emailAddress;
      case 'website':
        return TextInputType.url;
      default:
        return TextInputType.text;
    }
  }

  List<TextInputFormatter>? _getInputFormatters() {
    switch (icon) {
      case 'wathsApp':
      case 'telephone':
        return [FilteringTextInputFormatter.digitsOnly];
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GenerateScreenCubit(icon),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: const Color(0xff3D3D3D),
            appBar: CustomAppbar(
              title: icon.toUpper(),
              leading: true,
            ),
            body: Center(
              child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.transparent.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: const Border.symmetric(
                    horizontal: BorderSide(
                      color: AppColor.yellow,
                      width: 2,
                    ),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SvgPicture.asset(
                        "assets/categories/$icon.svg",
                        height: 60,
                        width: 60,
                      ),
                      const Gap(50),
                      CustomText(
                        text: label,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.start,
                      ),
                      const Gap(10),
                      BlocBuilder<GenerateScreenCubit, GenerateScreenState>(
                        builder: (context, state) {
                          return TextField(
                            onChanged: (value) => context
                                .read<GenerateScreenCubit>()
                                .updateInput(value),
                            keyboardType: _getKeyboardType(),
                            inputFormatters: _getInputFormatters(),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              hintText: "Enter $label...",
                              errorText:
                                  state.isInputValid ? null : "Invalid input",
                            ),
                          );
                        },
                      ),
                      const Gap(40),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50.0, vertical: 10),
                        child: BlocBuilder<GenerateScreenCubit,
                            GenerateScreenState>(
                          builder: (context, state) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.yellow,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: state.isInputValid
                                  ? () async {
                                      final qrCode = QrCodeModel(
                                        content: "$baseUrl${state.input}",
                                        createdAt: DateTime.now(),
                                        isScanned: false,
                                      );
                                      await QrCodeService().addQrCode(qrCode);

                                      if (context.mounted) {
                                        Navigator.of(context).pushNamed(
                                          AppRoute.resultScreen,
                                          arguments: qrCode,
                                        );
                                      }
                                    }
                                  : null,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: CustomText(
                                  text: "Generate QR Code",
                                  color: AppColor.black,
                                  fontWeight: FontWeight.bold,
                                  size: 18,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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

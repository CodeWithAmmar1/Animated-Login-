import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String riveAnimationPath;
  Artboard? teddyArtboard;
  SMITrigger? triggerSuccess, triggerFail;
  SMIBool? handsUpBool, checkingBool;
  SMINumber? lookNumber;
  StateMachineController? teddyController;
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  bool isRememberMeChecked = false;

  @override
  void initState() {
    super.initState();
    riveAnimationPath = defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS
        ? 'assets/animations/login.riv'
        : 'animations/login.riv';
    rootBundle.load(riveAnimationPath).then(
      (data) {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        teddyController =
            StateMachineController.fromArtboard(artboard, "Login Machine");
        if (teddyController != null) {
          artboard.addController(teddyController!);

          for (var input in teddyController!.inputs) {
            switch (input.name) {
              case "trigSuccess":
                triggerSuccess = input as SMITrigger;
                break;
              case "trigFail":
                triggerFail = input as SMITrigger;
                break;
              case "isHandsUp":
                handsUpBool = input as SMIBool;
                break;
              case "isChecking":
                checkingBool = input as SMIBool;
                break;
              case "numLook":
                lookNumber = input as SMINumber;
                break;
            }
          }
        }

        setState(() => teddyArtboard = artboard);
      },
    );
  }

  void onPasswordFieldTap() => handsUpBool?.change(true);

  void onEmailFieldTap() {
    handsUpBool?.change(false);
    checkingBool?.change(true);
    lookNumber?.change(0);
  }

  void onTextChanged(String value) {
    lookNumber?.change(value.length.toDouble());
  }

  void handleLogin() {
    checkingBool?.change(false);
    handsUpBool?.change(false);
    if (emailCtrl.text == "ammar@gmail.com" &&
        passwordCtrl.text == "ammar") {
      triggerSuccess?.fire();
    } else {
      triggerFail?.fire();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration:  BoxDecoration(
          gradient: material.LinearGradient(
    colors: [material.Color(0xffd6e2ea), material.Color(0xfff4f2f3)],
    begin: material.Alignment.topLeft,
    end: material.Alignment.bottomRight,
  ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (teddyArtboard != null)
                  SizedBox(
                    width: 400,
                    height: 300,
                    child: Rive(
                      artboard: teddyArtboard!,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                Container(
                  width: 400,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 25),
                  margin: const EdgeInsets.only(bottom: 40),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 245, 220, 229),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        offset: const Offset(0, 8),
                        blurRadius: 15,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: emailCtrl,
                        onTap: onEmailFieldTap,
                        onChanged: onTextChanged,
                        keyboardType: TextInputType.emailAddress,
                        style: GoogleFonts.poppins(fontSize: 14),
                        decoration: const InputDecoration(
                          hintText: "Email",
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xffb04863), width: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: passwordCtrl,
                        onTap: onPasswordFieldTap,
                        obscureText: true,
                        style: GoogleFonts.poppins(fontSize: 14),
                        decoration: const InputDecoration(
                          hintText: "Password",
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xffb04863), width: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                activeColor: const Color(0xffb04863),
                                value: isRememberMeChecked,
                                onChanged: (value) {
                                  setState(() {
                                    isRememberMeChecked = value!;
                                  });
                                },
                              ),
                              Text(
                                "Remember me",
                                style: GoogleFonts.poppins(fontSize: 13),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffb04863),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              "Login",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  "© All Rights Reserved",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

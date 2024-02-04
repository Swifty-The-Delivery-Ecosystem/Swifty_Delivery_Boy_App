import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swifty_delivery_boy/providers/deliveryBoyProvider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<void> login(String phone, int otp) async {
    int statusCode =
        await Provider.of<DeliveryBoyProvider>(context, listen: false)
            .login(phone, otp);
    if (statusCode == 201) {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController phone = TextEditingController();
    TextEditingController otp = TextEditingController();
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 100,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: -40,
                  height: 400,
                  width: width,
                  child: FadeInUp(
                    duration: const Duration(seconds: 1),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  height: 400,
                  width: width + 20,
                  child: FadeInUp(
                    duration: const Duration(milliseconds: 1000),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/background-2.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FadeInUp(
                  duration: const Duration(milliseconds: 1500),
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Color.fromRGBO(49, 39, 79, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                FadeInUp(
                  duration: const Duration(milliseconds: 1700),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(
                        color: Color.fromRGBO(196, 135, 198, .3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(196, 135, 198, .3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color.fromRGBO(196, 135, 198, .3),
                              ),
                            ),
                          ),
                          child: TextField(
                            controller: phone,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Phone Number",
                              hintStyle: TextStyle(color: Colors.grey.shade700),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            controller: otp,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "OTP",
                              hintStyle: TextStyle(color: Colors.grey.shade700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                FadeInUp(
                  duration: const Duration(milliseconds: 1700),
                  child: Center(),
                ),
                const SizedBox(
                  height: 30,
                ),
                FadeInUp(
                  duration: const Duration(milliseconds: 1900),
                  child: MaterialButton(
                    onPressed: () {
                      // TODO: Implement login logic
                      login(phone.text, int.parse(otp.text));
                    },
                    color: Color.fromRGBO(49, 39, 79, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    height: 50,
                    child: Center(
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

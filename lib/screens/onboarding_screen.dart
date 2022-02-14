import 'package:intechpro/screens/login_screen.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

Widget _buildImage(context, String _assetname, [double width = 300]) {

  return ClipRRect(
          borderRadius: BorderRadius.circular(220.0),
          child: Container(
          height: 300,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(120),
            color: Theme.of(context).primaryColor
          ),
          child: Image(
            image: AssetImage('assets/images/$_assetname'),
            width: width,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
      );
  
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

 void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }
  @override
  Widget build(BuildContext context) {
    const pageDecoration =  PageDecoration(
        titleTextStyle: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w900,color:  Color(0xfff56526),letterSpacing: 1.5),
        bodyTextStyle: TextStyle(fontSize: 18.0,color: Colors.white,letterSpacing: 1.1),
        pageColor: Color(0xff5779b9),
        imagePadding: EdgeInsets.zero);

    return IntroductionScreen(
      key: introKey,
      
       globalFooter: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).accentColor
          ),
          child: const Text(
            'Let\s go right away!',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          onPressed: () => _onIntroEnd(context),
        ),
      ),
      pages: [
        PageViewModel(
            title: "Connect with artisans",
            body: "Lets help you find reliable artisan to fix your issues quickly.",
            image: _buildImage(context,"slide_one.jpg"),
            decoration: pageDecoration
            ),

            PageViewModel(
            title: "Truck Service",
            body: "Have your waste dispose swiftly? Look no further our Truck call-up service is all you need.",
            image: _buildImage(context,"slide_two.jpg"),
            decoration: pageDecoration
            ),

             PageViewModel(
            title: "Connect with Suppliers?",
            body: "We got you covered! we provide you with materials suppliers network to match your needs.",
            image: _buildImage(context,"slide_three.jpg"),
            decoration: pageDecoration
            )
      ],
      onDone: ()=> _onIntroEnd(context),
      showSkipButton: true,
            skipFlex: 0,
            nextFlex: 0,
            skip: const Text('Skip', style: TextStyle( fontFamily: "QuickSand",color: Colors.white)),
            next: const Icon(Icons.arrow_forward,color: Colors.white,),
            done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600,  fontFamily: "QuickSand",color: Colors.white)),
            dotsDecorator: const DotsDecorator(
              size: Size(10.0, 10.0),
              color: Color(0xFFBDBDBD),
              activeSize: Size(22.0, 10.0),
              activeColor: Color(0xfff56526),
              activeShape: RoundedRectangleBorder(
                
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
            ),
    );
  }
}

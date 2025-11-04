import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          title: "AppOne-д тавтай морил!",
          body: "Таны амьдралыг илүү хялбар, ухаалаг болгох гайхалтай боломжуудыг нээнэ үү.",
          image: Lottie.asset('assets/animations/welcome.json'),
          decoration: _pageDecoration(),
        ),
        PageViewModel(
          title: "Эмх цэгцтэй бай",
          body: "Өөрийн зорилго, төлөвлөгөөгөө хянаж, амжилттайгаар хэрэгжүүлээрэй.",
          image: Lottie.asset('assets/animations/organize.json'),
          decoration: _pageDecoration(),
        ),
        PageViewModel(
          title: "Одоо эхэлье!",
          body: "AppOne-д нэгдэж, бүх боломжийг бүрэн ашиглаарай!",
          image: Lottie.asset('assets/animations/start.json'),
          decoration: _pageDecoration(),
        ),
      ],
      onDone: () {
        Navigator.of(context).pushReplacementNamed('/home');
      },
      onSkip: () {
        Navigator.of(context).pushReplacementNamed('/home');
      },
      showSkipButton: true,
      skip: const Text("Алгасах", style: TextStyle(fontWeight: FontWeight.bold)),
      next: const Icon(Icons.arrow_forward),
      done: const Text("Дуусгах", style: TextStyle(fontWeight: FontWeight.bold)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.grey,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
        activeColor: Colors.deepPurple,
      ),
    );
  }

  PageDecoration _pageDecoration() => const PageDecoration(
        titleTextStyle: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
        bodyTextStyle: TextStyle(fontSize: 16),
        imagePadding: EdgeInsets.all(24),
      );
}

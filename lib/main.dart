import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart'; 
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

  runApp(MyApp(seenOnboarding: seenOnboarding));
}

class MyApp extends StatelessWidget {
  final bool seenOnboarding;
  const MyApp({super.key, required this.seenOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Хобби Апп',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: seenOnboarding ? const LoginPage() : const OnboardingScreen(),
    );
  }
}

//
// ---------------- ONBOARDING PAGE ----------------
//
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  Future<void> _completeOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          title: "Тавтай морил!",
          body: "AppOne танд өөрийн хоббийг хялбар удирдах боломжийг олгоно.",
          image: Lottie.asset('assets/animations/welcome.json', width: 250),
          decoration: _pageDecoration(),
        ),
        PageViewModel(
          title: "Өөрийгөө хөгжүүл",
          body: "Өдөр бүр шинэ зүйл туршиж, өөрийн сонирхлыг өргөжүүлээрэй.",
          image: Lottie.asset('assets/animations/organize.json', width: 250),
          decoration: _pageDecoration(),
        ),
        PageViewModel(
          title: "Бэлэн боллоо!",
          body: "Хамтдаа AppOne-г туршиж үзье!",
          image: Lottie.asset('assets/animations/start.json', width: 250),
          decoration: _pageDecoration(),
        ),
      ],
      showSkipButton: true,
      skip: const Text("Алгасах", style: TextStyle(fontWeight: FontWeight.bold)),
      next: const Icon(Icons.arrow_forward),
      done: const Text("Дуусгах", style: TextStyle(fontWeight: FontWeight.bold)),
      onDone: () => _completeOnboarding(context),
      onSkip: () => _completeOnboarding(context),
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
        titleTextStyle:
            TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.deepPurple),
        bodyTextStyle: TextStyle(fontSize: 16),
        imagePadding: EdgeInsets.all(24),
      );
}

//
// ---------------- LOGIN PAGE ----------------
//
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  String _errorText = '';

  void _login() {
    if (_userController.text.isEmpty || _passController.text.isEmpty) {
      setState(() {
        _errorText = 'Нэр болон нууц үгээ оруулна уу.';
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/loginn.json', width: 200, height: 200),
              const SizedBox(height: 20),
              TextField(
                controller: _userController,
                decoration: const InputDecoration(
                  labelText: 'Хэрэглэгчийн нэр',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Нууц үг',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  minimumSize: const Size(double.infinity, 45),
                ),
                child: const Text('Нэвтрэх', style: TextStyle(color: Colors.white)),
              ),
              if (_errorText.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(_errorText, style: const TextStyle(color: Colors.red)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

//
// ---------------- MAIN PAGE ----------------
//
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HobbyPage(),
    ExplorePage(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Хобби'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
        ],
      ),
    );
  }
}

//
// ---------------- HOBBY PAGE ----------------
//
class HobbyPage extends StatelessWidget {
  const HobbyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final hobbies = [
      {
        'title': 'Тэмдэглэл хөтлөх',
        'animation': 'assets/write.json',
        'page': const HobbyDetailPage(
          title: 'Тэмдэглэл хөтлөх',
          description:
              'Өдөр бүр бодлоо бичиж үлдээх нь сэтгэл санааг тайвшруулж, өөрийгөө илүү сайн танихад тус болдог.',
          color: Colors.orangeAccent,
          animation: 'assets/write.json',
        ),
      },
      {
        'title': 'Дуу сонсох',
        'animation': 'assets/music.json',
        'page': const HobbyDetailPage(
          title: 'Дуу сонсох',
          description:
              'Хөгжим бол амьдралын аялгуу. Тэр биднийг урамшуулж, сэтгэл гутралд ч гэрэл оруулдаг.',
          color: Colors.purpleAccent,
          animation: 'assets/music.json',
        ),
      },
      {
        'title': 'Аялах',
        'animation': 'assets/travel.json',
        'page': const HobbyDetailPage(
          title: 'Аялах',
          description:
              'Амралт хэрэгтэй, бодлуудаа цэгцлэх хэрэгтэй болох үед аль болох аялаж шинэ газар үзэхийг хичээдэг.',
          color: Colors.tealAccent,
          animation: 'assets/travel.json',
        ),
      },
    ];

    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Миний хобби'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: hobbies.length,
        itemBuilder: (context, index) {
          final hobby = hobbies[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 700),
                  pageBuilder: (_, __, ___) => hobby['page'] as Widget,
                  transitionsBuilder: (_, animation, __, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      )),
                      child: child,
                    );
                  },
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Lottie.asset(hobby['animation'] as String, width: 80, height: 80),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        hobby['title'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, color: Colors.deepPurple),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

//
// ---------------- HOBBY DETAIL PAGE ----------------
//
class HobbyDetailPage extends StatelessWidget {
  final String title;
  final String description;
  final Color color;
  final String animation;

  const HobbyDetailPage({
    super.key,
    required this.title,
    required this.description,
    required this.color,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.withOpacity(0.2),
      appBar: AppBar(
        backgroundColor: color,
        title: Text(title),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(animation, width: 200, height: 200),
              const SizedBox(height: 20),
              Text(
                description,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 18, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
// ---------------- EXPLORE PAGE ----------------
//
class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final AudioPlayer _audioPlayer = AudioPlayer(); // ✅ Fixed type + import
  bool _isPlaying = false;

  final List<String> quotes = [
    "Өнөөдөр сайхан өдөр болно!",
    "Бүгдийг боломжтой гэж үзээрэй.",
    "Өөртөө итгээрэй, чадна шүү!",
    "Бяцхан алхам бүр том үр дүн авчирна.",
    "Инээмсэглэл таны хамгийн хүчирхэг зэвсэг."
  ];

  String getRandomQuote() {
    quotes.shuffle();
    return quotes.first;
  }

  void _playSound() async {
    if (_isPlaying) {
      await _audioPlayer.stop();
      setState(() => _isPlaying = false);
    } else {
      await _audioPlayer.play(AssetSource('sounds/chill.mp3')); // ✅ Correct API for v6.5.1
      setState(() => _isPlaying = true);
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Explore'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/sparkles.json', width: 250, height: 250),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _playSound,
              icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow, color: Colors.white),
              label: Text(
                _isPlaying ? 'Зогсоох' : 'Дуу тоглуулах',
                style: const TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              getRandomQuote(),
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

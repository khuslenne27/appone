import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
// awd
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Хобби апп',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const LoginPage(),
    );
  }
}

// ---------------- LOGIN PAGE ----------------
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

// ---------------- MAIN PAGE ----------------
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

// ---------------- HOBBY PAGE ----------------
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
              'Өдөр бүр бодлоо бичиж үлдээх нь сэтгэл санааг тайвшруулж, өөрийгөө илүү сайн танихад тус болдог',
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
                          parent: animation, curve: Curves.easeOutCubic)),
                      child: child,
                    );
                  },
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
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
                            fontSize: 18, fontWeight: FontWeight.w600),
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

// ---------------- HOBBY DETAIL PAGE ----------------
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
      backgroundColor: color.withValues(alpha: 0.2),
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

// ---------------- EXPLORE PAGE ----------------
class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

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
        child: Lottie.asset('assets/explore.json', width: 250, height: 250),
      ),
    );
  }
}

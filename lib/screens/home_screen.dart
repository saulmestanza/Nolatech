import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nolatech/bloc/auth/auth_bloc.dart';
import 'package:nolatech/bloc/auth/auth_event.dart';
import 'package:nolatech/models/user_model.dart';
import 'package:nolatech/screens/favorites_screen.dart';
import 'package:nolatech/screens/feed_screen.dart';
import 'package:nolatech/screens/onboard_screen.dart';
import 'package:nolatech/screens/reserve_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserModel? userModel;

  const HomeScreen({super.key, required this.userModel});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Widget> _pages;
  int _currentIndex = 0;

  @override
  void initState() {
    _pages = [
      FeedScreen(userModel: widget.userModel),
      ReserveScreen(),
      FavoritesScreen(),
    ];
    super.initState();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<IconData> icons = [
    Icons.home,
    Icons.calendar_month,
    Icons.favorite_border,
  ];

  final List<String> labels = ['Inicio', 'Reservas', 'Favoritos'];

  AppBar appBar() {
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F3D19), Color(0xFF8DC63F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      title: Row(
        children: [
          const Text(
            'Tennis',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF8DC63F), Color(0xFF0F3D19)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Text(
              'court',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      actions: [
        PopupMenuButton<int>(
          onSelected: (value) {
            if (value == 1) {
              context.read<AuthBloc>().add(LogoutUser());
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => OnboardingScreen()),
              );
            }
          },
          offset: const Offset(0, 35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white,
          itemBuilder:
              (context) => [
                PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: const [
                      Icon(Icons.logout, color: Colors.black54),
                      SizedBox(width: 8),
                      Text('Cerrar sesión'),
                    ],
                  ),
                ),
              ],
          child: CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage('https://i.pravatar.cc/50'),
          ),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.notifications_none, color: Colors.white),
        const SizedBox(width: 8),
        const Icon(Icons.menu, color: Colors.white),
        const SizedBox(width: 8),
      ],
      toolbarHeight: 70,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      bottomNavigationBar: Container(
        height: 60,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(3, (index) {
            final isSelected = _currentIndex == index;
            return Expanded(
              child: GestureDetector(
                onTap: () => _onTabTapped(index),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 30,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? const Color(0xFF95C11F)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icons[index],
                        color: isSelected ? Colors.white : Colors.grey,
                      ),
                      Text(
                        labels[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
      body: _pages[_currentIndex],
      /*body: BlocConsumer<AuthBloc, AuthState>(
        builder: (context, state) {
          return Container(color: Colors.black);
        },
        listener: (BuildContext context, AuthState state) {},
      ),
      */
    );
  }
}

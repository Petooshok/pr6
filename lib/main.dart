import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import 'pages/manga_selected.dart';
import 'pages/authorization.dart';
import 'pages/cart_page.dart'; // Импортируем страницу корзины
import 'providers/favorite_provider.dart';
import 'providers/cart_provider.dart'; // Импортируем CartProvider

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()), // Добавляем CartProvider
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MANgo100',
      theme: ThemeData(
        fontFamily: 'Russo One',
        scaffoldBackgroundColor: const Color.fromRGBO(45, 66, 99, 1),
        appBarTheme: const AppBarTheme(
          color: Color.fromRGBO(45, 66, 99, 1),
          iconTheme: IconThemeData(color: Color(0xFFECDBBA)),
          titleTextStyle: TextStyle(
            color: Color(0xFFECDBBA),
            fontFamily: 'Russo One',
            fontSize: 20,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color.fromRGBO(45, 66, 99, 1), // Темно-синий фон
          selectedItemColor: Color.fromRGBO(200, 75, 49, 1),
          unselectedItemColor: Color(0xFFECDBBA),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    MangaSelectedPage(),
    CartPage(), 
    Authorization(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final totalCartItems = cartProvider.cartItems.fold(0, (sum, item) => sum + cartProvider.getItemQuantity(item));

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(

        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
            backgroundColor: Color.fromRGBO(45, 66, 99, 1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Избранное',
            backgroundColor: Color.fromRGBO(45, 66, 99, 1),
          ),
          BottomNavigationBarItem(
              icon: Stack(
                alignment: Alignment.center, // Центрируем элементы
                children: [
                  Icon(Icons.shopping_cart), // Кнопка корзины
                  if (totalCartItems > 0)
                    Positioned(
                      left: 9,
                      bottom: 6.3, // Позиционируем по центру
                      child: Text(
                        '$totalCartItems',
                        style: TextStyle(
                          color: _selectedIndex == 2 ? const Color(0xFFECDBBA)   : const Color(0xFFC84B31), // Меняем цвет цифры
                          fontSize: 12, // Размер шрифта
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
              label: 'Корзина',
              backgroundColor: Color.fromRGBO(45, 66, 99, 1),
            ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Авторизация',
            backgroundColor: Color.fromRGBO(45, 66, 99, 1),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromRGBO(200, 75, 49, 1),
        unselectedItemColor: const Color(0xFFECDBBA),
        onTap: _onItemTapped,
      ),
    );
  }
}
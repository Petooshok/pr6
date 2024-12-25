import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/manga_item.dart';
import '../providers/favorite_provider.dart';
import '../providers/cart_provider.dart'; // Импортируем CartProvider

class MangaDetailsScreen extends StatelessWidget {
  final String title;
  final String price;
  final int index;
  final List<String> additionalImages;
  final String description;
  final String format;
  final String publisher;
  final String imagePath;
  final String chapters;
  final void Function() onDelete;

  const MangaDetailsScreen({
    Key? key,
    required this.title,
    required this.price,
    required this.index,
    required this.additionalImages,
    required this.description,
    required this.format,
    required this.publisher,
    required this.imagePath,
    required this.chapters,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 450;

    Future<void> _handleEscKey() async {
      if (ModalRoute.of(context)?.isCurrent == true) {
        Navigator.pop(context);
      }
    }

    SystemChannels.keyEvent.setMessageHandler((message) async {
      final keyMessage = message as Map<String, dynamic>?;
      if (keyMessage != null && keyMessage['type'] == 'keydown') {
        final keyCode = keyMessage['keyCode'];
        if (keyCode == 27) {
          await _handleEscKey();
        }
      }
      return null;
    });

    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context); // Добавляем CartProvider

    final mangaItem = MangaItem(
      imagePath: imagePath,
      title: title,
      description: description,
      price: price,
      additionalImages: additionalImages,
      format: format,
      publisher: publisher,
      shortDescription: "", // Если нужно, добавьте значение для этого поля
      chapters: chapters,
    );

    // Проверка, добавлена ли манга в избранное
    final isFavorite = favoriteProvider.isFavorite(mangaItem);

    // Проверка, добавлена ли манга в корзину
    final isInCart = cartProvider.cartItems.contains(mangaItem);

    return Scaffold(
      backgroundColor: const Color(0xFF2D4263),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 27, 20, 43),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'MAN ',
                      style: TextStyle(
                        fontFamily: 'RussoOne',
                        fontSize: isMobile ? 28.0 : 60.0,
                        color: const Color(0xFFECDBBA),
                      ),
                    ),
                    TextSpan(
                      text: 'go100',
                      style: TextStyle(
                        fontFamily: 'Tektur',
                        fontSize: isMobile ? 28.0 : 60.0,
                        color: const Color(0xFFECDBBA),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'RussoOne',
                  fontSize: isMobile ? 28.0 : 50.0,
                  color: const Color(0xFFECDBBA),
                ),
              ),
              const SizedBox(height: 50),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: Image.network(
                            imagePath,
                            width: isMobile ? 120 : 250,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 50),
                        Text(
                          format,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Tektur',
                            fontSize: isMobile ? 10.0 : 20.0,
                            color: const Color(0xFFECDBBA),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chapters,
                          style: TextStyle(
                            fontFamily: 'RussoOne',
                            fontSize: isMobile ? 16.0 : 28.0,
                            color: const Color(0xFFC84B31),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          description,
                          style: TextStyle(
                            fontFamily: 'RussoOne',
                            fontSize: isMobile ? 12.0 : 18.0,
                            color: const Color(0xFFECDBBA),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: additionalImages.map((image) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.network(
                                  image,
                                  width: isMobile ? 50 : 80,
                                  height: isMobile ? 50 : 80,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'Tektur',
                    fontSize: isMobile ? 12.0 : 16.0,
                    color: const Color(0xFFECDBBA),
                  ),
                  children: [
                    const TextSpan(
                      text: '\n\nПеревод выполнен профессионально, сохраняя дух оригинала.',
                    ),
                    const TextSpan(text: 'Издательство '),
                    TextSpan(
                      text: publisher,
                      style: TextStyle(
                        fontFamily: 'Tektur',
                        fontSize: isMobile ? 12.0 : 16.0,
                        color: const Color(0xFFC84B31),
                      ),
                    ),
                    const TextSpan(
                      text: ' уделяет внимание деталям при производстве книг, что делает каждое издание не только интересным для чтения, но и привлекательным для коллекционеров.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  _showDeleteConfirmationDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC84B31),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: isMobile ? 10 : 20, // Уменьшаем вертикальный отступ на мобильной версии
                  ),
                ),
                child: Text(
                  'Удалить',
                  style: TextStyle(
                    fontFamily: 'RussoOne',
                    fontSize: isMobile ? 14.0 : 20.0,
                    color: const Color(0xFFECDBBA),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: FloatingActionButton(
              onPressed: () {
                if (isInCart) {
                  cartProvider.removeFromCart(mangaItem);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$title удалено из корзины!'),
                    ),
                  );
                } else {
                  cartProvider.addToCart(mangaItem);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$title добавлено в корзину!'),
                    ),
                  );
                }
              },
              backgroundColor: const Color(0xFFC84B31),
              child: Icon(
                isInCart ? Icons.shopping_cart : Icons.add_shopping_cart,
                color: Colors.white,
                size: isMobile ? 20.0 : 28.0, // Уменьшаем размер иконки на мобильной версии
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              if (isFavorite) {
                favoriteProvider.removeFromFavorites(mangaItem);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$title удалено из избранного!'),
                  ),
                );
              } else {
                favoriteProvider.addToFavorites(mangaItem);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$title добавлено в избранное!'),
                  ),
                );
              }
            },
            backgroundColor: const Color(0xFFC84B31),
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
              size: isMobile ? 20.0 : 28.0, // Уменьшаем размер иконки на мобильной версии
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Подтверждение удаления'),
          content: const Text('Вы уверены, что хотите удалить этот товар?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop(); // Закрываем диалоговое окно
              },
            ),
            TextButton(
              child: const Text('Удалить'),
              onPressed: () {
                onDelete(); // Вызываем функцию удаления
                Navigator.of(context).pop(); // Закрываем диалоговое окно
                Navigator.pop(context); // Возвращаемся на предыдущий экран
                Navigator.pushReplacementNamed(context, '/home'); // Переходим на главное меню
              },
            ),
          ],
        );
      },
    );
  }
}
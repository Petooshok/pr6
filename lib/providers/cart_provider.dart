import 'package:flutter/material.dart';
import '../models/manga_item.dart';

class CartProvider with ChangeNotifier {
  List<MangaItem> _cartItems = [];
  Map<MangaItem, int> _itemQuantities = {};

  List<MangaItem> get cartItems => _cartItems;

  void addToCart(MangaItem item) {
    if (_cartItems.contains(item)) {
      _itemQuantities[item] = _itemQuantities[item]! + 1;
    } else {
      _cartItems.add(item);
      _itemQuantities[item] = 1;
    }
    notifyListeners();
  }

  void removeFromCart(MangaItem item) {
    _cartItems.remove(item);
    _itemQuantities.remove(item);
    notifyListeners();
  }

  void increaseQuantity(MangaItem item) {
    if (_cartItems.contains(item)) {
      _itemQuantities[item] = _itemQuantities[item]! + 1;
      notifyListeners();
    }
  }

  void decreaseQuantity(MangaItem item) {
    if (_cartItems.contains(item) && _itemQuantities[item]! > 1) {
      _itemQuantities[item] = _itemQuantities[item]! - 1;
      notifyListeners();
    }
  }

  int getItemQuantity(MangaItem item) {
    return _itemQuantities[item] ?? 0;
  }

  // Добавляем метод для очистки корзины
  void clearCart() {
    _cartItems.clear();
    _itemQuantities.clear(); // Очистим количество для каждого товара
    notifyListeners();
  }
}

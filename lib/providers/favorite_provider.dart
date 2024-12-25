import 'package:flutter/foundation.dart';
import '../models/manga_item.dart';

class FavoriteProvider with ChangeNotifier {
  List<MangaItem> _favoriteItems = [];

  List<MangaItem> get favoriteItems => _favoriteItems;

  void addToFavorites(MangaItem item) {
    if (!_favoriteItems.contains(item)) {
      _favoriteItems.add(item);
      notifyListeners();
    }
  }

  void removeFromFavorites(MangaItem item) {
    _favoriteItems.remove(item);
    notifyListeners();
  }

  bool isFavorite(MangaItem item) {
    return _favoriteItems.contains(item);
  }
}

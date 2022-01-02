class SortBy {
  final String _value;
  final String _name;

  const SortBy._(this._value, this._name);

  get value => _value;

  @override
  String toString() {
    return _name;
  }
}

const sortByDefault = SortBy._("", "默认");
const sortByNew = SortBy._("mr", "最新");
const sortByLike = SortBy._("tf", "心");
const sortByView = SortBy._("mv", "查看");
const sortByViewDay = SortBy._("mv_t", "日榜");
const sortByViewWeek = SortBy._("mv_w", "周榜");
const sortByViewMonth = SortBy._("mv_m", "月榜");

const sorts = [
  sortByDefault,
  sortByNew,
  sortByLike,
  sortByView,
  sortByViewDay,
  sortByViewWeek,
  sortByViewMonth,
];

class SearchPage {
  SearchPage({
    required this.searchQuery,
    required this.total,
  });

  late final String searchQuery;
  late final int total;

  SearchPage.fromJson(Map<String, dynamic> json) {
    searchQuery = json['search_query'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['search_query'] = searchQuery;
    _data['total'] = total;
    return _data;
  }
}

class ComicsResponse extends SearchPage {
  late final List<ComicSimple> content;

  ComicsResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    content =
        List.from(json['content']).map((e) => ComicSimple.fromJson(e)).toList();
  }

  @override
  Map<String, dynamic> toJson() {
    final _data = super.toJson();
    _data['content'] = content;
    return _data;
  }
}

class ComicSimple extends ComicBasic {
  ComicSimple({
    required int id,
    required String author,
    required String description,
    required String name,
    required String image,
    required this.category,
    required this.categorySub,
  }) : super(
            id: id,
            author: author,
            description: description,
            name: name,
            image: image);

  late final ComicSimpleCategory category;
  late final ComicSimpleCategory categorySub;

  ComicSimple.fromJson(Map<String, dynamic> json):super.fromJson(json) {
    category = ComicSimpleCategory.fromJson(json['category']);
    categorySub = ComicSimpleCategory.fromJson(json['category_sub']);
  }

  @override
  Map<String, dynamic> toJson() {
    final _data = super.toJson();
    _data['category'] = category.toJson();
    _data['category_sub'] = categorySub.toJson();
    return _data;
  }
}

class ComicSimpleCategory {
  ComicSimpleCategory({
    this.id,
    this.title,
  });

  late final String? id;
  late final String? title;

  ComicSimpleCategory.fromJson(Map<String, dynamic> json) {
    id = null;
    title = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    return _data;
  }
}

class CategoriesResponse {
  CategoriesResponse({
    required this.categories,
    required this.blocks,
  });

  late final List<Categories> categories;
  late final List<Blocks> blocks;

  CategoriesResponse.fromJson(Map<String, dynamic> json) {
    categories = List.from(json['categories'])
        .map((e) => Categories.fromJson(e))
        .toList();
    blocks = List.from(json['blocks']).map((e) => Blocks.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['categories'] = categories.map((e) => e.toJson()).toList();
    _data['blocks'] = blocks.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Categories {
  Categories({
    required this.id,
    required this.name,
    required this.slug,
    required this.totalAlbums,
    this.type,
  });

  late final int id;
  late final String name;
  late final String slug;
  late final int totalAlbums;
  late final String? type;

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    totalAlbums = json['total_albums'];
    type = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['slug'] = slug;
    _data['total_albums'] = totalAlbums;
    _data['type'] = type;
    return _data;
  }
}

class Blocks {
  Blocks({
    required this.title,
    required this.content,
  });

  late final String title;
  late final List<String> content;

  Blocks.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    content = List.castFrom<dynamic, String>(json['content']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['content'] = content;
    return _data;
  }
}

class AlbumResponse {
  AlbumResponse({
    required this.id,
    required this.name,
    required this.author,
    required this.images,
    required this.description,
    required this.totalViews,
    required this.likes,
    required this.series,
    required this.seriesId,
    required this.commentTotal,
    required this.tags,
    required this.works,
    required this.relatedList,
    required this.liked,
    required this.isFavorite,
  });

  late final int id;
  late final String name;
  late final List<String> author;
  late final List<String> images;
  late final String description;
  late final int totalViews;
  late final int likes;
  late final List<Series> series;
  late final int seriesId;
  late final int commentTotal;
  late final List<String> tags;
  late final List<String> works;
  late final List<ComicBasic> relatedList;
  late final bool liked;
  late final bool isFavorite;

  AlbumResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    author = List.castFrom<dynamic, String>(json['author']);
    images = List.castFrom<dynamic, String>(json['images']);
    description = json['description'];
    totalViews = json['total_views'];
    likes = json['likes'];
    series = List.from(json['series']).map((e) => Series.fromJson(e)).toList();
    seriesId = json['series_id'];
    commentTotal = json['comment_total'];
    tags = List.castFrom<dynamic, String>(json['tags']);
    works = List.castFrom<dynamic, String>(json['works']);
    relatedList = List.from(json['related_list'])
        .map((e) => ComicBasic.fromJson(e))
        .toList();
    liked = json['liked'];
    isFavorite = json['is_favorite'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['author'] = author;
    _data['images'] = images;
    _data['description'] = description;
    _data['total_views'] = totalViews;
    _data['likes'] = likes;
    _data['series'] = series.map((e) => e.toJson()).toList();
    _data['series_id'] = seriesId;
    _data['comment_total'] = commentTotal;
    _data['tags'] = tags;
    _data['works'] = works;
    _data['related_list'] = relatedList.map((e) => e.toJson()).toList();
    _data['liked'] = liked;
    _data['is_favorite'] = isFavorite;
    return _data;
  }
}

class Series {
  Series({
    required this.id,
    required this.name,
    required this.sort,
  });

  late final int id;
  late final String name;
  late final String sort;

  Series.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['sort'] = sort;
    return _data;
  }
}

class ComicBasic {
  ComicBasic({
    required this.id,
    required this.author,
    required this.description,
    required this.name,
    required this.image,
  });

  late final int id;
  late final String author;
  late final String description;
  late final String name;
  late final String image;

  ComicBasic.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    author = json['author'];
    description = json['description'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['author'] = author;
    _data['description'] = description;
    _data['name'] = name;
    _data['image'] = image;
    return _data;
  }
}

class ChapterResponse {
  ChapterResponse({
    required this.id,
    required this.series,
    required this.tags,
    required this.name,
    required this.images,
    required this.seriesId,
    required this.isFavorite,
    required this.liked,
  });
  late final int id;
  late final List<Series> series;
  late final String tags;
  late final String name;
  late final List<String> images;
  late final String seriesId;
  late final bool isFavorite;
  late final bool liked;

  ChapterResponse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    series = List.from(json['series']).map((e)=>Series.fromJson(e)).toList();
    tags = json['tags'];
    name = json['name'];
    images = List.castFrom<dynamic, String>(json['images']);
    seriesId = json['series_id'];
    isFavorite = json['is_favorite'];
    liked = json['liked'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['series'] = series.map((e)=>e.toJson()).toList();
    _data['tags'] = tags;
    _data['name'] = name;
    _data['images'] = images;
    _data['series_id'] = seriesId;
    _data['is_favorite'] = isFavorite;
    _data['liked'] = liked;
    return _data;
  }
}

class ImageSize {
  ImageSize({
    required this.h,
    required this.w,
  });
  late final int h;
  late final int w;

  ImageSize.fromJson(Map<String, dynamic> json){
    h = json['h'];
    w = json['w'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['h'] = h;
    _data['w'] = w;
    return _data;
  }
}

import 'package:vendx/features/product/model/category.dart';
import 'package:vendx/features/product/model/price.dart';

class ProductModel {
  final int id;
  final String documentId;
  final String name;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime publishedAt;
  final String productStatus;
  final Price price;
  final List<Category> category;
  // final List<dynamic> ratings;
  final List<Tag> tags;
  final List<Image>? images;

  ProductModel({
    required this.id,
    required this.documentId,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.productStatus,
    required this.price,
    required this.category,
    // required this.ratings,
    required this.tags,
    this.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      documentId: json['documentId'],
      name: json['name'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      publishedAt: DateTime.parse(json['publishedAt']),
      productStatus: json['productStatus'],
      price: Price.fromJson(json['price']),
      category: List<Category>.from(
          json['category'].map((x) => Category.fromJson(x))),
      // ratings: List<dynamic>.from(json['ratings']),
      tags: List<Tag>.from(json['tags'].map((x) => Tag.fromJson(x))),
      images: json['images'] != null
          ? List<Image>.from(json['images'].map((x) => Image.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'name': name,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'publishedAt': publishedAt.toIso8601String(),
      'productStatus': productStatus,
      'price': price.toJson(),
      // 'category': category,
      // 'ratings': ratings,
      'tags': tags,
      'images': images,
    };
  }
}

class Tag {
  final int id;
  final String value;

  Tag({
    required this.id,
    required this.value,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      value: json['value'],
    );
  }
}

class Image {
  final int id;
  final String documentId;
  final String name;
  final String? alternativeText;
  final String? caption;
  final int width;
  final int height;
  final Formats formats;
  final String hash;
  final String ext;
  final String mime;
  final double size;
  final String url;
  final String? previewUrl;
  final String provider;
  final dynamic providerMetadata;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime publishedAt;

  Image({
    required this.id,
    required this.documentId,
    required this.name,
    this.alternativeText,
    this.caption,
    required this.width,
    required this.height,
    required this.formats,
    required this.hash,
    required this.ext,
    required this.mime,
    required this.size,
    required this.url,
    this.previewUrl,
    required this.provider,
    this.providerMetadata,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
  });

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      id: json['id'],
      documentId: json['documentId'],
      name: json['name'],
      alternativeText: json['alternativeText'],
      caption: json['caption'],
      width: json['width'],
      height: json['height'],
      formats: Formats.fromJson(json['formats']),
      hash: json['hash'],
      ext: json['ext'],
      mime: json['mime'],
      size: json['size'].toDouble(),
      url: json['url'],
      previewUrl: json['previewUrl'],
      provider: json['provider'],
      providerMetadata: json['provider_metadata'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      publishedAt: DateTime.parse(json['publishedAt']),
    );
  }
}

class Formats {
  final Format? thumbnail;
  final Format? small;
  final Format? medium;
  final Format? large;

  Formats({
    this.thumbnail,
    this.small,
    this.medium,
    this.large,
  });

  factory Formats.fromJson(Map<String, dynamic> json) {
    return Formats(
      thumbnail:
          json['thumbnail'] != null ? Format.fromJson(json['thumbnail']) : null,
      small: json['small'] != null ? Format.fromJson(json['small']) : null,
      medium: json['medium'] != null ? Format.fromJson(json['medium']) : null,
      large: json['large'] != null ? Format.fromJson(json['large']) : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'thumbnail': thumbnail,
      'small': small,
      'medium': medium,
      'large': large,
    };
  }
}

class Format {
  final String ext;
  final String url;
  final String hash;
  final String mime;
  final String name;
  final dynamic path;
  final double size;
  final int width;
  final int height;
  final int sizeInBytes;

  Format({
    required this.ext,
    required this.url,
    required this.hash,
    required this.mime,
    required this.name,
    this.path,
    required this.size,
    required this.width,
    required this.height,
    required this.sizeInBytes,
  });

  factory Format.fromJson(Map<String, dynamic> json) {
    return Format(
      ext: json['ext'],
      url: json['url'],
      hash: json['hash'],
      mime: json['mime'],
      name: json['name'],
      path: json['path'],
      size: json['size'].toDouble(),
      width: json['width'],
      height: json['height'],
      sizeInBytes: json['sizeInBytes'],
    );
  }
}

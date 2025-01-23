// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductImpl _$$ProductImplFromJson(Map<String, dynamic> json) =>
    _$ProductImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      img: json['img'] as String,
      category: json['category'] as String,
      asp: json['asp'] as bool,
      defaultPrice: (json['defaultPrice'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$ProductImplToJson(_$ProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'description': instance.description,
      'img': instance.img,
      'category': instance.category,
      'asp': instance.asp,
      'defaultPrice': instance.defaultPrice,
    };

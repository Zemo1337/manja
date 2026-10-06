// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $RecipesTable extends Recipes with TableInfo<$RecipesTable, Recipe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _portionsMeta = const VerificationMeta(
    'portions',
  );
  @override
  late final GeneratedColumn<int> portions = GeneratedColumn<int>(
    'portions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _prepMinutesMeta = const VerificationMeta(
    'prepMinutes',
  );
  @override
  late final GeneratedColumn<int> prepMinutes = GeneratedColumn<int>(
    'prep_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cookMinutesMeta = const VerificationMeta(
    'cookMinutes',
  );
  @override
  late final GeneratedColumn<int> cookMinutes = GeneratedColumn<int>(
    'cook_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cookingInfoMeta = const VerificationMeta(
    'cookingInfo',
  );
  @override
  late final GeneratedColumn<String> cookingInfo = GeneratedColumn<String>(
    'cooking_info',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _finishedWeightGMeta = const VerificationMeta(
    'finishedWeightG',
  );
  @override
  late final GeneratedColumn<double> finishedWeightG = GeneratedColumn<double>(
    'finished_weight_g',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    portions,
    prepMinutes,
    cookMinutes,
    cookingInfo,
    isFavorite,
    createdAt,
    photoPath,
    finishedWeightG,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Recipe> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('portions')) {
      context.handle(
        _portionsMeta,
        portions.isAcceptableOrUnknown(data['portions']!, _portionsMeta),
      );
    }
    if (data.containsKey('prep_minutes')) {
      context.handle(
        _prepMinutesMeta,
        prepMinutes.isAcceptableOrUnknown(
          data['prep_minutes']!,
          _prepMinutesMeta,
        ),
      );
    }
    if (data.containsKey('cook_minutes')) {
      context.handle(
        _cookMinutesMeta,
        cookMinutes.isAcceptableOrUnknown(
          data['cook_minutes']!,
          _cookMinutesMeta,
        ),
      );
    }
    if (data.containsKey('cooking_info')) {
      context.handle(
        _cookingInfoMeta,
        cookingInfo.isAcceptableOrUnknown(
          data['cooking_info']!,
          _cookingInfoMeta,
        ),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('finished_weight_g')) {
      context.handle(
        _finishedWeightGMeta,
        finishedWeightG.isAcceptableOrUnknown(
          data['finished_weight_g']!,
          _finishedWeightGMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Recipe map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Recipe(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      portions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}portions'],
      )!,
      prepMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prep_minutes'],
      ),
      cookMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cook_minutes'],
      ),
      cookingInfo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cooking_info'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      finishedWeightG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}finished_weight_g'],
      ),
    );
  }

  @override
  $RecipesTable createAlias(String alias) {
    return $RecipesTable(attachedDatabase, alias);
  }
}

class Recipe extends DataClass implements Insertable<Recipe> {
  final int id;
  final String name;
  final int portions;
  final int? prepMinutes;
  final int? cookMinutes;
  final String cookingInfo;
  final bool isFavorite;
  final DateTime createdAt;
  final String? photoPath;
  final double? finishedWeightG;
  const Recipe({
    required this.id,
    required this.name,
    required this.portions,
    this.prepMinutes,
    this.cookMinutes,
    required this.cookingInfo,
    required this.isFavorite,
    required this.createdAt,
    this.photoPath,
    this.finishedWeightG,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['portions'] = Variable<int>(portions);
    if (!nullToAbsent || prepMinutes != null) {
      map['prep_minutes'] = Variable<int>(prepMinutes);
    }
    if (!nullToAbsent || cookMinutes != null) {
      map['cook_minutes'] = Variable<int>(cookMinutes);
    }
    map['cooking_info'] = Variable<String>(cookingInfo);
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || finishedWeightG != null) {
      map['finished_weight_g'] = Variable<double>(finishedWeightG);
    }
    return map;
  }

  RecipesCompanion toCompanion(bool nullToAbsent) {
    return RecipesCompanion(
      id: Value(id),
      name: Value(name),
      portions: Value(portions),
      prepMinutes: prepMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(prepMinutes),
      cookMinutes: cookMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(cookMinutes),
      cookingInfo: Value(cookingInfo),
      isFavorite: Value(isFavorite),
      createdAt: Value(createdAt),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      finishedWeightG: finishedWeightG == null && nullToAbsent
          ? const Value.absent()
          : Value(finishedWeightG),
    );
  }

  factory Recipe.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Recipe(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      portions: serializer.fromJson<int>(json['portions']),
      prepMinutes: serializer.fromJson<int?>(json['prepMinutes']),
      cookMinutes: serializer.fromJson<int?>(json['cookMinutes']),
      cookingInfo: serializer.fromJson<String>(json['cookingInfo']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      finishedWeightG: serializer.fromJson<double?>(json['finishedWeightG']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'portions': serializer.toJson<int>(portions),
      'prepMinutes': serializer.toJson<int?>(prepMinutes),
      'cookMinutes': serializer.toJson<int?>(cookMinutes),
      'cookingInfo': serializer.toJson<String>(cookingInfo),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'photoPath': serializer.toJson<String?>(photoPath),
      'finishedWeightG': serializer.toJson<double?>(finishedWeightG),
    };
  }

  Recipe copyWith({
    int? id,
    String? name,
    int? portions,
    Value<int?> prepMinutes = const Value.absent(),
    Value<int?> cookMinutes = const Value.absent(),
    String? cookingInfo,
    bool? isFavorite,
    DateTime? createdAt,
    Value<String?> photoPath = const Value.absent(),
    Value<double?> finishedWeightG = const Value.absent(),
  }) => Recipe(
    id: id ?? this.id,
    name: name ?? this.name,
    portions: portions ?? this.portions,
    prepMinutes: prepMinutes.present ? prepMinutes.value : this.prepMinutes,
    cookMinutes: cookMinutes.present ? cookMinutes.value : this.cookMinutes,
    cookingInfo: cookingInfo ?? this.cookingInfo,
    isFavorite: isFavorite ?? this.isFavorite,
    createdAt: createdAt ?? this.createdAt,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    finishedWeightG: finishedWeightG.present
        ? finishedWeightG.value
        : this.finishedWeightG,
  );
  Recipe copyWithCompanion(RecipesCompanion data) {
    return Recipe(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      portions: data.portions.present ? data.portions.value : this.portions,
      prepMinutes: data.prepMinutes.present
          ? data.prepMinutes.value
          : this.prepMinutes,
      cookMinutes: data.cookMinutes.present
          ? data.cookMinutes.value
          : this.cookMinutes,
      cookingInfo: data.cookingInfo.present
          ? data.cookingInfo.value
          : this.cookingInfo,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      finishedWeightG: data.finishedWeightG.present
          ? data.finishedWeightG.value
          : this.finishedWeightG,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Recipe(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('portions: $portions, ')
          ..write('prepMinutes: $prepMinutes, ')
          ..write('cookMinutes: $cookMinutes, ')
          ..write('cookingInfo: $cookingInfo, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('createdAt: $createdAt, ')
          ..write('photoPath: $photoPath, ')
          ..write('finishedWeightG: $finishedWeightG')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    portions,
    prepMinutes,
    cookMinutes,
    cookingInfo,
    isFavorite,
    createdAt,
    photoPath,
    finishedWeightG,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Recipe &&
          other.id == this.id &&
          other.name == this.name &&
          other.portions == this.portions &&
          other.prepMinutes == this.prepMinutes &&
          other.cookMinutes == this.cookMinutes &&
          other.cookingInfo == this.cookingInfo &&
          other.isFavorite == this.isFavorite &&
          other.createdAt == this.createdAt &&
          other.photoPath == this.photoPath &&
          other.finishedWeightG == this.finishedWeightG);
}

class RecipesCompanion extends UpdateCompanion<Recipe> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> portions;
  final Value<int?> prepMinutes;
  final Value<int?> cookMinutes;
  final Value<String> cookingInfo;
  final Value<bool> isFavorite;
  final Value<DateTime> createdAt;
  final Value<String?> photoPath;
  final Value<double?> finishedWeightG;
  const RecipesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.portions = const Value.absent(),
    this.prepMinutes = const Value.absent(),
    this.cookMinutes = const Value.absent(),
    this.cookingInfo = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.finishedWeightG = const Value.absent(),
  });
  RecipesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.portions = const Value.absent(),
    this.prepMinutes = const Value.absent(),
    this.cookMinutes = const Value.absent(),
    this.cookingInfo = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.finishedWeightG = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Recipe> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? portions,
    Expression<int>? prepMinutes,
    Expression<int>? cookMinutes,
    Expression<String>? cookingInfo,
    Expression<bool>? isFavorite,
    Expression<DateTime>? createdAt,
    Expression<String>? photoPath,
    Expression<double>? finishedWeightG,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (portions != null) 'portions': portions,
      if (prepMinutes != null) 'prep_minutes': prepMinutes,
      if (cookMinutes != null) 'cook_minutes': cookMinutes,
      if (cookingInfo != null) 'cooking_info': cookingInfo,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (createdAt != null) 'created_at': createdAt,
      if (photoPath != null) 'photo_path': photoPath,
      if (finishedWeightG != null) 'finished_weight_g': finishedWeightG,
    });
  }

  RecipesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? portions,
    Value<int?>? prepMinutes,
    Value<int?>? cookMinutes,
    Value<String>? cookingInfo,
    Value<bool>? isFavorite,
    Value<DateTime>? createdAt,
    Value<String?>? photoPath,
    Value<double?>? finishedWeightG,
  }) {
    return RecipesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      portions: portions ?? this.portions,
      prepMinutes: prepMinutes ?? this.prepMinutes,
      cookMinutes: cookMinutes ?? this.cookMinutes,
      cookingInfo: cookingInfo ?? this.cookingInfo,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      photoPath: photoPath ?? this.photoPath,
      finishedWeightG: finishedWeightG ?? this.finishedWeightG,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (portions.present) {
      map['portions'] = Variable<int>(portions.value);
    }
    if (prepMinutes.present) {
      map['prep_minutes'] = Variable<int>(prepMinutes.value);
    }
    if (cookMinutes.present) {
      map['cook_minutes'] = Variable<int>(cookMinutes.value);
    }
    if (cookingInfo.present) {
      map['cooking_info'] = Variable<String>(cookingInfo.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (finishedWeightG.present) {
      map['finished_weight_g'] = Variable<double>(finishedWeightG.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('portions: $portions, ')
          ..write('prepMinutes: $prepMinutes, ')
          ..write('cookMinutes: $cookMinutes, ')
          ..write('cookingInfo: $cookingInfo, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('createdAt: $createdAt, ')
          ..write('photoPath: $photoPath, ')
          ..write('finishedWeightG: $finishedWeightG')
          ..write(')'))
        .toString();
  }
}

class $RecipeIngredientsTable extends RecipeIngredients
    with TableInfo<$RecipeIngredientsTable, RecipeIngredient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipeIngredientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<int> recipeId = GeneratedColumn<int>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recipes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _foodKeyMeta = const VerificationMeta(
    'foodKey',
  );
  @override
  late final GeneratedColumn<String> foodKey = GeneratedColumn<String>(
    'food_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recipeId,
    position,
    name,
    amount,
    unit,
    foodKey,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_ingredients';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecipeIngredient> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('food_key')) {
      context.handle(
        _foodKeyMeta,
        foodKey.isAcceptableOrUnknown(data['food_key']!, _foodKeyMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipeIngredient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeIngredient(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recipe_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      foodKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_key'],
      ),
    );
  }

  @override
  $RecipeIngredientsTable createAlias(String alias) {
    return $RecipeIngredientsTable(attachedDatabase, alias);
  }
}

class RecipeIngredient extends DataClass
    implements Insertable<RecipeIngredient> {
  final int id;
  final int recipeId;
  final int position;
  final String name;
  final double amount;
  final String unit;
  final String? foodKey;
  const RecipeIngredient({
    required this.id,
    required this.recipeId,
    required this.position,
    required this.name,
    required this.amount,
    required this.unit,
    this.foodKey,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['recipe_id'] = Variable<int>(recipeId);
    map['position'] = Variable<int>(position);
    map['name'] = Variable<String>(name);
    map['amount'] = Variable<double>(amount);
    map['unit'] = Variable<String>(unit);
    if (!nullToAbsent || foodKey != null) {
      map['food_key'] = Variable<String>(foodKey);
    }
    return map;
  }

  RecipeIngredientsCompanion toCompanion(bool nullToAbsent) {
    return RecipeIngredientsCompanion(
      id: Value(id),
      recipeId: Value(recipeId),
      position: Value(position),
      name: Value(name),
      amount: Value(amount),
      unit: Value(unit),
      foodKey: foodKey == null && nullToAbsent
          ? const Value.absent()
          : Value(foodKey),
    );
  }

  factory RecipeIngredient.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeIngredient(
      id: serializer.fromJson<int>(json['id']),
      recipeId: serializer.fromJson<int>(json['recipeId']),
      position: serializer.fromJson<int>(json['position']),
      name: serializer.fromJson<String>(json['name']),
      amount: serializer.fromJson<double>(json['amount']),
      unit: serializer.fromJson<String>(json['unit']),
      foodKey: serializer.fromJson<String?>(json['foodKey']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recipeId': serializer.toJson<int>(recipeId),
      'position': serializer.toJson<int>(position),
      'name': serializer.toJson<String>(name),
      'amount': serializer.toJson<double>(amount),
      'unit': serializer.toJson<String>(unit),
      'foodKey': serializer.toJson<String?>(foodKey),
    };
  }

  RecipeIngredient copyWith({
    int? id,
    int? recipeId,
    int? position,
    String? name,
    double? amount,
    String? unit,
    Value<String?> foodKey = const Value.absent(),
  }) => RecipeIngredient(
    id: id ?? this.id,
    recipeId: recipeId ?? this.recipeId,
    position: position ?? this.position,
    name: name ?? this.name,
    amount: amount ?? this.amount,
    unit: unit ?? this.unit,
    foodKey: foodKey.present ? foodKey.value : this.foodKey,
  );
  RecipeIngredient copyWithCompanion(RecipeIngredientsCompanion data) {
    return RecipeIngredient(
      id: data.id.present ? data.id.value : this.id,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      position: data.position.present ? data.position.value : this.position,
      name: data.name.present ? data.name.value : this.name,
      amount: data.amount.present ? data.amount.value : this.amount,
      unit: data.unit.present ? data.unit.value : this.unit,
      foodKey: data.foodKey.present ? data.foodKey.value : this.foodKey,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeIngredient(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('position: $position, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('foodKey: $foodKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, recipeId, position, name, amount, unit, foodKey);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeIngredient &&
          other.id == this.id &&
          other.recipeId == this.recipeId &&
          other.position == this.position &&
          other.name == this.name &&
          other.amount == this.amount &&
          other.unit == this.unit &&
          other.foodKey == this.foodKey);
}

class RecipeIngredientsCompanion extends UpdateCompanion<RecipeIngredient> {
  final Value<int> id;
  final Value<int> recipeId;
  final Value<int> position;
  final Value<String> name;
  final Value<double> amount;
  final Value<String> unit;
  final Value<String?> foodKey;
  const RecipeIngredientsCompanion({
    this.id = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.position = const Value.absent(),
    this.name = const Value.absent(),
    this.amount = const Value.absent(),
    this.unit = const Value.absent(),
    this.foodKey = const Value.absent(),
  });
  RecipeIngredientsCompanion.insert({
    this.id = const Value.absent(),
    required int recipeId,
    required int position,
    required String name,
    required double amount,
    required String unit,
    this.foodKey = const Value.absent(),
  }) : recipeId = Value(recipeId),
       position = Value(position),
       name = Value(name),
       amount = Value(amount),
       unit = Value(unit);
  static Insertable<RecipeIngredient> custom({
    Expression<int>? id,
    Expression<int>? recipeId,
    Expression<int>? position,
    Expression<String>? name,
    Expression<double>? amount,
    Expression<String>? unit,
    Expression<String>? foodKey,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      if (position != null) 'position': position,
      if (name != null) 'name': name,
      if (amount != null) 'amount': amount,
      if (unit != null) 'unit': unit,
      if (foodKey != null) 'food_key': foodKey,
    });
  }

  RecipeIngredientsCompanion copyWith({
    Value<int>? id,
    Value<int>? recipeId,
    Value<int>? position,
    Value<String>? name,
    Value<double>? amount,
    Value<String>? unit,
    Value<String?>? foodKey,
  }) {
    return RecipeIngredientsCompanion(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      position: position ?? this.position,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      foodKey: foodKey ?? this.foodKey,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<int>(recipeId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (foodKey.present) {
      map['food_key'] = Variable<String>(foodKey.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeIngredientsCompanion(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('position: $position, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('foodKey: $foodKey')
          ..write(')'))
        .toString();
  }
}

class $RecipeStepsTable extends RecipeSteps
    with TableInfo<$RecipeStepsTable, RecipeStep> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipeStepsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<int> recipeId = GeneratedColumn<int>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recipes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, recipeId, position, body];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_steps';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecipeStep> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipeStep map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeStep(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recipe_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
    );
  }

  @override
  $RecipeStepsTable createAlias(String alias) {
    return $RecipeStepsTable(attachedDatabase, alias);
  }
}

class RecipeStep extends DataClass implements Insertable<RecipeStep> {
  final int id;
  final int recipeId;
  final int position;
  final String body;
  const RecipeStep({
    required this.id,
    required this.recipeId,
    required this.position,
    required this.body,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['recipe_id'] = Variable<int>(recipeId);
    map['position'] = Variable<int>(position);
    map['body'] = Variable<String>(body);
    return map;
  }

  RecipeStepsCompanion toCompanion(bool nullToAbsent) {
    return RecipeStepsCompanion(
      id: Value(id),
      recipeId: Value(recipeId),
      position: Value(position),
      body: Value(body),
    );
  }

  factory RecipeStep.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeStep(
      id: serializer.fromJson<int>(json['id']),
      recipeId: serializer.fromJson<int>(json['recipeId']),
      position: serializer.fromJson<int>(json['position']),
      body: serializer.fromJson<String>(json['body']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recipeId': serializer.toJson<int>(recipeId),
      'position': serializer.toJson<int>(position),
      'body': serializer.toJson<String>(body),
    };
  }

  RecipeStep copyWith({int? id, int? recipeId, int? position, String? body}) =>
      RecipeStep(
        id: id ?? this.id,
        recipeId: recipeId ?? this.recipeId,
        position: position ?? this.position,
        body: body ?? this.body,
      );
  RecipeStep copyWithCompanion(RecipeStepsCompanion data) {
    return RecipeStep(
      id: data.id.present ? data.id.value : this.id,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      position: data.position.present ? data.position.value : this.position,
      body: data.body.present ? data.body.value : this.body,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeStep(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('position: $position, ')
          ..write('body: $body')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, recipeId, position, body);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeStep &&
          other.id == this.id &&
          other.recipeId == this.recipeId &&
          other.position == this.position &&
          other.body == this.body);
}

class RecipeStepsCompanion extends UpdateCompanion<RecipeStep> {
  final Value<int> id;
  final Value<int> recipeId;
  final Value<int> position;
  final Value<String> body;
  const RecipeStepsCompanion({
    this.id = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.position = const Value.absent(),
    this.body = const Value.absent(),
  });
  RecipeStepsCompanion.insert({
    this.id = const Value.absent(),
    required int recipeId,
    required int position,
    required String body,
  }) : recipeId = Value(recipeId),
       position = Value(position),
       body = Value(body);
  static Insertable<RecipeStep> custom({
    Expression<int>? id,
    Expression<int>? recipeId,
    Expression<int>? position,
    Expression<String>? body,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      if (position != null) 'position': position,
      if (body != null) 'body': body,
    });
  }

  RecipeStepsCompanion copyWith({
    Value<int>? id,
    Value<int>? recipeId,
    Value<int>? position,
    Value<String>? body,
  }) {
    return RecipeStepsCompanion(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      position: position ?? this.position,
      body: body ?? this.body,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<int>(recipeId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeStepsCompanion(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('position: $position, ')
          ..write('body: $body')
          ..write(')'))
        .toString();
  }
}

class $MealLogsTable extends MealLogs with TableInfo<$MealLogsTable, MealLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<int> recipeId = GeneratedColumn<int>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recipes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _eatenAtMeta = const VerificationMeta(
    'eatenAt',
  );
  @override
  late final GeneratedColumn<DateTime> eatenAt = GeneratedColumn<DateTime>(
    'eaten_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, recipeId, eatenAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('eaten_at')) {
      context.handle(
        _eatenAtMeta,
        eatenAt.isAcceptableOrUnknown(data['eaten_at']!, _eatenAtMeta),
      );
    } else if (isInserting) {
      context.missing(_eatenAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recipe_id'],
      )!,
      eatenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}eaten_at'],
      )!,
    );
  }

  @override
  $MealLogsTable createAlias(String alias) {
    return $MealLogsTable(attachedDatabase, alias);
  }
}

class MealLog extends DataClass implements Insertable<MealLog> {
  final int id;
  final int recipeId;
  final DateTime eatenAt;
  const MealLog({
    required this.id,
    required this.recipeId,
    required this.eatenAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['recipe_id'] = Variable<int>(recipeId);
    map['eaten_at'] = Variable<DateTime>(eatenAt);
    return map;
  }

  MealLogsCompanion toCompanion(bool nullToAbsent) {
    return MealLogsCompanion(
      id: Value(id),
      recipeId: Value(recipeId),
      eatenAt: Value(eatenAt),
    );
  }

  factory MealLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealLog(
      id: serializer.fromJson<int>(json['id']),
      recipeId: serializer.fromJson<int>(json['recipeId']),
      eatenAt: serializer.fromJson<DateTime>(json['eatenAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recipeId': serializer.toJson<int>(recipeId),
      'eatenAt': serializer.toJson<DateTime>(eatenAt),
    };
  }

  MealLog copyWith({int? id, int? recipeId, DateTime? eatenAt}) => MealLog(
    id: id ?? this.id,
    recipeId: recipeId ?? this.recipeId,
    eatenAt: eatenAt ?? this.eatenAt,
  );
  MealLog copyWithCompanion(MealLogsCompanion data) {
    return MealLog(
      id: data.id.present ? data.id.value : this.id,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      eatenAt: data.eatenAt.present ? data.eatenAt.value : this.eatenAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealLog(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('eatenAt: $eatenAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, recipeId, eatenAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealLog &&
          other.id == this.id &&
          other.recipeId == this.recipeId &&
          other.eatenAt == this.eatenAt);
}

class MealLogsCompanion extends UpdateCompanion<MealLog> {
  final Value<int> id;
  final Value<int> recipeId;
  final Value<DateTime> eatenAt;
  const MealLogsCompanion({
    this.id = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.eatenAt = const Value.absent(),
  });
  MealLogsCompanion.insert({
    this.id = const Value.absent(),
    required int recipeId,
    required DateTime eatenAt,
  }) : recipeId = Value(recipeId),
       eatenAt = Value(eatenAt);
  static Insertable<MealLog> custom({
    Expression<int>? id,
    Expression<int>? recipeId,
    Expression<DateTime>? eatenAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      if (eatenAt != null) 'eaten_at': eatenAt,
    });
  }

  MealLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? recipeId,
    Value<DateTime>? eatenAt,
  }) {
    return MealLogsCompanion(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      eatenAt: eatenAt ?? this.eatenAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<int>(recipeId.value);
    }
    if (eatenAt.present) {
      map['eaten_at'] = Variable<DateTime>(eatenAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealLogsCompanion(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('eatenAt: $eatenAt')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  const AppSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSetting copyWith({String? key, String? value}) =>
      AppSetting(key: key ?? this.key, value: value ?? this.value);
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FoodsTable extends Foods with TableInfo<$FoodsTable, FoodRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detailMeta = const VerificationMeta('detail');
  @override
  late final GeneratedColumn<String> detail = GeneratedColumn<String>(
    'detail',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nutrientsMeta = const VerificationMeta(
    'nutrients',
  );
  @override
  late final GeneratedColumn<String> nutrients = GeneratedColumn<String>(
    'nutrients',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _portionsMeta = const VerificationMeta(
    'portions',
  );
  @override
  late final GeneratedColumn<String> portions = GeneratedColumn<String>(
    'portions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _densityGPerMlMeta = const VerificationMeta(
    'densityGPerMl',
  );
  @override
  late final GeneratedColumn<double> densityGPerMl = GeneratedColumn<double>(
    'density_g_per_ml',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    key,
    source,
    sourceId,
    name,
    detail,
    nutrients,
    portions,
    densityGPerMl,
    fetchedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'foods';
  @override
  VerificationContext validateIntegrity(
    Insertable<FoodRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('detail')) {
      context.handle(
        _detailMeta,
        detail.isAcceptableOrUnknown(data['detail']!, _detailMeta),
      );
    }
    if (data.containsKey('nutrients')) {
      context.handle(
        _nutrientsMeta,
        nutrients.isAcceptableOrUnknown(data['nutrients']!, _nutrientsMeta),
      );
    } else if (isInserting) {
      context.missing(_nutrientsMeta);
    }
    if (data.containsKey('portions')) {
      context.handle(
        _portionsMeta,
        portions.isAcceptableOrUnknown(data['portions']!, _portionsMeta),
      );
    }
    if (data.containsKey('density_g_per_ml')) {
      context.handle(
        _densityGPerMlMeta,
        densityGPerMl.isAcceptableOrUnknown(
          data['density_g_per_ml']!,
          _densityGPerMlMeta,
        ),
      );
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  FoodRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoodRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      detail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detail'],
      ),
      nutrients: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nutrients'],
      )!,
      portions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}portions'],
      )!,
      densityGPerMl: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}density_g_per_ml'],
      ),
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
    );
  }

  @override
  $FoodsTable createAlias(String alias) {
    return $FoodsTable(attachedDatabase, alias);
  }
}

class FoodRow extends DataClass implements Insertable<FoodRow> {
  final String key;
  final String source;
  final String sourceId;
  final String name;
  final String? detail;
  final String nutrients;
  final String portions;
  final double? densityGPerMl;
  final DateTime fetchedAt;
  const FoodRow({
    required this.key,
    required this.source,
    required this.sourceId,
    required this.name,
    this.detail,
    required this.nutrients,
    required this.portions,
    this.densityGPerMl,
    required this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['source'] = Variable<String>(source);
    map['source_id'] = Variable<String>(sourceId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || detail != null) {
      map['detail'] = Variable<String>(detail);
    }
    map['nutrients'] = Variable<String>(nutrients);
    map['portions'] = Variable<String>(portions);
    if (!nullToAbsent || densityGPerMl != null) {
      map['density_g_per_ml'] = Variable<double>(densityGPerMl);
    }
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  FoodsCompanion toCompanion(bool nullToAbsent) {
    return FoodsCompanion(
      key: Value(key),
      source: Value(source),
      sourceId: Value(sourceId),
      name: Value(name),
      detail: detail == null && nullToAbsent
          ? const Value.absent()
          : Value(detail),
      nutrients: Value(nutrients),
      portions: Value(portions),
      densityGPerMl: densityGPerMl == null && nullToAbsent
          ? const Value.absent()
          : Value(densityGPerMl),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory FoodRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoodRow(
      key: serializer.fromJson<String>(json['key']),
      source: serializer.fromJson<String>(json['source']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      name: serializer.fromJson<String>(json['name']),
      detail: serializer.fromJson<String?>(json['detail']),
      nutrients: serializer.fromJson<String>(json['nutrients']),
      portions: serializer.fromJson<String>(json['portions']),
      densityGPerMl: serializer.fromJson<double?>(json['densityGPerMl']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'source': serializer.toJson<String>(source),
      'sourceId': serializer.toJson<String>(sourceId),
      'name': serializer.toJson<String>(name),
      'detail': serializer.toJson<String?>(detail),
      'nutrients': serializer.toJson<String>(nutrients),
      'portions': serializer.toJson<String>(portions),
      'densityGPerMl': serializer.toJson<double?>(densityGPerMl),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  FoodRow copyWith({
    String? key,
    String? source,
    String? sourceId,
    String? name,
    Value<String?> detail = const Value.absent(),
    String? nutrients,
    String? portions,
    Value<double?> densityGPerMl = const Value.absent(),
    DateTime? fetchedAt,
  }) => FoodRow(
    key: key ?? this.key,
    source: source ?? this.source,
    sourceId: sourceId ?? this.sourceId,
    name: name ?? this.name,
    detail: detail.present ? detail.value : this.detail,
    nutrients: nutrients ?? this.nutrients,
    portions: portions ?? this.portions,
    densityGPerMl: densityGPerMl.present
        ? densityGPerMl.value
        : this.densityGPerMl,
    fetchedAt: fetchedAt ?? this.fetchedAt,
  );
  FoodRow copyWithCompanion(FoodsCompanion data) {
    return FoodRow(
      key: data.key.present ? data.key.value : this.key,
      source: data.source.present ? data.source.value : this.source,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      name: data.name.present ? data.name.value : this.name,
      detail: data.detail.present ? data.detail.value : this.detail,
      nutrients: data.nutrients.present ? data.nutrients.value : this.nutrients,
      portions: data.portions.present ? data.portions.value : this.portions,
      densityGPerMl: data.densityGPerMl.present
          ? data.densityGPerMl.value
          : this.densityGPerMl,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FoodRow(')
          ..write('key: $key, ')
          ..write('source: $source, ')
          ..write('sourceId: $sourceId, ')
          ..write('name: $name, ')
          ..write('detail: $detail, ')
          ..write('nutrients: $nutrients, ')
          ..write('portions: $portions, ')
          ..write('densityGPerMl: $densityGPerMl, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    key,
    source,
    sourceId,
    name,
    detail,
    nutrients,
    portions,
    densityGPerMl,
    fetchedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FoodRow &&
          other.key == this.key &&
          other.source == this.source &&
          other.sourceId == this.sourceId &&
          other.name == this.name &&
          other.detail == this.detail &&
          other.nutrients == this.nutrients &&
          other.portions == this.portions &&
          other.densityGPerMl == this.densityGPerMl &&
          other.fetchedAt == this.fetchedAt);
}

class FoodsCompanion extends UpdateCompanion<FoodRow> {
  final Value<String> key;
  final Value<String> source;
  final Value<String> sourceId;
  final Value<String> name;
  final Value<String?> detail;
  final Value<String> nutrients;
  final Value<String> portions;
  final Value<double?> densityGPerMl;
  final Value<DateTime> fetchedAt;
  final Value<int> rowid;
  const FoodsCompanion({
    this.key = const Value.absent(),
    this.source = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.name = const Value.absent(),
    this.detail = const Value.absent(),
    this.nutrients = const Value.absent(),
    this.portions = const Value.absent(),
    this.densityGPerMl = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FoodsCompanion.insert({
    required String key,
    required String source,
    required String sourceId,
    required String name,
    this.detail = const Value.absent(),
    required String nutrients,
    this.portions = const Value.absent(),
    this.densityGPerMl = const Value.absent(),
    required DateTime fetchedAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       source = Value(source),
       sourceId = Value(sourceId),
       name = Value(name),
       nutrients = Value(nutrients),
       fetchedAt = Value(fetchedAt);
  static Insertable<FoodRow> custom({
    Expression<String>? key,
    Expression<String>? source,
    Expression<String>? sourceId,
    Expression<String>? name,
    Expression<String>? detail,
    Expression<String>? nutrients,
    Expression<String>? portions,
    Expression<double>? densityGPerMl,
    Expression<DateTime>? fetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (source != null) 'source': source,
      if (sourceId != null) 'source_id': sourceId,
      if (name != null) 'name': name,
      if (detail != null) 'detail': detail,
      if (nutrients != null) 'nutrients': nutrients,
      if (portions != null) 'portions': portions,
      if (densityGPerMl != null) 'density_g_per_ml': densityGPerMl,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FoodsCompanion copyWith({
    Value<String>? key,
    Value<String>? source,
    Value<String>? sourceId,
    Value<String>? name,
    Value<String?>? detail,
    Value<String>? nutrients,
    Value<String>? portions,
    Value<double?>? densityGPerMl,
    Value<DateTime>? fetchedAt,
    Value<int>? rowid,
  }) {
    return FoodsCompanion(
      key: key ?? this.key,
      source: source ?? this.source,
      sourceId: sourceId ?? this.sourceId,
      name: name ?? this.name,
      detail: detail ?? this.detail,
      nutrients: nutrients ?? this.nutrients,
      portions: portions ?? this.portions,
      densityGPerMl: densityGPerMl ?? this.densityGPerMl,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (detail.present) {
      map['detail'] = Variable<String>(detail.value);
    }
    if (nutrients.present) {
      map['nutrients'] = Variable<String>(nutrients.value);
    }
    if (portions.present) {
      map['portions'] = Variable<String>(portions.value);
    }
    if (densityGPerMl.present) {
      map['density_g_per_ml'] = Variable<double>(densityGPerMl.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodsCompanion(')
          ..write('key: $key, ')
          ..write('source: $source, ')
          ..write('sourceId: $sourceId, ')
          ..write('name: $name, ')
          ..write('detail: $detail, ')
          ..write('nutrients: $nutrients, ')
          ..write('portions: $portions, ')
          ..write('densityGPerMl: $densityGPerMl, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RecipesTable recipes = $RecipesTable(this);
  late final $RecipeIngredientsTable recipeIngredients =
      $RecipeIngredientsTable(this);
  late final $RecipeStepsTable recipeSteps = $RecipeStepsTable(this);
  late final $MealLogsTable mealLogs = $MealLogsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $FoodsTable foods = $FoodsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    recipes,
    recipeIngredients,
    recipeSteps,
    mealLogs,
    appSettings,
    foods,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'recipes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('recipe_ingredients', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'recipes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('recipe_steps', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'recipes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('meal_logs', kind: UpdateKind.delete)],
    ),
  ]);
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$RecipesTableCreateCompanionBuilder = RecipesCompanion Function({
  Value<int> id,
  required String name,
  Value<int> portions,
  Value<int?> prepMinutes,
  Value<int?> cookMinutes,
  Value<String> cookingInfo,
  Value<bool> isFavorite,
  Value<DateTime> createdAt,
  Value<String?> photoPath,
  Value<double?> finishedWeightG,
});
typedef $$RecipesTableUpdateCompanionBuilder = RecipesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int> portions,
  Value<int?> prepMinutes,
  Value<int?> cookMinutes,
  Value<String> cookingInfo,
  Value<bool> isFavorite,
  Value<DateTime> createdAt,
  Value<String?> photoPath,
  Value<double?> finishedWeightG,
});

final class $$RecipesTableReferences
    extends BaseReferences<_$AppDatabase, $RecipesTable, Recipe> {
  $$RecipesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RecipeIngredientsTable, List<RecipeIngredient>>
  _recipeIngredientsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.recipeIngredients,
        aliasName: 'recipes__id__recipe_ingredients__recipe_id',
      );

  $$RecipeIngredientsTableProcessedTableManager get recipeIngredientsRefs {
    final manager = $$RecipeIngredientsTableTableManager(
      $_db,
      $_db.recipeIngredients,
    ).filter((f) => f.recipeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _recipeIngredientsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RecipeStepsTable, List<RecipeStep>>
  _recipeStepsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.recipeSteps,
    aliasName: 'recipes__id__recipe_steps__recipe_id',
  );

  $$RecipeStepsTableProcessedTableManager get recipeStepsRefs {
    final manager = $$RecipeStepsTableTableManager(
      $_db,
      $_db.recipeSteps,
    ).filter((f) => f.recipeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_recipeStepsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MealLogsTable, List<MealLog>> _mealLogsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.mealLogs,
    aliasName: 'recipes__id__meal_logs__recipe_id',
  );

  $$MealLogsTableProcessedTableManager get mealLogsRefs {
    final manager = $$MealLogsTableTableManager(
      $_db,
      $_db.mealLogs,
    ).filter((f) => f.recipeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mealLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RecipesTableFilterComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get portions => $composableBuilder(
    column: $table.portions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get prepMinutes => $composableBuilder(
    column: $table.prepMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cookMinutes => $composableBuilder(
    column: $table.cookMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cookingInfo => $composableBuilder(
    column: $table.cookingInfo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get finishedWeightG => $composableBuilder(
    column: $table.finishedWeightG,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> recipeIngredientsRefs(
    Expression<bool> Function($$RecipeIngredientsTableFilterComposer f) f,
  ) {
    final $$RecipeIngredientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeIngredients,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeIngredientsTableFilterComposer(
            $db: $db,
            $table: $db.recipeIngredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recipeStepsRefs(
    Expression<bool> Function($$RecipeStepsTableFilterComposer f) f,
  ) {
    final $$RecipeStepsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeSteps,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeStepsTableFilterComposer(
            $db: $db,
            $table: $db.recipeSteps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> mealLogsRefs(
    Expression<bool> Function($$MealLogsTableFilterComposer f) f,
  ) {
    final $$MealLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealLogs,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealLogsTableFilterComposer(
            $db: $db,
            $table: $db.mealLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecipesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get portions => $composableBuilder(
    column: $table.portions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get prepMinutes => $composableBuilder(
    column: $table.prepMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cookMinutes => $composableBuilder(
    column: $table.cookMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cookingInfo => $composableBuilder(
    column: $table.cookingInfo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get finishedWeightG => $composableBuilder(
    column: $table.finishedWeightG,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecipesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get portions =>
      $composableBuilder(column: $table.portions, builder: (column) => column);

  GeneratedColumn<int> get prepMinutes => $composableBuilder(
    column: $table.prepMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cookMinutes => $composableBuilder(
    column: $table.cookMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cookingInfo => $composableBuilder(
    column: $table.cookingInfo,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<double> get finishedWeightG => $composableBuilder(
    column: $table.finishedWeightG,
    builder: (column) => column,
  );

  Expression<T> recipeIngredientsRefs<T extends Object>(
    Expression<T> Function($$RecipeIngredientsTableAnnotationComposer a) f,
  ) {
    final $$RecipeIngredientsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recipeIngredients,
          getReferencedColumn: (t) => t.recipeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecipeIngredientsTableAnnotationComposer(
                $db: $db,
                $table: $db.recipeIngredients,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> recipeStepsRefs<T extends Object>(
    Expression<T> Function($$RecipeStepsTableAnnotationComposer a) f,
  ) {
    final $$RecipeStepsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeSteps,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeStepsTableAnnotationComposer(
            $db: $db,
            $table: $db.recipeSteps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> mealLogsRefs<T extends Object>(
    Expression<T> Function($$MealLogsTableAnnotationComposer a) f,
  ) {
    final $$MealLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealLogs,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.mealLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecipesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipesTable,
          Recipe,
          $$RecipesTableFilterComposer,
          $$RecipesTableOrderingComposer,
          $$RecipesTableAnnotationComposer,
          $$RecipesTableCreateCompanionBuilder,
          $$RecipesTableUpdateCompanionBuilder,
          (Recipe, $$RecipesTableReferences),
          Recipe,
          PrefetchHooks Function({
            bool recipeIngredientsRefs,
            bool recipeStepsRefs,
            bool mealLogsRefs,
          })
        > {
  $$RecipesTableTableManager(_$AppDatabase db, $RecipesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> portions = const Value.absent(),
                Value<int?> prepMinutes = const Value.absent(),
                Value<int?> cookMinutes = const Value.absent(),
                Value<String> cookingInfo = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<double?> finishedWeightG = const Value.absent(),
              }) => RecipesCompanion(
                id: id,
                name: name,
                portions: portions,
                prepMinutes: prepMinutes,
                cookMinutes: cookMinutes,
                cookingInfo: cookingInfo,
                isFavorite: isFavorite,
                createdAt: createdAt,
                photoPath: photoPath,
                finishedWeightG: finishedWeightG,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int> portions = const Value.absent(),
                Value<int?> prepMinutes = const Value.absent(),
                Value<int?> cookMinutes = const Value.absent(),
                Value<String> cookingInfo = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<double?> finishedWeightG = const Value.absent(),
              }) => RecipesCompanion.insert(
                id: id,
                name: name,
                portions: portions,
                prepMinutes: prepMinutes,
                cookMinutes: cookMinutes,
                cookingInfo: cookingInfo,
                isFavorite: isFavorite,
                createdAt: createdAt,
                photoPath: photoPath,
                finishedWeightG: finishedWeightG,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecipesTable, Recipe>(table),
                  $$RecipesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                recipeIngredientsRefs = false,
                recipeStepsRefs = false,
                mealLogsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (recipeIngredientsRefs) db.recipeIngredients,
                    if (recipeStepsRefs) db.recipeSteps,
                    if (mealLogsRefs) db.mealLogs,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (recipeIngredientsRefs)
                        await $_getPrefetchedData<
                          Recipe,
                          $RecipesTable,
                          RecipeIngredient
                        >(
                          currentTable: table,
                          referencedTable: $$RecipesTableReferences
                              ._recipeIngredientsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RecipesTableReferences(
                                db,
                                table,
                                p0,
                              ).recipeIngredientsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recipeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (recipeStepsRefs)
                        await $_getPrefetchedData<
                          Recipe,
                          $RecipesTable,
                          RecipeStep
                        >(
                          currentTable: table,
                          referencedTable: $$RecipesTableReferences
                              ._recipeStepsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RecipesTableReferences(
                                db,
                                table,
                                p0,
                              ).recipeStepsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recipeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (mealLogsRefs)
                        await $_getPrefetchedData<
                          Recipe,
                          $RecipesTable,
                          MealLog
                        >(
                          currentTable: table,
                          referencedTable: $$RecipesTableReferences
                              ._mealLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RecipesTableReferences(
                                db,
                                table,
                                p0,
                              ).mealLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recipeId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RecipesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipesTable,
      Recipe,
      $$RecipesTableFilterComposer,
      $$RecipesTableOrderingComposer,
      $$RecipesTableAnnotationComposer,
      $$RecipesTableCreateCompanionBuilder,
      $$RecipesTableUpdateCompanionBuilder,
      (Recipe, $$RecipesTableReferences),
      Recipe,
      PrefetchHooks Function({
        bool recipeIngredientsRefs,
        bool recipeStepsRefs,
        bool mealLogsRefs,
      })
    >;
typedef $$RecipeIngredientsTableCreateCompanionBuilder =
    RecipeIngredientsCompanion Function({
      Value<int> id,
      required int recipeId,
      required int position,
      required String name,
      required double amount,
      required String unit,
      Value<String?> foodKey,
    });
typedef $$RecipeIngredientsTableUpdateCompanionBuilder =
    RecipeIngredientsCompanion Function({
      Value<int> id,
      Value<int> recipeId,
      Value<int> position,
      Value<String> name,
      Value<double> amount,
      Value<String> unit,
      Value<String?> foodKey,
    });

final class $$RecipeIngredientsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RecipeIngredientsTable,
          RecipeIngredient
        > {
  $$RecipeIngredientsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RecipesTable _recipeIdTable(_$AppDatabase db) =>
      db.recipes.createAlias('recipe_ingredients__recipe_id__recipes__id');

  $$RecipesTableProcessedTableManager get recipeId {
    final $_column = $_itemColumn<int>('recipe_id')!;

    final manager = $$RecipesTableTableManager(
      $_db,
      $_db.recipes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RecipeIngredientsTableFilterComposer
    extends Composer<_$AppDatabase, $RecipeIngredientsTable> {
  $$RecipeIngredientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foodKey => $composableBuilder(
    column: $table.foodKey,
    builder: (column) => ColumnFilters(column),
  );

  $$RecipesTableFilterComposer get recipeId {
    final $$RecipesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableFilterComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeIngredientsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipeIngredientsTable> {
  $$RecipeIngredientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foodKey => $composableBuilder(
    column: $table.foodKey,
    builder: (column) => ColumnOrderings(column),
  );

  $$RecipesTableOrderingComposer get recipeId {
    final $$RecipesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableOrderingComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeIngredientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipeIngredientsTable> {
  $$RecipeIngredientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get foodKey =>
      $composableBuilder(column: $table.foodKey, builder: (column) => column);

  $$RecipesTableAnnotationComposer get recipeId {
    final $$RecipesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableAnnotationComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeIngredientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipeIngredientsTable,
          RecipeIngredient,
          $$RecipeIngredientsTableFilterComposer,
          $$RecipeIngredientsTableOrderingComposer,
          $$RecipeIngredientsTableAnnotationComposer,
          $$RecipeIngredientsTableCreateCompanionBuilder,
          $$RecipeIngredientsTableUpdateCompanionBuilder,
          (RecipeIngredient, $$RecipeIngredientsTableReferences),
          RecipeIngredient,
          PrefetchHooks Function({bool recipeId})
        > {
  $$RecipeIngredientsTableTableManager(
    _$AppDatabase db,
    $RecipeIngredientsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipeIngredientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipeIngredientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipeIngredientsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> recipeId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String?> foodKey = const Value.absent(),
              }) => RecipeIngredientsCompanion(
                id: id,
                recipeId: recipeId,
                position: position,
                name: name,
                amount: amount,
                unit: unit,
                foodKey: foodKey,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int recipeId,
                required int position,
                required String name,
                required double amount,
                required String unit,
                Value<String?> foodKey = const Value.absent(),
              }) => RecipeIngredientsCompanion.insert(
                id: id,
                recipeId: recipeId,
                position: position,
                name: name,
                amount: amount,
                unit: unit,
                foodKey: foodKey,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecipeIngredientsTable, RecipeIngredient>(table),
                  $$RecipeIngredientsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({recipeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (recipeId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.recipeId,
                        referencedTable: $$RecipeIngredientsTableReferences
                            ._recipeIdTable(db),
                        referencedColumn: $$RecipeIngredientsTableReferences
                            ._recipeIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RecipeIngredientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipeIngredientsTable,
      RecipeIngredient,
      $$RecipeIngredientsTableFilterComposer,
      $$RecipeIngredientsTableOrderingComposer,
      $$RecipeIngredientsTableAnnotationComposer,
      $$RecipeIngredientsTableCreateCompanionBuilder,
      $$RecipeIngredientsTableUpdateCompanionBuilder,
      (RecipeIngredient, $$RecipeIngredientsTableReferences),
      RecipeIngredient,
      PrefetchHooks Function({bool recipeId})
    >;
typedef $$RecipeStepsTableCreateCompanionBuilder =
    RecipeStepsCompanion Function({
      Value<int> id,
      required int recipeId,
      required int position,
      required String body,
    });
typedef $$RecipeStepsTableUpdateCompanionBuilder =
    RecipeStepsCompanion Function({
      Value<int> id,
      Value<int> recipeId,
      Value<int> position,
      Value<String> body,
    });

final class $$RecipeStepsTableReferences
    extends BaseReferences<_$AppDatabase, $RecipeStepsTable, RecipeStep> {
  $$RecipeStepsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RecipesTable _recipeIdTable(_$AppDatabase db) =>
      db.recipes.createAlias('recipe_steps__recipe_id__recipes__id');

  $$RecipesTableProcessedTableManager get recipeId {
    final $_column = $_itemColumn<int>('recipe_id')!;

    final manager = $$RecipesTableTableManager(
      $_db,
      $_db.recipes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RecipeStepsTableFilterComposer
    extends Composer<_$AppDatabase, $RecipeStepsTable> {
  $$RecipeStepsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  $$RecipesTableFilterComposer get recipeId {
    final $$RecipesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableFilterComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeStepsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipeStepsTable> {
  $$RecipeStepsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  $$RecipesTableOrderingComposer get recipeId {
    final $$RecipesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableOrderingComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeStepsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipeStepsTable> {
  $$RecipeStepsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  $$RecipesTableAnnotationComposer get recipeId {
    final $$RecipesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableAnnotationComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeStepsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipeStepsTable,
          RecipeStep,
          $$RecipeStepsTableFilterComposer,
          $$RecipeStepsTableOrderingComposer,
          $$RecipeStepsTableAnnotationComposer,
          $$RecipeStepsTableCreateCompanionBuilder,
          $$RecipeStepsTableUpdateCompanionBuilder,
          (RecipeStep, $$RecipeStepsTableReferences),
          RecipeStep,
          PrefetchHooks Function({bool recipeId})
        > {
  $$RecipeStepsTableTableManager(_$AppDatabase db, $RecipeStepsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipeStepsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipeStepsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipeStepsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> recipeId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> body = const Value.absent(),
              }) => RecipeStepsCompanion(
                id: id,
                recipeId: recipeId,
                position: position,
                body: body,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int recipeId,
                required int position,
                required String body,
              }) => RecipeStepsCompanion.insert(
                id: id,
                recipeId: recipeId,
                position: position,
                body: body,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecipeStepsTable, RecipeStep>(table),
                  $$RecipeStepsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({recipeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (recipeId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.recipeId,
                        referencedTable: $$RecipeStepsTableReferences
                            ._recipeIdTable(db),
                        referencedColumn: $$RecipeStepsTableReferences
                            ._recipeIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RecipeStepsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipeStepsTable,
      RecipeStep,
      $$RecipeStepsTableFilterComposer,
      $$RecipeStepsTableOrderingComposer,
      $$RecipeStepsTableAnnotationComposer,
      $$RecipeStepsTableCreateCompanionBuilder,
      $$RecipeStepsTableUpdateCompanionBuilder,
      (RecipeStep, $$RecipeStepsTableReferences),
      RecipeStep,
      PrefetchHooks Function({bool recipeId})
    >;
typedef $$MealLogsTableCreateCompanionBuilder = MealLogsCompanion Function({
  Value<int> id,
  required int recipeId,
  required DateTime eatenAt,
});
typedef $$MealLogsTableUpdateCompanionBuilder = MealLogsCompanion Function({
  Value<int> id,
  Value<int> recipeId,
  Value<DateTime> eatenAt,
});

final class $$MealLogsTableReferences
    extends BaseReferences<_$AppDatabase, $MealLogsTable, MealLog> {
  $$MealLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RecipesTable _recipeIdTable(_$AppDatabase db) =>
      db.recipes.createAlias('meal_logs__recipe_id__recipes__id');

  $$RecipesTableProcessedTableManager get recipeId {
    final $_column = $_itemColumn<int>('recipe_id')!;

    final manager = $$RecipesTableTableManager(
      $_db,
      $_db.recipes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MealLogsTableFilterComposer
    extends Composer<_$AppDatabase, $MealLogsTable> {
  $$MealLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get eatenAt => $composableBuilder(
    column: $table.eatenAt,
    builder: (column) => ColumnFilters(column),
  );

  $$RecipesTableFilterComposer get recipeId {
    final $$RecipesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableFilterComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $MealLogsTable> {
  $$MealLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get eatenAt => $composableBuilder(
    column: $table.eatenAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$RecipesTableOrderingComposer get recipeId {
    final $$RecipesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableOrderingComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealLogsTable> {
  $$MealLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get eatenAt =>
      $composableBuilder(column: $table.eatenAt, builder: (column) => column);

  $$RecipesTableAnnotationComposer get recipeId {
    final $$RecipesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableAnnotationComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealLogsTable,
          MealLog,
          $$MealLogsTableFilterComposer,
          $$MealLogsTableOrderingComposer,
          $$MealLogsTableAnnotationComposer,
          $$MealLogsTableCreateCompanionBuilder,
          $$MealLogsTableUpdateCompanionBuilder,
          (MealLog, $$MealLogsTableReferences),
          MealLog,
          PrefetchHooks Function({bool recipeId})
        > {
  $$MealLogsTableTableManager(_$AppDatabase db, $MealLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> recipeId = const Value.absent(),
            Value<DateTime> eatenAt = const Value.absent(),
          }) => MealLogsCompanion(id: id, recipeId: recipeId, eatenAt: eatenAt),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int recipeId,
                required DateTime eatenAt,
              }) => MealLogsCompanion.insert(
                id: id,
                recipeId: recipeId,
                eatenAt: eatenAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MealLogsTable, MealLog>(table),
                  $$MealLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({recipeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (recipeId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.recipeId,
                        referencedTable: $$MealLogsTableReferences
                            ._recipeIdTable(db),
                        referencedColumn: $$MealLogsTableReferences
                            ._recipeIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MealLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealLogsTable,
      MealLog,
      $$MealLogsTableFilterComposer,
      $$MealLogsTableOrderingComposer,
      $$MealLogsTableAnnotationComposer,
      $$MealLogsTableCreateCompanionBuilder,
      $$MealLogsTableUpdateCompanionBuilder,
      (MealLog, $$MealLogsTableReferences),
      MealLog,
      PrefetchHooks Function({bool recipeId})
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, AppSetting>(table),
                  BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$FoodsTableCreateCompanionBuilder = FoodsCompanion Function({
  required String key,
  required String source,
  required String sourceId,
  required String name,
  Value<String?> detail,
  required String nutrients,
  Value<String> portions,
  Value<double?> densityGPerMl,
  required DateTime fetchedAt,
  Value<int> rowid,
});
typedef $$FoodsTableUpdateCompanionBuilder = FoodsCompanion Function({
  Value<String> key,
  Value<String> source,
  Value<String> sourceId,
  Value<String> name,
  Value<String?> detail,
  Value<String> nutrients,
  Value<String> portions,
  Value<double?> densityGPerMl,
  Value<DateTime> fetchedAt,
  Value<int> rowid,
});

class $$FoodsTableFilterComposer extends Composer<_$AppDatabase, $FoodsTable> {
  $$FoodsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detail => $composableBuilder(
    column: $table.detail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nutrients => $composableBuilder(
    column: $table.nutrients,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get portions => $composableBuilder(
    column: $table.portions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get densityGPerMl => $composableBuilder(
    column: $table.densityGPerMl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FoodsTableOrderingComposer
    extends Composer<_$AppDatabase, $FoodsTable> {
  $$FoodsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detail => $composableBuilder(
    column: $table.detail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nutrients => $composableBuilder(
    column: $table.nutrients,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get portions => $composableBuilder(
    column: $table.portions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get densityGPerMl => $composableBuilder(
    column: $table.densityGPerMl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FoodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoodsTable> {
  $$FoodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get detail =>
      $composableBuilder(column: $table.detail, builder: (column) => column);

  GeneratedColumn<String> get nutrients =>
      $composableBuilder(column: $table.nutrients, builder: (column) => column);

  GeneratedColumn<String> get portions =>
      $composableBuilder(column: $table.portions, builder: (column) => column);

  GeneratedColumn<double> get densityGPerMl => $composableBuilder(
    column: $table.densityGPerMl,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$FoodsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FoodsTable,
          FoodRow,
          $$FoodsTableFilterComposer,
          $$FoodsTableOrderingComposer,
          $$FoodsTableAnnotationComposer,
          $$FoodsTableCreateCompanionBuilder,
          $$FoodsTableUpdateCompanionBuilder,
          (FoodRow, BaseReferences<_$AppDatabase, $FoodsTable, FoodRow>),
          FoodRow,
          PrefetchHooks Function()
        > {
  $$FoodsTableTableManager(_$AppDatabase db, $FoodsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> detail = const Value.absent(),
                Value<String> nutrients = const Value.absent(),
                Value<String> portions = const Value.absent(),
                Value<double?> densityGPerMl = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FoodsCompanion(
                key: key,
                source: source,
                sourceId: sourceId,
                name: name,
                detail: detail,
                nutrients: nutrients,
                portions: portions,
                densityGPerMl: densityGPerMl,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String source,
                required String sourceId,
                required String name,
                Value<String?> detail = const Value.absent(),
                required String nutrients,
                Value<String> portions = const Value.absent(),
                Value<double?> densityGPerMl = const Value.absent(),
                required DateTime fetchedAt,
                Value<int> rowid = const Value.absent(),
              }) => FoodsCompanion.insert(
                key: key,
                source: source,
                sourceId: sourceId,
                name: name,
                detail: detail,
                nutrients: nutrients,
                portions: portions,
                densityGPerMl: densityGPerMl,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FoodsTable, FoodRow>(table),
                  BaseReferences<_$AppDatabase, $FoodsTable, FoodRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FoodsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FoodsTable,
      FoodRow,
      $$FoodsTableFilterComposer,
      $$FoodsTableOrderingComposer,
      $$FoodsTableAnnotationComposer,
      $$FoodsTableCreateCompanionBuilder,
      $$FoodsTableUpdateCompanionBuilder,
      (FoodRow, BaseReferences<_$AppDatabase, $FoodsTable, FoodRow>),
      FoodRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RecipesTableTableManager get recipes =>
      $$RecipesTableTableManager(_db, _db.recipes);
  $$RecipeIngredientsTableTableManager get recipeIngredients =>
      $$RecipeIngredientsTableTableManager(_db, _db.recipeIngredients);
  $$RecipeStepsTableTableManager get recipeSteps =>
      $$RecipeStepsTableTableManager(_db, _db.recipeSteps);
  $$MealLogsTableTableManager get mealLogs =>
      $$MealLogsTableTableManager(_db, _db.mealLogs);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$FoodsTableTableManager get foods =>
      $$FoodsTableTableManager(_db, _db.foods);
}

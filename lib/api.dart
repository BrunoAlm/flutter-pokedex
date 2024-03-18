import 'package:dio/dio.dart';

class PokeApiProvider {
  final int? count;
  final String? nextPage;
  final String? previousPage;
  final List<PokemonEntity>? results;
  final String url = 'https://pokeapi.co/api/v2/pokemon/';

  PokeApiProvider({
    this.count,
    this.nextPage,
    this.previousPage,
    this.results,
  });

  PokeApiProvider.fromJson(Map<String, dynamic> json)
      : count = json['count'],
        nextPage = json['next'],
        previousPage = json['previous'],
        results = List<PokemonEntity>.from(
          json['results'].map((v) => PokemonEntity.fromJson(v)),
        );

  final Dio _dio = Dio();

  Future<PokemonEntity?> getPokemon(String name) async {
    if (name.isEmpty) return null;
    var result = await _dio.get(url + name);
    if (result.statusCode == 200) {
      var pokemonData = PokemonEntity.fromJson(result.data);
      return pokemonData;
    }
    return null;
  }

  int getPokemonCount() {
    return count ?? 0;
  }
}

class PokemonEntity {
  final int id;
  final String name;
  final List<MoveEntity> moves;
  final SpritesEntity sprites;
  final List<TypesEntity> types;

  PokemonEntity({
    required this.id,
    required this.name,
    required this.moves,
    required this.sprites,
    required this.types,
  });

  PokemonEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        moves = (json['moves'] as List)
            .map((e) => MoveEntity.fromJson(e['move']))
            .toList(),
        sprites = SpritesEntity.fromJson(json['sprites']),
        types = (json['types'] as List)
            .map((e) => TypesEntity.fromJson(e['type']))
            .toList();
}

class MoveEntity {
  final String name;
  final String url;

  MoveEntity({
    required this.name,
    required this.url,
  });

  MoveEntity.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        url = json['url'];
}

class TypesEntity {
  final String name;
  final String url;

  TypesEntity({
    required this.name,
    required this.url,
  });

  TypesEntity.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        url = json['url'];
}

class SpritesEntity {
  final String frontDefault;
  SpritesEntity({required this.frontDefault});

  SpritesEntity.fromJson(Map<String, dynamic> json)
      : frontDefault = json['front_default'];
}

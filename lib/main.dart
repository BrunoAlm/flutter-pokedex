import 'package:flutter/material.dart';
import 'package:myapp/api.dart';

void main() {
  runApp(const AppWidget());
}

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PokeApiProvider _pokeApiProvider = PokeApiProvider();
  final TextEditingController _pokemonNameCt = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  'https://raw.githubusercontent.com/PokeAPI/media/master/logo/pokeapi_256.png',
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: _pokemonNameCt,
                    decoration: const InputDecoration(
                      hintText: 'Nome ou ID',
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                    ),
                    onEditingComplete: () => setState(() {}),
                  ),
                ),
                FutureBuilder(
                  future: _pokemonNameCt.text.isEmpty
                      ? null
                      : _pokeApiProvider.getPokemon(_pokemonNameCt.text),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    if (snapshot.hasData) {
                      var pokemon = snapshot.data!;
                      return Column(
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Text(
                                pokemon.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                pokemon.id.toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Image.network(
                            pokemon.sprites.frontDefault,
                            height: 200,
                          ),
                          Row(
                            children: List.generate(
                              pokemon.types.length,
                              (index) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Text(pokemon.types[index].name),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Habilidades',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 150,
                            child: ListView.builder(
                              itemCount: pokemon.moves.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) => Text(
                                pokemon.moves[index].name,
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
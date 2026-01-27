package com.example.pokedex

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.example.pokedex.model.Pokemon

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val recyclerView = findViewById<RecyclerView>(R.id.recyclerView)
        recyclerView.layoutManager = LinearLayoutManager(this)

        val pokemonList = listOf(
            Pokemon("Caterpie", "https://images.wikidexcdn.net/mwuploads/wikidex/7/74/latest/20220318232211/EP1191_Caterpie_de_Goh.png"),
            Pokemon("Larvitar", "https://static0.gamerantimages.com/wordpress/wp-content/uploads/2025/10/how-to-get-evolve-larvitar-in-pokemon-legends-z-a.jpg"),
            Pokemon("Nidorino", "https://static.wikia.nocookie.net/pokegengame/images/7/7a/Nidorino.png/revision/latest?cb=20140106191027"),
            Pokemon("Quilava", "https://w1.pngwing.com/pngs/864/693/png-transparent-flame-quilava-cyndaquil-typhlosion-video-games-playing-card-bird-beak.png"),
            Pokemon("Slugma", "https://kurapixel.com/wp-content/uploads/2024/10/0218Slugma-1.png"),
            Pokemon("Typhlosion", "https://static.pokemonpets.com/images/monsters-images-800-800/2157-Shiny-Typhlosion.webp")
        )

        val adapter = PokemonAdapter(pokemonList)
        recyclerView.adapter = adapter
    }
}

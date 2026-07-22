package com.example.myapplication

import android.os.Bundle
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import androidx.navigation.compose.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.ui.graphics.Color
import androidx.navigation.NavType
import androidx.navigation.navArgument
import com.example.myapplication.ui.theme.MyApplicationTheme
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import kotlin.system.exitProcess

data class Trip(
    val id: Int,
    val cost: Int,
    val people: Int,
    val startDate: Date,
    val endDate: Date,
    val destination: String
)

class MainActivity : ComponentActivity() {
    private val trips = mutableStateListOf(
        Trip(1, 300, 5, Date(2023 - 1900, 6, 15), Date(2023 - 1900, 6, 20), "Paris"),
        Trip(2, 150, 3, Date(2023 - 1900, 7, 10), Date(2023 - 1900, 7, 15), "New York"),
        Trip(3, 500, 8, Date(2023 - 1900, 8, 5), Date(2023 - 1900, 8, 12), "Tokyo")
    )

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            MyApplicationTheme {
                MyApp(trips)
            }
        }
    }
}

@Composable
fun MyApp(trips: MutableList<Trip>) {
    val navController = rememberNavController()

    NavHost(
        navController = navController,
        startDestination = "home"
    ) {
        composable("home") { HomeScreen(navController) }
        composable("read") { ReadScreen(navController,trips) }
        composable("create") { CreateScreen(navController,trips) }
        composable(
            "update/{tripId}",
            arguments = listOf(navArgument("tripId") { type = NavType.IntType })
        ) { backStackEntry ->
            val tripId = backStackEntry.arguments?.getInt("tripId")
            if (tripId != null) {
                UpdateScreen(navController, tripId, trips)
            }
        }
        composable(
            "delete/{tripId}",
            arguments = listOf(navArgument("tripId") { type = NavType.IntType })
        ) { backStackEntry ->
            val tripId = backStackEntry.arguments?.getInt("tripId")
            if (tripId != null) {
                DeleteScreen(navController, tripId,trips)
            }
        }
    }

}

@Composable
fun ReadScreen(navController: NavController, trips: List<Trip>) {
    Scaffold(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0xFF516199)),
    ) { innerPadding ->
        Column(
            modifier = Modifier
                .padding(innerPadding)
                .fillMaxSize()
                .padding(16.dp)
        ) {
            Text(text = "View Trips", style = MaterialTheme.typography.titleLarge)

            Spacer(modifier = Modifier.height(16.dp))

            Button(
                onClick = { navController.navigate("create") },
                modifier = Modifier.fillMaxWidth(),
                colors = ButtonDefaults.buttonColors(
                    containerColor = Color.Blue,
                    contentColor = Color.White)
            ) {
                Text(text = "Add Trip")
            }

            Spacer(modifier = Modifier.height(16.dp))

            LazyColumn(
                modifier = Modifier.fillMaxSize()

            ) {
                items(trips) { trip ->
                    TripItem(
                        trip = trip,
                        onEditClick = { navController.navigate("update/${trip.id}") },
                        onDeleteClick = { navController.navigate("delete/${trip.id}") }
                    )
                }
            }
        }
    }
}

@Composable
fun TripItem(trip: Trip, onEditClick: (Trip) -> Unit, onDeleteClick: (Trip) -> Unit) {
    val dateFormat = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 4.dp),
        colors = CardDefaults.cardColors(
            containerColor = Color.Blue
        )

    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Text(text = "ID: ${trip.id}", style = MaterialTheme.typography.titleMedium)
            Text(text = "Destination: ${trip.destination}", style = MaterialTheme.typography.bodyLarge)
            Text(text = "Cost: ${trip.cost}", style = MaterialTheme.typography.bodyMedium)
            Text(text = "People: ${trip.people}", style = MaterialTheme.typography.bodyMedium)
            Text(text = "Start Date: ${dateFormat.format(trip.startDate)}", style = MaterialTheme.typography.bodySmall)
            Text(text = "End Date: ${dateFormat.format(trip.endDate)}", style = MaterialTheme.typography.bodySmall)

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
            ) { Button (onClick = { onEditClick(trip) }) { Text(text = "Edit") }
            Button(onClick = { onDeleteClick(trip) }) { Text(text = "Delete") }
        }
    }
        }
}
@Composable
fun HomeScreen(navController: NavController) {
    Scaffold(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0x516199)),
    ) { innerPadding ->
        Column(
            modifier = Modifier
                .padding(innerPadding)
                .fillMaxSize()
                .padding(16.dp)
        ) {
            Greeting(name = "Welcome to Trip Planner")

            Spacer(modifier = Modifier.height(16.dp))

            Button(
                onClick = {
                    navController.navigate("read")
                },
                modifier = Modifier.fillMaxWidth(),
                colors = ButtonDefaults.buttonColors(
                    containerColor = Color.Blue,
                    contentColor = Color.White)
            ) {
                Text(text = "Start Planning")
            }
            Button(
                onClick = {
                    exitProcess(-1)
                },
                modifier = Modifier.fillMaxWidth(),
                colors = ButtonDefaults.buttonColors(
                    containerColor = Color.Blue,
                    contentColor = Color.White)
            ) {
                Text(text = "Exit App")
            }
        }
    }
}

@Composable
fun CreateScreen(navController: NavController, trips: MutableList<Trip>) {
    var destination by remember { mutableStateOf("") }
    var cost by remember { mutableStateOf("") }
    var people by remember { mutableStateOf("") }
    var startDate by remember { mutableStateOf("") }
    var endDate by remember { mutableStateOf("") }

    fun parseDate(input: String): Date? {
        return try {
            SimpleDateFormat("yyyy-MM-dd", Locale.getDefault()).parse(input)
        } catch (e: Exception) {
            null
        }
    }

    Scaffold(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0x516199)),
    ) { innerPadding ->
        Column(
            modifier = Modifier
                .padding(innerPadding)
                .fillMaxSize()
                .padding(16.dp)

        ) {
            Text(text = "Add a New Trip", style = MaterialTheme.typography.titleLarge)

            Spacer(modifier = Modifier.height(16.dp))

            OutlinedTextField(
                value = destination,
                onValueChange = { destination = it },
                label = { Text("Destination") },
                modifier = Modifier.fillMaxWidth()
            )

            OutlinedTextField(
                value = cost,
                onValueChange = { cost = it },
                label = { Text("Cost") },
                modifier = Modifier.fillMaxWidth()
            )

            OutlinedTextField(
                value = people,
                onValueChange = { people = it },
                label = { Text("People") },
                modifier = Modifier.fillMaxWidth()
            )

            OutlinedTextField(
                value = startDate,
                onValueChange = { startDate = it },
                label = { Text("Start Date (yyyy-MM-dd)") },
                modifier = Modifier.fillMaxWidth()
            )

            OutlinedTextField(
                value = endDate,
                onValueChange = { endDate = it },
                label = { Text("End Date (yyyy-MM-dd)") },
                modifier = Modifier.fillMaxWidth()
            )

            Spacer(modifier = Modifier.height(16.dp))

            Button(
                onClick = {
                    val newTrip = Trip(
                        id = trips.last().id + 1,
                        cost = cost.toIntOrNull() ?: 0,
                        people = people.toIntOrNull() ?: 0,
                        startDate = parseDate(startDate) ?: Date(),
                        endDate = parseDate(endDate) ?: Date(),
                        destination = destination
                    )
                    trips.add(newTrip)
                    navController.navigate("read")
                },
                modifier = Modifier.fillMaxWidth(),
                colors = ButtonDefaults.buttonColors(
                    containerColor = Color.Blue,
                    contentColor = Color.White)
            ) {
                Text("Add Trip")
            }
        }
    }
}


@Composable
fun UpdateScreen(navController: NavController, tripId: Int, trips: MutableList<Trip>) {
    val tripIndex = trips.indexOfFirst { it.id == tripId }
    var destination by remember { mutableStateOf(trips.get(tripIndex).destination) }
    var cost by remember { mutableStateOf(trips.get(tripIndex).cost.toString()) }
    var people by remember { mutableStateOf(trips.get(tripIndex).people.toString()) }
    var startDate by remember { mutableStateOf(trips.get(tripIndex).startDate.toString()) }
    var endDate by remember { mutableStateOf(trips.get(tripIndex).endDate.toString()) }
    Log.d("myTag", destination);
    Log.d("myTag", tripIndex.toString());
    fun parseDate(input: String): Date? {
        return try {
            SimpleDateFormat("yyyy-MM-dd", Locale.getDefault()).parse(input)
        } catch (e: Exception) {
            null
        }
    }

    Scaffold(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0x516199)),
    ) { innerPadding ->
        Column(
            modifier = Modifier
                .padding(innerPadding)
                .fillMaxSize()
                .padding(16.dp)
        ) {
            Text(text = "Update Trip $tripIndex", style = MaterialTheme.typography.titleLarge)

            Spacer(modifier = Modifier.height(16.dp))

            OutlinedTextField(
                value = destination,
                onValueChange = { destination = it },
                label = { Text("Destination") },
                modifier = Modifier.fillMaxWidth()
            )

            OutlinedTextField(
                value = cost,
                onValueChange = { cost = it },
                label = { Text("Cost") },
                modifier = Modifier.fillMaxWidth()
            )

            OutlinedTextField(
                value = people,
                onValueChange = { people = it },
                label = { Text("People") },
                modifier = Modifier.fillMaxWidth()
            )

            OutlinedTextField(
                value = startDate,
                onValueChange = { startDate = it },
                label = { Text("Start Date (yyyy-MM-dd)") },
                modifier = Modifier.fillMaxWidth()
            )

            OutlinedTextField(
                value = endDate,
                onValueChange = { endDate = it },
                label = { Text("End Date (yyyy-MM-dd)") },
                modifier = Modifier.fillMaxWidth()
            )

            Spacer(modifier = Modifier.height(16.dp))

            Button(
                onClick = {
                    Log.d("myTag", tripIndex.toString());
                    val newTrip = Trip(
                        id = tripIndex,
                        cost = cost.toIntOrNull() ?: 0,
                        people = people.toIntOrNull() ?: 0,
                        startDate = parseDate(startDate) ?: Date(),
                        endDate = parseDate(endDate) ?: Date(),
                        destination = destination
                    )
                    trips[tripIndex] = newTrip
                    navController.navigate("read")
                },
                modifier = Modifier.fillMaxWidth(),
                colors = ButtonDefaults.buttonColors(
                    containerColor = Color.Blue,
                    contentColor = Color.White)
            ) {
                Text("Update Trip")
            }
        }
    }
}

@Composable
fun DeleteScreen(navController: NavController, tripId: Int, trips: MutableList<Trip>) {
    val tripIndex = trips.indexOfFirst { it.id == tripId }
    Scaffold(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0x516199)),
    ) { innerPadding ->
        Column(
            modifier = Modifier
                .padding(innerPadding)
                .fillMaxSize()
                .padding(16.dp)
        ) {
            Text(
                text = "Deleting Trip ID: $tripId",
                style = MaterialTheme.typography.titleLarge
            )

            Spacer(modifier = Modifier.height(16.dp))

            Button(
                onClick = {
                    trips.removeAt(tripIndex)
                    navController.navigate("read")
                },
                modifier = Modifier.fillMaxWidth(),
                colors = ButtonDefaults.buttonColors(
                    containerColor = Color.Blue,
                    contentColor = Color.White)
            ) {
                Text(text = "Delete Trip")
            }
            Button(
                onClick = {
                    navController.popBackStack()
                },
                modifier = Modifier.fillMaxWidth(),
                colors = ButtonDefaults.buttonColors(
                containerColor = Color.Blue,
                contentColor = Color.White
            )
            ) {
                Text(text = "Go Back")
            }
        }
    }
}


@Composable
fun Greeting(name: String, modifier: Modifier = Modifier) {
    Text(
        text = "$name",
        modifier = modifier,
        style = MaterialTheme.typography.titleLarge
    )
}

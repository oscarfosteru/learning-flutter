
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:empty/modules/home/entities/restaurant.dart';

class DetailsRestaurant extends StatefulWidget {
  final Restaurant restaurant;

  const DetailsRestaurant({super.key, required this.restaurant});

  @override
  State<DetailsRestaurant> createState() => _DetailsRestaurantState();
}

class _DetailsRestaurantState extends State<DetailsRestaurant> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  final Completer<GoogleMapController> _mapController = Completer();
  CameraPosition? _restaurantPosition;
  Marker? _restaurantMarker;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  void _initializeMap() {
    // Obtiene las coordenadas del restaurante
    final LatLng restaurantLocation =
        LatLng(widget.restaurant.x.toDouble(), widget.restaurant.y.toDouble());

    // Configura la posición de la cámara
    _restaurantPosition = CameraPosition(
      target: restaurantLocation,
      zoom: 14.4746,
    );

    // Configura el marcador para la ubicación del restaurante
    _restaurantMarker = Marker(
      markerId: const MarkerId('restaurantLocation'),
      position: restaurantLocation,
      infoWindow: InfoWindow(title: widget.restaurant.name),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurant.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Carousel de imágenes
              SizedBox(
                height: 200,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemCount: widget.restaurant.images.length,
                  itemBuilder: (context, index) {
                    final imageUrl = widget.restaurant.images[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width * 0.8,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              // Indicador de posición en el carrusel de imágenes
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.restaurant.images.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () {
                      _pageController.animateToPage(
                        entry.key,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      width: 12.0,
                      height: 12.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == entry.key
                            ? Colors.blueAccent
                            : Colors.grey,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              // Nombre del restaurante
              Text(
                widget.restaurant.name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // Calificación
              StarRating(
                rating: widget.restaurant.rating,
                starCount: 5,
                size: 20,
                color: Colors.amber,
                borderColor: Colors.grey,
              ),
              const SizedBox(height: 8),
              // Descripción
              Text(
                widget.restaurant.description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Reviews: ${widget.restaurant.count}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              // Mapa de Google mostrando la ubicación del restaurante
              SizedBox(
                height: 250,
                child: GoogleMap(
                  initialCameraPosition: _restaurantPosition!,
                  markers:
                      _restaurantMarker != null ? {_restaurantMarker!} : {},
                  onMapCreated: (GoogleMapController controller) {
                    _mapController.complete(controller);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
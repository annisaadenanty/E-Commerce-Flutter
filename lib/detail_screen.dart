import 'package:flutter/material.dart';
import 'checkout_screen.dart'; // Import untuk CheckoutScreen
import 'cart_screen.dart'; // Import untuk CartScreen

class DetailScreen extends StatelessWidget {
  final Map product;

  const DetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {
              // Aksi favorit
            },
          ),
        ],
      ),
      backgroundColor: Colors.white, // Set background menjadi putih
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Produk dengan rounded corners dan memberikan padding tambahan
            Center(
              child: Padding(
                padding: const EdgeInsets.all(
                    16.0), // Menambahkan padding di sekitar gambar
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20), // Sudut melengkung
                  child: Image.network(
                    product['image'],
                    height: 350, // Ukuran gambar lebih besar
                    width: double.infinity, // Gambar memenuhi lebar layar
                    fit: BoxFit
                        .contain, // Gambar akan sepenuhnya terlihat tanpa terpotong
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Informasi Produk
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Harga
                  Text(
                    '\$${product['price']}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Nama Produk
                  Text(
                    product['title'],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Deskripsi Produk
                  Text(
                    product['description'],
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      // Tombol Beli dan Add to Cart
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Tombol Add to Cart
            ElevatedButton(
              onPressed: () {
                // Arahkan ke layar CartScreen dengan produk yang dipilih
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(
                      cartItems: [
                        {
                          'title': product['title'],
                          'price': product['price'],
                          'image': product['image'],
                        }
                      ],
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.black, // Latar belakang hitam untuk tombol
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: const BorderSide(color: Colors.black, width: 1),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.add_shopping_cart,
                    color: Colors.white, // Ikon putih
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Add to Cart',
                    style: TextStyle(color: Colors.white), // Teks putih
                  ),
                ],
              ),
            ),
            const SizedBox(
                width: 16), // Jarak antara tombol Add to Cart dan Buy Now
            // Tombol Buy Now
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Arahkan ke halaman checkout dengan item yang dipilih
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutScreen(
                        cartItems: [
                          {
                            'title': product['title'],
                            'price': product['price'],
                            'image': product['image'],
                          }
                        ],
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.black, // Latar belakang hitam untuk tombol
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Buy Now',
                  style: TextStyle(
                      fontSize: 18, color: Colors.white), // Teks putih
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan opsi warna
  Widget _buildColorOption(Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
    );
  }
}

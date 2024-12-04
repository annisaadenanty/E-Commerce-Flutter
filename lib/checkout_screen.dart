import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  final List<Map> cartItems; // Produk dalam keranjang

  const CheckoutScreen({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    // Hitung total harga
    double totalPrice = cartItems.fold(
      0,
      (sum, item) => sum + (item['price'] as double),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {
              // Aksi untuk melihat keranjang jika diperlukan
            },
          ),
        ],
      ),
      backgroundColor: Colors.white, // Latar belakang putih
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: cartItems.isEmpty
            ? const Center(
                child: Text(
                  'Your cart is empty!',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const Text(
                    'Order Summary',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // List item dalam keranjang
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation:
                              2, // Menurunkan elevation agar lebih ringan
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color:
                              Colors.white, // Latar belakang putih untuk card
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item['image'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              item['title'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black, // Teks hitam
                              ),
                            ),
                            subtitle: Text(
                              '\$${item['price']}',
                              style: TextStyle(
                                color: Colors.grey[
                                    800], // Warna abu-abu gelap untuk subtitle
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.remove_circle,
                                  color: Colors
                                      .red), // Ikon remove dengan warna merah
                              onPressed: () {
                                // Logika penghapusan item dari keranjang
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const Divider(thickness: 1.2, color: Colors.grey),

                  // Total Harga
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '\$${totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tombol Place Order
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _showOrderSuccessDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        backgroundColor: Colors.black, // Tombol hitam
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Place Order',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // Dialog untuk sukses pembelian
  void _showOrderSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white, // Latar belakang dialog putih
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Center(
            child: Text(
              'Order Successful! 🎉',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Teks hitam untuk judul
              ),
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                size: 100,
                color: Colors.green, // Warna hijau untuk ikon sukses
              ),
              SizedBox(height: 16),
              Text(
                'Thank you for your purchase!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black, // Teks hitam untuk pesan
                ),
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Tutup dialog
                  Navigator.pop(context); // Kembali ke layar utama
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Warna tombol hitam
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8), // Sudut tombol membulat
                  ),
                ),
                child: Text(
                  'Back to Home',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white, // Teks putih di tombol
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

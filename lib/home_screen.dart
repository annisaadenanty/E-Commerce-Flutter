import 'package:flutter/material.dart';
import 'detail_screen.dart';
import 'checkout_screen.dart';
import 'cart_screen.dart';
import 'api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> categories = [];
  List products = [];
  String selectedCategory = 'all';
  bool isLoading = true;
  String? errorMessage;
  List filteredProducts = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    try {
      await fetchCategories();
      await fetchProducts();
    } catch (e) {
      setState(() {
        errorMessage = 'Gagal memuat data. Coba lagi nanti.';
      });
    }
  }

  Future<void> fetchCategories() async {
    final fetchedCategories = await ApiService.getCategories();
    setState(() {
      categories = ['all', ...fetchedCategories];
    });
  }

  Future<void> fetchProducts({String category = 'all'}) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final fetchedProducts = await ApiService.getProducts(category: category);
      setState(() {
        products = fetchedProducts;
        filteredProducts = fetchedProducts;
        selectedCategory = category;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Gagal memuat produk. Coba lagi nanti.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _searchProducts(String query) {
    final results = products.where((product) {
      final title = product['title'].toLowerCase();
      return title.contains(query.toLowerCase());
    }).toList();
    setState(() {
      filteredProducts = results;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'NS Shop',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  'https://www.w3schools.com/w3images/avatar2.png', // User image
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(cartItems: const []),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
              });
            },
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // Hanya menampilkan TextField jika dalam mode pencarian
          if (_isSearching)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _searchController,
                onChanged: _searchProducts,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true, // Memberikan warna latar belakang
                  fillColor: Colors
                      .grey[100], // Warna latar belakang yang lebih ringan
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(32), // Membuat sudut lebih bulat
                    borderSide: const BorderSide(
                      color:
                          Colors.transparent, // Menyembunyikan border default
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32),
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 129, 132, 135),
                        width: 2), // Border saat fokus
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32),
                    borderSide: const BorderSide(
                        color: Colors
                            .transparent), // Menyembunyikan border default
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                  hintStyle: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),

          const SizedBox(height: 16),
          categories.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : _buildCategories(),
          const SizedBox(height: 16),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage != null
                    ? _buildErrorMessage()
                    : filteredProducts.isEmpty
                        ? _buildEmptyProducts()
                        : _buildProductGrid(screenWidth),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedCategory == categories[index];

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = categories[index];
              });
              fetchProducts(category: categories[index]);
            },
            child: MouseRegion(
              onEnter: (_) {
                // Ketika kursor memasuki kategori, ganti warna latar belakang menjadi hitam
                setState(() {
                  // Bisa digunakan untuk menambah efek ketika hover
                });
              },
              onExit: (_) {
                // Kembalikan ke warna semula saat kursor keluar
                setState(() {
                  // Bisa digunakan untuk menambah efek ketika hover berhenti
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.black
                      : Colors.white, // Hitam ketika dipilih
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.black, // Border hitam di sekeliling
                    width: 2, // Lebar border
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected
                          ? Colors.black.withOpacity(0.4)
                          : Colors.transparent,
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    categories[index].toUpperCase(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14, // Ukuran font yang lebih kecil dan modern
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(
            errorMessage ?? '',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyProducts() {
    return const Center(
      child: Text(
        'Tidak ada produk dalam kategori ini.',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  Widget _buildProductGrid(double screenWidth) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: screenWidth < 600 ? 2 : 4,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return ProductCard(
          product: product,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(product: product),
              ),
            );
          },
        );
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian gambar produk dengan jarak (rounded inset)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Center(
                  child: Image.network(
                    product['image'],
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: 120,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['title'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '(${product['rating']})',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product['price'].toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12.0, top: 8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.favorite_border,
                  color: Colors.red,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

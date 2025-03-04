import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:vendx/features/cart/controller/cart_state.dart';
import 'package:vendx/features/product/model/product.dart';
import 'package:vendx/features/product/view/widgets/product_item_card.dart';
import 'package:vendx/utlis/constants/colors.dart';
import 'package:vendx/utlis/constants/env.dart';
import 'package:shimmer/shimmer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String selectedCategory = 'All';
  String selectedMachine = 'SHED';
  String searchQuery = '';
  String sortOption = 'Sort';

  List<String> categories = [
    'All',
    'Art',
    'Writing',
    'Tech',
    'Stationery',
    'Sports'
  ];
  List<String> machines = ['SHED', 'Cube'];
  List<String> sortOptions = [
    'Sort',
    'Price: Low to High',
    'Price: High to Low'
  ];

  List<ProductModel> _allProducts = [];
  List<ProductModel> _filteredProducts = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http
          .get(Uri.parse('${Env.apiBaseUrl}/api/products?populate=*'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> products = data['data'];

        setState(() {
          _allProducts =
              products.map((json) => ProductModel.fromJson(json)).toList();
          _applyFiltersAndSort();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _applyFiltersAndSort() {
    // Filter by category and search query
    _filteredProducts = _allProducts.where((product) {
      final matchesCategory =
          selectedCategory == 'All' || product.category == selectedCategory;

      final matchesSearch = searchQuery.isEmpty ||
          product.name.toLowerCase().contains(searchQuery.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();

    // Sort products
    if (sortOption == 'Price: Low to High') {
      _filteredProducts
          .sort((a, b) => (a.price.netPrice - b.price.netPrice).toInt());
    } else if (sortOption == 'Price: High to Low') {
      _filteredProducts
          .sort((a, b) => (b.price.netPrice - a.price.netPrice).toInt());
    }
  }

  Widget _buildLoadingState() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: VendxColors.primary800),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.grey),
          ),
          onChanged: (value) {
            setState(() {
              searchQuery = value;
              _applyFiltersAndSort();
            });
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Filters Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Category Dropdown
                  DropdownButton<String>(
                    value: selectedCategory,
                    hint: Text('Category'),
                    items: categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value!;
                        _applyFiltersAndSort();
                      });
                    },
                  ),
                  SizedBox(width: 10),
                  // Machine Dropdown
                  DropdownButton<String>(
                    value: selectedMachine,
                    hint: Text('Machine'),
                    items: machines.map((String machine) {
                      return DropdownMenuItem<String>(
                        value: machine,
                        child: Text(machine),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedMachine = value!;
                      });
                    },
                  ),
                  SizedBox(width: 10),
                  // Sort Dropdown
                  DropdownButton<String>(
                    value: sortOption,
                    hint: Text('Sort'),
                    items: sortOptions.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        sortOption = value!;
                        _applyFiltersAndSort();
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            // Product Grid
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : _errorMessage.isNotEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 48.0,
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                'Oops! Something went wrong.',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                _errorMessage,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 16.0),
                              ElevatedButton(
                                onPressed: _fetchProducts,
                                child: Text('Retry'),
                              )
                            ],
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16.0,
                            mainAxisSpacing: 16.0,
                            childAspectRatio: 0.9,
                          ),
                          itemCount: _filteredProducts.length,
                          itemBuilder: (context, index) {
                            return ProductItemCard(
                              product: _filteredProducts[index],
                              onAddToCart: () {
                                final CartState cartState =
                                    Get.find<CartState>();
                                cartState.manageItem(
                                    _filteredProducts[index], "add");
                              },
                            );
                          },
                        ),
            )
          ],
        ),
      ),
    );
  }
}

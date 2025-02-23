import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vendx/utlis/constants/colors.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String selectedCategory = 'All';
  String selectedMachine = 'SHED';
  String searchQuery = '';
  String sortOption = 'Sort';

  List<String> categories = ['All', 'Art', 'Writing', 'Tech', 'Stationery', 'Sports'];
  List<String> machines = ['SHED', 'Cube'];
  List<String> sortOptions = ['Sort', 'Price: Low to High', 'Price: High to Low'];

  List<Map<String, dynamic>> products = [
    {'name': 'Sticky Notes', 'price': 5.00, 'category': 'Stationery', 'image': 'sticky_notes.png'},
    {'name': 'Drawing Set', 'price': 13.65, 'category': 'Art', 'image': 'drawing_set.png'},
    {'name': 'Pencil', 'price': 2.25, 'category': 'Writing', 'image': 'pencil.png'},
    {'name': 'Paper', 'price': 0.50, 'category': 'Stationery', 'image': 'paper.png'},
    {'name': 'Camera', 'price': 50.00, 'category': 'Tech', 'image': 'camera.png'},
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredProducts = products
        .where((product) =>
    (selectedCategory == 'All' || product['category'] == selectedCategory) &&
        product['name'].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    if (sortOption == 'Price: Low to High') {
      filteredProducts.sort((a, b) => a['price'].compareTo(b['price']));
    } else if (sortOption == 'Price: High to Low') {
      filteredProducts.sort((a, b) => b['price'].compareTo(a['price']));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: VendxColors.primary800),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.grey),
          ),
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: selectedCategory,
                  items: categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                ),
                DropdownButton<String>(
                  value: selectedMachine,
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
                DropdownButton<String>(
                  value: sortOption,
                  items: sortOptions.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      sortOption = value!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  var product = filteredProducts[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(12)), // Rounded top corners
                            child: Image.asset(
                              'assets/${product['image']}',
                              fit: BoxFit.cover,
                              width: double.infinity, // Ensures full width
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensures text is on left and button on right
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name'],
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: 4), // Small space between name and price
                                  Text(
                                    '€${product['price'].toStringAsFixed(2)}',
                                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: VendxColors.primary800,
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.add, color: Colors.white, size: 18),
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );

                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

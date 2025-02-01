import 'package:flutter/material.dart';
import 'package:vendx/features/home/view/screens/favourites.dart';
import 'package:vendx/features/home/view/screens/home.dart';

import 'package:vendx/features/orders/view/screens/orders.dart';

class CategoryList extends StatelessWidget {
  CategoryList({super.key});

  final List<CategoryItem> categories = [
    CategoryItem(icon: Icons.palette, label: 'Art'),
    CategoryItem(icon: Icons.create, label: 'Writing'),
    CategoryItem(icon: Icons.computer, label: 'Tech'),
    CategoryItem(icon: Icons.cut_outlined, label: 'Stationery'),
    CategoryItem(icon: Icons.sports_soccer, label: 'Sports'),
  ];

  @override
  Widget build(BuildContext context) {
    final List<List<CategoryItem>> carouselPages =
        _createCarouselPages(categories, 4);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16.0),
        SizedBox(
          height: 100,
          child: PageView.builder(
            itemCount: carouselPages.length,
            itemBuilder: (context, pageIndex) {
              final pageCategories = carouselPages[pageIndex];
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1,
                ),
                itemCount: pageCategories.length,
                itemBuilder: (context, index) {
                  final category = pageCategories[index];
                  return Column(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Icon(
                          category.icon,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        category.label,
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // Helper function to create pages for the carousel
  List<List<CategoryItem>> _createCarouselPages(
      List<CategoryItem> items, int itemsPerPage) {
    final List<List<CategoryItem>> pages = [];
    for (int i = 0; i < items.length; i += itemsPerPage) {
      pages.add(items.sublist(
        i,
        i + itemsPerPage > items.length ? items.length : i + itemsPerPage,
      ));
    }
    return pages;
  }
}

class CategoriesList extends StatelessWidget {
  final List<CategoryItem> categories = [
    CategoryItem(icon: Icons.palette, label: 'Art'),
    CategoryItem(icon: Icons.create, label: 'Writing'),
    CategoryItem(icon: Icons.computer, label: 'Tech'),
    CategoryItem(icon: Icons.cut_outlined, label: 'Stationery'),
    CategoryItem(icon: Icons.sports_soccer, label: 'Sports'),
  ];

  CategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8.0),
        itemBuilder: (context, index) {
          final category = categories[index];
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Icon(category.icon, color: Colors.white, size: 30),
              ),
              Text(
                category.label,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          );
        },
      ),
    );
  }
}

class CategoryItem {
  final IconData icon;
  final String label;

  CategoryItem({required this.icon, required this.label});
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    OrdersScreen(),
    const FavouritesScreen(),
    // CartScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 1.0,
            ),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.published_with_changes_rounded),
              activeIcon: Icon(Icons.published_with_changes_rounded),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_outlined),
              activeIcon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
          ],
        ),
      ),
    );
  }
}

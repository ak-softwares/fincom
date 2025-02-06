import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../data/database/mongodb/mongodb.dart';
import '../../controllers/product/product_controller.dart';
import '../../models/product_model.dart';

class Products1 extends StatelessWidget {
  const Products1({super.key});
  @override
  Widget build(BuildContext context) {
    final MongoDatabase _mongoDatabase = MongoDatabase();

    MongoDatabase();
    return Scaffold(
      appBar: TAppBar2(titleText: 'Products'),
      // floatingActionButton: FloatingActionButton(
      //   heroTag: 'products_fab', // Unique tag
      //   shape: CircleBorder(),
      //   backgroundColor: TColors.primaryColor,
      //   onPressed: () => Get.to(PurchaseEntry()),
      //   child: Icon(LineIcons.plus, size: 30, color: Colors.white),
      // ),
      body: SingleChildScrollView(
        child: Text('Products'),
      ),
    );
  }
}

class Products2 extends StatefulWidget {
  const Products2({super.key});

  @override
  _Products2State createState() => _Products2State();
}

class _Products2State extends State<Products2> {
  final MongoDatabase _mongoDatabase = MongoDatabase();
  final productController = Get.put(ProductController());

  @override
  void initState() {
    super.initState();
    _initMongoDB();
  }

  // Initialize MongoDB connection
  void _initMongoDB() async {
    await _mongoDatabase.connect();
  }

  // Insert a sample document into MongoDB
  Future<void> _insertData() async {
    ProductModel product  = await productController.getProductById('4383');
    ProductModel product1 = ProductModel(
      id: 101,
      name: 'Smartphone X',
      mainImage: 'https://example.com/images/smartphone-x.jpg',
      permalink: 'https://example.com/products/smartphone-x',
      slug: 'smartphone-x',
      dateCreated: '2025-02-06T10:00:00Z',
      type: 'simple',
      status: 'publish',
      featured: true,
      catalogVisibility: 'visible',
      description: 'A high-end smartphone with the latest features.',
      shortDescription: 'Premium smartphone with AI camera',
      sku: 'SMX-2025',
      price: 799.99,
      regularPrice: 899.99,
      salePrice: 749.99,
      dateOnSaleFrom: '2025-02-01',
      dateOnSaleTo: '2025-02-15',
      onSale: true,
      purchasable: true,
      totalSales: 1500,
      virtual: false,
      downloadable: false,
      taxStatus: 'taxable',
      taxClass: '',
      manageStock: true,
      stockQuantity: 250,
      weight: '200g',
      dimensions: {
        'length': '15cm',
        'width': '7cm',
        'height': '0.8cm'
      },
      shippingRequired: true,
      shippingTaxable: true,
      shippingClass: 'standard',
      shippingClassId: 1,
      reviewsAllowed: true,
      averageRating: 4.5,
      ratingCount: 320,
      upsellIds: [102, 103],
      crossSellIds: [104, 105],
      parentId: 0,
      purchaseNote: 'Thank you for purchasing Smartphone X!',
      tags: [
        {'id': 1001, 'name': '5G'},
        {'id': 1002, 'name': 'AI Camera'}
      ],
      images: [
        {'src': 'https://example.com/images/smartphone-x.jpg', 'alt': 'Smartphone X Front'},
        {'src': 'https://example.com/images/smartphone-x-back.jpg', 'alt': 'Smartphone X Back'}
      ],
      image: 'https://example.com/images/smartphone-x.jpg',

      variations: [201, 202],
      groupedProducts: [],
      menuOrder: 1,
      relatedIds: [102, 103, 104],
      stockStatus: 'instock',
      isCODBlocked: false,
    );

    _mongoDatabase.insertDocument('products', product.toMap());
  }


  // Fetch and display documents
  void _fetchData() async {
    var documents = await _mongoDatabase.fetchDocuments('products');
    print(documents); // You can display them in your UI
  }

  @override
  void dispose() {
    _mongoDatabase.close(); // Close the connection when done
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar2(titleText: 'Products',),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _insertData,
              child: Text('Insert Data'),
            ),
            ElevatedButton(
              onPressed: _fetchData,
              child: Text('Fetch Data'),
            ),
          ],
        ),
      ),
    );
  }
}
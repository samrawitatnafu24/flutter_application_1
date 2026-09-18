// ============================================================================
// Screen: AddProduct (and Edit Product)
// Form screen allowing users to create a new product or edit an existing one.
// ============================================================================

import 'package:flutter/material.dart'; // Standard Flutter UI toolkit.
import '../data/categories.dart'; // Predefined categories list.
import '../data/market_store.dart'; // In-memory data store for products.
import '../models/product.dart'; // Product data model.

// StatefulWidget is necessary to manage text controllers and dropdown selection state.
class AddProducts extends StatefulWidget {
  // Optional product passed in when editing an existing product.
  // If null, the screen operates in "Add Product" (create) mode.
  final Product? product;

  // Constructor accepting an optional product for edit mode.
  const AddProducts({super.key, this.product});

  @override
  State<AddProducts> createState() => _AddProductState();
}

class _AddProductState extends State<AddProducts> {
  // GlobalKey uniquely identifies the Form and allows form validation.
  final _formKey = GlobalKey<FormState>();

  // TextEditingControllers manage the text input state for each field.
  late final TextEditingController _titleController;
  late final TextEditingController _priceController;
  late final TextEditingController _descriptionController;

  // State variable holding the currently selected category dropdown value.
  late String _selectedCategory;

  @override
  void initState() {
    super.initState(); // Always call super.initState() first in lifecycle.

    // Check if we are in edit mode (existing product passed).
    final isEditing = widget.product != null;

    // Initialize controllers with existing product values if editing, or empty strings if adding.
    _titleController = TextEditingController(
      text: isEditing ? widget.product!.title : '',
    );
    _priceController = TextEditingController(
      text: isEditing ? widget.product!.price.toString() : '0',
    );
    _descriptionController = TextEditingController(
      text: isEditing ? widget.product!.description : '',
    );

    // Initialize category with product's category if editing, or default to first category.
    _selectedCategory = isEditing ? widget.product!.category : kCategories.first;
  }

  @override
  void dispose() {
    // Clean up controllers when the widget is removed from the widget tree to prevent memory leaks.
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose(); // Always call super.dispose() at the end.
  }

  // Handles form submission, validation, and saving to the MarketStore.
  void _saveProduct() {
    // Validate all form fields using the form key.
    if (_formKey.currentState?.validate() ?? false) {
      // Parse price safely, fallback to 0.0 if invalid format.
      final double parsedPrice = double.tryParse(_priceController.text.trim()) ?? 0.0;

      if (widget.product != null) {
        // Edit Mode: Update existing product using copyWith.
        final updatedProduct = widget.product!.copyWith(
          title: _titleController.text.trim(),
          price: parsedPrice,
          category: _selectedCategory,
          description: _descriptionController.text.trim(),
        );
        MarketStore.updateProduct(updatedProduct); // Save updates in store.
      } else {
        // Create Mode: Instantiate a brand new Product.
        final newProduct = Product(
          id: MarketStore.newProductId(), // Generate unique ID.
          title: _titleController.text.trim(),
          price: parsedPrice,
          category: _selectedCategory,
          description: _descriptionController.text.trim(),
        );
        MarketStore.addProduct(newProduct); // Add new product to store.
      }

      // Return back to previous screen.
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine screen header title based on whether we are editing or creating.
    final bool isEditing = widget.product != null;

    return Scaffold(
      backgroundColor: Colors.white, // White background for clean layout.
      appBar: AppBar(
        backgroundColor: Colors.white, // White app bar background.
        elevation: 0, // Flat app bar.
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // Back button.
          onPressed: () => Navigator.pop(context), // Pops route.
        ),
        title: Text(
          isEditing ? 'Edit product' : 'Add product', // Dynamic title matching mockups.
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // Center the title in the app bar.
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFE5E7EB)), // Subtle divider.
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey, // Connects the Form widget to our form key.
          child: SingleChildScrollView(
            // SingleChildScrollView allows scrolling on smaller screens or when keyboard appears.
            padding: const EdgeInsets.all(20.0), // Padding around form contents.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Left-align all form labels.
              children: [
                // Label for Product Title input.
                Text(
                  'Title',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600, // Subdued grey label color.
                  ),
                ),
                const SizedBox(height: 8), // Spacing between label and input box.
                // TextFormField for entering the product title.
                TextFormField(
                  controller: _titleController, // Connects controller.
                  decoration: InputDecoration(
                    hintText: 'e.g. Desk lamp', // Hint placeholder.
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded corners.
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a product title'; // Validation error.
                    }
                    return null; // Valid input.
                  },
                ),
                const SizedBox(height: 18), // Field separator spacing.

                // Label for Product Price input.
                Text(
                  'Price',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                // TextFormField for entering the numerical price.
                TextFormField(
                  controller: _priceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true), // Number keyboard.
                  decoration: InputDecoration(
                    hintText: '0',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a price';
                    }
                    if (double.tryParse(value.trim()) == null) {
                      return 'Please enter a valid numeric price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                // Label for Category selector.
                Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                // DropdownButtonFormField for selecting from allowed categories.
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory, // Currently active initial category value.
                  items: kCategories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category), // Category label in dropdown menu.
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedCategory = newValue; // Update selected category state.
                      });
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
                const SizedBox(height: 18),

                // Label for Description input.
                Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                // Multiline TextFormField for entering the product description.
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4, // Multi-line text area allowing 4 rows of text.
                  decoration: InputDecoration(
                    hintText: 'Short description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32), // Spacing before the save button.

                // Full-width "Save product" button.
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _saveProduct, // Trigger save logic when tapped.
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB), // Signature primary blue.
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Save product',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

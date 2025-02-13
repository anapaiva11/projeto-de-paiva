import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Produtos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
       home: const BottomNavigationScreen(),
    );
  }
}

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  _BottomNavigationScreenState createState() =>
      _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _selectedIndex = 0;

  // Lista de telas
  final List<Widget> _screens = [
    ProductsScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App com Navegação'),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Produtos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Carrinho',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Lista de produtos no carrinho
  final List<Map<String, dynamic>> cartItems = [
    {'name': 'Produto 1', 'price': 50.00, 'quantity': 1},
    {'name': 'Produto 2', 'price': 30.00, 'quantity': 2},
    {'name': 'Produto 3', 'price': 70.00, 'quantity': 1},
  ];

  final double shippingFee = 10.00; // Valor fixo do frete

  // Calcula o total dos produtos
  double get totalProducts {
    return cartItems.fold(0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  // Calcula o total final (produtos + frete)
  double get totalAmount => totalProducts + shippingFee;

  void _increaseQuantity(int index) {
    setState(() {
      cartItems[index]['quantity']++;
    });
  }

  void _decreaseQuantity(int index) {
    setState(() {
      if (cartItems[index]['quantity'] > 1) {
        cartItems[index]['quantity']--;
      } else {
        cartItems.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carrinho de Compras')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Lista de produtos no carrinho
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(item['name']),
                      subtitle: Text('Preço: R\$ ${item['price'].toStringAsFixed(2)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () => _decreaseQuantity(index),
                          ),
                          Text('${item['quantity']}'),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => _increaseQuantity(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Resumo da compra
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildSummaryRow('Total dos Produtos:', totalProducts),
                    _buildSummaryRow('Frete:', shippingFee),
                    const Divider(),
                    _buildSummaryRow('Total a Pagar:', totalAmount, isBold: true),
                  ],
                ),
              ),
            ),

            // Botão de compra
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Ação ao clicar no botão comprar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Compra realizada com sucesso!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Comprar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para exibir os valores no resumo
  Widget _buildSummaryRow(String label, double value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text('R\$ ${value.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}

// Tela de Perfil
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Foto de perfil
          CircleAvatar(
            radius: 50,
            child: Icon(Icons.person, size: 50, color: Colors.white,), // Adicione uma imagem na pasta assets
          ),
          const SizedBox(height: 16),

          // Nome do usuário
          const Text(
            'João Silva',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // E-mail
          Text(
            'joao.silva@email.com',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),

          // Botão de edição
          ElevatedButton.icon(
            onPressed: () {
              // Ação para editar perfil
            },
            icon: const Icon(Icons.edit),
            label: const Text('Editar Perfil'),
          ),

          const SizedBox(height: 24),

          // Informações adicionais
          ListTile(
            leading: const Icon(Icons.phone, color: Colors.blue),
            title: const Text('Telefone'),
            subtitle: const Text('(11) 98765-4321'),
          ),
          ListTile(
            leading: const Icon(Icons.location_on, color: Colors.red),
            title: const Text('Endereço'),
            subtitle: const Text('Rua das Flores, 123 - São Paulo, SP'),
          ),

          const Spacer(),

          // Botão de logout
          TextButton.icon(
            onPressed: () {
              // Lógica de logout
            },
            icon: const Icon(Icons.exit_to_app, color: Colors.red),
            label: const Text(
              'Sair',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final List<Map<String, String>> products = [
    {'name': 'Produto 1', 'description': 'Descrição do Produto 1', 'price': 'R\$ 50,00'},
    {'name': 'Produto 2', 'description': 'Descrição do Produto 2', 'price': 'R\$ 30,00'},
    {'name': 'Produto 3', 'description': 'Descrição do Produto 3', 'price': 'R\$ 70,00'},
    {'name': 'Produto 4', 'description': 'Descrição do Produto 4', 'price': 'R\$ 100,00'},
    {'name': 'Produto 5', 'description': 'Descrição do Produto 5', 'price': 'R\$ 40,00'},
    {'name': 'Produto 6', 'description': 'Descrição do Produto 6', 'price': 'R\$ 20,00'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductCard(product: products[index]);
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Map<String, String> product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product['name']!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product['description']!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product['price']!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

// ---------------- PANTALLA PRINCIPAL ----------------

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ----------- CAMPOS DE TEXTO -----------
  final TextEditingController nombreCtrl = TextEditingController();
  final TextEditingController edadCtrl = TextEditingController();

  // ----------- MÉTODO AÑADIR USUARIO -----------
  Future<void> anadirUsuario() async {
    await FirebaseFirestore.instance.collection('usuarios').add({
      'nombre': nombreCtrl.text,
      'edad': int.parse(edadCtrl.text),
    });

    nombreCtrl.clear();
    edadCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestor de Usuarios')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ----------- CAMPO NOMBRE -----------
            TextField(
              controller: nombreCtrl,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),

            // ----------- CAMPO EDAD -----------
            TextField(
              controller: edadCtrl,
              decoration: const InputDecoration(labelText: 'Edad'),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 10),

            // -----------  BOTÓN AÑADIR -----------
            ElevatedButton(
              onPressed: anadirUsuario,
              child: const Text('Añadir usuario'),
            ),

            const Divider(),

            // ----------- LISTADO DE USUARIOS -----------
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('usuarios')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView(
                    children: snapshot.data!.docs.map((doc) {
                      return ListTile(
                        title: Text(doc['nombre']),
                        subtitle: Text('Edad: ${doc['edad']}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('usuarios')
                                .doc(doc.id)
                                .delete();
                          },
                        ),
                      );
                    }).toList(),
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
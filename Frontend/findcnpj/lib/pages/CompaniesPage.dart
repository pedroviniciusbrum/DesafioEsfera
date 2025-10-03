import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/Company.dart';
import '../services/Apifindservice.dart';

class CompaniesPage extends StatefulWidget {
  const CompaniesPage({super.key});

  @override
  State<CompaniesPage> createState() => _CompaniesPageState();
}

class _CompaniesPageState extends State<CompaniesPage> {
  final apiService = ApiService();
  List<Company> companies = [];
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    loadCompanies();
  }

  Future<void> loadCompanies() async {
    try {
      final result = await apiService.fetchAllCompanies();
      setState(() {
        companies = result;
        errorMessage = "";
      });
    } catch (e) {
      setState(() {
        errorMessage = "Erro ao carregar empresas: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Empresas Salvas"),
        backgroundColor: const Color.fromRGBO(0, 99, 190, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: errorMessage.isNotEmpty
                  ? Center(
                      child: Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                  : companies.isEmpty
                  ? const Center(child: Text("Nenhuma empresa salva ainda."))
                  : ListView.builder(
                      itemCount: companies.length,
                      itemBuilder: (context, index) {
                        final company = companies[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: const Icon(
                              Icons.business,
                              color: Color.fromRGBO(0, 99, 190, 1),
                            ),
                            title: Text(company.razaoSocial),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("CNPJ: ${company.cnpj}"),
                                Text("Situação: ${company.situacao}"),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.go('/');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(253, 204, 23, 1),
                foregroundColor: const Color.fromRGBO(0, 99, 190, 1),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Voltar para Home",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

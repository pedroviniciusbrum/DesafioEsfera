import 'package:findcnpj/models/Company.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../services/Apifindservice.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController cnpjController = TextEditingController();
  Company? company;
  String responseText = "";
  final apiService = ApiService();
  List<Company> companies = [];
  bool isLoading = false;

  Future<void> fetchCompany() async {
    setState(() => isLoading = true);

    final cnpj = cnpjController.text.trim().replaceAll(RegExp(r'\D'), "");
    if (cnpj.isEmpty) {
      setState(() {
        responseText = "Digite um CNPJ primeiro!";
        isLoading = false;
      });
      return;
    }

    final result = await apiService.fetchCompany(cnpj);
    setState(() {
      company = result;
      responseText = result == null ? "Erro ao buscar CNPJ" : "";
      isLoading = false;
    });
  }

  Future<void> fetchCompanies() async {
    try {
      final result = await apiService.fetchAllCompanies();
      setState(() {
        companies = result;
      });
    } catch (e) {
      setState(() {
        responseText = "Erro ao carregar empresas: $e";
      });
    }
  }

  Future<void> saveCompany() async {
    if (company != null) {
      final success = await apiService.saveCompany(company!);
      setState(() {
        responseText = success
            ? "Empresa salva com sucesso!"
            : "Erro ao salvar";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 99, 190, 1),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 120, bottom: 15),
                child: Text(
                  "Buscador\nde CNPJ",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 96,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(253, 204, 23, 1),
                    height: 1.0,
                  ),
                ),
              ),
              SizedBox(
                width: 500,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: cnpjController,
                        inputFormatters: [cnpjMask],
                        decoration: InputDecoration(
                          hintText: "Digite o CNPJ",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 20,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        context.go('/companies');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(253, 204, 23, 1),
                        foregroundColor: const Color.fromRGBO(0, 99, 190, 1),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Listar Empresas Salvas",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: fetchCompany,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(253, 204, 23, 1),
                        foregroundColor: const Color.fromRGBO(0, 99, 190, 1),
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 23,
                          bottom: 23,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Icon(Icons.search, size: 28),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (responseText.isNotEmpty) ...[
                Text(
                  responseText,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ] else if (company != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "CNPJ: ${company!.cnpj}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "Razão Social: ${company!.razaoSocial}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "Nome Fantasia: ${company!.nomeFantasia}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "CNAE Principal: ${company!.cnaePrincipal}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "Situação: ${company!.situacao}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 7),
                      ElevatedButton(
                        onPressed: isLoading ? null : saveCompany,
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.blue,
                              )
                            : const Text("Salvar no Banco"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(
                            253,
                            204,
                            23,
                            1,
                          ),
                          foregroundColor: const Color.fromRGBO(0, 99, 190, 1),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      if (companies.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Container(
                          width: 500,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Empresas no Banco:",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 300,
                                child: ListView.builder(
                                  itemCount: companies.length,
                                  itemBuilder: (context, index) {
                                    final comp = companies[index];
                                    return ListTile(
                                      leading: const Icon(
                                        Icons.business,
                                        color: Colors.blue,
                                      ),
                                      title: Text(comp.razaoSocial),
                                      subtitle: Text("CNPJ: ${comp.cnpj}"),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
              if (isLoading) ...[
                const CircularProgressIndicator(color: Colors.white),
              ],
            ],
          ),
        ],
      ),
    );
  }

  final cnpjMask = MaskTextInputFormatter(
    mask: '##.###.###/####-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
}

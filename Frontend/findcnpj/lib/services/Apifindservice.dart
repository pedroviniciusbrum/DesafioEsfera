import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Company.dart';

class ApiService {
  static const String baseUrl = "http://localhost:3000";

  Future<Company?> fetchCompany(String cnpj) async {
    try {
      final url = Uri.parse("$baseUrl/cnpj/$cnpj");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Company.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception("Erro ao buscar CNPJ: $e");
    }
  }

  Future<List<Company>> fetchAllCompanies() async {
    try {
      final url = Uri.parse("$baseUrl/companies");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Company.fromJson(json)).toList();
      } else {
        throw Exception("Erro ao buscar empresas: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Erro de conexão: $e");
    }
  }

  Future<bool> saveCompany(Company company) async {
    try {
      final url = Uri.parse("$baseUrl/companies");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(company.toJson()),
      );

      return true;
    } catch (e) {
      throw Exception("Erro ao salvar empresa: $e");
    }
  }
}

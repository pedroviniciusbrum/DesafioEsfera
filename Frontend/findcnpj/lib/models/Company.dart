class Company {
  final String cnpj;
  final String razaoSocial;
  final String nomeFantasia;
  final String cnaePrincipal;
  final String situacao;

  Company({
    required this.cnpj,
    required this.razaoSocial,
    required this.nomeFantasia,
    required this.cnaePrincipal,
    required this.situacao,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      cnpj: json['cnpj'] ?? '',
      razaoSocial: json['razao_social'] ?? '',
      nomeFantasia: json['nome_fantasia'] ?? '',
      cnaePrincipal: json['cnae_principal'] ?? '',
      situacao: json['situacao'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cnpj': cnpj,
      'razao_social': razaoSocial,
      'nome_fantasia': nomeFantasia,
      'cnae_principal': cnaePrincipal,
      'situacao': situacao,
    };
  }
}

bool validarCPF(String cpf) {
  // Remova os caracteres especiais
  cpf = cpf.replaceAll(RegExp(r'[^\d]'), '');

  // Verifique se todos os dígitos são iguais
  if (RegExp(r'^(\d)\1+$').hasMatch(cpf)) {
    return false;
  }

  // Cálculo dos dígitos verificadores
  List<int> digitos = cpf.split('').map(int.parse).toList();

  int soma = 0;
  for (int i = 0; i < 9; i++) {
    soma += digitos[i] * (10 - i);
  }

  int resto = soma % 11;
  int digito1 = (resto < 2) ? 0 : (11 - resto);

  if (digitos[9] != digito1) {
    return false;
  }

  soma = 0;
  for (int i = 0; i < 10; i++) {
    soma += digitos[i] * (11 - i);
  }

  resto = soma % 11;
  int digito2 = (resto < 2) ? 0 : (11 - resto);

  return digitos[10] == digito2;
}
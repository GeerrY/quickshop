from django.core.validators import RegexValidator


no_whitespaces = RegexValidator(
    regex = r'\s',
    message = 'Não use espaços em branco',
    inverse_match = True
)

special_characters = RegexValidator(
    regex = r'[*&%$#@_\-!]',
    message = 'Use pelo menos um caractere especial'
)

uppercase_letters = RegexValidator(
    regex = r'[A-Z]',
    message = 'Use pelo menos uma letra MAIÚSCULA'
)

lowercase_letters = RegexValidator(
    regex = r'[a-z]',
    message = 'Use pelo menos uma letra minúscula'
)

number_validator = RegexValidator(
    regex = r'\d+',
    message = 'Use pelo menos um número'
)

cpf_validator = RegexValidator(
    regex = r'^\d{3}\.?\d{3}\.?\d{3}-?\d{2}$',
    message = 'Digite um CPF válido'
)

cep_validator = RegexValidator(
    regex = r'\d{5}-?\d{3}',
    message = 'Digite um CEP válido'
)
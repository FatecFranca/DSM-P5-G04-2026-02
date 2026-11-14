
/// Opções dos dropdowns do formulário.
class FormOptions {
  // ============================================================
  // CURSOS DO APLICATIVO
  // ============================================================

  static const Map<String, String> courses = {
    'Gestão de Recursos Humanos': 'RH',
    'Análise e Desenvolvimento de Sistemas': 'ADS',
    'Desenvolvimento de Software Multiplataforma': 'DSM',
    'Gestão Empresarial': 'GE',
  };

  static const Map<String, int> courseCodes = {
    'Gestão de Recursos Humanos': 1,
    'Análise e Desenvolvimento de Sistemas': 2,
    'Desenvolvimento de Software Multiplataforma': 3,
    'Gestão Empresarial': 4,
  };

  static String courseShort(String course) => courses[course] ?? course;

  // ============================================================
  // DADOS ACADÊMICOS
  // ============================================================

  static const List<String> semesters = [
    '1º semestre',
    '2º semestre',
    '3º semestre',
    '4º semestre',
    '5º semestre',
    '6º semestre',
  ];

  static const List<String> shifts = [
    'Matutino',
    'Vespertino',
    'Noturno',
  ];

  static const Map<String, int> shiftCodes = {
    'Matutino': 1,
    'Vespertino': 1,
    'Noturno': 0,
  };

  // ============================================================
  // ESTADO CIVIL
  // ============================================================

  static const Map<String, int> maritalStatusCodes = {
    'Solteiro(a)': 1,
    'Casado(a)': 2,
    'Viúvo(a)': 3,
    'Divorciado(a)': 4,
    'União estável': 5,
    'Separado(a) legalmente': 6,
  };

  // ============================================================
  // FORMA DE INGRESSO
  // ============================================================

  static const Map<String, int> applicationModeCodes = {
    'Concurso geral - 1ª fase': 1,
    'Portaria nº 612/93': 2,
    'Concurso especial - Açores': 5,
    'Titular de outro curso superior': 7,
    'Portaria nº 854-B/99': 10,
    'Estudante internacional': 15,
    'Concurso especial - Madeira': 16,
    'Concurso geral - 2ª fase': 17,
    'Concurso geral - 3ª fase': 18,
    'Portaria nº 533-A/99 - plano diferente': 26,
    'Portaria nº 533-A/99 - outra instituição': 27,
    'Maiores de 23 anos': 39,
    'Transferência': 42,
    'Mudança de curso': 43,
    'Diploma de especialização tecnológica': 44,
    'Mudança de instituição/curso': 51,
    'Diploma de ciclo curto': 53,
    'Mudança internacional de instituição/curso': 57,
  };

  static const Map<String, int> applicationOrderCodes = {
    '1ª opção': 0,
    '2ª opção': 1,
    '3ª opção': 2,
    '4ª opção': 3,
    '5ª opção': 4,
    '6ª opção': 5,
    '7ª opção': 6,
    '8ª opção': 7,
    '9ª opção': 8,
    '10ª opção': 9,
  };

  // ============================================================
  // ESCOLARIDADE ANTERIOR DO ESTUDANTE
  // ============================================================

  static const Map<String, int> previousQualificationCodes = {
    'Ensino secundário': 1,
    'Ensino superior - bacharelado': 2,
    'Ensino superior - licenciatura': 3,
    'Ensino superior - mestrado': 4,
    'Ensino superior - doutorado': 5,
    'Frequência do ensino superior': 6,
    '12º ano não concluído': 9,
    '11º ano não concluído': 10,
    'Outro - 11º ano': 12,
    '10º ano': 14,
    '10º ano não concluído': 15,
    'Ensino básico - 3º ciclo': 19,
    'Ensino básico - 2º ciclo': 38,
    'Especialização tecnológica': 39,
    'Ensino superior - 1º ciclo': 40,
    'Curso técnico superior profissional': 42,
    'Ensino superior - mestrado (2º ciclo)': 43,
  };

  // ============================================================
  // NACIONALIDADE
  // ============================================================

  static const Map<String, int> nationalityCodes = {
    'Portuguesa': 1,
    'Alemã': 2,
    'Espanhola': 6,
    'Italiana': 11,
    'Holandesa': 13,
    'Inglesa': 14,
    'Lituana': 17,
    'Angolana': 21,
    'Cabo-verdiana': 22,
    'Guineense': 24,
    'Moçambicana': 25,
    'São-tomense': 26,
    'Turca': 32,
    'Brasileira': 41,
    'Romena': 62,
    'Moldava': 100,
    'Mexicana': 101,
    'Ucraniana': 103,
    'Russa': 105,
    'Cubana': 108,
    'Colombiana': 109,
  };

  // ============================================================
  // ESCOLARIDADE DA MÃE
  // ============================================================

  static const Map<String, int> motherQualificationCodes = {
    'Ensino secundário completo': 1,
    'Ensino superior - bacharelado': 2,
    'Ensino superior - licenciatura': 3,
    'Ensino superior - mestrado': 4,
    'Ensino superior - doutorado': 5,
    'Frequência do ensino superior': 6,
    '12º ano não concluído': 9,
    '11º ano não concluído': 10,
    '7º ano antigo': 11,
    'Outro - 11º ano': 12,
    '10º ano': 14,
    'Curso geral de comércio': 18,
    'Ensino básico - 3º ciclo': 19,
    'Curso técnico-profissional': 22,
    '7º ano de escolaridade': 26,
    '2º ciclo do ensino secundário': 27,
    '9º ano não concluído': 29,
    '8º ano de escolaridade': 30,
    'Desconhecido': 34,
    'Não sabe ler nem escrever': 35,
    'Sabe ler, sem 4º ano': 36,
    'Ensino básico - 1º ciclo': 37,
    'Ensino básico - 2º ciclo': 38,
    'Especialização tecnológica': 39,
    'Ensino superior - 1º ciclo': 40,
    'Estudos superiores especializados': 41,
    'Curso técnico superior profissional': 42,
    'Mestrado': 43,
    'Doutorado': 44,
  };

  // ============================================================
  // ESCOLARIDADE DO PAI
  // ============================================================

  static const Map<String, int> fatherQualificationCodes = {
    'Ensino secundário completo': 1,
    'Ensino superior - bacharelado': 2,
    'Ensino superior - licenciatura': 3,
    'Ensino superior - mestrado': 4,
    'Ensino superior - doutorado': 5,
    'Frequência do ensino superior': 6,
    '12º ano não concluído': 9,
    '11º ano não concluído': 10,
    '7º ano antigo': 11,
    'Outro - 11º ano': 12,
    '2º ano complementar do secundário': 13,
    '10º ano': 14,
    'Curso geral de comércio': 18,
    'Ensino básico - 3º ciclo': 19,
    'Curso complementar do secundário': 20,
    'Curso técnico-profissional': 22,
    'Curso complementar não concluído': 25,
    '7º ano de escolaridade': 26,
    '2º ciclo do ensino secundário': 27,
    '9º ano não concluído': 29,
    '8º ano de escolaridade': 30,
    'Curso geral de administração e comércio': 31,
    'Contabilidade e administração': 33,
    'Desconhecido': 34,
    'Não sabe ler nem escrever': 35,
    'Sabe ler, sem 4º ano': 36,
    'Ensino básico - 1º ciclo': 37,
    'Ensino básico - 2º ciclo': 38,
    'Especialização tecnológica': 39,
    'Ensino superior - 1º ciclo': 40,
    'Estudos superiores especializados': 41,
    'Curso técnico superior profissional': 42,
    'Mestrado': 43,
    'Doutorado': 44,
  };

  // ============================================================
  // OCUPAÇÃO DA MÃE
  // Códigos encontrados no dataset: 1 a 32.
  // ============================================================

  static final Map<String, int> motherOccupationCodes = {
    for (int code = 1; code <= 32; code++)
      'Código $code': code,
  };

  // ============================================================
  // OCUPAÇÃO DO PAI
  // Códigos encontrados no dataset: 1 a 46.
  // ============================================================

  static final Map<String, int> fatherOccupationCodes = {
    for (int code = 1; code <= 46; code++)
      'Código $code': code,
  };

  // ============================================================
  // GÊNERO
  // ============================================================

  static const Map<String, int> genderCodes = {
    'Feminino': 0,
    'Masculino': 1,
  };

  // ============================================================
  // DADOS SOCIOECONÔMICOS
  // ============================================================

  static const Map<String, int> yesNoCodes = {
    'Não': 0,
    'Sim': 1,
  };

  static const List<String> yesNo = [
    'Sim',
    'Não',
  ];

  static const List<String> incomes = [
    'Até 1 salário mínimo',
    'Até 3 salários mínimos',
    'De 3 a 6 salários mínimos',
    'Acima de 6 salários mínimos',
  ];

  // ============================================================
  // MÉTODOS AUXILIARES
  // ============================================================

  static List<String> get maritalStatuses =>
      maritalStatusCodes.keys.toList();

  static List<String> get applicationModes =>
      applicationModeCodes.keys.toList();

  static List<String> get applicationOrders =>
      applicationOrderCodes.keys.toList();

  static List<String> get previousQualifications =>
      previousQualificationCodes.keys.toList();

  static List<String> get nationalities =>
      nationalityCodes.keys.toList();

  static List<String> get motherQualifications =>
      motherQualificationCodes.keys.toList();

  static List<String> get fatherQualifications =>
      fatherQualificationCodes.keys.toList();

  static List<String> get motherOccupations =>
      motherOccupationCodes.keys.toList();

  static List<String> get fatherOccupations =>
      fatherOccupationCodes.keys.toList();

  static List<String> get genders =>
      genderCodes.keys.toList();
}

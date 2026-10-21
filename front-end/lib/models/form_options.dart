/// Opções fixas dos dropdowns do formulário.
/// Futuramente podem vir da API (ex.: GET /courses).
class FormOptions {
  /// Nome completo do curso -> abreviação exibida nos cards.
  static const Map<String, String> courses = {
    'Análise e Desenvolvimento de Sistemas': 'ADS',
    'Engenharia de Software': 'Engenharia',
    'Gestão da Tecnologia da Informação': 'GTI',
    'Ciência de Dados': 'Ciência de Dados',
    'Logística': 'Logística',
  };

  static const List<String> semesters = [
    '1º semestre', '2º semestre', '3º semestre',
    '4º semestre', '5º semestre', '6º semestre',
  ];

  static const List<String> shifts = ['Matutino', 'Vespertino', 'Noturno'];

  static const List<String> genders = [
    'Feminino', 'Masculino', 'Outro', 'Prefiro não informar',
  ];

  static const List<String> yesNo = ['Sim', 'Não'];

  static const List<String> incomes = [
    'Até 1 salário mínimo',
    'Até 3 salários mínimos',
    'De 3 a 6 salários mínimos',
    'Acima de 6 salários mínimos',
  ];

  static String courseShort(String course) => courses[course] ?? course;
}

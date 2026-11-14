
import 'form_options.dart';

/// Dados de um estudante utilizados pelo aplicativo e pela API.
class Student {
  // Dados básicos
  final String name;
  final String course;
  final int courseCode;
  final String semester;
  final String shift;
  final int age;
  final String gender;

  // Campos antigos mantidos para compatibilidade
  final bool works;
  final String familyIncome;
  final bool hasScholarship;
  final bool failedBefore;

  // Dados pessoais exigidos pela API
  final int? maritalStatus;
  final int? applicationMode;
  final int? applicationOrder;
  final int? daytimeAttendance;
  final int? previousQualification;
  final int? nationality;
  final int? motherQualification;
  final int? fatherQualification;
  final int? motherOccupation;
  final int? fatherOccupation;
  final bool? displaced;
  final bool? educationalSpecialNeeds;
  final int? genderCode;
  final bool? international;

  // Dados socioeconômicos
  final bool? debtor;
  final bool? tuitionFeesUpToDate;

  // Primeiro semestre
  final double averageGradeFirst;
  final double attendanceFirst;
  final int? creditsFirst;
  final int? enrolledFirst;
  final int? evaluationsFirst;
  final int? approvedFirst;
  final int? withoutEvaluationsFirst;

  // Segundo semestre
  final double averageGradeSecond;
  final double attendanceSecond;
  final int? creditsSecond;
  final int? enrolledSecond;
  final int? evaluationsSecond;
  final int? approvedSecond;
  final int? withoutEvaluationsSecond;

  const Student({
    required this.name,
    required this.course,
    required this.courseCode,
    required this.semester,
    required this.shift,
    required this.age,
    required this.gender,
    required this.works,
    required this.familyIncome,
    required this.hasScholarship,
    required this.averageGradeFirst,
    required this.attendanceFirst,
    required this.averageGradeSecond,
    required this.attendanceSecond,
    required this.failedBefore,

    this.maritalStatus,
    this.applicationMode,
    this.applicationOrder,
    this.daytimeAttendance,
    this.previousQualification,
    this.nationality,
    this.motherQualification,
    this.fatherQualification,
    this.motherOccupation,
    this.fatherOccupation,
    this.displaced,
    this.educationalSpecialNeeds,
    this.genderCode,
    this.international,

    this.debtor,
    this.tuitionFeesUpToDate,

    this.creditsFirst,
    this.enrolledFirst,
    this.evaluationsFirst,
    this.approvedFirst,
    this.withoutEvaluationsFirst,

    this.creditsSecond,
    this.enrolledSecond,
    this.evaluationsSecond,
    this.approvedSecond,
    this.withoutEvaluationsSecond,
  });

  // Compatibilidade com o serviço fictício.
  double get averageGrade => averageGradeSecond;
  double get attendance => attendanceSecond;

  String get summaryLine =>
      '${FormOptions.courseShort(course)} • $semester • $shift';

  /// Dados gerais do estudante.
  Map<String, dynamic> toJson() => {
    'name': name,
    'course': course,
    'codigo_curso': courseCode,
    'semester': semester,
    'shift': shift,
    'age': age,
    'gender': gender,
    'works': works,
    'family_income': familyIncome,
    'has_scholarship': hasScholarship,
    'failed_before': failedBefore,

    'estado_civil': maritalStatus,
    'modo_ingresso': applicationMode,
    'ordem_ingresso': applicationOrder,
    'turno_dataset': daytimeAttendance,
    'qualificacao_anterior': previousQualification,
    'nacionalidade': nationality,
    'qualificacao_mae': motherQualification,
    'qualificacao_pai': fatherQualification,
    'ocupacao_mae': motherOccupation,
    'ocupacao_pai': fatherOccupation,
    'deslocado': displaced,
    'necessidades_especiais': educationalSpecialNeeds,
    'genero_codigo': genderCode,
    'idade_ingresso': age,
    'internacional': international,

    'devedor': debtor,
    'mensalidades_em_dia': tuitionFeesUpToDate,
    'bolsista': hasScholarship,

    'media_notas_primeiro_semestre': averageGradeFirst,
    'frequencia_primeiro_semestre': attendanceFirst,
    'creditos_primeiro_semestre': creditsFirst,
    'disciplinas_matriculadas_primeiro_semestre': enrolledFirst,
    'avaliacoes_primeiro_semestre': evaluationsFirst,
    'disciplinas_aprovadas_primeiro_semestre': approvedFirst,
    'disciplinas_sem_avaliacao_primeiro_semestre':
        withoutEvaluationsFirst,

    'media_notas_segundo_semestre': averageGradeSecond,
    'frequencia_segundo_semestre': attendanceSecond,
    'creditos_segundo_semestre': creditsSecond,
    'disciplinas_matriculadas_segundo_semestre': enrolledSecond,
    'avaliacoes_segundo_semestre': evaluationsSecond,
    'disciplinas_aprovadas_segundo_semestre': approvedSecond,
    'disciplinas_sem_avaliacao_segundo_semestre':
        withoutEvaluationsSecond,
  };
}

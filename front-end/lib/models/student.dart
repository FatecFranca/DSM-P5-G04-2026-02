import 'form_options.dart';

/// Dados do estudante enviados ao modelo de previsão.
class Student {
  final String name;
  final String course;
  final String semester;
  final String shift;
  final int age;
  final String gender;
  final bool works;
  final String familyIncome;
  final bool hasScholarship;
  final double averageGrade;
  final double attendance; // 0 a 100
  final bool failedBefore;

  const Student({
    required this.name,
    required this.course,
    required this.semester,
    required this.shift,
    required this.age,
    required this.gender,
    required this.works,
    required this.familyIncome,
    required this.hasScholarship,
    required this.averageGrade,
    required this.attendance,
    required this.failedBefore,
  });

  /// Ex.: "ADS • 3º semestre • Noturno"
  String get summaryLine =>
      '${FormOptions.courseShort(course)} • $semester • $shift';

  /// Corpo do futuro POST /prediction.
  Map<String, dynamic> toJson() => {
        'name': name,
        'course': course,
        'semester': semester,
        'shift': shift,
        'age': age,
        'gender': gender,
        'works': works,
        'family_income': familyIncome,
        'has_scholarship': hasScholarship,
        'average_grade': averageGrade,
        'attendance': attendance,
        'failed_before': failedBefore,
      };
}

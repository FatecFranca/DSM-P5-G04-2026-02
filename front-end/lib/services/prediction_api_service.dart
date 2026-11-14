
import '../models/student.dart';
import '../models/prediction_result.dart';
import 'prediction_service.dart';
import 'api_client.dart';

class PredictionApiService implements PredictionService {
  @override
  Future<PredictionResult> predict(Student student) async {
    // 1. Cadastra os dados pessoais do estudante.
    final aluno = await ApiClient.post('/alunos/', {
      'nome': student.name,
      'estado_civil': student.maritalStatus!,
      'modo_ingresso': student.applicationMode!,
      'ordem_ingresso': student.applicationOrder!,
      'codigo_curso': student.courseCode,
      'turno_dataset': student.daytimeAttendance!,
      'qualificacao_anterior': student.previousQualification!,
      'nacionalidade': student.nationality!,
      'qualificacao_mae': student.motherQualification!,
      'qualificacao_pai': student.fatherQualification!,
      'ocupacao_mae': student.motherOccupation!,
      'ocupacao_pai': student.fatherOccupation!,
      'deslocado': student.displaced!,
      'necessidades_especiais': student.educationalSpecialNeeds!,
      'genero_codigo': student.genderCode!,
      'idade_ingresso': student.age,
      'internacional': student.international!,
    });

    final int alunoId = aluno['id'] as int;

    // 2. Cadastra os dados socioeconômicos.
    await ApiClient.post('/alunos/$alunoId/socioeconomicos', {
      'devedor': student.debtor!,
      'mensalidades_em_dia': student.tuitionFeesUpToDate!,
      'bolsista': student.hasScholarship,
    });

    // 3. Cadastra o desempenho do primeiro semestre.
    await ApiClient.post('/alunos/$alunoId/desempenho', {
      'semestre': 1,
      'creditos': student.creditsFirst!,
      'disciplinas_matriculadas': student.enrolledFirst!,
      'avaliacoes': student.evaluationsFirst!,
      'disciplinas_aprovadas': student.approvedFirst!,
      'media_notas': student.averageGradeFirst,
      'disciplinas_sem_avaliacao': student.withoutEvaluationsFirst!,
    });

    // 4. Cadastra o desempenho do segundo semestre.
    await ApiClient.post('/alunos/$alunoId/desempenho', {
      'semestre': 2,
      'creditos': student.creditsSecond!,
      'disciplinas_matriculadas': student.enrolledSecond!,
      'avaliacoes': student.evaluationsSecond!,
      'disciplinas_aprovadas': student.approvedSecond!,
      'media_notas': student.averageGradeSecond,
      'disciplinas_sem_avaliacao': student.withoutEvaluationsSecond!,
    });

    // 5. Solicita a previsão usando o ID do estudante cadastrado.
    final resultado = await ApiClient.post(
      '/prever?aluno_id=$alunoId',
      {},
    );

    // 6. Converte a resposta da API para o modelo do aplicativo.
    if (resultado is! Map) {
      throw const FormatException(
        'A API retornou uma resposta de previsão inválida.',
      );
    }

    return PredictionResult.fromJson(
      Map<String, dynamic>.from(resultado),
    );
  }
}

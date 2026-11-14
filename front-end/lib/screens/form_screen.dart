
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/form_options.dart';
import '../models/student.dart';
import '../services/mock_student_repository.dart';
import '../services/prediction_service.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/form_fields.dart';
import '../widgets/section_card.dart';
import 'result_screen.dart';

class FormScreen extends StatefulWidget {
  final PredictionService predictionService;
  final MockStudentRepository repository;
  final VoidCallback onSaved;

  const FormScreen({
    super.key,
    required this.predictionService,
    required this.repository,
    required this.onSaved,
  });

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Dados básicos
  final _name = TextEditingController();
  final _age = TextEditingController();

  // Desempenho do primeiro semestre
  final _gradeFirst = TextEditingController();
  final _attendanceFirst = TextEditingController();
  final _creditsFirst = TextEditingController();
  final _enrolledFirst = TextEditingController();
  final _evaluationsFirst = TextEditingController();
  final _approvedFirst = TextEditingController();
  final _withoutEvaluationsFirst = TextEditingController();

  // Desempenho do segundo semestre
  final _gradeSecond = TextEditingController();
  final _attendanceSecond = TextEditingController();
  final _creditsSecond = TextEditingController();
  final _enrolledSecond = TextEditingController();
  final _evaluationsSecond = TextEditingController();
  final _approvedSecond = TextEditingController();
  final _withoutEvaluationsSecond = TextEditingController();

  // Seleções acadêmicas
  String? _course;
  String? _semester;
  String? _shift;

  // Seleções pessoais
  String? _gender;
  String? _maritalStatus;
  String? _applicationMode;
  String? _applicationOrder;
  String? _previousQualification;
  String? _nationality;

  // Escolaridade e ocupação dos pais
  String? _motherQualification;
  String? _fatherQualification;
  String? _motherOccupation;
  String? _fatherOccupation;

  // Informações socioeconômicas
  String? _works;
  String? _income;
  String? _scholarship;
  String? _debtor;
  String? _feesUpToDate;
  String? _displaced;
  String? _specialNeeds;
  String? _international;
  String? _failed;

  bool _loading = false;
  String? _errorMessage;

  List<TextEditingController> get _controllers => [
        _name,
        _age,
        _gradeFirst,
        _attendanceFirst,
        _creditsFirst,
        _enrolledFirst,
        _evaluationsFirst,
        _approvedFirst,
        _withoutEvaluationsFirst,
        _gradeSecond,
        _attendanceSecond,
        _creditsSecond,
        _enrolledSecond,
        _evaluationsSecond,
        _approvedSecond,
        _withoutEvaluationsSecond,
      ];

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  double? _parse(String value) {
    return double.tryParse(value.trim().replaceAll(',', '.'));
  }

  int? _parseInt(String value) {
    return int.tryParse(value.trim());
  }

  String? _range(
    String? value,
    double min,
    double max,
    String unit,
  ) {
    final requiredError = _required(value);
    if (requiredError != null) return requiredError;

    final number = _parse(value!);

    if (number == null || number < min || number > max) {
      return 'Informe um valor entre $min e $max$unit';
    }

    return null;
  }

  String? _countValidator(String? value) {
    final requiredError = _required(value);
    if (requiredError != null) return requiredError;

    final number = _parseInt(value!);

    if (number == null || number < 0) {
      return 'Informe um número inteiro igual ou maior que zero';
    }

    return null;
  }

  bool _validateSelections() {
    final selections = [
      _course,
      _semester,
      _shift,
      _gender,
      _maritalStatus,
      _applicationMode,
      _applicationOrder,
      _previousQualification,
      _nationality,
      _motherQualification,
      _fatherQualification,
      _motherOccupation,
      _fatherOccupation,
      _works,
      _income,
      _scholarship,
      _debtor,
      _feesUpToDate,
      _displaced,
      _specialNeeds,
      _international,
      _failed,
    ];

    return selections.every((value) => value != null);
  }

  void _reset() {
    _formKey.currentState?.reset();

    for (final controller in _controllers) {
      controller.clear();
    }

    setState(() {
      _course = null;
      _semester = null;
      _shift = null;

      _gender = null;
      _maritalStatus = null;
      _applicationMode = null;
      _applicationOrder = null;
      _previousQualification = null;
      _nationality = null;

      _motherQualification = null;
      _fatherQualification = null;
      _motherOccupation = null;
      _fatherOccupation = null;

      _works = null;
      _income = null;
      _scholarship = null;
      _debtor = null;
      _feesUpToDate = null;
      _displaced = null;
      _specialNeeds = null;
      _international = null;
      _failed = null;

      _errorMessage = null;
    });
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      setState(() {
        _errorMessage = 'Revise os campos destacados em vermelho.';
      });
      return;
    }

    if (!_validateSelections()) {
      setState(() {
        _errorMessage = 'Preencha todas as opções dos campos de seleção.';
      });
      return;
    }

    final student = Student(
      // Dados básicos
      name: _name.text.trim(),
      course: _course!,
      courseCode: FormOptions.courseCodes[_course!]!,
      semester: _semester!,
      shift: _shift!,
      age: int.parse(_age.text.trim()),
      gender: _gender!,
      works: _works == 'Sim',
      familyIncome: _income!,
      hasScholarship: _scholarship == 'Sim',
      failedBefore: _failed == 'Sim',

      // Dados de ingresso
      maritalStatus: FormOptions.maritalStatusCodes[_maritalStatus!]!,
      applicationMode: FormOptions.applicationModeCodes[_applicationMode!]!,
      applicationOrder: FormOptions.applicationOrderCodes[_applicationOrder!]!,
      daytimeAttendance: FormOptions.shiftCodes[_shift!]!,
      previousQualification:
          FormOptions.previousQualificationCodes[_previousQualification!]!,
      nationality: FormOptions.nationalityCodes[_nationality!]!,

      // Escolaridade e ocupação dos pais
      motherQualification:
          FormOptions.motherQualificationCodes[_motherQualification!]!,
      fatherQualification:
          FormOptions.fatherQualificationCodes[_fatherQualification!]!,
      motherOccupation:
          FormOptions.motherOccupationCodes[_motherOccupation!]!,
      fatherOccupation:
          FormOptions.fatherOccupationCodes[_fatherOccupation!]!,

      // Dados pessoais
      genderCode: FormOptions.genderCodes[_gender!]!,
      displaced: _displaced == 'Sim',
      educationalSpecialNeeds: _specialNeeds == 'Sim',
      international: _international == 'Sim',

      // Dados socioeconômicos
      debtor: _debtor == 'Sim',
      tuitionFeesUpToDate: _feesUpToDate == 'Sim',

      // Primeiro semestre
      averageGradeFirst: _parse(_gradeFirst.text)!,
      attendanceFirst: _parse(_attendanceFirst.text)!,
      creditsFirst: _parseInt(_creditsFirst.text)!,
      enrolledFirst: _parseInt(_enrolledFirst.text)!,
      evaluationsFirst: _parseInt(_evaluationsFirst.text)!,
      approvedFirst: _parseInt(_approvedFirst.text)!,
      withoutEvaluationsFirst:
          _parseInt(_withoutEvaluationsFirst.text)!,

      // Segundo semestre
      averageGradeSecond: _parse(_gradeSecond.text)!,
      attendanceSecond: _parse(_attendanceSecond.text)!,
      creditsSecond: _parseInt(_creditsSecond.text)!,
      enrolledSecond: _parseInt(_enrolledSecond.text)!,
      evaluationsSecond: _parseInt(_evaluationsSecond.text)!,
      approvedSecond: _parseInt(_approvedSecond.text)!,
      withoutEvaluationsSecond:
          _parseInt(_withoutEvaluationsSecond.text)!,
    );

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final result = await widget.predictionService.predict(student);

      if (!mounted) return;

      setState(() => _loading = false);

      final saved = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            student: student,
            result: result,
            repository: widget.repository,
          ),
        ),
      );

      if (saved == true && mounted) {
        _reset();
        widget.onSaved();
      }
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _errorMessage = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Form(
        key: _formKey,
        child: AbsorbPointer(
          absorbing: _loading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Novo Registro',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Preencha os dados do estudante para realizar a previsão de evasão.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14.5,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),

              _academic(),
              const SizedBox(height: 16),

              _personal(),
              const SizedBox(height: 16),

              _family(),
              const SizedBox(height: 16),

              _socioeconomic(),
              const SizedBox(height: 16),

              _performance(),
              const SizedBox(height: 20),

              if (_errorMessage != null) _errorBanner(),

              CustomButton(
                label: 'Enviar para previsão',
                icon: Icons.send_rounded,
                loading: _loading,
                onPressed: _submit,
              ),

              if (_loading)
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Center(
                    child: Text(
                      'Analisando dados do estudante...',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 14);

  Widget _dropdown({
    required String label,
    required List<String> items,
    required String? value,
    required ValueChanged<String?> onChanged,
    String? hint,
    IconData? icon,
  }) {
    return AppDropdown(
      label: label,
      hint: hint ?? 'Selecione uma opção',
      icon: icon,
      items: items,
      value: value,
      onChanged: (newValue) {
        setState(() {
          onChanged(newValue);
        });
      },
    );
  }

  Widget _academic() => SectionCard(
        title: 'Informações Acadêmicas',
        icon: Icons.menu_book_outlined,
        child: Column(
          children: [
            AppTextField(
              label: 'Nome do estudante',
              hint: 'Ex.: Ana Souza',
              icon: Icons.person_outline,
              controller: _name,
              validator: _required,
            ),
            _gap(),
            _dropdown(
              label: 'Curso',
              items: FormOptions.courses.keys.toList(),
              value: _course,
              onChanged: (v) => _course = v,
              icon: Icons.school_outlined,
            ),
            _gap(),
            _dropdown(
              label: 'Período atual',
              items: FormOptions.semesters,
              value: _semester,
              onChanged: (v) => _semester = v,
              icon: Icons.calendar_today_outlined,
            ),
            _gap(),
            _dropdown(
              label: 'Turno',
              items: FormOptions.shifts,
              value: _shift,
              onChanged: (v) => _shift = v,
              icon: Icons.schedule,
            ),
          ],
        ),
      );

  Widget _personal() => SectionCard(
        title: 'Dados Pessoais e Ingresso',
        icon: Icons.person_outline,
        child: Column(
          children: [
            AppTextField(
              label: 'Idade ao ingressar',
              hint: 'Ex.: 20',
              icon: Icons.cake_outlined,
              controller: _age,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (v) => _range(v, 14, 100, ' anos'),
            ),
            _gap(),
            _dropdown(
              label: 'Gênero',
              items: FormOptions.genders,
              value: _gender,
              onChanged: (v) => _gender = v,
            ),
            _gap(),
            _dropdown(
              label: 'Estado civil',
              items: FormOptions.maritalStatuses,
              value: _maritalStatus,
              onChanged: (v) => _maritalStatus = v,
            ),
            _gap(),
            _dropdown(
              label: 'Nacionalidade',
              items: FormOptions.nationalities,
              value: _nationality,
              onChanged: (v) => _nationality = v,
            ),
            _gap(),
            _dropdown(
              label: 'Forma de ingresso',
              items: FormOptions.applicationModes,
              value: _applicationMode,
              onChanged: (v) => _applicationMode = v,
            ),
            _gap(),
            _dropdown(
              label: 'Ordem da opção de ingresso',
              items: FormOptions.applicationOrders,
              value: _applicationOrder,
              onChanged: (v) => _applicationOrder = v,
            ),
            _gap(),
            _dropdown(
              label: 'Escolaridade anterior',
              items: FormOptions.previousQualifications,
              value: _previousQualification,
              onChanged: (v) => _previousQualification = v,
            ),
          ],
        ),
      );

  Widget _family() => SectionCard(
        title: 'Informações Familiares',
        icon: Icons.groups_outlined,
        child: Column(
          children: [
            _dropdown(
              label: 'Escolaridade da mãe',
              items: FormOptions.motherQualifications,
              value: _motherQualification,
              onChanged: (v) => _motherQualification = v,
            ),
            _gap(),
            _dropdown(
              label: 'Ocupação da mãe',
              items: FormOptions.motherOccupations,
              value: _motherOccupation,
              onChanged: (v) => _motherOccupation = v,
            ),
            _gap(),
            _dropdown(
              label: 'Escolaridade do pai',
              items: FormOptions.fatherQualifications,
              value: _fatherQualification,
              onChanged: (v) => _fatherQualification = v,
            ),
            _gap(),
            _dropdown(
              label: 'Ocupação do pai',
              items: FormOptions.fatherOccupations,
              value: _fatherOccupation,
              onChanged: (v) => _fatherOccupation = v,
            ),
          ],
        ),
      );

  Widget _socioeconomic() => SectionCard(
        title: 'Dados Socioeconômicos',
        icon: Icons.account_balance_outlined,
        child: Column(
          children: [
            _dropdown(
              label: 'Trabalha?',
              items: FormOptions.yesNo,
              value: _works,
              onChanged: (v) => _works = v,
            ),
            _gap(),
            _dropdown(
              label: 'Renda familiar',
              items: FormOptions.incomes,
              value: _income,
              onChanged: (v) => _income = v,
            ),
            _gap(),
            _dropdown(
              label: 'Possui bolsa de estudos?',
              items: FormOptions.yesNo,
              value: _scholarship,
              onChanged: (v) => _scholarship = v,
            ),
            _gap(),
            _dropdown(
              label: 'Possui dívida com a instituição?',
              items: FormOptions.yesNo,
              value: _debtor,
              onChanged: (v) => _debtor = v,
            ),
            _gap(),
            _dropdown(
              label: 'Mensalidades em dia?',
              items: FormOptions.yesNo,
              value: _feesUpToDate,
              onChanged: (v) => _feesUpToDate = v,
            ),
            _gap(),
            _dropdown(
              label: 'É deslocado da região de origem?',
              items: FormOptions.yesNo,
              value: _displaced,
              onChanged: (v) => _displaced = v,
            ),
            _gap(),
            _dropdown(
              label: 'Possui necessidades educacionais especiais?',
              items: FormOptions.yesNo,
              value: _specialNeeds,
              onChanged: (v) => _specialNeeds = v,
            ),
            _gap(),
            _dropdown(
              label: 'É estudante internacional?',
              items: FormOptions.yesNo,
              value: _international,
              onChanged: (v) => _international = v,
            ),
          ],
        ),
      );

  Widget _numberField({
    required String label,
    required TextEditingController controller,
  }) {
    return AppTextField(
      label: label,
      hint: 'Ex.: 5',
      icon: Icons.numbers,
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      validator: _countValidator,
    );
  }

  Widget _gradeField({
    required String label,
    required TextEditingController controller,
  }) {
    return AppTextField(
      label: label,
      hint: 'Ex.: 7,5',
      icon: Icons.grade_outlined,
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
      ],
      validator: (v) => _range(v, 0, 10, ''),
    );
  }

  Widget _attendanceField({
    required String label,
    required TextEditingController controller,
  }) {
    return AppTextField(
      label: label,
      hint: 'Ex.: 85',
      icon: Icons.fact_check_outlined,
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
      ],
      validator: (v) => _range(v, 0, 100, '%'),
    );
  }

  Widget _semesterPerformance({
    required String title,
    required TextEditingController grade,
    required TextEditingController attendance,
    required TextEditingController credits,
    required TextEditingController enrolled,
    required TextEditingController evaluations,
    required TextEditingController approved,
    required TextEditingController withoutEvaluations,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            fontSize: 16,
          ),
        ),
        _gap(),
        _gradeField(
          label: 'Média das notas - $title (0 a 10)',
          controller: grade,
        ),
        _gap(),
        _attendanceField(
          label: 'Frequência - $title (%)',
          controller: attendance,
        ),
        _gap(),
        _numberField(
          label: 'Créditos obtidos - $title',
          controller: credits,
        ),
        _gap(),
        _numberField(
          label: 'Disciplinas matriculadas - $title',
          controller: enrolled,
        ),
        _gap(),
        _numberField(
          label: 'Avaliações realizadas - $title',
          controller: evaluations,
        ),
        _gap(),
        _numberField(
          label: 'Disciplinas aprovadas - $title',
          controller: approved,
        ),
        _gap(),
        _numberField(
          label: 'Disciplinas sem avaliação - $title',
          controller: withoutEvaluations,
        ),
      ],
    );
  }

  Widget _performance() => SectionCard(
        title: 'Desempenho Acadêmico',
        icon: Icons.insights_outlined,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _semesterPerformance(
              title: '1º Semestre',
              grade: _gradeFirst,
              attendance: _attendanceFirst,
              credits: _creditsFirst,
              enrolled: _enrolledFirst,
              evaluations: _evaluationsFirst,
              approved: _approvedFirst,
              withoutEvaluations: _withoutEvaluationsFirst,
            ),
            const Divider(height: 32),
            _semesterPerformance(
              title: '2º Semestre',
              grade: _gradeSecond,
              attendance: _attendanceSecond,
              credits: _creditsSecond,
              enrolled: _enrolledSecond,
              evaluations: _evaluationsSecond,
              approved: _approvedSecond,
              withoutEvaluations: _withoutEvaluationsSecond,
            ),
            const Divider(height: 24),
            _dropdown(
              label: 'Já reprovou alguma disciplina?',
              items: FormOptions.yesNo,
              value: _failed,
              onChanged: (v) => _failed = v,
            ),
          ],
        ),
      );

  Widget _errorBanner() => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.dangerBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.danger,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _errorMessage!,
                style: const TextStyle(
                  color: AppColors.danger,
                ),
              ),
            ),
          ],
        ),
      );
}

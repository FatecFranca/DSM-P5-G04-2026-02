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
  final _name = TextEditingController();
  final _age = TextEditingController();
  final _grade = TextEditingController();
  final _attendance = TextEditingController();

  String? _course, _semester, _shift, _gender, _works, _income, _scholarship, _failed;
  bool _loading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _name.dispose();
    _age.dispose();
    _grade.dispose();
    _attendance.dispose();
    super.dispose();
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Campo obrigatório' : null;

  double? _parse(String s) => double.tryParse(s.trim().replaceAll(',', '.'));

  String? _range(String? v, double min, double max, String unit) {
    final req = _required(v);
    if (req != null) return req;
    final n = _parse(v!);
    if (n == null || n < min || n > max) {
      return 'Informe um valor entre ${min.toInt()} e ${max.toInt()}$unit';
    }
    return null;
  }

  void _reset() {
    _formKey.currentState?.reset();
    _name.clear();
    _age.clear();
    _grade.clear();
    _attendance.clear();
    setState(() {
      _course = _semester = _shift = _gender = null;
      _works = _income = _scholarship = _failed = null;
      _errorMessage = null;
    });
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      setState(() => _errorMessage = 'Revise os campos destacados em vermelho.');
      return;
    }
    final student = Student(
      name: _name.text.trim(),
      course: _course!,
      semester: _semester!,
      shift: _shift!,
      age: int.parse(_age.text.trim()),
      gender: _gender!,
      works: _works == 'Sim',
      familyIncome: _income!,
      hasScholarship: _scholarship == 'Sim',
      averageGrade: _parse(_grade.text)!,
      attendance: _parse(_attendance.text)!,
      failedBefore: _failed == 'Sim',
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
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _errorMessage =
            'Não foi possível obter a previsão. Verifique a conexão e tente novamente.';
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
              const Text('Novo Registro',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              const Text(
                'Preencha os dados do estudante para que o modelo de Machine '
                'Learning possa realizar a previsão de evasão.',
                style: TextStyle(
                    color: AppColors.textSecondary, fontSize: 14.5, height: 1.4),
              ),
              const SizedBox(height: 20),
              _academic(),
              const SizedBox(height: 16),
              _personal(),
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
                    child: Text('Analisando dados do estudante...',
                        style: TextStyle(color: AppColors.textSecondary)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 14);

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
            AppDropdown(
              label: 'Curso',
              hint: 'Selecione o curso',
              icon: Icons.school_outlined,
              items: FormOptions.courses.keys.toList(),
              value: _course,
              onChanged: (v) => setState(() => _course = v),
            ),
            _gap(),
            AppDropdown(
              label: 'Período atual',
              hint: 'Selecione o período',
              icon: Icons.calendar_today_outlined,
              items: FormOptions.semesters,
              value: _semester,
              onChanged: (v) => setState(() => _semester = v),
            ),
            _gap(),
            AppDropdown(
              label: 'Turno',
              hint: 'Selecione o turno',
              icon: Icons.schedule,
              items: FormOptions.shifts,
              value: _shift,
              onChanged: (v) => setState(() => _shift = v),
            ),
          ],
        ),
      );

  Widget _personal() => SectionCard(
        title: 'Dados Pessoais e Socioeconômicos',
        icon: Icons.groups_outlined,
        child: Column(
          children: [
            AppTextField(
              label: 'Idade',
              hint: 'Ex.: 20',
              icon: Icons.cake_outlined,
              controller: _age,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) => _range(v, 14, 100, ' anos'),
            ),
            _gap(),
            AppDropdown(
              label: 'Gênero',
              items: FormOptions.genders,
              value: _gender,
              onChanged: (v) => setState(() => _gender = v),
            ),
            _gap(),
            AppDropdown(
              label: 'Trabalha?',
              items: FormOptions.yesNo,
              value: _works,
              onChanged: (v) => setState(() => _works = v),
            ),
            _gap(),
            AppDropdown(
              label: 'Renda familiar (faixa)',
              items: FormOptions.incomes,
              value: _income,
              onChanged: (v) => setState(() => _income = v),
            ),
            _gap(),
            AppDropdown(
              label: 'Possui bolsa de estudos?',
              items: FormOptions.yesNo,
              value: _scholarship,
              onChanged: (v) => setState(() => _scholarship = v),
            ),
          ],
        ),
      );

  Widget _performance() => SectionCard(
        title: 'Desempenho Acadêmico',
        icon: Icons.insights_outlined,
        child: Column(
          children: [
            AppTextField(
              label: 'Média das notas',
              hint: 'Ex.: 7,5',
              icon: Icons.grade_outlined,
              controller: _grade,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))
              ],
              validator: (v) => _range(v, 0, 10, ''),
            ),
            _gap(),
            AppTextField(
              label: 'Frequência (%)',
              hint: 'Ex.: 85',
              icon: Icons.fact_check_outlined,
              controller: _attendance,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))
              ],
              textInputAction: TextInputAction.done,
              validator: (v) => _range(v, 0, 100, '%'),
            ),
            _gap(),
            AppDropdown(
              label: 'Já reprovou alguma disciplina?',
              items: FormOptions.yesNo,
              value: _failed,
              onChanged: (v) => setState(() => _failed = v),
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
            const Icon(Icons.error_outline, color: AppColors.danger),
            const SizedBox(width: 10),
            Expanded(
              child: Text(_errorMessage!,
                  style: const TextStyle(color: AppColors.danger)),
            ),
          ],
        ),
      );
}

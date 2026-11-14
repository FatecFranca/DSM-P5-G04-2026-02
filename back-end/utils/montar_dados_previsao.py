
from fastapi import HTTPException
from sqlalchemy.orm import Session

from database.models import (
    Aluno,
    DadosSocioeconomicos,
    DesempenhoAcademico
)

from utils.referencias import (
    CURSO_REFERENCIA,
    TAXA_DESEMPREGO,
    TAXA_INFLACAO,
    PIB
)


def montar_dados_previsao(aluno_id: int, db: Session):

    # Busca o estudante
    aluno = db.query(Aluno).filter(
        Aluno.id == aluno_id
    ).first()

    if aluno is None:
        raise HTTPException(
            status_code=404,
            detail="Estudante não encontrado."
        )

    # Busca os dados socioeconômicos
    socioeconomico = db.query(DadosSocioeconomicos).filter(
        DadosSocioeconomicos.aluno_id == aluno_id
    ).first()

    if socioeconomico is None:
        raise HTTPException(
            status_code=400,
            detail="Dados socioeconômicos não cadastrados."
        )

    # Busca os desempenhos acadêmicos
    desempenhos = db.query(DesempenhoAcademico).filter(
        DesempenhoAcademico.aluno_id == aluno_id
    ).all()

    desempenhos_por_semestre = {
        desempenho.semestre: desempenho
        for desempenho in desempenhos
    }

    # Verifica se os dois primeiros semestres estão cadastrados
    if 1 not in desempenhos_por_semestre or 2 not in desempenhos_por_semestre:
        raise HTTPException(
            status_code=400,
            detail="É necessário cadastrar o desempenho do primeiro e do segundo semestre para realizar a previsão."
        )

    primeiro = desempenhos_por_semestre[1]
    segundo = desempenhos_por_semestre[2]

    # Monta os dados pessoais e socioeconômicos
    dados = {
        "Marital status": aluno.estado_civil,
        "Application mode": aluno.modo_ingresso,
        "Application order": aluno.ordem_ingresso,
        "Course": CURSO_REFERENCIA,
        "Daytime/evening attendance": aluno.turno_dataset,
        "Previous qualification": aluno.qualificacao_anterior,
        "Nacionality": aluno.nacionalidade,
        "Mother's qualification": aluno.qualificacao_mae,
        "Father's qualification": aluno.qualificacao_pai,
        "Mother's occupation": aluno.ocupacao_mae,
        "Father's occupation": aluno.ocupacao_pai,
        "Displaced": int(aluno.deslocado) if aluno.deslocado is not None else None,
        "Educational special needs": int(aluno.necessidades_especiais) if aluno.necessidades_especiais is not None else None,
        "Debtor": int(socioeconomico.devedor),
        "Tuition fees up to date": int(socioeconomico.mensalidades_em_dia),
        "Gender": aluno.genero_codigo,
        "Scholarship holder": int(socioeconomico.bolsista),
        "Age at enrollment": aluno.idade_ingresso,
        "International": int(aluno.internacional) if aluno.internacional is not None else None,

        # Primeiro semestre
        "Curricular units 1st sem (credited)": primeiro.creditos,
        "Curricular units 1st sem (enrolled)": primeiro.disciplinas_matriculadas,
        "Curricular units 1st sem (evaluations)": primeiro.avaliacoes,
        "Curricular units 1st sem (approved)": primeiro.disciplinas_aprovadas,
        "Curricular units 1st sem (grade)": float(primeiro.media_notas) * 2,
        "Curricular units 1st sem (without evaluations)": primeiro.disciplinas_sem_avaliacao,

        # Segundo semestre
        "Curricular units 2nd sem (credited)": segundo.creditos,
        "Curricular units 2nd sem (enrolled)": segundo.disciplinas_matriculadas,
        "Curricular units 2nd sem (evaluations)": segundo.avaliacoes,
        "Curricular units 2nd sem (approved)": segundo.disciplinas_aprovadas,
        "Curricular units 2nd sem (grade)": float(segundo.media_notas) * 2,
        "Curricular units 2nd sem (without evaluations)": segundo.disciplinas_sem_avaliacao,

        # Indicadores econômicos de referência
        "Unemployment rate": TAXA_DESEMPREGO,
        "Inflation rate": TAXA_INFLACAO,
        "GDP": PIB
    }

    # Verifica se algum dado obrigatório está vazio
    campos_vazios = [
        campo
        for campo, valor in dados.items()
        if valor is None
    ]

    if campos_vazios:
        raise HTTPException(
            status_code=400,
            detail={
                "erro": "Existem dados obrigatórios não cadastrados.",
                "campos": campos_vazios
            }
        )

    return dados

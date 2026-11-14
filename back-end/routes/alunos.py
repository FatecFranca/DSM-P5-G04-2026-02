
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from database.connection import get_db

from schemas.aluno import AlunoCreate, AlunoResponse

from database.models import Aluno, DadosSocioeconomicos, DesempenhoAcademico, Previsao
from schemas.previsao import PrevisaoResponse

from schemas.desempenho import (
    DesempenhoCreate,
    DesempenhoResponse
)

from schemas.socioeconomico import (
    SocioeconomicoCreate,
    SocioeconomicoResponse
)

router = APIRouter(
    prefix="/alunos",
    tags=["Alunos"]
)


# Cadastrar estudante
@router.post("/", response_model=AlunoResponse, status_code=201)
def cadastrar_aluno(
    dados: AlunoCreate,
    db: Session = Depends(get_db)
):
    try:
        novo_aluno = Aluno(**dados.model_dump())

        db.add(novo_aluno)
        db.commit()
        db.refresh(novo_aluno)

        return novo_aluno

    except Exception as erro:
        db.rollback()
        print(f"Erro ao cadastrar estudante: {erro}")
        raise HTTPException(
            status_code=500,
            detail="Erro ao cadastrar estudante."
        )

# Consultar estudante pelo ID
@router.get("/{aluno_id}", response_model=AlunoResponse)
def consultar_aluno(
    aluno_id: int,
    db: Session = Depends(get_db)
):
    aluno = db.query(Aluno).filter(
        Aluno.id == aluno_id
    ).first()

    if aluno is None:
        raise HTTPException(
            status_code=404,
            detail="Estudante não encontrado."
        )

    return aluno

# Cadastrar dados socioeconômicos de um estudante
@router.post(
    "/{aluno_id}/socioeconomicos",
    response_model=SocioeconomicoResponse,
    status_code=201
)
def cadastrar_dados_socioeconomicos(
    aluno_id: int,
    dados: SocioeconomicoCreate,
    db: Session = Depends(get_db)
):
    # Verifica se o estudante existe
    aluno = db.query(Aluno).filter(
        Aluno.id == aluno_id
    ).first()

    if aluno is None:
        raise HTTPException(
            status_code=404,
            detail="Estudante não encontrado."
        )

    # Verifica se já existem dados socioeconômicos cadastrados
    existente = db.query(DadosSocioeconomicos).filter(
        DadosSocioeconomicos.aluno_id == aluno_id
    ).first()

    if existente:
        raise HTTPException(
            status_code=409,
            detail="Os dados socioeconômicos deste estudante já foram cadastrados."
        )

    try:
        novos_dados = DadosSocioeconomicos(
            aluno_id=aluno_id,
            **dados.model_dump()
        )

        db.add(novos_dados)
        db.commit()
        db.refresh(novos_dados)

        return novos_dados

    except Exception as erro:
        db.rollback()
        print(f"Erro ao cadastrar dados socioeconômicos: {erro}")

        raise HTTPException(
            status_code=500,
            detail="Erro ao cadastrar dados socioeconômicos."
        )


# Cadastrar desempenho acadêmico de um estudante
@router.post(
    "/{aluno_id}/desempenho",
    response_model=DesempenhoResponse,
    status_code=201
)
def cadastrar_desempenho(
    aluno_id: int,
    dados: DesempenhoCreate,
    db: Session = Depends(get_db)
):
    # Verifica se o estudante existe
    aluno = db.query(Aluno).filter(
        Aluno.id == aluno_id
    ).first()

    if aluno is None:
        raise HTTPException(
            status_code=404,
            detail="Estudante não encontrado."
        )

    # Verifica se já existe desempenho para esse semestre
    existente = db.query(DesempenhoAcademico).filter(
        DesempenhoAcademico.aluno_id == aluno_id,
        DesempenhoAcademico.semestre == dados.semestre
    ).first()

    if existente:
        raise HTTPException(
            status_code=409,
            detail="Já existe um desempenho cadastrado para este semestre."
        )

    try:
        novo_desempenho = DesempenhoAcademico(
            aluno_id=aluno_id,
            **dados.model_dump()
        )

        db.add(novo_desempenho)
        db.commit()
        db.refresh(novo_desempenho)

        return novo_desempenho

    except Exception as erro:
        db.rollback()
        print(f"Erro ao cadastrar desempenho acadêmico: {erro}")

        raise HTTPException(
            status_code=500,
            detail="Erro ao cadastrar desempenho acadêmico."
        )

# Consultar histórico de desempenho acadêmico
@router.get(
    "/{aluno_id}/desempenho",
    response_model=list[DesempenhoResponse]
)
def consultar_desempenho(
    aluno_id: int,
    db: Session = Depends(get_db)
):
    # Verifica se o estudante existe
    aluno = db.query(Aluno).filter(
        Aluno.id == aluno_id
    ).first()

    if aluno is None:
        raise HTTPException(
            status_code=404,
            detail="Estudante não encontrado."
        )

    desempenhos = db.query(DesempenhoAcademico).filter(
        DesempenhoAcademico.aluno_id == aluno_id
    ).order_by(
        DesempenhoAcademico.semestre
    ).all()

    return desempenhos

# Consultar dados socioeconômicos de um estudante
@router.get(
    "/{aluno_id}/socioeconomicos",
    response_model=SocioeconomicoResponse
)
def consultar_dados_socioeconomicos(
    aluno_id: int,
    db: Session = Depends(get_db)
):
    aluno = db.query(Aluno).filter(
        Aluno.id == aluno_id
    ).first()

    if aluno is None:
        raise HTTPException(
            status_code=404,
            detail="Estudante não encontrado."
        )

    dados = db.query(DadosSocioeconomicos).filter(
        DadosSocioeconomicos.aluno_id == aluno_id
    ).first()

    if dados is None:
        raise HTTPException(
            status_code=404,
            detail="Dados socioeconômicos não encontrados."
        )

    return dados


# Consultar histórico de previsões do estudante
@router.get(
    "/{aluno_id}/previsoes",
    response_model=list[PrevisaoResponse]
)
def consultar_previsoes(
    aluno_id: int,
    db: Session = Depends(get_db)
):
    # Verifica se o estudante existe
    aluno = db.query(Aluno).filter(Aluno.id == aluno_id).first()

    if aluno is None:
        raise HTTPException(
            status_code=404,
            detail="Estudante não encontrado."
        )

    # Busca as previsões do estudante
    previsoes = (
        db.query(Previsao)
        .filter(Previsao.aluno_id == aluno_id)
        .order_by(Previsao.data_previsao.desc())
        .all()
    )

    return previsoes

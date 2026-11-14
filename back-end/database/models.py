
from sqlalchemy import (
    Column,
    BigInteger,
    Integer,
    SmallInteger,
    String,
    Boolean,
    Numeric,
    DateTime,
    ForeignKey,
    JSON,
    UniqueConstraint
)

from database.connection import Base


# ==========================================
# TABELA: alunos
# ==========================================

class Aluno(Base):
    __tablename__ = "alunos"

    id = Column(BigInteger, primary_key=True, autoincrement=True)

    nome = Column(String, nullable=False)

    # Campos antigos
    curso = Column(String, nullable=True)
    semestre = Column(String, nullable=True)
    turno = Column(String, nullable=True)
    idade = Column(Integer, nullable=True)
    genero = Column(String, nullable=True)
    trabalha = Column(Boolean, nullable=True)
    renda_familiar = Column(String, nullable=True)
    possui_bolsa = Column(Boolean, nullable=True)
    media_notas = Column(Numeric, nullable=True)
    frequencia = Column(Numeric, nullable=True)
    reprovou_anteriormente = Column(Boolean, nullable=True)

    criado_em = Column(DateTime(timezone=True), nullable=True)

    # Dados pessoais e de ingresso
    estado_civil = Column(SmallInteger, nullable=True)
    modo_ingresso = Column(Integer, nullable=True)
    ordem_ingresso = Column(SmallInteger, nullable=True)
    codigo_curso = Column(SmallInteger, nullable=True)
    turno_dataset = Column(SmallInteger, nullable=True)
    qualificacao_anterior = Column(SmallInteger, nullable=True)
    nacionalidade = Column(SmallInteger, nullable=True)
    qualificacao_mae = Column(SmallInteger, nullable=True)
    qualificacao_pai = Column(SmallInteger, nullable=True)
    ocupacao_mae = Column(SmallInteger, nullable=True)
    ocupacao_pai = Column(SmallInteger, nullable=True)
    deslocado = Column(Boolean, nullable=True)
    necessidades_especiais = Column(Boolean, nullable=True)
    genero_codigo = Column(SmallInteger, nullable=True)
    idade_ingresso = Column(SmallInteger, nullable=True)
    internacional = Column(Boolean, nullable=True)

    atualizado_em = Column(DateTime(timezone=True), nullable=True)


# ==========================================
# TABELA: dados_socioeconomicos
# ==========================================

class DadosSocioeconomicos(Base):
    __tablename__ = "dados_socioeconomicos"

    id = Column(BigInteger, primary_key=True, autoincrement=True)

    aluno_id = Column(
        BigInteger,
        ForeignKey("alunos.id"),
        nullable=False,
        unique=True
    )

    devedor = Column(Boolean, nullable=False)
    mensalidades_em_dia = Column(Boolean, nullable=False)
    bolsista = Column(Boolean, nullable=False)

    atualizado_em = Column(DateTime(timezone=True), nullable=True)


# ==========================================
# TABELA: desempenho_academico
# ==========================================

class DesempenhoAcademico(Base):
    __tablename__ = "desempenho_academico"

    id = Column(BigInteger, primary_key=True, autoincrement=True)

    aluno_id = Column(
        BigInteger,
        ForeignKey("alunos.id"),
        nullable=False
    )

    semestre = Column(SmallInteger, nullable=False)

    creditos = Column(Integer, nullable=False)
    disciplinas_matriculadas = Column(Integer, nullable=False)
    avaliacoes = Column(Integer, nullable=False)
    disciplinas_aprovadas = Column(Integer, nullable=False)
    media_notas = Column(Numeric(6, 2), nullable=False)
    disciplinas_sem_avaliacao = Column(Integer, nullable=False)

    criado_em = Column(DateTime(timezone=True), nullable=True)

    __table_args__ = (
        UniqueConstraint(
            "aluno_id",
            "semestre",
            name="uk_aluno_semestre"
        ),
    )


# ==========================================
# TABELA: previsoes
# ==========================================

class Previsao(Base):
    __tablename__ = "previsoes"

    id = Column(BigInteger, primary_key=True, autoincrement=True)

    aluno_id = Column(
        BigInteger,
        ForeignKey("alunos.id"),
        nullable=False
    )

    resultado = Column(String, nullable=True)
    data_previsao = Column(DateTime(timezone=True), nullable=True)
    risco = Column(String, nullable=True)

    probabilidades = Column(JSON, nullable=True)
    dados_utilizados = Column(JSON, nullable=True)

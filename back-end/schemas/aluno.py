
from pydantic import BaseModel, ConfigDict, Field


class AlunoCreate(BaseModel):
    nome: str = Field(min_length=1, max_length=150)

    estado_civil: int
    modo_ingresso: int
    ordem_ingresso: int

    # Cursos disponíveis no aplicativo:
    # 1 - Gestão de RH
    # 2 - Gestão de Produção Industrial
    # 3 - Desenvolvimento de Software Multiplataforma
    # 4 - Desenvolvimento de Sistemas
    codigo_curso: int = Field(
        ge=1,
        le=4,
        description="Código do curso, de 1 a 4."
    )

    turno_dataset: int
    qualificacao_anterior: int
    nacionalidade: int
    qualificacao_mae: int
    qualificacao_pai: int
    ocupacao_mae: int
    ocupacao_pai: int

    deslocado: bool
    necessidades_especiais: bool

    genero_codigo: int
    idade_ingresso: int = Field(gt=0)

    internacional: bool


class AlunoResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    nome: str
    codigo_curso: int | None = None
    idade_ingresso: int | None = None

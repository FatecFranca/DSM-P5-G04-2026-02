
from pydantic import BaseModel, ConfigDict, Field


class DesempenhoCreate(BaseModel):
    semestre: int = Field(ge=1, le=2)

    creditos: int = Field(ge=0)
    disciplinas_matriculadas: int = Field(ge=0)
    avaliacoes: int = Field(ge=0)
    disciplinas_aprovadas: int = Field(ge=0)

    media_notas: float = Field(ge=0, le=10)

    disciplinas_sem_avaliacao: int = Field(ge=0)


class DesempenhoResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    aluno_id: int
    semestre: int
    creditos: int
    disciplinas_matriculadas: int
    avaliacoes: int
    disciplinas_aprovadas: int
    media_notas: float
    disciplinas_sem_avaliacao: int

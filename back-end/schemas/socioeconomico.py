
from pydantic import BaseModel, ConfigDict


class SocioeconomicoCreate(BaseModel):
    devedor: bool
    mensalidades_em_dia: bool
    bolsista: bool


class SocioeconomicoResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    aluno_id: int
    devedor: bool
    mensalidades_em_dia: bool
    bolsista: bool

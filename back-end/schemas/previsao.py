
from datetime import datetime
from pydantic import BaseModel, ConfigDict


class PrevisaoResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    aluno_id: int
    resultado: str | None = None
    data_previsao: datetime | None = None
    risco: str | None = None
    probabilidades: dict[str, float] | None = None

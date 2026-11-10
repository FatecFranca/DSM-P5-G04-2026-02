
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pathlib import Path
from pydantic import BaseModel, Field, ConfigDict
import pandas as pd
import joblib
import math


# Modelo de entrada dos dados do estudante
class DadosEstudante(BaseModel):
    model_config = ConfigDict(
        populate_by_name=True,
        extra="forbid",
        allow_inf_nan=False
    )

    marital_status: float = Field(alias="Marital status", description="Estado civil do estudante")
    application_mode: float = Field(alias="Application mode", description="Modalidade de candidatura")
    application_order: float = Field(alias="Application order", description="Ordem de candidatura")
    course: float = Field(alias="Course", description="Curso escolhido")
    attendance: float = Field(alias="Daytime/evening attendance", description="Turno de frequência")
    previous_qualification: float = Field(alias="Previous qualification", description="Qualificação anterior")
    nationality: float = Field(alias="Nacionality", description="Nacionalidade")
    mother_qualification: float = Field(alias="Mother's qualification", description="Qualificação da mãe")
    father_qualification: float = Field(alias="Father's qualification", description="Qualificação do pai")
    mother_occupation: float = Field(alias="Mother's occupation", description="Ocupação da mãe")
    father_occupation: float = Field(alias="Father's occupation", description="Ocupação do pai")
    displaced: float = Field(alias="Displaced", description="Estudante deslocado")
    special_needs: float = Field(alias="Educational special needs", description="Necessidades educacionais especiais")
    debtor: float = Field(alias="Debtor", description="Possui dívida")
    tuition_fees: float = Field(alias="Tuition fees up to date", description="Mensalidades em dia")
    gender: float = Field(alias="Gender", description="Gênero registrado na base")
    scholarship_holder: float = Field(alias="Scholarship holder", description="Possui bolsa de estudos")
    age: float = Field(alias="Age at enrollment", description="Idade no ingresso")
    international: float = Field(alias="International", description="Estudante internacional")

    credited_1st: float = Field(alias="Curricular units 1st sem (credited)", description="Disciplinas creditadas no primeiro semestre")
    enrolled_1st: float = Field(alias="Curricular units 1st sem (enrolled)", description="Disciplinas matriculadas no primeiro semestre")
    evaluations_1st: float = Field(alias="Curricular units 1st sem (evaluations)", description="Avaliações no primeiro semestre")
    approved_1st: float = Field(alias="Curricular units 1st sem (approved)", description="Disciplinas aprovadas no primeiro semestre")
    grade_1st: float = Field(alias="Curricular units 1st sem (grade)", description="Nota do primeiro semestre")
    without_evaluations_1st: float = Field(alias="Curricular units 1st sem (without evaluations)", description="Disciplinas sem avaliação no primeiro semestre")

    credited_2nd: float = Field(alias="Curricular units 2nd sem (credited)", description="Disciplinas creditadas no segundo semestre")
    enrolled_2nd: float = Field(alias="Curricular units 2nd sem (enrolled)", description="Disciplinas matriculadas no segundo semestre")
    evaluations_2nd: float = Field(alias="Curricular units 2nd sem (evaluations)", description="Avaliações no segundo semestre")
    approved_2nd: float = Field(alias="Curricular units 2nd sem (approved)", description="Disciplinas aprovadas no segundo semestre")
    grade_2nd: float = Field(alias="Curricular units 2nd sem (grade)", description="Nota do segundo semestre")
    without_evaluations_2nd: float = Field(alias="Curricular units 2nd sem (without evaluations)", description="Disciplinas sem avaliação no segundo semestre")

    unemployment_rate: float = Field(alias="Unemployment rate", description="Taxa de desemprego")
    inflation_rate: float = Field(alias="Inflation rate", description="Taxa de inflação")
    gdp: float = Field(alias="GDP", description="Produto Interno Bruto")


# Modelo de resposta da previsão
class ResultadoPrevisao(BaseModel):
    previsao: str
    probabilidades: dict[str, float]

# Caminho da pasta atual
BASE_DIR = Path(__file__).resolve().parent

# Caminhos dos arquivos
CAMINHO_MODELO = BASE_DIR / "modelos" / "modelo_evasao_rl_corrigido.pkl"

CAMINHO_PREPROCESSADOR = BASE_DIR / "modelos" / "preprocessador_rl_corrigido.pkl"

# Carregamento dos arquivos
modelo = joblib.load(CAMINHO_MODELO)
preprocessador = joblib.load(CAMINHO_PREPROCESSADOR)

# Criação da API
app = FastAPI(
    title="API de Previsão de Evasão Estudantil",
    description="""
    API desenvolvida para prever a situação acadêmica de estudantes
    do ensino superior utilizando Machine Learning.

    O sistema utiliza um modelo de Regressão Logística treinado
    para classificar os estudantes em três categorias:

    - Dropout: estudante evadido.
    - Enrolled: estudante matriculado.
    - Graduate: estudante formado.

    A API recebe os dados do estudante, aplica o pré-processamento
    e retorna a previsão com as probabilidades de cada categoria.
    """,
    version="1.0.0"
)

# Configuração de CORS para permitir integração com o Flutter
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Rota inicial
@app.get(
    "/",
    summary="Página inicial",
    description="Apresenta uma mensagem indicando que a API está funcionando."
)
def inicio():
    return {
        "mensagem": "API de Previsão de Evasão em funcionamento!"
    }


# Rota para verificar o funcionamento da API
@app.get(
    "/health",
    summary="Verificar funcionamento da API",
    description="Verifica se a API está online e informa o modelo utilizado."
)
def verificar_api():
    return {
        "status": "online",
        "modelo": "Regressão Logística"
    }


# Rota para realizar a previsão
@app.post(
    "/prever",
    
    summary="Realizar previsão de evasão",
    description="""
    Recebe os dados acadêmicos de um estudante e realiza uma previsão
    utilizando o modelo de Regressão Logística.

    A requisição deve conter os 33 campos numéricos esperados
    pelo modelo.

    O sistema aplica o pré-processador utilizado durante o treinamento
    e retorna a classificação prevista e as probabilidades das três classes.
    """,
    response_model=ResultadoPrevisao,
    response_description="Resultado da previsão e probabilidades de cada classe.",
    responses={
        422: {
            "description": "Erro de validação: campos ausentes, extras ou valores inválidos."
        },
        500: {
            "description": "Erro interno durante a realização da previsão."
        }
    }
)

def prever(dados: DadosEstudante):

    try:
        dados_dict = dados.model_dump(by_alias=True)
        # Identifica as colunas esperadas pelo pré-processador
        colunas_esperadas = list(preprocessador.feature_names_in_)

        # Verifica os campos recebidos
        campos_recebidos = set(dados_dict.keys())
        campos_esperados = set(colunas_esperadas)

        campos_faltantes = campos_esperados - campos_recebidos
        campos_extras = campos_recebidos - campos_esperados

        if campos_faltantes:
            raise HTTPException(
                status_code=422,
                detail={
                    "erro": "Existem campos obrigatórios ausentes.",
                    "campos": sorted(campos_faltantes)
                }
            )

        if campos_extras:
            raise HTTPException(
                status_code=422,
                detail={
                    "erro": "Foram recebidos campos não reconhecidos.",
                    "campos": sorted(campos_extras)
                }
            )

        # Verifica se os valores são números válidos
        for campo, valor in dados_dict.items():
         if not math.isfinite(valor):
            raise HTTPException(
                status_code=422,
                detail=f"O campo '{campo}' possui um valor inválido."
        )

        # Organiza os dados em um DataFrame
        entrada = pd.DataFrame(
           [dados_dict],
           columns=colunas_esperadas
        )

        # Verifica valores vazios
        if entrada.isnull().any().any():
            raise HTTPException(
                status_code=422,
                detail="Existem campos com valores vazios."
            )

        # Aplica o mesmo pré-processamento do treinamento
        dados_processados = preprocessador.transform(entrada)

        # Realiza a previsão
        previsao = modelo.predict(dados_processados)[0]

        # Obtém as probabilidades de cada classe
        probabilidades = modelo.predict_proba(dados_processados)[0]

        resultado_probabilidades = {
            str(classe): round(float(probabilidade) * 100, 2)
            for classe, probabilidade in zip(
                modelo.classes_,
                probabilidades
            )
        }

        # Retorna o resultado
        return {
            "previsao": str(previsao),
            "probabilidades": resultado_probabilidades
        }

    except HTTPException:
        raise

    except Exception as erro:
        raise HTTPException(
            status_code=500,
            detail=f"Erro ao realizar previsão: {str(erro)}"
        )

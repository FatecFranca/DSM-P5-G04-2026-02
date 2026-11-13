# Monitoriza

**Sistema preditivo de evasão no Ensino Superior.**

Aplicativo mobile e API de inteligência artificial que estimam o risco de um estudante abandonar o curso, para que coordenadores e professores possam agir antes que a desistência aconteça.

> Projeto Interdisciplinar (PI) do **5º semestre** do curso de **Tecnologia em Desenvolvimento de Software Multiplataforma** — **Fatec Franca "Dr. Thomaz Novelino"** (Centro Paula Souza).

---

## Sobre o projeto

A evasão escolar costuma ser percebida tarde: o estudante deixa de comparecer ou tranca a matrícula quando o desengajamento já é difícil de reverter. O Monitoriza propõe uma postura **preventiva**. A partir de dados socioeconômicos e do desempenho acadêmico por semestre, um modelo de aprendizado de máquina estima a probabilidade de evasão e classifica o estudante em **risco baixo, médio ou alto**.

O ecossistema tem três partes integradas:

- **Aplicativo mobile (Flutter)**: cadastro do estudante por um formulário em etapas, consulta do risco, resultado detalhado com probabilidades e histórico com busca e filtros por nível de risco.
- **API RESTful (FastAPI)**: recebe os dados do estudante, executa o modelo e devolve a previsão em JSON; salva e consulta registros no banco de dados.
- **Modelo de Machine Learning**: Random Forest treinado com a base *Higher Education Predictors of Student Retention*, que classifica o estudante em *Dropout* (evasão), *Enrolled* (cursando) ou *Graduate* (formado).

## Funcionalidades

- Formulário de cadastro em 5 etapas, com listas de seleção para todas as categorias do dataset.
- Previsão do risco de evasão com a probabilidade de cada resultado (evasão, cursando, formado).
- Classificação em risco **baixo**, **médio** e **alto**.
- Histórico de registros salvo no banco, com busca por nome ou matrícula e filtro por nível de risco.
- Tela de detalhes com todos os dados informados e o resultado da análise.
- Modo de demonstração com dados simulados, que funciona sem a API.

## Arquitetura

```
┌──────────────────┐   HTTP / JSON   ┌────────────────────┐        ┌────────────────┐
│  App mobile      │ ──────────────► │  API FastAPI       │ ─────► │  Banco de dados │
│  (Flutter)       │ ◄────────────── │                    │ ◄───── │  SQLite / PostgreSQL │
└──────────────────┘                 │  ┌──────────────┐  │        └────────────────┘
                                     │  │ Modelo ML    │  │
                                     │  │ (joblib)     │  │
                                     │  └──────────────┘  │
                                     └────────────────────┘
```

O app não executa o modelo: ele envia os dados à API, que carrega o modelo treinado, calcula a previsão e devolve o resultado.

## Tecnologias

| Camada | Tecnologias |
|---|---|
| Mobile | Flutter, Dart, Material 3, pacote `http` |
| API | Python, FastAPI, Pydantic, SQLAlchemy, Uvicorn |
| Machine Learning | scikit-learn (Random Forest), pandas, numpy, joblib |
| Banco de dados | SQLite (desenvolvimento) e PostgreSQL (produção) |
| Testes | pytest, httpx |

## Como executar

### Pré-requisitos

- [Python](https://www.python.org/) 3.10 ou superior
- [Flutter](https://docs.flutter.dev/get-started/install) (versão estável) e um celular Android ou emulador
- O dataset do Kaggle [*Higher Education Predictors of Student Retention*](https://www.kaggle.com/datasets/thedevastator/higher-education-predictors-of-student-retention), salvo em `backend/datasets/dataset.csv`

### 1. Backend

Dentro da pasta `backend/`:

```bash
python -m venv .venv
.venv\Scripts\activate          # Windows
# source .venv/bin/activate     # Linux / macOS

pip install -r requirements.txt

# Treina o modelo e salva em models/model.joblib
python training/train_baseline.py --csv datasets/dataset.csv

# Inicia a API
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

A API fica em `http://localhost:8000`. A documentação interativa (Swagger) está em **`/docs`** e a verificação de saúde em **`/health`**.

Para rodar os testes:

```bash
pytest
```

### 2. Aplicativo mobile

Dentro da pasta `front-end/`:

```bash
flutter pub get
```

**Modo demonstração** (dados simulados, não precisa da API):

```bash
flutter run
```

**Conectado à API:**

```bash
# Emulador Android
flutter run --dart-define=USE_MOCK=false --dart-define=API_URL=http://10.0.2.2:8000

# Celular físico via cabo USB
adb reverse tcp:8000 tcp:8000
flutter run -d <id-do-celular> --dart-define=USE_MOCK=false --dart-define=API_URL=http://127.0.0.1:8000

# Celular físico pela rede Wi-Fi (mesma rede do computador)
flutter run -d <id-do-celular> --dart-define=USE_MOCK=false --dart-define=API_URL=http://<IP-do-computador>:8000
```

Use `flutter devices` para listar os dispositivos e seus ids.

### Variáveis de ambiente (backend)

Todas são opcionais em desenvolvimento. Veja `backend/.env.example`.

| Variável | Descrição | Padrão |
|---|---|---|
| `DATABASE_URL` | Conexão com o banco (ex.: `postgresql://usuario:senha@host:5432/monitoriza`) | SQLite local (`monitoriza.db`) |
| `MODEL_PATH` | Caminho do modelo treinado | `models/model.joblib` |
| `RISK_HIGH` | Probabilidade de evasão a partir da qual o risco é **alto** | `0.60` |
| `RISK_MEDIUM` | Probabilidade de evasão a partir da qual o risco é **médio** | `0.30` |
| `CORS_ORIGINS` | Origens permitidas, separadas por vírgula | `*` |

## Endpoints da API

| Método | Rota | Descrição |
|---|---|---|
| `GET` | `/health` | Estado da API e do modelo |
| `POST` | `/predict` | Calcula a previsão para os dados de um estudante, sem salvar |
| `POST` | `/records` | Salva o estudante e a previsão gerada |
| `GET` | `/records` | Lista os registros (parâmetros: `q`, `risk`, `limit`, `offset`) |
| `GET` | `/records/{id}` | Detalha um registro |
| `GET` | `/students` | Lista os estudantes cadastrados |
| `GET` | `/students/{matrícula}/records` | Histórico de previsões de um estudante |

## Sobre o modelo e os dados

O modelo foi treinado com a base pública *Higher Education Predictors of Student Retention* (equivalente ao *Predict Students' Dropout and Academic Success*, do UCI Machine Learning Repository), com 4.424 estudantes e 34 variáveis, coletada no Instituto Politécnico de Portalegre, em Portugal.

- A variável-alvo tem três classes: `Dropout`, `Enrolled` e `Graduate`.
- O risco exibido no app é calculado a partir da **probabilidade de evasão** (`Dropout`), usando as faixas definidas em `RISK_HIGH` e `RISK_MEDIUM`.
- Por ser uma base portuguesa, algumas categorias (formas de ingresso, ocupações) seguem a classificação portuguesa, e as notas usam a escala de 0 a 20. O app exibe os nomes traduzidos e envia à API os códigos do dataset.
- Os indicadores macroeconômicos (desemprego, inflação e PIB) são preenchidos pela API, não pelo usuário.

## Equipe

| Integrante | Atuação |
|---|---|
| **Ana Júlia Ferreira Rodrigues** | Aplicativo mobile (Flutter) e integração com a API |
| **Guilherme Laurindo de Souza Silva** | Modelo de Machine Learning, API e infraestrutura em nuvem |

## Contexto acadêmico

Projeto desenvolvido como Projeto Interdisciplinar do 5º semestre do curso de Tecnologia em Desenvolvimento de Software Multiplataforma da Fatec Franca "Dr. Thomaz Novelino", Centro Paula Souza, em 2026.

## Referências

- Realinho, V.; Machado, J.; Baptista, L.; Martins, M. V. *Predicting Student Dropout and Academic Success*. Data, 7(11), 146, 2022. https://mdpi.com/2306-5729/7/11/146
- Kaggle: *Higher Education Predictors of Student Retention*.
- Documentação do [Flutter](https://docs.flutter.dev/), do [FastAPI](https://fastapi.tiangolo.com/), do [scikit-learn](https://scikit-learn.org/) e do [PostgreSQL](https://www.postgresql.org/docs/).
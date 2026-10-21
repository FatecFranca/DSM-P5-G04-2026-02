# Monitoriza

Sistema preditivo de evasão no ensino superior com Aprendizado de Máquina e Computação em Nuvem. Projeto Integrador (PI).

O ecossistema completo é formado por:
- **Aplicativo mobile (Flutter)**: formulário de dados do estudante, diagnóstico de risco de evasão em % e histórico de registros.
- **API REST (Python)**: recebe os dados em JSON e devolve a predição do modelo.
- **Modelo de Machine Learning**: classificador treinado com o dataset *Higher Education Predictors of Student Retention* (Kaggle).
- **Banco de dados e nuvem**: PostgreSQL e API hospedados em nuvem pública, com o banco acessível apenas pela API.

| Parte | Situação |
|---|---|
| App mobile: telas, navegação, formulário, resultado e histórico | Pronto (com dados simulados) |
| App mobile: dashboard e planos de intervenção | A fazer |
| Integração do app com a API | A fazer |
| API REST, modelo de ML, banco e nuvem | [atualizar] |

O app usa hoje uma previsão simulada (`MockPredictionService`) e um histórico em memória. Quando a API estiver pronta, basta trocar o serviço simulado por um `PredictionApiService`, sem alterar as telas.

## Como rodar o app

Pré-requisitos: Flutter instalado e um emulador Android (ou dispositivo) ativo.

```
flutter pub get
flutter run
```

## Estrutura do código (`lib/`)

```
lib/
├── main.dart        # tema, navegação inferior e injeção do serviço
├── models/          # Student, PredictionResult, HistoryRecord
├── screens/         # home, formulário, resultado, histórico, detalhes
├── services/        # PredictionService (interface), mocks
├── theme/           # cores e tema
├── utils/           # formatação
└── widgets/         # componentes reutilizáveis
```

## Contrato previsto da API

`POST /previsao`

Resposta esperada (a definir com o back-end):

```json
{
  "prediction": "em_risco",
  "probability": 0.78
}
```

## Equipe

- **Ana Júlia Ferreira Rodrigues**: aplicativo mobile (Flutter), UX/UI, integração com a API e testes do mobile.
- **Guilherme Laurindo de S. Silva**: API REST, modelo de Machine Learning, banco de dados, nuvem e CI/CD.

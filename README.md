# Monitoriza

**Sistema preditivo de evasão no Ensino Superior.**

O Monitoriza é um projeto desenvolvido para auxiliar instituições de ensino superior no acompanhamento de estudantes. Por meio de um aplicativo mobile, uma API e um modelo de aprendizado de máquina, o sistema analisa informações acadêmicas e socioeconômicas para estimar a probabilidade de evasão.

A proposta é oferecer informações que possam auxiliar coordenadores e equipes pedagógicas na identificação de estudantes que necessitam de maior acompanhamento.

> Projeto Interdisciplinar (PI) do 5º semestre do curso de **Tecnologia em Desenvolvimento de Software Multiplataforma** da **Fatec Franca – Dr. Thomaz Novelino**, Centro Paula Souza.

---

## Sobre o projeto

A evasão no ensino superior pode estar relacionada a diversos fatores, como dificuldades financeiras, condições familiares e desempenho acadêmico. Muitas vezes, os sinais de desengajamento são percebidos somente quando o estudante já está próximo de abandonar o curso.

O Monitoriza busca contribuir para a identificação antecipada dessas situações por meio da análise de dados e da utilização de técnicas de aprendizado de máquina.

O projeto possui três componentes principais:

- **Aplicativo mobile (Flutter):** permite cadastrar estudantes, consultar informações, visualizar resultados das previsões e acessar registros.
- **API REST (Python e FastAPI):** recebe os dados enviados pelo aplicativo, realiza o processamento das informações, executa o modelo preditivo e acessa o banco de dados.
- **Modelo de Machine Learning:** utiliza o algoritmo de Regressão Logística para classificar os estudantes em três categorias: `Dropout` (evasão), `Enrolled` (cursando) e `Graduate` (formado).

## Funcionalidades

- Cadastro de estudantes por meio de formulário no aplicativo.
- Registro de informações pessoais, socioeconômicas e acadêmicas.
- Envio dos dados para a API.
- Previsão da situação acadêmica utilizando o modelo de aprendizado de máquina.
- Apresentação das probabilidades de evasão, permanência e conclusão.
- Classificação do risco de evasão conforme os critérios definidos no sistema.
- Armazenamento das informações no banco de dados PostgreSQL.
- Consulta dos estudantes cadastrados e de seus registros.

*Observação: a disponibilidade de cada funcionalidade depende da versão integrada e executável do projeto.*

## Arquitetura

O sistema utiliza uma arquitetura em que o aplicativo Flutter se comunica com a API FastAPI por meio de requisições HTTP. A API é responsável por acessar o banco de dados PostgreSQL e executar o modelo de aprendizado de máquina.

```text
┌────────────────────┐
│   Aplicativo       │
│     Flutter        │
└─────────┬──────────┘
          │
          │ HTTP / JSON
          ▼
┌────────────────────┐
│       API          │
│     FastAPI        │
│                    │
│ ┌────────────────┐ │
│ │ Modelo de      │ │
│ │ Regressão      │ │
│ │ Logística      │ │
│ └────────────────┘ │
└─────────┬──────────┘
          │
          │ SQLAlchemy
          ▼
┌────────────────────┐
│     PostgreSQL     │
│                    │
│ Dados dos alunos   │
│ Dados acadêmicos  │
│ Dados              │
│ socioeconômicos    │
│ Previsões          │
└────────────────────┘
```

O aplicativo não executa diretamente o modelo de aprendizado de máquina. Ele envia as informações à API, que realiza o processamento e devolve os resultados ao aplicativo.

## Tecnologias utilizadas

| Camada | Tecnologias |
|---|---|
| Aplicativo mobile | Flutter e Dart |
| Interface | Material Design |
| Comunicação mobile | HTTP e JSON |
| Back-End | Python e FastAPI |
| Validação de dados | Pydantic |
| ORM | SQLAlchemy |
| Banco de dados | PostgreSQL |
| Machine Learning | scikit-learn |
| Manipulação de dados | pandas e numpy |
| Execução da API | Uvicorn |
| Versionamento | Git e GitHub |

## Estrutura do projeto

A organização principal do repositório é dividida entre o aplicativo mobile e o Back-End.

```text
DSM-P5-G04-2026-02/
│
├── back-end/
│   ├── database/
│   ├── routes/
│   ├── schemas/
│   ├── services/
│   ├── main.py
│   └── ...
│
├── front-end/
│   ├── lib/
│   ├── android/
│   ├── test/
│   └── ...
│
└── README.md
```

*Observação: a estrutura acima apresenta as pastas principais conhecidas do projeto. Outros arquivos e diretórios podem existir em cada parte.*

## Como executar o projeto

### Pré-requisitos

Antes de iniciar, é necessário ter instalado:

- Python 3.12.
- Flutter SDK.
- Git.
- PostgreSQL.
- Um dispositivo Android ou emulador configurado.
- Dependências do projeto.

### 1. Back-End

Na raiz do repositório, abra o terminal e ative o ambiente virtual utilizado no projeto:

```powershell
.\.venv312\Scripts\Activate.ps1
```

Entre na pasta do Back-End:

```powershell
cd back-end
```

Inicie a API:

```powershell
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

Quando a API estiver funcionando, será possível acessá-la pelo navegador do computador:

- API: http://127.0.0.1:8000
- Documentação interativa (Swagger): http://127.0.0.1:8000/docs

O endereço `0.0.0.0` permite que a API receba conexões de outros dispositivos na rede, conforme a configuração do ambiente.

### 2. Aplicativo mobile

Abra outro terminal e entre na pasta do Front-End:

```powershell
cd front-end
```

Instale as dependências:

```powershell
flutter pub get
```

Verifique os dispositivos disponíveis:

```powershell
flutter devices
```

Execute o aplicativo:

```powershell
flutter run
```

### 3. Comunicação com a API

Para que o aplicativo Android utilize a API executada no computador, é necessário configurar o endereço de acesso corretamente.

**Emulador Android**

Utilize o endereço especial `10.0.2.2`, que permite ao emulador acessar o computador hospedeiro:

```text
http://10.0.2.2:8000
```

**Celular físico conectado por USB**

É possível utilizar o encaminhamento de porta do ADB:

```powershell
adb reverse tcp:8000 tcp:8000
```

Nesse caso, o aplicativo pode acessar a API pelo endereço:

```text
http://127.0.0.1:8000
```

**Celular conectado pela mesma rede Wi-Fi**

Utilize o endereço IP local do computador, seguido da porta 8000:

```text
http://IP-DO-COMPUTADOR:8000
```

O computador e o celular precisam estar conectados à mesma rede, e o firewall deve permitir a comunicação.

## Banco de dados

O projeto utiliza PostgreSQL para armazenar as informações dos estudantes e os dados necessários para o funcionamento da aplicação.

O Back-End realiza a comunicação com o banco de dados por meio do SQLAlchemy, permitindo cadastrar, consultar e relacionar as informações.

As principais informações armazenadas envolvem:

- Dados de identificação dos estudantes.
- Informações socioeconômicas.
- Desempenho acadêmico.
- Registros relacionados às previsões.

As configurações de conexão devem ser realizadas no ambiente do Back-End, de acordo com os parâmetros definidos no projeto.

**Importante:** as credenciais de acesso ao banco de dados não devem ser compartilhadas publicamente ou enviadas ao repositório.

## Modelo de Machine Learning

O projeto utiliza aprendizado de máquina supervisionado para estimar a situação acadêmica dos estudantes.

Foram avaliados diferentes algoritmos de classificação durante os testes, incluindo:

- Regressão Logística;
- Análise Discriminante Linear (LDA);
- K-Nearest Neighbors (KNN);
- Classification and Regression Trees (CART);
- Naive Bayes;
- Support Vector Machine (SVM);
- Multilayer Perceptron (MLP).

Após a comparação dos resultados, a **Regressão Logística** foi escolhida para ser utilizada como modelo principal do projeto.

A variável-alvo possui três classes:

| Classe | Significado |
|---|---|
| `Dropout` | Evasão |
| `Enrolled` | Estudante matriculado |
| `Graduate` | Estudante formado |

O sistema utiliza as probabilidades calculadas pelo modelo para apresentar o resultado da previsão.

A classificação do risco de evasão considera a probabilidade associada à classe `Dropout`, conforme os critérios definidos na implementação.

### Base de dados

O modelo foi desenvolvido utilizando a base pública **Higher Education Predictors of Student Retention**, disponibilizada no Kaggle.

A base está relacionada ao estudo *Predicting Students' Dropout and Academic Success*, desenvolvido com dados de estudantes do Instituto Politécnico de Portalegre, em Portugal.

A utilização dessa base permite analisar informações acadêmicas, socioeconômicas e demográficas relacionadas à trajetória dos estudantes.

É importante considerar que os dados utilizados no treinamento são provenientes de uma instituição portuguesa, enquanto o aplicativo foi pensado para o contexto brasileiro. Essa diferença representa uma limitação que deve ser considerada na interpretação dos resultados e na aplicação do modelo.

## Equipe

| Integrante | Atuação |
|---|---|
| Ana Júlia Ferreira Rodrigues | Desenvolvimento do aplicativo mobile (Flutter) e integração com a API |
| Guilherme Laurindo de Souza Silva | Desenvolvimento do Back-End, integração com o banco de dados e modelo de Machine Learning |

## Contexto acadêmico

Projeto desenvolvido como Projeto Interdisciplinar do 5º semestre do curso de Tecnologia em Desenvolvimento de Software Multiplataforma da Faculdade de Tecnologia de Franca – Dr. Thomaz Novelino, pertencente ao Centro Paula Souza, no ano de 2026.

## Referências

REALINHO, V.; MACHADO, J.; BAPTISTA, L.; MARTINS, M. V. *Predicting Student Dropout and Academic Success*. Data, v. 7, n. 11, art. 146, 2022. Disponível em: https://doi.org/10.3390/data7110146.

KAGGLE. *Higher Education Predictors of Student Retention*. Disponível em: https://www.kaggle.com/datasets/thedevastator/higher-education-predictors-of-student-retention.

FASTAPI. *FastAPI Documentation*. Disponível em: https://fastapi.tiangolo.com/.

FLUTTER. *Flutter Documentation*. Disponível em: https://docs.flutter.dev/.

POSTGRESQL. *PostgreSQL Documentation*. Disponível em: https://www.postgresql.org/docs/.

SCIKIT-LEARN. *Scikit-learn Documentation*. Disponível em: https://scikit-learn.org/.
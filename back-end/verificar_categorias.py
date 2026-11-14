
import pandas as pd

# Carrega o dataset
df = pd.read_csv("data/dataset.csv")

# Colunas categóricas utilizadas pelo modelo
colunas = [
    "Marital status",
    "Application mode",
    "Application order",
    "Course",
    "Daytime/evening attendance",
    "Previous qualification",
    "Nacionality",
    "Mother's qualification",
    "Father's qualification",
    "Mother's occupation",
    "Father's occupation",
    "Displaced",
    "Educational special needs",
    "Debtor",
    "Tuition fees up to date",
    "Gender",
    "Scholarship holder",
    "International"
]

print("Dimensões do dataset:", df.shape)
print("\nVALORES CATEGÓRICOS:\n")

for coluna in colunas:
    valores = sorted(df[coluna].dropna().unique().tolist())
    print(f"{coluna}: {valores}")

print("\nFREQUÊNCIA DOS VALORES:\n")

for coluna in colunas:
    print(f"\n{coluna}")
    print(df[coluna].value_counts().sort_index().to_string())
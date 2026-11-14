
import pandas as pd

df = pd.read_csv("data/dataset.csv")

print("Curso mais frequente:")
print(df["Course"].mode().iloc[0])

print("\nIndicadores econômicos:")
print("Taxa de desemprego:", df["Unemployment rate"].median())
print("Taxa de inflação:", df["Inflation rate"].median())
print("PIB:", df["GDP"].median())

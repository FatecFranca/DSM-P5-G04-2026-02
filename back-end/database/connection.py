
import os
from pathlib import Path

from dotenv import load_dotenv
from sqlalchemy import create_engine, URL, text
from sqlalchemy.orm import sessionmaker, declarative_base

# Localiza o arquivo .env na pasta back-end
BASE_DIR = Path(__file__).resolve().parent.parent
load_dotenv(BASE_DIR / ".env")

# Recupera as credenciais
DB_HOST = os.getenv("DB_HOST")
DB_PORT = os.getenv("DB_PORT")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")

# Verifica se as credenciais foram preenchidas
if not all([DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_PASSWORD]):
    raise ValueError("Verifique as configurações do arquivo .env")

# Configura a conexão
DATABASE_URL = URL.create(
    drivername="postgresql+psycopg",
    username=DB_USER,
    password=DB_PASSWORD,
    host=DB_HOST,
    port=int(DB_PORT),
    database=DB_NAME,
)

engine = create_engine(
    DATABASE_URL,
    pool_pre_ping=True
)

# Gerenciador de sessões
SessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine
)

# Base para futuras tabelas do SQLAlchemy
Base = declarative_base()


# Dependência para utilizar o banco na API
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


# Teste de conexão
def test_connection():
    with engine.connect() as connection:
        connection.execute(text("SELECT 1"))
        print("Conexão com PostgreSQL realizada com sucesso!")

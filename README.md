# DesafioEsfera

Aplicação para buscar informações de CNPJs a partir de uma API externa, salvar no banco de dados PostgreSQL e visualizar no frontend em Flutter Web.

---

## 🚀 Tecnologias Utilizadas
- **Backend:** Node.js + Express + PostgreSQL
- **Frontend:** Flutter Web
- **Banco de Dados:** PostgreSQL
- **Gerenciador de Pacotes:** npm/yarn (Node.js) e flutter pub (Flutter)

---

## 📂 Estrutura do Projeto
/backend -> Código Node.js (API REST)
/frontend -> Código Flutter web

---

## 🛠️ Como Rodar o Projeto

### 1️⃣ Clonar o repositório

    git clone https://github.com/pedroviniciusbrum/DesafioEsfera
    cd DesafioEsfera

### 2️⃣ Configurar o Backend (Node.js + PostgreSQL)
    1 Va para a pasta backend:
        cd backend

    2 Instale as dependências:
        npm install

    3 Configurar o banco de dados:
        CREATE DATABASE findcnpj;
        \c findcnpj
        CREATE TABLE companies (
            id SERIAL PRIMARY KEY,
            cnpj VARCHAR(18) NOT NULL,
            razao_social VARCHAR(255),
            nome_fantasia VARCHAR(255),
            cnae_principal VARCHAR(255),
            situacao VARCHAR(100)
        );

    4 Altere db.js com suas informações de usuario, senha e porta do postgres.
    
    5 Inicie o servidor:
        node index.js

### 3️⃣ Configurar o Frontend (Flutter Web)
    1 Vá para a pasta frontend:
        cd ../frontend

    2 Instale as dependências:
        flutter pub get

    3 Rodar o projeto:
        flutter run -d chrome

    4 O frontend abrirá no navegador (porta padrão do Flutter).

📌 Endpoints da API

    GET /cnpj/:cnpj → Busca informações de um CNPJ na API externa.

    POST /companies → Salva uma empresa no banco.

    GET /companies → Lista todas as empresas salvas.

📷 Telas

    Home: Busca CNPJs e salva no banco.

    Companies: Lista todas as empresas já salvas.
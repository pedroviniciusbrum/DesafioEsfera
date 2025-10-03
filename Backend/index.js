const express = require("express");
const axios = require("axios");
const cors = require("cors");
const pool = require ("./db")

const app = express();
app.use(cors());
app.use(express.json())
const PORT = 3000;


// Rota que consome API externa
app.get("/cnpj/:numbercnpj", async (req, res) => {
  try {
    //Pegando o cnpj do url
    const numCnpj = req.params.numbercnpj

    //Enviando um get para a api de cnpj e está instanciando com a informação do cnpj coletada logo acima
    const resposta = await axios.get(`https://api.opencnpj.org/${numCnpj}`);

    // Retorna o arquivo json para quem chamou a api
    console.log("Deu certo o get")
    res.json(resposta.data);
    
  } catch (error) {
    console.error(error.message);
    res.status(500).json({ erro: "Erro ao buscar dados da API externa" });
  }
});



app.get("/companies", async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM companies ORDER BY id ASC;");
    res.json(result.rows); // retorna array de objetos
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Erro ao buscar empresas" });
  }
});

app.post("/companies", async (req, res) => {
  const { cnpj, razao_social, nome_fantasia, cnae_principal, situacao } = req.body;
  const query = "INSERT INTO companies (cnpj, razao_social, nome_fantasia, cnae_principal, situacao) VALUES ($1,$2,$3,$4,$5) RETURNING *";
  const values = [cnpj, razao_social, nome_fantasia, cnae_principal, situacao];
  const result = await pool.query(query, values);
  res.json(result.rows[0]);
});


app.listen(PORT, () => {
  console.log(`Servidor rodando em http://localhost:${PORT}`);
});
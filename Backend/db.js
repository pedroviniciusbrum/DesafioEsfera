const { Pool } = require("pg")


const pool = new Pool({
  user: "SEU USUARIO",
  host: "localhost",
  database: "Findcnpj",
  password: "SUA SENHA",
  port: 5433, //Coloque a porta do seu postgres
});

module.exports = pool;
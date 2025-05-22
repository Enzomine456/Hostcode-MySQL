// index.js
const { exec } = require("child_process");

console.log("🔧 Iniciando tarefas automatizadas do Hostcode-MySQL...");

exec("grunt", (err, stdout, stderr) => {
  if (err) {
    console.error(`❌ Erro ao executar Grunt: ${err.message}`);
    process.exit(1);
  }
  if (stderr) {
    console.warn(`⚠️  Aviso: ${stderr}`);
  }
  console.log(`✅ Grunt executado com sucesso:\n${stdout}`);
});

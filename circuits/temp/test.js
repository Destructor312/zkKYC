const { poseidon } = require("circomlibjs");

async function calculateHash() {
  const s = 812313;  // Ваш секретный вход
  const hash = await poseidon([s]);  // Poseidon([s]) для 1 входа
  console.log("Poseidon(s) =", hash.toString());
}

calculateHash();
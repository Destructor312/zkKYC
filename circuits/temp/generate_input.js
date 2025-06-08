// generate_input.js
const fs = require('fs');
const { buildPoseidon } = require('circomlibjs');

async function main() {
  const poseidon = await buildPoseidon();
  
  // 1. Your secret value (private input)
  const s = 812313; // Replace with your actual secret
  
  // 2. Compute Poseidon hash (public hash)
  const publicHash = poseidon([s]);
  const publicHashStr = poseidon.F.toString(publicHash);
  
  // 3. Generate input.json
  fs.writeFileSync('../build/circuit_js/input.json', JSON.stringify({
    s: s.toString(),
    public_hash: publicHashStr
  }, null, 2));

  console.log("Generated input.json");
  console.log("Public hash:", publicHashStr);
}

main().catch(console.error);
#!/bin/bash
set -e
echo "1. Compiling the circuit..."
mkdir -p build
circom2 circuit.circom -o build/ --r1cs --wasm --sym -l node_modules --prime bls12381
echo "2. Starting Powers of Tau ceremony..."
cd build || exit
# Phase 1: Powers of Tau ceremony
snarkjs powersoftau new bls12-381 12 pot12_0000.ptau -v
snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau -n="First" -v
snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v
echo "3. Generating proving and verification keys..."
# Phase 2: Circuit-specific setup
snarkjs groth16 setup circuit.r1cs pot12_final.ptau circuit_0000.zkey
snarkjs zkey contribute circuit_0000.zkey circuit_final.zkey -n="Second" -v
echo "4. Exporting verification key..."
snarkjs zkey export verificationkey circuit_final.zkey verification_key.json

echo "5. All done! Files generated in build/ directory:"
ls -lh

cd ..
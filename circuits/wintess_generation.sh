#!/bin/bash
#  witness generation process
set -e
cd build/circuit_js
snarkjs wtns calculate circuit.wasm input.json witness.wtns
snarkjs groth16 prove circuit_0001.zkey witness.wtns proof.json public.json

cd ../..
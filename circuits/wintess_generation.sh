#!/bin/bash
#  witness generation process
snarkjs wtns calculate circuit.wasm input.json witness.wtns
snarkjs groth16 prove circuit_0001.zkey witness.wtns proof.json public.json

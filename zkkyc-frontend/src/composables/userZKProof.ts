import { ref } from 'vue';
import * as snarkjs from 'snarkjs';

export function useZkProof() {
  const proof = ref<any>(null);
  
  const generateProof = async (input: object) => {
    const { proof: zkProof } = await snarkjs.groth16.fullProve(
      input,
      "/circuits/kyc.wasm",
      "/circuits/kyc.zkey"
    );
    proof.value = zkProof;
  };

  return { proof, generateProof };
}
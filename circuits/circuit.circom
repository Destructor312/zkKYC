pragma circom 2.0.0;

include "./poseidon.circom";

template HashPreimage() {
    signal input s;
    signal output hash;
    component poseidon = Poseidon(1);  
    poseidon.inputs[0] <== s;
    hash <== poseidon.out;
}

template Main() {
    signal input s;
    signal input public_hash;  
    component hashComp = HashPreimage();
    hashComp.s <== s;
    public_hash === hashComp.hash;  
}

component main {public [public_hash]} = Main();
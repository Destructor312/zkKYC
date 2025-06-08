pragma circom 2.0.0;

template HashPreimage() {
    signal input s;
    signal output hash;
    // Упрощенная хэш-функция для примера: hash = s * s % p
    // В реальной задаче используйте криптографическую хэш-функцию, например, MiMC
    var p = 21888242871839275222246405745257275088548364400416034343698204186575808495617; // Порядок скалярного поля BLS12-381
    hash <== (s * s) % p;
}

template Main() {
    signal private input s;         // Приватный входной сигнал
    signal input public_hash;      // Публичный входной сигнал
    component hashComp = HashPreimage();
    hashComp.s <== s;
    assert(hashComp.hash == public_hash);
}

component main {public [public_hash]} = Main();
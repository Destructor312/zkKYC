// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import "@semaphore-protocol/contracts/base/Semaphore.sol";
import {console2} from "forge-std/console2.sol";
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@semaphore-protocol/contracts/interfaces/ISemaphore.sol";

contract ZkKYC is AccessControl, IERC165 {
    function supportsInterface(bytes4 interfaceID) public view override(ERC165,IERC165) returns (bool){
        return
            interfaceID == type(IERC165).interfaceID ||
            interfaceID == type(IAcessControl).interfaceID ||
            super.supportsInterface(interfaceID);
    }
    
    // Роли
    bytes32 public constant ISSUER_ROLE = keccak256("ISSUER_ROLE");
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    // Semaphore
    ISemaphore public semaphore;
    uint256 public groupId;
    mapping(uint256 => bool) public nullifiers;

    // DID -> Merkle Root
    mapping(address => bytes32) public didRoots;

    // События
    event CredentialIssued(address indexed did, bytes32 root);
    event KYCVerified(address indexed did, uint256 nullifier);

    constructor(address _semaphore, uint256 _groupId) {
        semaphore = ISemaphore(_semaphore);
        groupId = _groupId;
        
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(ADMIN_ROLE, msg.sender);
    }

    // ========== ISSUER FUNCTIONS ==========

    /** 
     * @dev Добавление Merkle Root для DID (только Issuer)
     * @param did Адрес DID субъекта
     * @param root Корень Merkle-дерева с commitments
     */
    function issueCredential(address did, bytes32 root) external onlyRole(ISSUER_ROLE) {
        didRoots[did] = root;
        emit CredentialIssued(did, root);
    }

    // ========== USER FUNCTIONS ==========

    /**
     * @dev Верификация ZK-SNARK proof через Semaphore
     * @param did Адрес DID пользователя
     * @param root Корень Merkle-дерева
     * @param nullifier Уникальный идентификатор proof
     * @param proof Доказательство Semaphore
     */
    function verifyKYC(
        address did,
        bytes32 root,
        uint256 nullifier,
        uint256[8] calldata proof
    ) external {
        require(didRoots[did] == root, "Invalid DID root");
        require(!nullifiers[nullifier], "Proof already used");

        // Верификация через Semaphore
        semaphore.verifyProof(
            groupId,
            root,
            nullifier,
            keccak256(abi.encodePacked(did)), // signal = hash(did)
            proof
        );

        nullifiers[nullifier] = true;
        emit KYCVerified(did, nullifier);
    }

    // ========== ADMIN FUNCTIONS ==========

    /**
     * @dev Обновление Semaphore группы (только Admin)
     */
    function updateSemaphoreGroup(uint256 newGroupId) external onlyRole(ADMIN_ROLE) {
        groupId = newGroupId;
    }
}

// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.7;

import "../interfaces/ISoulboundIdentity.sol";
import "./MasaSBT.sol";

/// @title MasaSBTChild
/// @author Masa Finance
/// @notice Soulbound token. Non-fungible token that is not transferable.
/// Adds a link to a SoulboundIdentity SC to let minting using the identityId
/// @dev Implementation of https://papers.ssrn.com/sol3/papers.cfm?abstract_id=4105763 Soulbound token.
abstract contract MasaSBTChild is MasaSBT {
    /* ========== STATE VARIABLES =========================================== */

    ISoulboundIdentity public soulboundIdentity;

    /* ========== INITIALIZE ================================================ */

    /// @notice Creates a new soulbound token
    /// @dev Creates a new soulbound token
    /// @param owner Owner of the smart contract
    /// @param name Name of the token
    /// @param symbol Symbol of the token
    /// @param baseTokenURI Base URI of the token
    /// @param _soulboundIdentity Address of the SoulboundIdentity contract
    constructor(
        address owner,
        string memory name,
        string memory symbol,
        string memory baseTokenURI,
        ISoulboundIdentity _soulboundIdentity
    ) MasaSBT(owner, name, symbol, baseTokenURI) {
        require(address(_soulboundIdentity) != address(0), "ZERO_ADDRESS");

        soulboundIdentity = _soulboundIdentity;
    }

    /* ========== RESTRICTED FUNCTIONS ====================================== */

    /// @notice Sets the SoulboundIdentity contract address linked to this SBT
    /// @dev The caller must be the owner to call this function
    /// @param _soulboundIdentity Address of the SoulboundIdentity contract
    function setSoulboundIdentity(ISoulboundIdentity _soulboundIdentity)
        external
        onlyOwner
    {
        require(address(_soulboundIdentity) != address(0), "ZERO_ADDRESS");
        require(soulboundIdentity != _soulboundIdentity, "SAME_VALUE");
        soulboundIdentity = _soulboundIdentity;
    }

    /* ========== MUTATIVE FUNCTIONS ======================================== */

    /* ========== VIEWS ===================================================== */

    /* ========== PRIVATE FUNCTIONS ========================================= */

    /* ========== MODIFIERS ================================================= */

    /* ========== EVENTS ==================================================== */
}

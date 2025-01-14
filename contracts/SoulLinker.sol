// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/cryptography/draft-EIP712.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

import "./dex/PaymentGateway.sol";
import "./interfaces/ISoulboundIdentity.sol";

/// @title Soul linker
/// @author Masa Finance
/// @notice Soul linker smart contract that let add links to a Soulbound token.
contract SoulLinker is PaymentGateway, EIP712, Pausable {
    /* ========== STATE VARIABLES =========================================== */

    ISoulboundIdentity public soulboundIdentity;

    // linked SBTs
    mapping(address => bool) public linkedSBT;
    address[] public linkedSBTs;

    uint256 public addPermissionPrice; // store permission price in stable coin
    uint256 public addPermissionPriceMASA; // store permission price in MASA

    // token => tokenId => readerIdentityId => signatureDate => PermissionData
    mapping(address => mapping(uint256 => mapping(uint256 => mapping(uint256 => PermissionData))))
        private _permissions;
    mapping(address => mapping(uint256 => mapping(uint256 => uint256[])))
        private _permissionSignatureDates;

    struct PermissionData {
        uint256 ownerIdentityId;
        string data;
        uint256 expirationDate;
        bool isRevoked;
    }

    /* ========== INITIALIZE ================================================ */

    /// @notice Creates a new soul linker
    /// @param owner Owner of the smart contract
    /// @param _soulboundIdentity Soulbound identity smart contract
    /// @param _addPermissionPrice Store permission price in stable coin
    /// @param _addPermissionPriceMASA Store permission price in MASA
    /// @param paymentParams Payment gateway params
    constructor(
        address owner,
        ISoulboundIdentity _soulboundIdentity,
        uint256 _addPermissionPrice,
        uint256 _addPermissionPriceMASA,
        PaymentParams memory paymentParams
    ) EIP712("SoulLinker", "1.0.0") PaymentGateway(owner, paymentParams) {
        require(address(_soulboundIdentity) != address(0), "ZERO_ADDRESS");

        soulboundIdentity = _soulboundIdentity;

        addPermissionPrice = _addPermissionPrice;
        addPermissionPriceMASA = _addPermissionPriceMASA;
    }

    /* ========== RESTRICTED FUNCTIONS ====================================== */

    /// @notice Sets the SoulboundIdentity contract address linked to this soul name
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

    /// @notice Adds an SBT to the list of linked SBTs
    /// @dev The caller must be the owner to call this function
    /// @param token Address of the SBT contract
    function addLinkedSBT(address token) external onlyOwner {
        require(address(token) != address(0), "ZERO_ADDRESS");
        require(!linkedSBT[token], "SBT_ALREADY_LINKED");

        linkedSBT[token] = true;
        linkedSBTs.push(token);
    }

    /// @notice Removes an SBT from the list of linked SBTs
    /// @dev The caller must be the owner to call this function
    /// @param token Address of the SBT contract
    function removeLinkedSBT(address token) external onlyOwner {
        require(linkedSBT[token], "SBT_NOT_LINKED");

        linkedSBT[token] = false;
        _removeLinkedSBT(token);
    }

    /// @notice Sets the price of store permission in stable coin
    /// @dev The caller must have the owner to call this function
    /// @param _addPermissionPrice New price of the store permission in stable coin
    function setAddPermissionPrice(uint256 _addPermissionPrice)
        external
        onlyOwner
    {
        require(addPermissionPrice != _addPermissionPrice, "SAME_VALUE");
        addPermissionPrice = _addPermissionPrice;
    }

    /// @notice Sets the price of store permission in MASA
    /// @dev The caller must have the owner to call this function
    /// @param _addPermissionPriceMASA New price of the store permission in MASA
    function setAddPermissionPriceMASA(uint256 _addPermissionPriceMASA)
        external
        onlyOwner
    {
        require(
            addPermissionPriceMASA != _addPermissionPriceMASA,
            "SAME_VALUE"
        );
        addPermissionPriceMASA = _addPermissionPriceMASA;
    }

    /// @notice Pauses the smart contract
    /// @dev The caller must have the owner to call this function
    function pause() public onlyOwner {
        _pause();
    }

    /// @notice Unpauses the smart contract
    /// @dev The caller must have the owner to call this function
    function unpause() public onlyOwner {
        _unpause();
    }

    /* ========== MUTATIVE FUNCTIONS ======================================== */

    /// @notice Stores the permission, validating the signature of the given read link request
    /// @dev The token must be linked to this soul linker
    /// @param readerIdentityId Id of the identity of the reader
    /// @param ownerIdentityId Id of the identity of the owner of the SBT
    /// @param token Address of the SBT contract
    /// @param tokenId Id of the token
    /// @param data Data that owner wants to share
    /// @param signatureDate Signature date of the signature
    /// @param expirationDate Expiration date of the signature
    /// @param signature Signature of the read link request made by the owner
    function addPermission(
        address paymentMethod,
        uint256 readerIdentityId,
        uint256 ownerIdentityId,
        address token,
        uint256 tokenId,
        string memory data,
        uint256 signatureDate,
        uint256 expirationDate,
        bytes calldata signature
    ) external whenNotPaused {
        require(linkedSBT[token], "SBT_NOT_LINKED");

        address identityOwner = soulboundIdentity.ownerOf(ownerIdentityId);
        address tokenOwner = IERC721Enumerable(token).ownerOf(tokenId);

        require(identityOwner == tokenOwner, "IDENTITY_OWNER_NOT_TOKEN_OWNER");
        require(identityOwner == _msgSender(), "CALLER_NOT_OWNER");
        require(expirationDate >= block.timestamp, "VALID_PERIOD_EXPIRED");
        require(
            _verify(
                _hash(
                    readerIdentityId,
                    ownerIdentityId,
                    token,
                    tokenId,
                    data,
                    signatureDate,
                    expirationDate
                ),
                signature,
                identityOwner
            ),
            "INVALID_SIGNATURE"
        );

        if (addPermissionPriceMASA > 0) {
            // if there is a price in MASA, pay it without conversion rate
            _payWithMASA(addPermissionPriceMASA);
        } else {
            // pay with MASA with conversion rate
            _pay(paymentMethod, addPermissionPrice);
        }

        // token => tokenId => readerIdentityId => signatureDate => PermissionData
        _permissions[token][tokenId][readerIdentityId][
            signatureDate
        ] = PermissionData(ownerIdentityId, data, expirationDate, false);
        _permissionSignatureDates[token][tokenId][readerIdentityId].push(
            signatureDate
        );

        emit PermissionAdded(
            readerIdentityId,
            ownerIdentityId,
            token,
            tokenId,
            data,
            signatureDate,
            expirationDate
        );
    }

    /// @notice Revokes the permission
    /// @dev The token must be linked to this soul linker
    /// @param readerIdentityId Id of the identity of the reader
    /// @param ownerIdentityId Id of the identity of the owner of the SBT
    /// @param token Address of the SBT contract
    /// @param tokenId Id of the token
    /// @param signatureDate Signature date of the signature
    function revokePermission(
        uint256 readerIdentityId,
        uint256 ownerIdentityId,
        address token,
        uint256 tokenId,
        uint256 signatureDate
    ) external whenNotPaused {
        address identityOwner = soulboundIdentity.ownerOf(ownerIdentityId);
        address tokenOwner = IERC721Enumerable(token).ownerOf(tokenId);

        require(identityOwner == tokenOwner, "IDENTITY_OWNER_NOT_TOKEN_OWNER");
        require(identityOwner == _msgSender(), "CALLER_NOT_OWNER");
        require(
            _permissions[token][tokenId][readerIdentityId][signatureDate]
                .isRevoked == false,
            "PERMISSION_ALREADY_REVOKED"
        );

        // token => tokenId => readerIdentityId => signatureDate => PermissionData
        _permissions[token][tokenId][readerIdentityId][signatureDate]
            .isRevoked = true;

        emit PermissionRevoked(
            readerIdentityId,
            ownerIdentityId,
            token,
            tokenId,
            signatureDate
        );
    }

    /* ========== VIEWS ===================================================== */

    /// @notice Returns the identityId owned by the given token
    /// @dev The token must be linked to this soul linker
    /// @param token Address of the SBT contract
    /// @param tokenId Id of the token
    /// @return Id of the identity
    function getIdentityId(address token, uint256 tokenId)
        external
        view
        returns (uint256)
    {
        address owner = IERC721Enumerable(token).ownerOf(tokenId);
        return soulboundIdentity.tokenOfOwner(owner);
    }

    /// @notice Returns the list of linked SBTs by a given SBT token
    /// @dev The token must be linked to this soul linker
    /// @param identityId Id of the identity
    /// @param token Address of the SBT contract
    /// @return List of linked SBTs
    function getSBTLinks(uint256 identityId, address token)
        external
        view
        returns (uint256[] memory)
    {
        require(linkedSBT[token], "SBT_NOT_LINKED");
        address owner = soulboundIdentity.ownerOf(identityId);

        return getSBTLinks(owner, token);
    }

    /// @notice Returns the list of linked SBTs by a given SBT token
    /// @dev The token must be linked to this soul linker
    /// @param owner Address of the owner of the identity
    /// @param token Address of the SBT contract
    /// @return List of linked SBTs
    function getSBTLinks(address owner, address token)
        public
        view
        returns (uint256[] memory)
    {
        require(linkedSBT[token], "SBT_NOT_LINKED");

        uint256 links = IERC721Enumerable(token).balanceOf(owner);
        uint256[] memory sbtLinks = new uint256[](links);
        for (uint256 i = 0; i < links; i++) {
            sbtLinks[i] = IERC721Enumerable(token).tokenOfOwnerByIndex(
                owner,
                i
            );
        }

        return sbtLinks;
    }

    /// @notice Returns the list of permission signature dates for a given SBT token and reader
    /// @param token Address of the SBT contract
    /// @param tokenId Id of the token
    /// @param readerIdentityId Id of the identity of the reader of the SBT
    /// @return List of linked SBTs
    function getPermissionSignatureDates(
        address token,
        uint256 tokenId,
        uint256 readerIdentityId
    ) public view returns (uint256[] memory) {
        return _permissionSignatureDates[token][tokenId][readerIdentityId];
    }

    /// @notice Returns the information of permission dates for a given SBT token and reader
    /// @param token Address of the SBT contract
    /// @param tokenId Id of the token
    /// @param readerIdentityId Id of the identity of the reader of the SBT
    /// @param signatureDate Signature date of the signature
    /// @return permissionData List of linked SBTs
    function getPermissionInfo(
        address token,
        uint256 tokenId,
        uint256 readerIdentityId,
        uint256 signatureDate
    ) public view returns (PermissionData memory) {
        return _permissions[token][tokenId][readerIdentityId][signatureDate];
    }

    /// @notice Validates the permission of the given read link request and returns the
    /// data that reader can read if the permission is valid
    /// @dev The token must be linked to this soul linker
    /// @param readerIdentityId Id of the identity of the reader
    /// @param ownerIdentityId Id of the identity of the owner of the SBT
    /// @param token Address of the SBT contract
    /// @param tokenId Id of the token
    /// @param signatureDate Signature date of the signature
    /// @return Data that the reader can read
    function validatePermission(
        uint256 readerIdentityId,
        uint256 ownerIdentityId,
        address token,
        uint256 tokenId,
        uint256 signatureDate
    ) external view returns (string memory) {
        require(linkedSBT[token], "SBT_NOT_LINKED");

        address identityReader = soulboundIdentity.ownerOf(readerIdentityId);
        address identityOwner = soulboundIdentity.ownerOf(ownerIdentityId);
        address tokenOwner = IERC721Enumerable(token).ownerOf(tokenId);

        PermissionData memory permission = _permissions[token][tokenId][
            readerIdentityId
        ][signatureDate];

        require(identityOwner == tokenOwner, "IDENTITY_OWNER_NOT_TOKEN_OWNER");
        require(identityReader == _msgSender(), "CALLER_NOT_READER");
        require(permission.expirationDate > 0, "PERMISSION_DOES_NOT_EXIST");
        require(
            permission.expirationDate >= block.timestamp,
            "VALID_PERIOD_EXPIRED"
        );
        require(permission.isRevoked == false, "PERMISSION_REVOKED");

        return permission.data;
    }

    /// @notice Returns the price for storing a permission
    /// @dev Returns the current pricing for storing a permission
    /// @param paymentMethod Address of token that user want to pay
    /// @return price Current price of storing a permission
    /// @return paymentMethodUsed Address of the token used to pay
    function getPriceForAddPermission(address paymentMethod)
        public
        view
        returns (uint256 price, address paymentMethodUsed)
    {
        if (
            addPermissionPriceMASA > 0 &&
            masaToken != address(0) &&
            erc20token[masaToken]
        ) {
            // if there is a price in MASA, return it without conversion rate
            return (addPermissionPriceMASA, masaToken);
        } else {
            // return MASA with conversion rate
            return (
                _convertFromStableCoin(paymentMethod, addPermissionPrice),
                paymentMethod
            );
        }
    }

    /* ========== PRIVATE FUNCTIONS ========================================= */

    function _removeLinkedSBT(address token) internal {
        for (uint256 i = 0; i < linkedSBTs.length; i++) {
            if (linkedSBTs[i] == token) {
                linkedSBTs[i] = linkedSBTs[linkedSBTs.length - 1];
                linkedSBTs.pop();
                break;
            }
        }
    }

    function _hash(
        uint256 readerIdentityId,
        uint256 ownerIdentityId,
        address token,
        uint256 tokenId,
        string memory data,
        uint256 signatureDate,
        uint256 expirationDate
    ) internal view returns (bytes32) {
        return
            _hashTypedDataV4(
                keccak256(
                    abi.encode(
                        keccak256(
                            "Link(uint256 readerIdentityId,uint256 ownerIdentityId,address token,uint256 tokenId,string data,uint256 signatureDate,uint256 expirationDate)"
                        ),
                        readerIdentityId,
                        ownerIdentityId,
                        token,
                        tokenId,
                        keccak256(bytes(data)),
                        signatureDate,
                        expirationDate
                    )
                )
            );
    }

    function _verify(
        bytes32 digest,
        bytes memory signature,
        address owner
    ) internal pure returns (bool) {
        return ECDSA.recover(digest, signature) == owner;
    }

    /* ========== MODIFIERS ================================================= */

    /* ========== EVENTS ==================================================== */

    event PermissionAdded(
        uint256 readerIdentityId,
        uint256 ownerIdentityId,
        address token,
        uint256 tokenId,
        string data,
        uint256 signatureDate,
        uint256 expirationDate
    );

    event PermissionRevoked(
        uint256 readerIdentityId,
        uint256 ownerIdentityId,
        address token,
        uint256 tokenId,
        uint256 signatureDate
    );
}

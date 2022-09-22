# SoulboundIdentity

*Masa Finance*

> Soulbound Identity

Soulbound token that represents an identity.

*Soulbound identity, that inherits from the SBT contract.*

## Methods

### DEFAULT_ADMIN_ROLE

```solidity
function DEFAULT_ADMIN_ROLE() external view returns (bytes32)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes32 | undefined |

### MINTER_ROLE

```solidity
function MINTER_ROLE() external view returns (bytes32)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes32 | undefined |

### PAUSER_ROLE

```solidity
function PAUSER_ROLE() external view returns (bytes32)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes32 | undefined |

### approve

```solidity
function approve(address to, uint256 tokenId) external nonpayable
```



*See {IERC721-approve}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| to | address | undefined |
| tokenId | uint256 | undefined |

### balanceOf

```solidity
function balanceOf(address owner) external view returns (uint256)
```



*See {IERC721-balanceOf}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| owner | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### burn

```solidity
function burn(uint256 tokenId) external nonpayable
```

Burns the token

*The caller must own `tokenId` or be an approved operator*

#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | The NFT ID to burn |

### getApproved

```solidity
function getApproved(uint256 tokenId) external view returns (address)
```



*See {IERC721-getApproved}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### getExtension

```solidity
function getExtension() external view returns (string)
```

Returns the extension of the soul name

*This function returns the extension of the soul name*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | string | Extension of the soul name |

### getRoleAdmin

```solidity
function getRoleAdmin(bytes32 role) external view returns (bytes32)
```



*Returns the admin role that controls `role`. See {grantRole} and {revokeRole}. To change a role&#39;s admin, use {_setRoleAdmin}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| role | bytes32 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes32 | undefined |

### getSoulName

```solidity
function getSoulName() external view returns (contract ISoulName)
```

Returns the address of the SoulName contract linked to this identity

*This function returns the address of the SoulName contract linked to this identity*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | contract ISoulName | Address of the SoulName contract |

### getSoulNames

```solidity
function getSoulNames(uint256 tokenId) external view returns (string[] sbtNames)
```

Returns all the identity names of an identity

*This function queries all the identity names of the specified identity Id*

#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | TokenId of the identity |

#### Returns

| Name | Type | Description |
|---|---|---|
| sbtNames | string[] | Array of soul names associated to the identity Id |

### getSoulNames

```solidity
function getSoulNames(address owner) external view returns (string[] sbtNames)
```

Returns all the identity names of an account

*This function queries all the identity names of the specified account*

#### Parameters

| Name | Type | Description |
|---|---|---|
| owner | address | Address of the owner of the identities |

#### Returns

| Name | Type | Description |
|---|---|---|
| sbtNames | string[] | Array of soul names associated to the account |

### getTokenData

```solidity
function getTokenData(string name) external view returns (string sbtName, uint256 identityId, uint256 expirationDate)
```

Returns the information of a soul name

*This function queries the information of a soul name*

#### Parameters

| Name | Type | Description |
|---|---|---|
| name | string | Name of the soul name |

#### Returns

| Name | Type | Description |
|---|---|---|
| sbtName | string | Soul name, in upper/lower case and extension |
| identityId | uint256 | Identity id of the soul name |
| expirationDate | uint256 | Expiration date of the soul name |

### grantRole

```solidity
function grantRole(bytes32 role, address account) external nonpayable
```



*Grants `role` to `account`. If `account` had not been already granted `role`, emits a {RoleGranted} event. Requirements: - the caller must have ``role``&#39;s admin role. May emit a {RoleGranted} event.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| role | bytes32 | undefined |
| account | address | undefined |

### hasRole

```solidity
function hasRole(bytes32 role, address account) external view returns (bool)
```



*Returns `true` if `account` has been granted `role`.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| role | bytes32 | undefined |
| account | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### isApprovedForAll

```solidity
function isApprovedForAll(address owner, address operator) external view returns (bool)
```



*See {IERC721-isApprovedForAll}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| owner | address | undefined |
| operator | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### mint

```solidity
function mint(address to) external nonpayable returns (uint256)
```

Mints a new soulbound identity

*The caller can only mint one identity per address*

#### Parameters

| Name | Type | Description |
|---|---|---|
| to | address | Address of the owner of the new identity |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### mintIdentityWithName

```solidity
function mintIdentityWithName(address to, string name, uint256 period) external payable returns (uint256)
```

Mints a new soulbound identity with a SoulName associated to it

*The caller can only mint one identity per address, and the name must be unique*

#### Parameters

| Name | Type | Description |
|---|---|---|
| to | address | Address of the owner of the new identity |
| name | string | Name of the new identity |
| period | uint256 | Period of validity of the name |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### name

```solidity
function name() external view returns (string)
```



*See {IERC721Metadata-name}.*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | string | undefined |

### ownerOf

```solidity
function ownerOf(uint256 tokenId) external view returns (address)
```

Returns the owner address of an identity

*This function returns the owner address of the identity specified by the tokenId*

#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | TokenId of the identity |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | Address of the owner of the identity |

### ownerOf

```solidity
function ownerOf(string name) external view returns (address)
```

Returns the owner address of a soul name

*This function returns the owner address of the soul name identity specified by the name*

#### Parameters

| Name | Type | Description |
|---|---|---|
| name | string | Name of the soul name |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | Address of the owner of the identity |

### pause

```solidity
function pause() external nonpayable
```

Pauses the operations in the smart contract

*Sets an emergency stop mechanism that can be triggered by an authorized account.*


### paused

```solidity
function paused() external view returns (bool)
```



*Returns true if the contract is paused, and false otherwise.*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### renounceRole

```solidity
function renounceRole(bytes32 role, address account) external nonpayable
```



*Revokes `role` from the calling account. Roles are often managed via {grantRole} and {revokeRole}: this function&#39;s purpose is to provide a mechanism for accounts to lose their privileges if they are compromised (such as when a trusted device is misplaced). If the calling account had been revoked `role`, emits a {RoleRevoked} event. Requirements: - the caller must be `account`. May emit a {RoleRevoked} event.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| role | bytes32 | undefined |
| account | address | undefined |

### revokeRole

```solidity
function revokeRole(bytes32 role, address account) external nonpayable
```



*Revokes `role` from `account`. If `account` had been granted `role`, emits a {RoleRevoked} event. Requirements: - the caller must have ``role``&#39;s admin role. May emit a {RoleRevoked} event.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| role | bytes32 | undefined |
| account | address | undefined |

### safeTransferFrom

```solidity
function safeTransferFrom(address from, address to, uint256 tokenId) external pure
```

Transfers the ownership of an NFT from one address to another address

*This will raise an exception because the token is not transferable.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| from | address | The current owner of the NFT |
| to | address | The new owner |
| tokenId | uint256 | The NFT ID to transfer |

### safeTransferFrom

```solidity
function safeTransferFrom(address from, address to, uint256 tokenId, bytes data) external pure
```

Transfer ownership of the token to another address safely

*This will raise an exception because the token is not transferable.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| from | address | The current owner of the NFT |
| to | address | The new owner |
| tokenId | uint256 | The NFT ID to transfer |
| data | bytes | Additional data with no specified format, sent in call to `_to` |

### setApprovalForAll

```solidity
function setApprovalForAll(address operator, bool approved) external nonpayable
```



*See {IERC721-setApprovalForAll}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| operator | address | undefined |
| approved | bool | undefined |

### setSoulName

```solidity
function setSoulName(contract ISoulName _soulName) external nonpayable
```

Sets the SoulName contract address linked to this identity

*The caller must have the admin role to call this function*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _soulName | contract ISoulName | Address of the SoulName contract |

### soulLinker

```solidity
function soulLinker() external view returns (contract ISoulLinker)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | contract ISoulLinker | undefined |

### soulName

```solidity
function soulName() external view returns (contract ISoulName)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | contract ISoulName | undefined |

### soulNameExists

```solidity
function soulNameExists(string name) external view returns (bool exists)
```

Checks if a soul name already exists

*This function queries if a soul name already exists*

#### Parameters

| Name | Type | Description |
|---|---|---|
| name | string | Name of the soul name |

#### Returns

| Name | Type | Description |
|---|---|---|
| exists | bool | `true` if the soul name exists, `false` otherwise |

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) external view returns (bool)
```

Query if a contract implements an interface

*Interface identification is specified in ERC-165.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| interfaceId | bytes4 | The interface identifier, as specified in ERC-165 |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | `true` if the contract implements `interfaceId` and  `interfaceId` is not 0xffffffff, `false` otherwise |

### symbol

```solidity
function symbol() external view returns (string)
```



*See {IERC721Metadata-symbol}.*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | string | undefined |

### tokenByIndex

```solidity
function tokenByIndex(uint256 index) external view returns (uint256)
```



*See {IERC721Enumerable-tokenByIndex}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| index | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### tokenOfOwner

```solidity
function tokenOfOwner(address owner) external view returns (uint256)
```

Returns the identity id of an account

*This function returns the tokenId of the identity owned by an account*

#### Parameters

| Name | Type | Description |
|---|---|---|
| owner | address | Address of the owner of the identity |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | TokenId of the identity owned by the account |

### tokenOfOwnerByIndex

```solidity
function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256)
```



*See {IERC721Enumerable-tokenOfOwnerByIndex}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| owner | address | undefined |
| index | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### tokenURI

```solidity
function tokenURI(string name) external view returns (string)
```

Returns the URI of a soul name

*This function returns the token URI of the soul name identity specified by the name*

#### Parameters

| Name | Type | Description |
|---|---|---|
| name | string | Name of the soul name |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | string | URI of the identity associated to a soul name |

### tokenURI

```solidity
function tokenURI(address owner) external view returns (string)
```

Returns the URI of the owner of an identity

*This function returns the token URI of the identity owned by an account*

#### Parameters

| Name | Type | Description |
|---|---|---|
| owner | address | Address of the owner of the identity |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | string | URI of the identity owned by the account |

### tokenURI

```solidity
function tokenURI(uint256 tokenId) external view returns (string)
```

A distinct Uniform Resource Identifier (URI) for a given asset.

*Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC  3986. The URI may point to a JSON file that conforms to the &quot;ERC721  Metadata JSON Schema&quot;.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | NFT to get the URI of |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | string | URI of the NFT |

### totalSupply

```solidity
function totalSupply() external view returns (uint256)
```



*See {IERC721Enumerable-totalSupply}.*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### transferFrom

```solidity
function transferFrom(address from, address to, uint256 tokenId) external pure
```

Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE  THEY MAY BE PERMANENTLY LOST

*This will raise an exception because the token is not transferable.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| from | address | The current owner of the NFT |
| to | address | The new owner |
| tokenId | uint256 | The NFT ID to transfer |

### unpause

```solidity
function unpause() external nonpayable
```

Unpauses the operations in the smart contract

*Unsets an emergency stop mechanism. It can be triggered by an authorized account.*




## Events

### Approval

```solidity
event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| owner `indexed` | address | undefined |
| approved `indexed` | address | undefined |
| tokenId `indexed` | uint256 | undefined |

### ApprovalForAll

```solidity
event ApprovalForAll(address indexed owner, address indexed operator, bool approved)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| owner `indexed` | address | undefined |
| operator `indexed` | address | undefined |
| approved  | bool | undefined |

### Paused

```solidity
event Paused(address account)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| account  | address | undefined |

### RoleAdminChanged

```solidity
event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| role `indexed` | bytes32 | undefined |
| previousAdminRole `indexed` | bytes32 | undefined |
| newAdminRole `indexed` | bytes32 | undefined |

### RoleGranted

```solidity
event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| role `indexed` | bytes32 | undefined |
| account `indexed` | address | undefined |
| sender `indexed` | address | undefined |

### RoleRevoked

```solidity
event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| role `indexed` | bytes32 | undefined |
| account `indexed` | address | undefined |
| sender `indexed` | address | undefined |

### Transfer

```solidity
event Transfer(address indexed from, address indexed to, uint256 indexed tokenId)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| from `indexed` | address | undefined |
| to `indexed` | address | undefined |
| tokenId `indexed` | uint256 | undefined |

### Unpaused

```solidity
event Unpaused(address account)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| account  | address | undefined |




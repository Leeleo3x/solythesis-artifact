pragma solidity ^0.5.0;
library Roles {
struct Role {
    mapping (address => bool) bearer;
  }
function add (Role storage role, address account) internal {
require(account != address(0));
role.bearer[account] = true;
}

function remove (Role storage role, address account) internal {
require(account != address(0));
role.bearer[account] = false;
}

function has (Role storage role, address account) internal view returns (bool) {
require(account != address(0));
{
return role.bearer[account];
}

}

}
contract MinterRole {
using Roles for Roles.Role;
event MinterAdded(address indexed account);
event MinterRemoved(address indexed account);
Roles.Role private minters;
constructor () public {
minters.add(msg.sender);
}

modifier onlyMinter() {
    require(isMinter(msg.sender));
    _;
  }
function isMinter (address account) public view returns (bool) {
{
return minters.has(account);
}

}

function addMinter (address account) onlyMinter public {
minters.add(account);
emit MinterAdded(account);
}

function renounceMinter () public {
minters.remove(msg.sender);
}

function _removeMinter (address account) internal {
minters.remove(account);
emit MinterRemoved(account);
}

}
interface IERC165 {
function supportsInterface (bytes4 interfaceId) external view returns (bool);
}
contract ERC165 is IERC165 {
bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
mapping (bytes4=>bool) internal _supportedInterfaces;
constructor () public {
_registerInterface(_InterfaceId_ERC165);
}

function supportsInterface (bytes4 interfaceId) external view returns (bool) {
{
return _supportedInterfaces[interfaceId];
}

}

function _registerInterface (bytes4 interfaceId) internal {
require(interfaceId != 0xffffffff);
_supportedInterfaces[interfaceId] = true;
}

}
library SafeMath {
function mul (uint256 a, uint256 b) internal pure returns (uint256) {
if (a == 0) {
{
return 0;
}

}

uint256 c = a * b;
require(c / a == b);
{
return c;
}

}

function div (uint256 a, uint256 b) internal pure returns (uint256) {
require(b > 0);
uint256 c = a / b;
{
return c;
}

}

function sub (uint256 a, uint256 b) internal pure returns (uint256) {
require(b <= a);
uint256 c = a - b;
{
return c;
}

}

function add (uint256 a, uint256 b) internal pure returns (uint256) {
uint256 c = a + b;
require(c >= a);
{
return c;
}

}

function mod (uint256 a, uint256 b) internal pure returns (uint256) {
require(b != 0);
{
return a % b;
}

}

}
library Address {
function isContract (address account) internal view returns (bool) {
uint256 size;
assembly {
size := extcodesize(account)
}

{
return size > 0;
}

}

}
contract IERC721 is IERC165 {
uint256[] internal _allTokens;
event Transfer(
    address indexed from,
    address indexed to,
    uint256 indexed tokenId
  );
event Approval(
    address indexed owner,
    address indexed approved,
    uint256 indexed tokenId
  );
event ApprovalForAll(
    address indexed owner,
    address indexed operator,
    bool approved
  );
function balanceOf (address owner) public view returns (uint256 balance);
function ownerOf (uint256 tokenId) public view returns (address owner);
function approve (address to, uint256 tokenId) public;
function getApproved (uint256 tokenId) public view returns (address operator);
function setApprovalForAll (address operator, bool _approved) public;
function isApprovedForAll (address owner, address operator) public view returns (bool);
function transferFrom (address from, address to, uint256 tokenId) public;
function safeTransferFrom (address from, address to, uint256 tokenId) public;
function safeTransferFrom (
    address from,
    address to,
    uint256 tokenId,
    bytes memory data
  ) public;
}
contract IERC721Receiver {
function onERC721Received (
    address operator,
    address from,
    uint256 tokenId,
    bytes memory data
  ) public returns(bytes4);
}
contract ERC721 is ERC165, IERC721 {
uint256 depth_0;
mapping (address=>bool) a_checker_3;
address[] a_store_4;
uint256 sum_tokenCount;
mapping (uint256=>bool) a_checker_7;
uint256[] a_store_8;
mapping (address=>bool) b_checker_5;
address[] b_store_6;
mapping (address=>uint256) sum_ownersToken;
mapping (address=>bool) a_checker_9;
address[] a_store_10;
using SafeMath for uint256;
using Address for address;
bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
mapping (uint256=>address) internal _tokenOwner;
mapping (uint256=>address) internal _tokenApprovals;
mapping (address=>uint256) internal _ownedTokensCount;
mapping (address=>mapping (address=>bool)) private _operatorApprovals;
bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
constructor () public {
_registerInterface(_InterfaceId_ERC721);
}

function balanceOf (address owner) public view returns (uint256) {
require(owner != address(0));
{
return _ownedTokensCount[owner];
}

}

function ownerOf (uint256 tokenId) public view returns (address) {
address owner = _tokenOwner[tokenId];
require(owner != address(0));
{
return owner;
}

}

function approve (address to, uint256 tokenId) public {
address owner = ownerOf(tokenId);
require(to != owner);
require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
_tokenApprovals[tokenId] = to;
emit Approval(owner, to, tokenId);
}

function getApproved (uint256 tokenId) public view returns (address) {
require(_exists(tokenId));
{
return _tokenApprovals[tokenId];
}

}

function setApprovalForAll (address to, bool approved) public {
require(to != msg.sender);
_operatorApprovals[msg.sender][to] = approved;
emit ApprovalForAll(msg.sender, to, approved);
}

function isApprovedForAll (
    address owner,
    address operator
  ) public view returns (bool) {
{
return _operatorApprovals[owner][operator];
}

}

function transferFrom (
    address from,
    address to,
    uint256 tokenId
  ) public {
depth_0 += 1;
require(_isApprovedOrOwner(msg.sender, tokenId));
require(to != address(0));
_clearApproval(from, tokenId);
_removeTokenFrom(from, tokenId);
_addTokenTo(to, tokenId);
emit Transfer(from, to, tokenId);
depth_0 -= 1;
if (depth_0 == 0) {
{
{
sum_tokenCount = 0;
}

for (uint256 index_2 = 0; index_2 < a_store_4.length; index_2 += 1) {
sum_tokenCount += _ownedTokensCount[a_store_4[index_2]];
assert(sum_tokenCount >= _ownedTokensCount[a_store_4[index_2]]);
}

}

assert(sum_tokenCount == _allTokens.length);
{
for (uint256 index_3 = 0; index_3 < b_store_6.length; index_3 += 1) {
sum_ownersToken[b_store_6[index_3]] = 0;
}

for (uint256 index_4 = 0; index_4 < a_store_8.length; index_4 += 1) {
sum_ownersToken[_tokenOwner[a_store_8[index_4]]] += 1;
assert(sum_ownersToken[_tokenOwner[a_store_8[index_4]]] >= 1);
}

}

for (uint256 index_7 = 0; index_7 < a_store_10.length; index_7 += 1) {
assert(_ownedTokensCount[a_store_10[index_7]] == sum_ownersToken[a_store_10[index_7]]);
}

}

}

function safeTransferFrom (
    address from,
    address to,
    uint256 tokenId
  ) public {
depth_0 += 1;
safeTransferFrom(from, to, tokenId, "");
depth_0 -= 1;
if (depth_0 == 0) {
{
{
sum_tokenCount = 0;
}

for (uint256 index_8 = 0; index_8 < a_store_4.length; index_8 += 1) {
sum_tokenCount += _ownedTokensCount[a_store_4[index_8]];
assert(sum_tokenCount >= _ownedTokensCount[a_store_4[index_8]]);
}

}

assert(sum_tokenCount == _allTokens.length);
{
for (uint256 index_9 = 0; index_9 < b_store_6.length; index_9 += 1) {
sum_ownersToken[b_store_6[index_9]] = 0;
}

for (uint256 index_10 = 0; index_10 < a_store_8.length; index_10 += 1) {
sum_ownersToken[_tokenOwner[a_store_8[index_10]]] += 1;
assert(sum_ownersToken[_tokenOwner[a_store_8[index_10]]] >= 1);
}

}

for (uint256 index_13 = 0; index_13 < a_store_10.length; index_13 += 1) {
assert(_ownedTokensCount[a_store_10[index_13]] == sum_ownersToken[a_store_10[index_13]]);
}

}

}

function safeTransferFrom (
    address from,
    address to,
    uint256 tokenId,
    bytes memory _data
  ) public {
depth_0 += 1;
transferFrom(from, to, tokenId);
require(_checkAndCallSafeTransfer(from, to, tokenId, _data));
depth_0 -= 1;
if (depth_0 == 0) {
{
{
sum_tokenCount = 0;
}

for (uint256 index_14 = 0; index_14 < a_store_4.length; index_14 += 1) {
sum_tokenCount += _ownedTokensCount[a_store_4[index_14]];
assert(sum_tokenCount >= _ownedTokensCount[a_store_4[index_14]]);
}

}

assert(sum_tokenCount == _allTokens.length);
{
for (uint256 index_15 = 0; index_15 < b_store_6.length; index_15 += 1) {
sum_ownersToken[b_store_6[index_15]] = 0;
}

for (uint256 index_16 = 0; index_16 < a_store_8.length; index_16 += 1) {
sum_ownersToken[_tokenOwner[a_store_8[index_16]]] += 1;
assert(sum_ownersToken[_tokenOwner[a_store_8[index_16]]] >= 1);
}

}

for (uint256 index_19 = 0; index_19 < a_store_10.length; index_19 += 1) {
assert(_ownedTokensCount[a_store_10[index_19]] == sum_ownersToken[a_store_10[index_19]]);
}

}

}

function _exists (uint256 tokenId) internal view returns (bool) {
address owner = _tokenOwner[tokenId];
{
return owner != address(0);
}

}

function _isApprovedOrOwner (
    address spender,
    uint256 tokenId
  ) internal view returns (bool) {
address owner = ownerOf(tokenId);
{
return (
      spender == owner ||
      getApproved(tokenId) == spender ||
      isApprovedForAll(owner, spender)
    );
}

}

function _mint (address to, uint256 tokenId) internal {
require(to != address(0));
_addTokenTo(to, tokenId);
emit Transfer(address(0), to, tokenId);
}

function _burn (address owner, uint256 tokenId) internal {
_clearApproval(owner, tokenId);
_removeTokenFrom(owner, tokenId);
emit Transfer(owner, address(0), tokenId);
}

function _clearApproval (address owner, uint256 tokenId) internal {
require(ownerOf(tokenId) == owner);
if (_tokenApprovals[tokenId] != address(0)) {
_tokenApprovals[tokenId] = address(0);
}

}

function _addTokenTo (address to, uint256 tokenId) internal {
require(_tokenOwner[tokenId] == address(0));
_tokenOwner[tokenId] = to;if (! a_checker_7[tokenId]) {
a_store_8.push(tokenId);
a_checker_7[tokenId] = true;
}
if (! b_checker_5[_tokenOwner[tokenId]]) {
b_store_6.push(_tokenOwner[tokenId]);
b_checker_5[_tokenOwner[tokenId]] = true;
}

_ownedTokensCount[to] = _ownedTokensCount[to].add(1);if (! a_checker_3[to]) {
a_store_4.push(to);
a_checker_3[to] = true;
}
if (! a_checker_9[to]) {
a_store_10.push(to);
a_checker_9[to] = true;
}

}

function _removeTokenFrom (address from, uint256 tokenId) internal {
require(ownerOf(tokenId) == from);
_ownedTokensCount[from] = _ownedTokensCount[from].sub(1);if (! a_checker_3[from]) {
a_store_4.push(from);
a_checker_3[from] = true;
}
if (! a_checker_9[from]) {
a_store_10.push(from);
a_checker_9[from] = true;
}

_tokenOwner[tokenId] = address(0);if (! a_checker_7[tokenId]) {
a_store_8.push(tokenId);
a_checker_7[tokenId] = true;
}
if (! b_checker_5[_tokenOwner[tokenId]]) {
b_store_6.push(_tokenOwner[tokenId]);
b_checker_5[_tokenOwner[tokenId]] = true;
}

}

function _checkAndCallSafeTransfer (
    address from,
    address to,
    uint256 tokenId,
    bytes memory _data
  ) internal returns (bool) {
if (! to.isContract()) {
{
return true;
}

}

bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
{
return (retval == _ERC721_RECEIVED);
}

}

}
contract IERC721Enumerable is IERC721 {
function totalSupply () public view returns (uint256);
function tokenOfOwnerByIndex (
    address owner,
    uint256 index
  ) public view returns (uint256 tokenId);
function tokenByIndex (uint256 index) public view returns (uint256);
}
contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
mapping (address=>uint256[]) private _ownedTokens;
mapping (uint256=>uint256) private _ownedTokensIndex;
mapping (uint256=>uint256) private _allTokensIndex;
bytes4 private constant _InterfaceId_ERC721Enumerable = 0x780e9d63;
constructor () public {
_registerInterface(_InterfaceId_ERC721Enumerable);
}

function tokenOfOwnerByIndex (
    address owner,
    uint256 index
  ) public view returns (uint256) {
require(index < balanceOf(owner));
{
return _ownedTokens[owner][index];
}

}

function totalSupply () public view returns (uint256) {
{
return _allTokens.length;
}

}

function tokenByIndex (uint256 index) public view returns (uint256) {
require(index < totalSupply());
{
return _allTokens[index];
}

}

function _addTokenTo (address to, uint256 tokenId) internal {
super._addTokenTo(to, tokenId);
uint256 length = _ownedTokens[to].length;
_ownedTokens[to].push(tokenId);
_ownedTokensIndex[tokenId] = length;
}

function _removeTokenFrom (address from, uint256 tokenId) internal {
super._removeTokenFrom(from, tokenId);
uint256 tokenIndex = _ownedTokensIndex[tokenId];
uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
uint256 lastToken = _ownedTokens[from][lastTokenIndex];
_ownedTokens[from][tokenIndex] = lastToken;
_ownedTokens[from].length --;
_ownedTokensIndex[tokenId] = 0;
_ownedTokensIndex[lastToken] = tokenIndex;
}

function _mint (address to, uint256 tokenId) internal {
super._mint(to, tokenId);
_allTokensIndex[tokenId] = _allTokens.length;
_allTokens.push(tokenId);
}

function _burn (address owner, uint256 tokenId) internal {
super._burn(owner, tokenId);
uint256 tokenIndex = _allTokensIndex[tokenId];
uint256 lastTokenIndex = _allTokens.length.sub(1);
uint256 lastToken = _allTokens[lastTokenIndex];
_allTokens[tokenIndex] = lastToken;
_allTokens[lastTokenIndex] = 0;
_allTokens.length --;
_allTokensIndex[tokenId] = 0;
_allTokensIndex[lastToken] = tokenIndex;
}

}
contract IERC721Metadata is IERC721 {
function name () external view returns (string memory);
function symbol () external view returns (string memory);
function tokenURI (uint256 tokenId) public view returns (string memory);
}
contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
string internal _name;
string internal _symbol;
mapping (uint256=>string) private _tokenURIs;
bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
constructor (string memory name, string memory symbol) public {
_name = name;
_symbol = symbol;
_registerInterface(InterfaceId_ERC721Metadata);
}

function name () external view returns (string memory ) {
{
return _name;
}

}

function symbol () external view returns (string memory) {
{
return _symbol;
}

}

function tokenURI (uint256 tokenId) public view returns (string memory) {
require(_exists(tokenId));
{
return _tokenURIs[tokenId];
}

}

function _setTokenURI (uint256 tokenId, string memory uri) internal {
require(_exists(tokenId));
_tokenURIs[tokenId] = uri;
}

function _burn (address owner, uint256 tokenId) internal {
super._burn(owner, tokenId);
if (bytes(_tokenURIs[tokenId]).length != 0) {
delete _tokenURIs[tokenId];
}

}

}
contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
constructor (string memory name, string memory symbol) ERC721Metadata(name, symbol) public {
}

}
contract ERC721Mintable is ERC721Full, MinterRole {
event MintingFinished();
bool private _mintingFinished = false;
modifier onlyBeforeMintingFinished() {
    require(!_mintingFinished);
    _;
  }
function mintingFinished () public view returns(bool) {
{
return _mintingFinished;
}

}

function mint (
    address to,
    uint256 tokenId
  ) onlyMinter onlyBeforeMintingFinished public returns (bool) {
depth_0 += 1;
_mint(to, tokenId);
{
depth_0 -= 1;
if (depth_0 == 0) {
{
{
sum_tokenCount = 0;
}

for (uint256 index_20 = 0; index_20 < a_store_4.length; index_20 += 1) {
sum_tokenCount += _ownedTokensCount[a_store_4[index_20]];
assert(sum_tokenCount >= _ownedTokensCount[a_store_4[index_20]]);
}

}

assert(sum_tokenCount == _allTokens.length);
{
for (uint256 index_21 = 0; index_21 < b_store_6.length; index_21 += 1) {
sum_ownersToken[b_store_6[index_21]] = 0;
}

for (uint256 index_22 = 0; index_22 < a_store_8.length; index_22 += 1) {
sum_ownersToken[_tokenOwner[a_store_8[index_22]]] += 1;
assert(sum_ownersToken[_tokenOwner[a_store_8[index_22]]] >= 1);
}

}

for (uint256 index_25 = 0; index_25 < a_store_10.length; index_25 += 1) {
assert(_ownedTokensCount[a_store_10[index_25]] == sum_ownersToken[a_store_10[index_25]]);
}

}

return true;
}

depth_0 -= 1;
if (depth_0 == 0) {
{
{
sum_tokenCount = 0;
}

for (uint256 index_26 = 0; index_26 < a_store_4.length; index_26 += 1) {
sum_tokenCount += _ownedTokensCount[a_store_4[index_26]];
assert(sum_tokenCount >= _ownedTokensCount[a_store_4[index_26]]);
}

}

assert(sum_tokenCount == _allTokens.length);
{
for (uint256 index_27 = 0; index_27 < b_store_6.length; index_27 += 1) {
sum_ownersToken[b_store_6[index_27]] = 0;
}

for (uint256 index_28 = 0; index_28 < a_store_8.length; index_28 += 1) {
sum_ownersToken[_tokenOwner[a_store_8[index_28]]] += 1;
assert(sum_ownersToken[_tokenOwner[a_store_8[index_28]]] >= 1);
}

}

for (uint256 index_30 = 0; index_30 < a_store_10.length; index_30 += 1) {
assert(_ownedTokensCount[a_store_10[index_30]] == sum_ownersToken[a_store_10[index_30]]);
}

}

}

function mintWithTokenURI (
    address to,
    uint256 tokenId,
    string memory tokenURI
  ) onlyMinter onlyBeforeMintingFinished public returns (bool) {
depth_0 += 1;
mint(to, tokenId);
_setTokenURI(tokenId, tokenURI);
{
depth_0 -= 1;
if (depth_0 == 0) {
{
{
sum_tokenCount = 0;
}

for (uint256 index_31 = 0; index_31 < a_store_4.length; index_31 += 1) {
sum_tokenCount += _ownedTokensCount[a_store_4[index_31]];
assert(sum_tokenCount >= _ownedTokensCount[a_store_4[index_31]]);
}

}

assert(sum_tokenCount == _allTokens.length);
{
for (uint256 index_32 = 0; index_32 < b_store_6.length; index_32 += 1) {
sum_ownersToken[b_store_6[index_32]] = 0;
}

for (uint256 index_33 = 0; index_33 < a_store_8.length; index_33 += 1) {
sum_ownersToken[_tokenOwner[a_store_8[index_33]]] += 1;
assert(sum_ownersToken[_tokenOwner[a_store_8[index_33]]] >= 1);
}

}

for (uint256 index_36 = 0; index_36 < a_store_10.length; index_36 += 1) {
assert(_ownedTokensCount[a_store_10[index_36]] == sum_ownersToken[a_store_10[index_36]]);
}

}

return true;
}

depth_0 -= 1;
if (depth_0 == 0) {
{
{
sum_tokenCount = 0;
}

for (uint256 index_37 = 0; index_37 < a_store_4.length; index_37 += 1) {
sum_tokenCount += _ownedTokensCount[a_store_4[index_37]];
assert(sum_tokenCount >= _ownedTokensCount[a_store_4[index_37]]);
}

}

assert(sum_tokenCount == _allTokens.length);
{
for (uint256 index_38 = 0; index_38 < b_store_6.length; index_38 += 1) {
sum_ownersToken[b_store_6[index_38]] = 0;
}

for (uint256 index_39 = 0; index_39 < a_store_8.length; index_39 += 1) {
sum_ownersToken[_tokenOwner[a_store_8[index_39]]] += 1;
assert(sum_ownersToken[_tokenOwner[a_store_8[index_39]]] >= 1);
}

}

for (uint256 index_41 = 0; index_41 < a_store_10.length; index_41 += 1) {
assert(_ownedTokensCount[a_store_10[index_41]] == sum_ownersToken[a_store_10[index_41]]);
}

}

}

function finishMinting () onlyMinter onlyBeforeMintingFinished public returns (bool) {
_mintingFinished = true;
emit MintingFinished();
{
return true;
}

}

}
contract PauserRole {
using Roles for Roles.Role;
event PauserAdded(address indexed account);
event PauserRemoved(address indexed account);
Roles.Role private pausers;
constructor () public {
pausers.add(msg.sender);
}

modifier onlyPauser() {
    require(isPauser(msg.sender));
    _;
  }
function isPauser (address account) public view returns (bool) {
{
return pausers.has(account);
}

}

function addPauser (address account) onlyPauser public {
pausers.add(account);
emit PauserAdded(account);
}

function renouncePauser () public {
pausers.remove(msg.sender);
}

function _removePauser (address account) internal {
pausers.remove(account);
emit PauserRemoved(account);
}

}
contract Pausable is PauserRole {
event Paused();
event Unpaused();
bool private _paused = false;
function paused () public view returns(bool) {
{
return _paused;
}

}

modifier whenNotPaused() {
    require(!_paused);
    _;
  }
modifier whenPaused() {
    require(_paused);
    _;
  }
function pause () onlyPauser whenNotPaused public {
_paused = true;
emit Paused();
}

function unpause () onlyPauser whenPaused public {
_paused = false;
emit Unpaused();
}

}
contract ERC721Pausable is ERC721, Pausable {
function approve (
    address to,
    uint256 tokenId
  ) whenNotPaused public {
super.approve(to, tokenId);
}

function setApprovalForAll (
    address to,
    bool approved
  ) whenNotPaused public {
super.setApprovalForAll(to, approved);
}

function transferFrom (
    address from,
    address to,
    uint256 tokenId
  ) whenNotPaused public {
depth_0 += 1;
super.transferFrom(from, to, tokenId);
depth_0 -= 1;
if (depth_0 == 0) {
{
{
sum_tokenCount = 0;
}

for (uint256 index_42 = 0; index_42 < a_store_4.length; index_42 += 1) {
sum_tokenCount += _ownedTokensCount[a_store_4[index_42]];
assert(sum_tokenCount >= _ownedTokensCount[a_store_4[index_42]]);
}

}

assert(sum_tokenCount == _allTokens.length);
{
for (uint256 index_43 = 0; index_43 < b_store_6.length; index_43 += 1) {
sum_ownersToken[b_store_6[index_43]] = 0;
}

for (uint256 index_44 = 0; index_44 < a_store_8.length; index_44 += 1) {
sum_ownersToken[_tokenOwner[a_store_8[index_44]]] += 1;
assert(sum_ownersToken[_tokenOwner[a_store_8[index_44]]] >= 1);
}

}

for (uint256 index_47 = 0; index_47 < a_store_10.length; index_47 += 1) {
assert(_ownedTokensCount[a_store_10[index_47]] == sum_ownersToken[a_store_10[index_47]]);
}

}

}

}
contract HeroAsset is ERC721Full, ERC721Mintable, ERC721Pausable {
uint16 public constant HERO_TYPE_OFFSET = 10000;
string public tokenURIPrefix = "https://www.mycryptoheroes.net/metadata/hero/";
mapping (uint16=>uint16) private heroTypeToSupplyLimit;
constructor () ERC721Full("MyCryptoHeroes:Hero", "MCHH") public {
}

function setSupplyLimit (uint16 _heroType, uint16 _supplyLimit) onlyMinter external {
require(heroTypeToSupplyLimit[_heroType] == 0 || _supplyLimit < heroTypeToSupplyLimit[_heroType], "_supplyLimit is bigger");
heroTypeToSupplyLimit[_heroType] = _supplyLimit;
}

function setTokenURIPrefix (string memory _tokenURIPrefix) onlyMinter public {
tokenURIPrefix = _tokenURIPrefix;
}

function getSupplyLimit (uint16 _heroType) public view returns (uint16) {
{
return heroTypeToSupplyLimit[_heroType];
}

}

function mintHeroAsset (address _owner, uint256 _tokenId) onlyMinter public {
depth_0 += 1;
uint16 _heroType = uint16(_tokenId / HERO_TYPE_OFFSET);
uint16 _heroTypeIndex = uint16(_tokenId % HERO_TYPE_OFFSET) - 1;
require(_heroTypeIndex < heroTypeToSupplyLimit[_heroType], "supply over");
_mint(_owner, _tokenId);
depth_0 -= 1;
if (depth_0 == 0) {
{
{
sum_tokenCount = 0;
}

for (uint256 index_48 = 0; index_48 < a_store_4.length; index_48 += 1) {
sum_tokenCount += _ownedTokensCount[a_store_4[index_48]];
assert(sum_tokenCount >= _ownedTokensCount[a_store_4[index_48]]);
}

}

assert(sum_tokenCount == _allTokens.length);
{
for (uint256 index_49 = 0; index_49 < b_store_6.length; index_49 += 1) {
sum_ownersToken[b_store_6[index_49]] = 0;
}

for (uint256 index_50 = 0; index_50 < a_store_8.length; index_50 += 1) {
sum_ownersToken[_tokenOwner[a_store_8[index_50]]] += 1;
assert(sum_ownersToken[_tokenOwner[a_store_8[index_50]]] >= 1);
}

}

for (uint256 index_53 = 0; index_53 < a_store_10.length; index_53 += 1) {
assert(_ownedTokensCount[a_store_10[index_53]] == sum_ownersToken[a_store_10[index_53]]);
}

}

}

function transfer (address _to, uint256 _tokenId) public {
depth_0 += 1;
safeTransferFrom(msg.sender, _to, _tokenId);
depth_0 -= 1;
if (depth_0 == 0) {
{
{
sum_tokenCount = 0;
}

for (uint256 index_54 = 0; index_54 < a_store_4.length; index_54 += 1) {
sum_tokenCount += _ownedTokensCount[a_store_4[index_54]];
assert(sum_tokenCount >= _ownedTokensCount[a_store_4[index_54]]);
}

}

assert(sum_tokenCount == _allTokens.length);
{
for (uint256 index_55 = 0; index_55 < b_store_6.length; index_55 += 1) {
sum_ownersToken[b_store_6[index_55]] = 0;
}

for (uint256 index_56 = 0; index_56 < a_store_8.length; index_56 += 1) {
sum_ownersToken[_tokenOwner[a_store_8[index_56]]] += 1;
assert(sum_ownersToken[_tokenOwner[a_store_8[index_56]]] >= 1);
}

}

for (uint256 index_59 = 0; index_59 < a_store_10.length; index_59 += 1) {
assert(_ownedTokensCount[a_store_10[index_59]] == sum_ownersToken[a_store_10[index_59]]);
}

}

}

function tokenURI (uint256 tokenId) public view returns (string memory) {
bytes32 tokenIdBytes;
if (tokenId == 0) {
tokenIdBytes = "0";
}
 else {
uint256 value = tokenId;
while (value > 0) {
                tokenIdBytes = bytes32(uint256(tokenIdBytes) / (2 ** 8));
                tokenIdBytes |= bytes32(((value % 10) + 48) * 2 ** (8 * 31));
                value /= 10;
            }
}

bytes memory prefixBytes = bytes(tokenURIPrefix);
bytes memory tokenURIBytes = new bytes(prefixBytes.length + tokenIdBytes.length);
uint8 i;
uint8 index = 0;
for (i = 0; i < prefixBytes.length; i ++) {
tokenURIBytes[index] = prefixBytes[i];
index ++;
}

for (i = 0; i < tokenIdBytes.length; i ++) {
tokenURIBytes[index] = tokenIdBytes[i];
index ++;
}

{
return string(tokenURIBytes);
}

}

}

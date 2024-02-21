// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)

pragma solidity ^0.8.0;
abstract contract ReentrancyGuard{
    uint256 private constant _NOT_ENTERED=1;
    uint256 private constant _ENTERED=2;
    uint256 private _status;

    constructor(){
        _status=_NOT_ENTERED;
    }
    modifier nonReentrancy(){
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED,"ReentrancyGaurd:reenttrant call");
        _status=_ENTERED;
        _;
    }
}
//contract ali is ReentrancyGuard{
 //   function add(uint a, uint b)public nonReentrancy() returns(uint){
 //       return a+b;

   //

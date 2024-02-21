// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./ReentrancyGaurd.sol";
import "./ECDSA.sol";
contract UnidirectionalPaymentChannel is ReentrancyGuard{
    using  ECDSA for bytes32;

    address payable public sender;//alice= 0xc88Fca44dFa47f573ccd59606727A7f1F25DDb01
    address payable public receiver;// bob:= 0x7C2e0204da2604aD06e3810a6CA7ECa6A9f0A621

    uint public constant DURATION=7*24*60*60;
    uint public expiresAt;

    constructor(address payable _receiver)payable{
        require(_receiver != address(0),"receiver=zero address");
        sender=payable(msg.sender);
        receiver=_receiver;
        expiresAt= block.timestamp+DURATION;
    }
    function getHash(uint _amount)external view returns(bytes32){
        return _getHash(_amount);
    }
    function _getHash(uint _amount)private view returns(bytes32){
        return keccak256(abi.encodePacked(address(this),_amount));
    }

    function getEthSignedHash(uint _amount)external view returns(bytes32){
        return _getEthSignedHash(_amount);
    }
    function _getEthSignedHash(uint _amount)private view returns(bytes32){
        return _getHash(_amount).toEthSignedMessageHash();
    }
    function verify(uint _amount,bytes memory _sig)external view returns(bool){
        return _verify(_amount,_sig);
    }
    function _verify(uint _amount,bytes memory _sig)private view returns(bool){
        return _getEthSignedHash(_amount).recover(_sig)==sender;
    }
    function close(uint _amount,bytes memory _sig)external nonReentrancy{
        require(msg.sender==receiver,"failed to send ether");
        require(_verify(_amount,_sig),"invalid sig");
        (bool sent,)=receiver.call{value:_amount}("");
        require(sent,"failed to send ether");
        selfdestruct(sender); 
    }
    function cancel()external{
        require(msg.sender==sender,"!sender");
        require(block.timestamp >= expiresAt,"!expired");
        selfdestruct(sender);
    }
}


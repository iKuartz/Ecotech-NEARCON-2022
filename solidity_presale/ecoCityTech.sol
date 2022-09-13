// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./erc721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";


contract presale is EchoCityTechNFT{
    address public owner = msg.sender;
	uint public cost = 25000000000000000;				// price in wei
	uint public maxSupply = 260;		// 260 weeks (1 year / 6 rooms)
	uint public currentTime = block.timestamp;
	uint public saleDuration = 7 * 24 * 60 * 60;    // 1 week
	enum State {Running, Ended}
	State public auctionState;
	EchoCityTechNFT public NFTs = new EchoCityTechNFT();

    constructor(){
	    auctionState = State.Running;
    }

    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }

	function checkState() internal returns(State){
		if(currentTime + saleDuration >= block.timestamp){
			auctionState = State.Ended;
			return(auctionState);
		}
		else
			return(auctionState);

	}

    function mint(uint256 _mintAmount) public payable{
		require(checkState() == State.Running);
		require(msg.value == cost);
		uint supply = totalSupply();
		require(supply + _mintAmount <= maxSupply);
		for(uint i = 1; i <= _mintAmount; i++){
			_safeMint(msg.sender, supply + i);
		}
	}

    function withdraw() public onlyOwner{  
        payable(msg.sender).transfer(address(this).balance);
    }
}
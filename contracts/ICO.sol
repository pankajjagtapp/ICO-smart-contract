// SPDX-License-Identifier: MIT
pragma solidity >0.6.0 <=0.9.0;

import "./MyToken.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ICO is MyToken, Ownable {
    //Defined 3 Stages for the ICO - Pre-Sale, Seed Sale, Final Sale
    enum CrowdsaleStage {
        preSale,
        seedSale,
        finalSale
    }

    CrowdsaleStage public stage = CrowdsaleStage.preSale;

    uint256 public preSaleTokens = 50000000 * 10**18;
    uint256 public seedSaleTokens = 30000000 * 10**18;
    uint256 public finalSaleTokens = 20000000 * 10**18;

    uint256 public finalSaleTokenValue;

    uint256 public numberOfTokens;
    uint256 public tokensPerEther = 200000;
    uint256 public tokensSold;
    uint256 public tokensForSale = preSaleTokens;

    mapping(address => uint256) public balances;

    // Allowing Owner to change the Crowdsale Stage as per necessity.
    function setCrowdsaleStage(uint256 _stage) public onlyOwner {
        if (uint256(CrowdsaleStage.preSale) == _stage) {
            stage = CrowdsaleStage.preSale;
        } else if (uint256(CrowdsaleStage.seedSale) == _stage) {
            stage = CrowdsaleStage.seedSale;
        } else if (uint256(CrowdsaleStage.finalSale) == _stage) {
            stage = CrowdsaleStage.finalSale;
        }

        if (stage == CrowdsaleStage.preSale) {
            // Pre-sale token value = 0.01$
            // Estimated value of Ether = 2000$
            // tokensPerEther = 2000/0.01
            tokensPerEther = 200000;
            tokensForSale = preSaleTokens;
        } else if (stage == CrowdsaleStage.seedSale) {
            // Pre-sale token value = 0.02$
            // Estimated value of Ether = 2000$
            // tokensPerEther = 2000/0.02
            tokensPerEther = 100000;
            tokensForSale = seedSaleTokens;
        } else if (stage == CrowdsaleStage.finalSale) {
            tokensPerEther = finalSaleTokenValue;
            tokensForSale = finalSaleTokens;
        }
    }

    function buyTokens() external payable {
        require(msg.value != 0, "Insufficient funds");

        // setting Crowdsale Stage according to the number of tokens sold
        if (tokensSold == 50000000 * 10**18) {
            setCrowdsaleStage(1);
        } else if (tokensSold == 80000000 * 10**18) {
            setCrowdsaleStage(2);
        }

        numberOfTokens = msg.value * tokensPerEther;
        // Updating total tokens sold
        tokensSold += numberOfTokens;
        // Updating tokens available for sale in the current Sale stage
        tokensForSale -= numberOfTokens;
        // Updating the balances of every token holder
        balances[msg.sender] += numberOfTokens;

        // sending the token to the buyer
        _transfer(manager, msg.sender, numberOfTokens);

        // send the transacted ether to the token owner
        payable(manager).transfer(msg.value);
    }

    // Get Tokens per Ether for the Final Sale
    function getFinalSaleTokenValue(uint256 _finalSaleTokenValue)
        public
        onlyOwner
    {
        finalSaleTokenValue = _finalSaleTokenValue;
    }
}

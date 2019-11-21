pragma solidity ^0.5.0;

contract ERC20 {
    function transferFrom(address _from, address _to, uint256 _amount) external returns (bool);
    function approve(address _from, uint256 amount) external returns (bool);
}

contract Rule701 {

mapping (address => uint256) Organization701; // tracks value of shares issued by Organization under Rule 701
uint256 valueSharesToBeIssued = 0; // preventings over-issuance by tracking value of shares to be issued by Organization


function approve (address spender, address _tokenAddress, uint256 _amount) public returns(bool){
    ERC20(_tokenAddress).approve(spender, _amount);
    return true;
}

  function TransferRule701 (


    uint256 valueShares, // USD value of shares being transferred or issued
    uint256 totalAssets, // USD value of organization's total assets
    uint256 outstandingSecurities, // USD value of entire class of securities
    address tokenAddress, // Ethereum address of security token to be transferred
    address recipientAddress, // Ethereum address of recipient
    uint256 numberShares) // Number of shares to be transferred
    public returns(bool success){
        valueSharesToBeIssued = Organization701[msg.sender]; // Tracks value of shares value by Organization under Rule 701
        valueSharesToBeIssued += valueShares; // checks if new transfer or issuance of shares is permitted under Rule 701
        if(valueSharesToBeIssued < 1000000 ) { // checks if organization has issued less than 1 million dollars under Rule 701
            ERC20(tokenAddress).transferFrom(msg.sender, recipientAddress, numberShares); // transfers shares
            Organization701[msg.sender] = valueSharesToBeIssued; // updates mapping that tracks value of shares issued by organization
            return true;
          }

        else if(valueSharesToBeIssued < (totalAssets * 15)/100) {
            ERC20(tokenAddress).transferFrom(msg.sender, recipientAddress, numberShares); // transfers shares
            Organization701[msg.sender] = valueSharesToBeIssued; // updates mapping that tracks value of shares issued by organization;
            return true;
          }

        else if(valueSharesToBeIssued < (outstandingSecurities * 15)/100) {
            ERC20(tokenAddress).transferFrom(msg.sender, recipientAddress, numberShares); // transfers shares
            Organization701[msg.sender] = valueSharesToBeIssued; // updates mapping that tracks value of shares issued by organization;


            return true;
          }
        else {
            return false;
      }
    }

      function checkValueIssued(address organizationAddress) public view returns(uint256){
         return Organization701[organizationAddress];
      }
     
      function clearValueIssued() public returns(bool success) {
          Organization701[msg.sender] = 0;
          return true;
      }
     
     function fixValueIssued(uint256 valueIssued) public returns(bool success) {
          Organization701[msg.sender] = valueIssued;
          return true;
      }
}

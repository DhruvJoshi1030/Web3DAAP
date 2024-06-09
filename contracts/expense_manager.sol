// spdx-license_identifier

pragma solidity ^0.8.19;

contract ExpenseMnagerContract{

    address public owner;
    struct Transaction  {
        address user;
        uint  amount;
        string reason;
        uint timestamp;

    }
    Transaction [] public transactioins;
    constructor()
    {
        owner=  msg.sender;
    }
     modifier onlyOwner() {
        require(msg.sender== owner,"Only owner can execute");
        _;
    }
    mapping(address => uint) public balances;
    event Deposit(address indexed _from ,uint _amount,string _reason, uint _timestamp );
       event Withdraw(address indexed _to ,uint _amount,string _reason, uint _timestamp );
    function depsit(uint _amount, string memory _reason) public payable
    {
        require(_amount>0,"The amount should be greater than 0");
        balances[msg.sender]+=_amount;
    transactioins.push(Transaction(msg.sender,_amount,_reason,block.timestamp));
    emit Deposit(msg.sender, _amount, _reason, block.timestamp);
    }
    function withdraw(uint _amount ,string memory _reason ) public 
    {
            require (balances[msg.sender]>= _amount ,"Insufficient Balance");
            balances[msg.sender]==_amount;
            transactioins.push(Transaction(msg.sender,_amount,_reason,block.timestamp));
            payable(msg.sender).transfer(_amount);
            emit Withdraw(msg.sender,_amount, _reason,block.timestamp);
    }
    function getBalance(address _account) public view returns (uint)
    {
        return balances [_account];

    }
    function getTransactionCount() public view returns (uint)
    {
return transactioins.length;
    }
    function getTransaction(uint _index) public view returns (address,uint,string memory,uint)
    {
require(_index<transactioins.length,"Index out of bound");
Transaction memory transactioin=transactioins[_index];
return(transactioin.user,transactioin.amount,  transactioin.reason,  transactioin.timestamp);

    }
    function getAllTransaction() public view returns(address[] memory,uint[] memory ,string[]memory,uint [] memory )
    {
        address[]  memory users =new address[](transactioins.length);
        uint[] memory amount =new uint[](transactioins.length);
        string[] memory reasons =new string[](transactioins.length);
        uint[] memory timestamps =new uint[](transactioins.length);
        for(uint i=0;i<transactioins.length;i++)
        {
            users[i]=transactioins[i].user;
            amount[i]=transactioins[i].amount;
            reasons[i]=transactioins[i].reason;
            timestamps[i]=transactioins[i].timestamp;
        }
        return(users,amount,reasons,timestamps);
    }
    
    function ChangeOwner(address _newOwner)public onlyOwner{
        owner=_newOwner;
        

    }
   
}
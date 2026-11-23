// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BEP20Token {
    string public name;
    string public symbol;
    uint8 private _decimals;
    uint256 public totalSupply;
    address public owner;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 decimals_,
        uint256 initialSupply,
        address _owner,
        address _supplyRecipient
    ) {
        require(_owner != address(0), "Owner cannot be zero address");
        require(_supplyRecipient != address(0), "Supply recipient cannot be zero address");
        name = _name;
        symbol = _symbol;
        _decimals = decimals_;
        owner = _owner;
        // The full supply is minted to _supplyRecipient (the creator). This is kept
        // separate from _owner (the admin role) so the creator always receives the
        // tokens even when the deployer is left as the temporary owner to renounce.
        uint256 total = initialSupply * (10 ** uint256(decimals_));
        totalSupply = total;
        _balances[_supplyRecipient] = total;
        emit Transfer(address(0), _supplyRecipient, total);
        emit OwnershipTransferred(address(0), _owner);
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 value) public returns (bool) {
        require(to != address(0), "Transfer to zero address");
        require(_balances[msg.sender] >= value, "Insufficient balance");
        _balances[msg.sender] -= value;
        _balances[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function allowance(address tokenOwner, address spender) public view returns (uint256) {
        return _allowances[tokenOwner][spender];
    }

    function approve(address spender, uint256 value) public returns (bool) {
        require(spender != address(0), "Approve to zero address");
        _allowances[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(to != address(0), "Transfer to zero address");
        require(_balances[from] >= value, "Insufficient balance");
        require(_allowances[from][msg.sender] >= value, "Insufficient allowance");
        _allowances[from][msg.sender] -= value;
        _balances[from] -= value;
        _balances[to] += value;
        emit Transfer(from, to, value);
        return true;
    }

    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(owner, address(0));
        owner = address(0);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner is zero address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}

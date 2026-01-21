// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
 * Bitcoin-style ERC20 on BSC
 * Fixed supply: 100,000,000
 * Decimals: 2
 * No owner
 * No mint
 * No pause
 * No blacklist
 */

contract BTCStyleToken {
    /* ========== 基本信息 ========== */
    string public constant name = "SNSC";
    string public constant symbol = "SNSC";
    uint8  public constant decimals = 2;

    // 1亿 * 10^2 = 10,000,000,000 最小单位
    uint256 public constant totalSupply = 100_000_000 * 10 ** decimals;

    /* ========== ERC20 状态 ========== */
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    /* ========== 事件 ========== */
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /* ========== 构造函数 ========== */
    constructor() {
        // 一次性全部发行给部署者（类似 BTC 创世分配）
        _balances[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    /* ========== ERC20 接口 ========== */
    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }

    function allowance(address owner, address spender) external view returns (uint256) {
        return _allowances[owner][spender];
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool) {
        uint256 currentAllowance = _allowances[from][msg.sender];
        require(currentAllowance >= amount, "ERC20: allowance exceeded");

        _allowances[from][msg.sender] = currentAllowance - amount;
        _transfer(from, to, amount);
        return true;
    }

    /* ========== 内部逻辑 ========== */
    function _transfer(address from, address to, uint256 amount) internal {
        require(to != address(0), "ERC20: transfer to zero");

        uint256 balance = _balances[from];
        require(balance >= amount, "ERC20: balance insufficient");

        unchecked {
            _balances[from] = balance - amount;
            _balances[to] += amount;
        }

        emit Transfer(from, to, amount);
    }
}

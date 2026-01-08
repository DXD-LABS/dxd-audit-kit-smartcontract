// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract STRAIN is ERC20, Ownable, ERC20Burnable, ERC20Pausable, ERC20Permit {
    constructor(address initialOwner)
        ERC20("STRAIN", "STR")
        Ownable(initialOwner)
        ERC20Permit("STRAIN")
    {
        _mint(msg.sender, 420000000 * 10 ** decimals());
    }

    function decimals() public view virtual override returns (uint8) {
        return 0;
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    // VI: Các function dưới đây là override bắt buộc bởi Solidity.
    // EN: The following functions are overrides required by Solidity.
    // ZH: 以下函数是 Solidity 要求的重写。

    function _update(address from, address to, uint256 value)
        internal
        override(ERC20, ERC20Pausable)
    {
        super._update(from, to, value);
    }
}

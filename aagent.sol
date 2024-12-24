// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;
/// @custom:security-contact sudeep@aagent.ai

import {ERC20} from "@openzeppelin/contracts@5.1.0/token/ERC20/ERC20.sol";
import {ERC20Pausable} from "@openzeppelin/contracts@5.1.0/token/ERC20/extensions/ERC20Pausable.sol";
import {ERC20Permit} from "@openzeppelin/contracts@5.1.0/token/ERC20/extensions/ERC20Permit.sol";
import {Ownable} from "@openzeppelin/contracts@5.1.0/access/Ownable.sol";

/**
 *    ░▒▓██████▓▒░ ░▒▓██████▓▒░ ░▒▓██████▓▒░░▒▓████████▓▒░▒▓███████▓▒░▒▓████████▓▒░ 
 *   ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░     
 *   ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░     
 *   ░▒▓████████▓▒░▒▓████████▓▒░▒▓█▓▒▒▓███▓▒░▒▓██████▓▒░ ░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░     
 *   ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░     
 *   ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░     
 *   ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓██████▓▒░░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░     
 * 
 *   Website: https://aagent.ai            Telegram: https://t.me/aagentAI                                                                                                                                                               
 */
contract Aagent is ERC20, ERC20Pausable, Ownable, ERC20Permit {

    /**
     * @dev Emitted when the pause is triggered by `account`.
     */
    event AccountPaused(address account, address sender);

    /**
     * @dev Emitted when the pause is lifted by `account`.
     */
    event AccountUnpaused(address account, address sender);

    /**
    * @dev Error if account is paused
    */
    error AccountPausedError(address account);

    /**
    * @dev mapping to keep track of paused addressess
    */
    mapping(address => bool) private pausedAddresses;

    constructor(address initialOwner)
        ERC20("Aagent", "AAI")
        Ownable(initialOwner)
        ERC20Permit("Aagent")
    {
        _mint(initialOwner, 888_888_888 * 10 ** decimals());
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    /**
     * @dev Returns true if the account is paused, and false otherwise.
     */
    function isAccountPaused(address account) public view returns (bool) {
        return pausedAddresses[account];
    }

    /**
     * @dev Triggers stopped state for the address.
     *
     */
    function pauseAccount(address account) external onlyOwner {
        pausedAddresses[account] = true;
        emit AccountPaused(account, _msgSender());
    }

    /**
     * @dev Returns to normal state.
     *
     */
    function unpauseAccount(address account) external onlyOwner {
        delete pausedAddresses[account];
        emit AccountUnpaused(account, _msgSender());
    }

    // The following functions are overrides required by Solidity.

    function _update(address from, address to, uint256 value)
        internal
        override(ERC20, ERC20Pausable)
    {
        if(pausedAddresses[from]) {
            revert AccountPausedError(from);
        } 
            
        super._update(from, to, value);
    }
}
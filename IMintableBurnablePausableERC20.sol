// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IMintableBurnablePausableERC20 is IERC20 {
    /**
     * @dev Mints `amount` tokens to `account`.
     * Can only be called by the contract owner or an authorized minter.
     */
    function mint(address account, uint256 amount) external;

    /**
     * @dev Burns `amount` tokens from the caller's account.
     */
    function burn(uint256 amount) external;

    /**
     * @dev Burns `amount` tokens from `account`, deducting from the caller's allowance.
     * Can only be called by an account with an allowance for the tokens being burned.
     */
    function burnFrom(address account, uint256 amount) external;

    /**
     * @dev Pauses all token transfers.
     * Can only be called by an account with the PAUSER_ROLE.
     */
    function pause() external;

    /**
     * @dev Unpauses all token transfers.
     * Can only be called by an account with the PAUSER_ROLE.
     */
    function unpause() external;

    /**
     * @dev Grants `role` to `account`.
     * Can only be called by an account with the admin role for that `role`.
     */
    function grantRole(bytes32 role, address account) external;

    /**
     * @dev Returns true if the account has been granted the role.
     */
    function hasRole(bytes32 role, address account) external view returns (bool);
}

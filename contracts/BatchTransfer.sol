// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
import {IERC721} from "@openzeppelin/contracts/interfaces/IERC721.sol";
import {IERC1155} from "@openzeppelin/contracts/interfaces/IERC1155.sol";

contract BatchTransfer {
    function batchSendEther(
        address[] memory recipients,
        uint256[] memory amounts
    ) public payable {
        require(
            recipients.length == amounts.length,
            "Recipients and amounts must match in length"
        );
        for (uint256 i = 0; i < recipients.length; i++) {
            (bool success, ) = recipients[i].call{value: amounts[i]}("");
            require(success, "Failed to send Ether");
        }
    }

    function batchTransferERC20(
        address tokenAddress,
        address[] memory recipients,
        uint256[] memory amounts
    ) public {
        require(
            recipients.length == amounts.length,
            "Recipients and amounts must match in length"
        );
        IERC20 token = IERC20(tokenAddress);
        for (uint256 i = 0; i < recipients.length; i++) {
            require(
                token.transferFrom(msg.sender, recipients[i], amounts[i]),
                "Transfer failed"
            );
        }
    }

    function batchTransferERC721(
        address tokenAddress,
        address[] memory recipients,
        uint256[] memory tokenIds
    ) public {
        require(
            recipients.length == tokenIds.length,
            "Recipients and tokenIds must match in length"
        );
        IERC721 token = IERC721(tokenAddress);
        for (uint256 i = 0; i < recipients.length; i++) {
            token.safeTransferFrom(msg.sender, recipients[i], tokenIds[i]);
        }
    }

    function batchTransferERC1155(
        address tokenAddress,
        address[] memory recipients,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public {
        require(
            recipients.length == ids.length && ids.length == amounts.length,
            "Recipients, ids, and amounts must match in length"
        );
        IERC1155 token = IERC1155(tokenAddress);
        for (uint256 i = 0; i < recipients.length; i++) {
            token.safeTransferFrom(
                msg.sender,
                recipients[i],
                ids[i],
                amounts[i],
                data
            );
        }
    }
}

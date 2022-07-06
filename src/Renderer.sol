//SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "hot-chain-svg/SVG.sol";
import "hot-chain-svg/Utils.sol";

contract Renderer {
    uint256 constant MAX_INT = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;

    uint256[2][4][4][8] pieces = [
        [
            [[0, 0], [0, 0], [0, 0], [0, 0]],
            [[0, 0], [0, 0], [0, 0], [0, 0]],
            [[0, 0], [0, 0], [0, 0], [0, 0]],
            [[0, 0], [0, 0], [0, 0], [0, 0]]
        ],
        // I
        [
            [[0, 0], [0, 1], [0, 2], [0, 3]],
            [[0, 0], [1, 0], [2, 0], [3, 0]],
            [[0, 0], [0, 1], [0, 2], [0, 3]],
            [[0, 0], [1, 0], [2, 0], [3, 0]]
        ],
        // O
        [
            [[0, 0], [0, 1], [1, 0], [1, 1]],
            [[0, 0], [0, 1], [1, 0], [1, 1]],
            [[0, 0], [0, 1], [1, 0], [1, 1]],
            [[0, 0], [0, 1], [1, 0], [1, 1]]
        ],
        // T
        [
            [[1, 0], [0, 1], [1, 1], [2, 1]],
            [[1, 0], [0, 1], [1, 1], [1, 2]],
            [[0, 0], [0, 1], [1, 1], [0, 2]],
            [[0, 0], [1, 0], [2, 0], [1, 1]]
        ],
        // S
        [
            [[0, 1], [1, 1], [1, 0], [2, 0]],
            [[0, 0], [0, 1], [1, 1], [1, 2]],
            [[0, 1], [1, 1], [1, 0], [2, 0]],
            [[0, 0], [0, 1], [1, 1], [1, 2]]
        ],
        // Z
        [
            [[0, 0], [1, 0], [1, 1], [2, 1]],
            [[1, 0], [1, 1], [0, 1], [0, 2]],
            [[0, 0], [1, 0], [1, 1], [2, 1]],
            [[1, 0], [1, 1], [0, 1], [0, 2]]
        ],
        // J
        [
            [[0, 0], [1, 0], [0, 1], [0, 2]],
            [[0, 0], [1, 0], [2, 0], [2, 1]],
            [[1, 0], [1, 1], [1, 2], [0, 2]],
            [[0, 0], [0, 1], [1, 1], [2, 1]]
        ],
        // L
        [
            [[0, 0], [1, 0], [2, 0], [0, 1]],
            [[0, 0], [1, 0], [1, 1], [1, 2]],
            [[0, 1], [1, 1], [2, 1], [2, 0]],
            [[0, 0], [0, 1], [0, 2], [1, 2]]
        ]
    ];

    function get_random_value(
        uint256 seed,
        uint256 _seed,
        uint256 _offset
    ) internal view returns (uint256) {
        uint256 a = uint256(keccak256(abi.encodePacked(_seed, seed, block.difficulty, block.timestamp)));

        uint256 b = (_offset % (MAX_INT - 1)) + 1;
        uint256 c = (a % (MAX_INT - 1)) | b;
        uint256 res = c + 1000;

        return res;
    }

    function random_piece(
        uint256 seed,
        uint256 _seed,
        uint256 _offset
    ) internal view returns (uint256[2][4][4] memory, uint256) {
        uint256 random_value = get_random_value(seed, _seed, _offset) % 8;

        return (pieces[random_value], random_value);
    }

    function build_board(uint256[10][10] memory _board) internal pure returns (string memory) {
        // NO PIECE, I, O, T, S, Z, J, L
        string[8] memory colours = ["", "#ff5050", "#158CFA", "#F9F25D", "#D05DF9", "#5DF9DD", "#ffffff", "#64CA81"];

        string memory output = "";

        for (uint256 i = 0; i < 10; i++) {
            for (uint256 j = 0; j < 10; j++) {
                if (_board[i][j] != 0) {
                    string memory colour_name = colours[_board[i][j]];

                    output = string.concat(
                        output,
                        svg.rect(
                            string.concat(
                                svg.prop("fill", colour_name),
                                svg.prop("stroke", "#252a3d"),
                                svg.prop("x", utils.uint2str(i * 100)),
                                svg.prop("y", utils.uint2str(j * 100)),
                                svg.prop("width", "100"),
                                svg.prop("height", "100")
                            ),
                            utils.NULL
                        )
                    );
                }
            }
        }

        return output;
    }

    function draw(string memory _board) internal pure returns (string memory) {
        return
            string.concat(
                '<svg xmlns="http://www.w3.org/2000/svg" width="1000" height="1000" style="background:#252a3d">',
                _board,
                "</svg>"
            );
    }

    function render(uint256 _tokenId) internal view returns (string memory) {
        uint256 seed = _tokenId;
        uint256 current_piece;
        uint256[10][10] memory _board;

        for (uint256 i = 0; i < 10; i++) {
            for (uint256 j = 0; j < 10; j++) {
                if (_board[i][j] == 0) {
                    bool next_piece = false;

                    for (uint256 k = 0; k < 4 && !next_piece; k++) {
                        (uint256[2][4][4] memory random_pieces, uint256 random_index) = random_piece(seed, i, j);

                        uint256[2][4] memory _random_piece = random_pieces[k];
                        current_piece = random_index;
                        seed = i;

                        if (
                            (i + _random_piece[0][0] < 10 && j + _random_piece[0][1] < 10) &&
                            (i + _random_piece[1][0] < 10 && j + _random_piece[1][1] < 10) &&
                            (i + _random_piece[2][0] < 10 && j + _random_piece[2][1] < 10) &&
                            (i + _random_piece[3][0] < 10 && j + _random_piece[3][1] < 10) &&
                            (_board[i + _random_piece[0][0]][j + _random_piece[0][1]] == 0) &&
                            (_board[i + _random_piece[1][0]][j + _random_piece[1][1]] == 0) &&
                            (_board[i + _random_piece[2][0]][j + _random_piece[2][1]] == 0) &&
                            (_board[i + _random_piece[3][0]][j + _random_piece[3][1]] == 0)
                        ) {
                            next_piece = true;

                            _board[i + _random_piece[0][0]][j + _random_piece[0][1]] = current_piece;
                            _board[i + _random_piece[1][0]][j + _random_piece[1][1]] = current_piece;
                            _board[i + _random_piece[2][0]][j + _random_piece[2][1]] = current_piece;
                            _board[i + _random_piece[3][0]][j + _random_piece[3][1]] = current_piece;
                        }
                    }
                }
            }
        }

        string memory a = build_board(_board);

        return draw(a);
    }
}

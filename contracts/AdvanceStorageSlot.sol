// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;

contract C {
    struct S { 
        uint16 a;    // Position of Struct S: Slot 0
        uint16 b;    // Position of Struct S: Slot 0
        uint256 c;   // Position of Struct S: Slot 1
    }
    uint x;                                       // Position of Contract C: Slot 0
    mapping(uint => mapping(uint => S)) s_data;   // Position of Contract C: Slot 1
    uint256[] private s_array;                    // Position of Contract C: Slot 2
    uint24[] private s_24array;                   // Position of Contract C: Slot 3

    constructor() {
        s_array.push(999);                        // Index 0
        s_array.push(2);                          // Index 1
        s_array.push(10);                         // Index 2

        s_24array.push(10);                       // Index 0
        s_24array.push(11);                       // Index 1
        s_24array.push(15);                       // Index 2
    }
}
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;

contract C {

    // Let assume Slot position as `p`
    struct S { 
        uint16 a;    // Position of Struct S: Slot 0
        uint16 b;    // Position of Struct S: Slot 0
        uint256 c;   // Position of Struct S: Slot 1
    }

    uint x;                                               // Position of Contract C: Slot 0
    mapping(uint => mapping(uint => S)) s_data;           // Position of Contract C: Slot 1
    uint256[] private s_array;                            // Position of Contract C: Slot 2
    uint24[] private s_24array;                           // Position of Contract C: Slot 3
    mapping(uint => uint) private s_simple_map;           // Position of Contract C: Slot 4
    mapping(uint32 => uint256) private s_small2Large_map; // Position of Contract C: Slot 5
    mapping(uint256 => uint32) private s_large2Small_map; // Position of Contract C: Slot 6
    mapping(uint256 => S) private s_num2Struct_map;       // Position of Contract C: Slot 7
    S[] private s_struct_array;                           // Position of Contract C: Slot 8

    constructor() {
        /* 
        ####################################### Array #####################################################
            p = variable slot location
            i = index of p's 
            keccak256(uint256(p)) + i
        ###################################################################################################
        */

        /*
            256 bits Array index.
            Each index have unique key. won't share the same location unlike 2_24array.
         */
        s_array.push(999);                        // Index 0
        s_array.push(2);                          // Index 1
        s_array.push(10);                         // Index 2

        /*
            s_24array is 24 bits (3 bytes) size array.
            Means each index size is 3 Bytes.
            Storage's value is 256-bits (32 bytes) wide.
            We can fix 10 indexs (0-9) in same slot location. (3 x 10 = 30 bytes.)

            Array data is located starting at keccak256(p) and 
            it is laid out in the same way as statically-sized array data would: 
            One element after the other, potentially sharing storage slots if the elements are not longer than 16 bytes. 
            Dynamic arrays of dynamic arrays apply this rule recursively.
         */
        s_24array.push(1);                       // Index 0
        s_24array.push(2);                       // Index 1
        s_24array.push(3);                       // Index 2
        s_24array.push(4);                       // Index 3
        s_24array.push(5);                       // Index 4
        s_24array.push(6);                       // Index 5
        s_24array.push(7);                       // Index 6
        s_24array.push(8);                       // Index 7
        s_24array.push(9);                       // Index 8
        s_24array.push(10);                      // Index 9

        s_24array.push(11);                      // Index 10 << This one will place in new location 
                                                 // key keccak256(uint256(p)) + 1
        /* ################################################################################################# */

        /* 
        ####################################### Map #####################################################
            p = variable slot location
            i = index of p's 
            keccak256(uint256(i).uint256(p))
        ###################################################################################################
        */

        /*
            s_simple_map is mapping with uint256 <=> uint256 vice versa.
         */        
         s_simple_map[0] = 1;
         s_simple_map[1] = 2;
         s_simple_map[3] = 3;

         /**
            s_small2Large_map is mapping with uint32 <=> uint256 vice versa.
            It works as the same ways as `s_simple_map'
            because keccak256(h(k) . p) where . is concatenation and h is a function that is applied to the key depending on its type
            for value types, h pads the value to 32 bytes in the same way as when storing the value in memory.
        */
        s_small2Large_map[0] = 9;
        s_small2Large_map[1] = 10;
        s_small2Large_map[2] = 230;

        /*
            s_large2Small is mapping with uint256 <=> uint32 vice versa.
            It works as the same ways as `s_simple_map'
         */
        s_large2Small_map[0] = 1;
        s_large2Small_map[1] = 1;
        s_large2Small_map[2] = 1;
        s_large2Small_map[3] = 1381995;
        s_large2Small_map[4] = 231288;

        /* ################################################################################################# */

        /* 
        ####################################### Struct's Arrray & Map ######################################
            p = Slot position of variable
            i = index of p's
            n = index of Struct's
            keccak256(uint256(i).uint256(p)) + n
        ###################################################################################################
        */

        /*
            s_num2Struct_map is mapping with uint256 <=> Struct vice versa.
            Even tho struct itself is non-value type, if their memembers is value type, 
            they treat them as same as normal value type. (Like x variable)
            a and b takes each 16 bits. it's 2 bytes. So, they can fit in one slot (share storage slot.)
        */
        S memory s1 = S({a: 13, b: 8, c: 1995});
        S memory s2 = S({a: 2323, b: 123, c: 19925});

        s_num2Struct_map[0] = s1;
        s_num2Struct_map[1] = s2;

        /* ################################################################################################# */

        /* 
            s_struct_array is Array of Struct.
        */
        s_struct_array.push(s1);
        s_struct_array.push(s2);

    }
}
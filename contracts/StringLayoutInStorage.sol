// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;

contract StringLayoutInStorage
{
    // REF: https://docs.soliditylang.org/en/latest/internals/layout_in_storage.htm
    // Let assume Slot position as `p`
    // Bytes and Strings does the same ways.`
    string private s_short_str1;    // Slot 0
    string private s_short_str2;    // Slot 1
    string private s_long_str1;     // Slot 2
    string private s_long_str2;     // Slot 3

    bytes private s_short_byte;     // Slot 4
    bytes private s_long_byte1;     // Slot 5
    bytes private s_long_byte2;     // Slot 6
    
    bytes1[] private s_byte_array;  // Slot 7
    bytes[] private s_bytes_array;  // Slot 8
    constructor ()
    {
        /* 
            ####################################### String #####################################################
        */

        /*
            if the data is at most 31 bytes long, 
            the elements are stored in the higher-order bytes (left aligned) 
            and the lowest-order byte stores the value length * 2.

            s_short_str1 = 0x48454c4c4f00000000000000000000000000000000000000000000000000000a

            HELLO is 0x48454c4c4f only take 5 bytes. LSB is 0xa which is 10. (Hint: 5 bytes of hex is 10 characters)
            Summary: if value is not over 31 bytes, the lowest-order byte store sizeOfBytes * 2.
        */
        s_short_str1 = "HELLO";
        s_short_str2 = "I LOVE OU";


        /*
            For byte arrays that store data which is 32 or more bytes long, 
            the main slot p stores length * 2 + 1 and the data is stored as usual in keccak256(p). 

            s_short_str1 = 0x0000000000000000000000000000000000000000000000000000000000000041
            Value of s_long_str1 is 32 bytes long. LSB is 0x41 which is 65 characters in hex.

            Summary: if value is 32 or more than, value store the lowest-order byte store (sizeOfBytes * 2) + 1 at storage position `p` whithout hashing 
                     The actual location of data is store in keccak256(p), 'p' is slot position.

                     > keccka256(2) = soliditySha3(padLeft('0x2', 64)) = 0x405787fa12a823e0f2b7631cc41b3ba8828b3321ca811111fa75cd3aa3bb5ace
                     > At keccak256(2) => 0x41414178644b793142733346684250305a456b394c49595571526a3979414141 
                                          which is 'AAAxdKy1Bs3FhBP0ZEk9LIYUqRj9yAAA'.

        */
        s_long_str1 = "AAAxdKy1Bs3FhBP0ZEk9LIYUqRj9yAAA";      // 32 bytes long
        s_long_str2 = "AAAxdKy1Bs3FhBP0ZEk9LIYUqRj9yAAABBBBBB"; // 38 bytes long

        /* ################################################################################################# */

        /* 
            ####################################### Bytes #####################################################
        */
        s_short_byte = bytes("ILOVEOUOU");                                     // Under 32 bytes
        s_long_byte1 = bytes("AAAxdKy1Bs3FhBP0ZEk9LIYUqRj9yAAA");              // 32 byts  
        s_long_byte2 = bytes("AAAxdKy1Bs3FhBP0ZEk9LIYUqRj9yAAAOUOUKOCHITDL");  // Over 32 bytes
        /* ################################################################################################# */

        /* 
        ####################################### Byte[] and Bytes[] ######################################
            p = Slot position of variable
            i = index of p's 
            keccak256(uint256(p)) + i
        ####################################################################################################
            for single bytes1[] store the value as Little endian
            - I put DE at index 0, and AD at index 1
            - EVM store it as keccak256(uint256(p)) - same slot position with little endian byte store order.
            - var p7 = soliditySha3(padLeft('0x7', 64))
            - await getStorageAt(d, p7)
            - 0x000000000000000000000000000000000000000000000000000000000000adde'
       
        * 
        */
        s_byte_array.push(hex'DE'); // take 1 byte for each byte[]
        s_byte_array.push(hex'AD');

        
        /*
            for bytes[] store the value as big endian
            - I put DEAD at index 0, 0102 at index 1, 0304 at index 2 respectivelly
            - It stores 32 bytes for each index at storage. 
               - Big endian for data and store (sizeOfBytes * 2) at little endian
            
            In order to calculate the key of storage it have to hash nested if data is more than 32 bytes.
            keccak(8) + 3 means index 3 of value that locate at hash of slot number 8.
 
            Value at index 3 is more than 32 bytes, so it only store (sizeOfBytes * 2) + 1 at `keccak(8) + 3`.

            Remember that storage size is 32 bytes and data is more than 32. So,
            Actual data store at keccak(keccak(8) + 3) + 0 and keccak(keccak(8) + 3) + 1 respectavielly.
       
        * 
        */
        s_bytes_array.push(hex'DEAD');
        s_bytes_array.push(hex'0102');
        s_bytes_array.push(hex'0304');
        s_bytes_array.push('0xAAAxdKy1Bs3FhBP0ZEk9LIYUqRj9yAAAOUOUKOCHITDL');
    }
}
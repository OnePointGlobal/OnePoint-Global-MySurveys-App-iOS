//
//  QueryDbType.h
//  Test
//
//  Created by Nitin on 10/10/13.
//  Copyright (c) 2013 OnePoint. All rights reserved.
//

#ifndef Test_QueryDbType_h
#define Test_QueryDbType_h

typedef enum
{
    /// <summary>
    /// The big integer.
    /// </summary>
    BigInt = 0,
    
    /// <summary>
    /// The binary.
    /// </summary>
    Binary = 1,
    
    /// <summary>
    /// The bit.
    /// </summary>
    Bit = 2,
    
    /// <summary>
    /// The char.
    /// </summary>
    Char = 3,
    
    /// <summary>
    /// The date time.
    /// </summary>
    DateTime = 4,
    
    /// <summary>
    /// The decimal.
    /// </summary>
    Decimal = 5,
    
    /// <summary>
    /// The float.
    /// </summary>
    Float = 6,
    
    /// <summary>
    /// The image.
    /// </summary>
    Image = 7,
    
    /// <summary>
    /// The integer.
    /// </summary>
    Int = 8,
    
    /// <summary>
    /// The money.
    /// </summary>
    Money = 9,
    
    /// <summary>
    /// The n char.
    /// </summary>
    NChar = 10,
    
    /// <summary>
    /// The n text.
    /// </summary>
    NText = 11,
    
    /// <summary>
    /// The double byte variable character.
    /// </summary>
    NVarChar = 12,
    
    /// <summary>
    /// The real.
    /// </summary>
    Real = 13,
    
    /// <summary>
    /// The unique identifier.
    /// </summary>
    UniqueIdentifier = 14,
    
    /// <summary>
    /// The small date time.
    /// </summary>
    SmallDateTime = 15,
    
    /// <summary>
    /// The small integer (16 bits).
    /// </summary>
    SmallInt = 16,
    
    /// <summary>
    /// The small money.
    /// </summary>
    SmallMoney = 17,
    
    /// <summary>
    /// The text.
    /// </summary>
    Text = 18,
    
    /// <summary>
    /// The timestamp.
    /// </summary>
    Timestamp = 19,
    
    /// <summary>
    /// The tiny integer (8 bits).
    /// </summary>
    TinyInt = 20,
    
    /// <summary>
    /// The variable binary (BLOB).
    /// </summary>
    VarBinary = 21,
    
    /// <summary>
    /// The variable character.
    /// </summary>
    VarChar = 22,
    
    /// <summary>
    /// The variant.
    /// </summary>
    variant = 23,
    
    /// <summary>
    /// The xml.
    /// </summary>
    Xml = 25,
    
    /// <summary>
    /// The Universal Date and Time.
    /// </summary>
    Udt = 29,
    
    /// <summary>
    /// The structured.
    /// </summary>
    Structured = 30,
    
    /// <summary>
    /// The date.
    /// </summary>
    Date = 31,
    
    /// <summary>
    /// The time.
    /// </summary>
    Time = 32,
    
    /// <summary>
    /// The date time 2.
    /// </summary>
    DateTime2 = 33,
    
    /// <summary>
    /// The date time offset.
    /// </summary>
    DateTimeOffset = 34,
    boolean=36
} QueryDbType;


#endif

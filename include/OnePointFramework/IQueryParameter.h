//
//  IQueryParameter.h
//  OnePointFramework
//
//  Created by Chinthan on 10/10/13.
//  Copyright (c) 2013 OnePoint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QueryParameterDirection.h"

@protocol IQueryParameter <NSObject>

//#region Public Properties

/// <summary>
///     Gets or sets the direction.
/// </summary>
@property (nonatomic, assign) QueryParameterDirection Direction;

/// <summary>
///     Gets or sets the value.
/// </summary>
@property (readwrite, strong) id Value;

/// <summary>
/// Gets or sets the name.
/// </summary>
@property (readwrite, strong) NSString *Name;

/// <summary>
/// Gets the Alternative name (the column Name)
/// </summary>
@property (readonly, strong) NSString *AltName;





@end

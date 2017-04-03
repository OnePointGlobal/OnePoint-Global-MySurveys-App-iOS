//
//  IDataReader.h
//  OnePointFramework
//
//  Created by Chinthan on 10/10/13.
//  Copyright (c) 2013 OnePoint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QueryDbType.h"

@protocol IDataReader <NSObject>

-(id)Get:(NSString *) pageNumber withdataType:(QueryDbType) dataType;

//#region Public Methods and Operators

/// <summary>
/// The close.
/// </summary>
-(void)Close;

/// <summary>
/// Read through the cursor and return false when it gets to the end of the rows
/// </summary>
/// <returns>
/// The <see cref="bool"/>.
/// </returns>
-(BOOL)Read;


@end

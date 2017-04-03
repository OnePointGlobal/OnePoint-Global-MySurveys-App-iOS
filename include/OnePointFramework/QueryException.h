//
//  QueryException.h
//  OnePointFramework
//
//  Created by Chinthan on 10/10/13.
//  Copyright (c) 2013 OnePoint. All rights reserved.
//

#import <Foundation/Foundation.h>

//@interface QueryException : NSObject

@interface QueryException : NSException
{
    long DeadlockError;
    
}

@end

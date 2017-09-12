//
//  OPGDB.h
//  OnePointFramework
//
//  Created by Manjunath on 06/07/17.
//  Copyright © 2017 OnePoint. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPGDB : NSObject

+(void)initializeWithDBVersion:(int)version;
+(void) setNewDatabaseVersion: (NSString*) databasePath withVersion: (NSString*) version;
+(void) deleteOldDatabase;
@end

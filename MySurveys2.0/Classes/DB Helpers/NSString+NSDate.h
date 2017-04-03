//
//  NSString+NSData.h
//  OnePoint.NetworkHelpers
//
//  Created by ThamaraiD on 10/04/14.
//  Copyright (c) 2014 Onepoint Global. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSDate)
+(NSDate*)stringToDate:(NSString*)string;
+(NSString*)stringFromDate:(NSDate*)date;
+(NSString *)getUTCFormateDate:(NSDate *)localDate;
@end

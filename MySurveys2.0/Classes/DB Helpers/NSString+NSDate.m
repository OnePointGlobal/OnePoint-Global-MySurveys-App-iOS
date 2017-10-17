//
//  NSString+NSData.m
//  OnePoint.NetworkHelpers
//
//  Created by Chinthan on 10/04/14.
//  Copyright (c) 2014 Onepoint Global. All rights reserved.
//

#import "NSString+NSDate.h"

@implementation NSString (NSDate)
+(NSDate*)stringToDate:(NSString*)string{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormat setLocale:usLocale];
    NSRange range=[string rangeOfString:@"."];
    if (range.location!=NSNotFound) {
       string=[string substringToIndex:range.location];
    }
    NSDate *date=[dateFormat dateFromString:[string stringByReplacingOccurrencesOfString:@"T" withString:@" "]];
    return date;

}
+(NSString*)stringFromDate:(NSDate*)date{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormat setLocale:usLocale];
    NSString *date2string=[[dateFormat stringFromDate:date]stringByReplacingOccurrencesOfString:@"+0000" withString:@""];
    return date2string;
}
+(NSString *)getUTCFormateDate:(NSDate *)localDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    
    return dateString;
}
@end

//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: /Users/chinthan/Framework/Logger/ConvertCode/OnePoint/Runtime/VirtualMachine/SupportingClasses/OpDateTime.java
//
//  Created by chinthan on 12/2/13.
//

#ifndef _OpDateTime_H_
#define _OpDateTime_H_

@class Executor;


#import "SuperClass.h"

@interface OpDateTime : SuperClass {
}

+ (NSString *)Name;
- (id)init;
- (void)getNowWithExecutor:(Executor *)executor;
- (void)getTodayWithExecutor:(Executor *)executor;
- (void)dateTimeDateWithExecutor:(Executor *)executor;
@end

#endif // _OpDateTime_H_

//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: /Users/ashchauhan/Desktop/SampleApp/OnePoint/Runtime/Common/IOM/IProperties.java
//
//  Created by ashchauhan on 6/20/14.
//

//#ifndef _IProperties_H_
//#define _IProperties_H_


#import <Foundation/Foundation.h>
@protocol IProperty;
@class ScriptReader;




@protocol IProperties < NSObject>
- (void)addProperty:(NSString *)key withValue:(id<IProperty>)value;
- (void)addProperty:(NSString *)key withValue:(id<IProperty>)value withIndex:(int)index;
- (void)addProperty:(id<IProperty>)value;
- (void)remove:(int)index;
- (void)removeWithKey:(NSString *)key;
- (NSArray*)getItems;
- (int)getCount;
- (void)clear;
- (BOOL)containsKey:(NSString *)key;
- (BOOL)containsValue:(id<IProperty>)value;
- (id<IProperty>)get___idx:(NSString *)key;
-(id)get___idxWithId:(id) key;
-(void) set___idxWithId:(id)key value:(id)value;
-(id)get___idxwithint:(NSNumber *) key;
- (void)set___idx:(NSString *)key withIProperty:(id<IProperty>)value;
-(void) deserializeWithStream:(NSData*) stream;
-(void)deserializeWithScriptReader:(ScriptReader*) reader;
-(NSMutableData *)serialize;
-(NSString*)getName;
-(void)setName:(NSString*)name;
@end

// _IProperties_H_
//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: /Users/ashchauhan/Desktop/SampleApp/OnePoint/Runtime/Common/IOM/ValidateOption.java
//
//  Created by ashchauhan on 6/20/14.
//

//#ifndef _ValidateOption_H_
//#define _ValidateOption_H_



#import "IValidateOption.h"

@interface  

ValidateOption : NSObject < IValidateOption > {
 @public
  NSString *__Name_;
  id __Value_;
}

- (NSString *)getName;
- (void)setName:(NSString *)value;
- (id)getValue;
- (void)setValue:(id)value;
- (id)init;

@end
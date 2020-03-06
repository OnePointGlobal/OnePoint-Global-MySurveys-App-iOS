//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: /Users/ashchauhan/Desktop/SampleApp/OnePoint/Runtime/Common/IOM/Validation.java
//
//  Created by ashchauhan on 6/20/14.
//

//#ifndef _Validation_H_
//#define _Validation_H_


@class Interview;
@protocol ICategories;
@protocol IQuestion;
#import "ValidatedActions.h"
#import "Ranges.h"


@interface Validation : NSObject<IValidation> {
 @public
  Ranges *ranges_;
  Interview *interview_;
  id<IQuestion> question_;
    ValidatedActions action;
  NSString *__Function_;
   long int __Precision_;
   long int __Scale_;
  NSString *__ValidateExpression_;
  NSMutableArray *__Options;
    int _categoryindex;
    int _sublistcount;
}
- (id)initWithQuestion:(id<IQuestion>)question;
- (id)initWithQuestion:(id<IQuestion>)question
                 withId:(NSMutableArray*)ranges;
- (NSString *)getFunction;
- (void)setFunction:(NSString *)value;
- (id)getMaxValue;
- (void)setMaxValue:(id)value;
- (NSString *)getMaxValueString;
- (NSString *)getMinValueString;
- (id)getMinValue;
- (void)setMinValue:(id)value;
- (long int)getPrecision;
- (void)setPrecision:(long int)value;
- (long int)getScale;
- (void)setScale:(long int)value;
- (NSString *)getValidateExpression;
- (void)setValidateExpression:(NSString *)value;
- (NSMutableArray*)getOptions;
-(void)setOptions:(NSMutableArray*)value;
- (void)validate:(ValidatedActions)validate;
- (void)standardValidation:(Interview*)interview;
- (BOOL)validateValidation:(Interview*)interview;
- (BOOL)validateCategory:(Interview*)interview withCategories:(id<ICategories>)categories withNSString:(NSString *)categorical withResponse:(NSString *)response;
- (void)addErrorMessage:(Interview *)interview withNSString:(NSString*)name
         withParameters:(id)parameters,... ;
- (BOOL)missingAnswer:(Interview*)interview;
- (BOOL)checkMissingAnswer;
- (BOOL)checkMissingAnswerWithoutCodes;
- (BOOL)checkMultipleAnswers:(Interview*)interview;
-(void)validate:(Interview*)interview withValidatedActions:(ValidatedActions)validate;

@end
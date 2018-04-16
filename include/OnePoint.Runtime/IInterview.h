//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: /Users/ashchauhan/Desktop/SampleApp/OnePoint/Runtime/Common/IOM/IInterview.java
//
//  Created by ashchauhan on 6/20/14.
//

//#ifndef _IInterview_H_
//#define _IInterview_H_

@protocol IDefaultStyles;
@protocol IInterviewInfo;
@protocol IInterviewSampleRecord;
@protocol ILabel;
@protocol ILabels;
@protocol INavigations;
@protocol INextPage;
@protocol IObjects;
@protocol IProperties;
@protocol IQuestions;
@protocol ISavePoints;
@protocol IStandardTexts;
#import "InterviewStatus.h"
#import "GlobalQuestionPositions.h"
#import "OffPathDataModes.h"

@protocol IInterview < NSObject>
- (id<ILabels>)getBanners;
- (id<IDefaultStyles>)getDefaultStyles;
- (id<ILabels>)getErrors;
- (id<IQuestions>)getGlobalQuestions;
- (id<IInterviewInfo>)getInfo;
- (InterviewStatus)getInterviewStatus;
- (id)getMDM;
- (id)getMessagesDocument;
- (id<INavigations>)getNavigations;
- (id<INextPage>)getNextPage;
- (id<IObjects>)getObjects;
- (id<IQuestions>)getPages;
- (NSString *)getProjectName;
- (id<IProperties>)getProperties;
- (id<IQuestions>)getQuestions;
- (id)getQuotaEngine;
- (NSString *)getRoutingContext;
- (id<IInterviewSampleRecord>)getSampleRecord;
- (id<ISavePoints>)getSavePoints;
- (void)setSavePoints:(id<ISavePoints>)value;
- (NSString *)getSessionToken;
- (id<IStandardTexts>)getTexts;
- (id<ILabel>)getTitle;
- (NSString *)getVersion;
- (BOOL)getAutoSelectOther;
- (void)setAutoSelectOther:(BOOL)value;
- (NSString *)getBannerTemplate;
- (void)setBannerTemplate:(NSString *)value;
- (NSString *)getContext;
- (void)setContext:(NSString *)value;
- (NSString *)getErrorTemplate;
- (void)setErrorTemplate:(NSString *)value;
- (GlobalQuestionPositions)getGlobalQuestionPosition;
- (void)setGlobalQuestionPosition:(GlobalQuestionPositions)value;
- (NSString *)getGridTemplate;
- (void)setGridTemplate:(NSString *)value;
- (NSString *)getLabelType;
- (void)setLabelType:(NSString *)value;
- (NSString *)getlanguage;
- (void)setlanguage:(NSString *)value;
- (NSString *)getLayoutTemplate;
- (void)setLayoutTemplate:(NSString *)value;
- (long long int)getLocale;
- (void)setLocale:(long long int)value;
- (BOOL)getMustAnswer;
- (void)setMustAnswer:(BOOL)value;
- (NSString *)getNavBarTemplate;
- (void)setNavBarTemplate:(NSString *)value;
- (OffPathDataModes)getOffPathDataMode;
- (void)setOffPathDataMode:(OffPathDataModes)value;
- (NSString *)getQuestionTemplate;
- (void)setQuestionTemplate:(NSString *)value;
@end

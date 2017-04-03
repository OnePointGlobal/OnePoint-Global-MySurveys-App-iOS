//
//  IQueryHelper.h
//  OnePointFramework
//
//  Created by Chinthan on 10/10/13.
//  Copyright (c) 2013 OnePoint. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IQueryHelper <NSObject>

//region Public Properties

@property (readwrite, strong) NSString *Statement;

//region Public Functions

-(NSString *)AddIdentityRequest;
-(NSString *)AddLimitClause:(int)limit;
-(NSString *)AddOrderByField:(NSString *) orderByField;
-(NSString *)AddOrderByFields:(NSArray *) orderByFields;
-(NSString *)BuildPageStatement:(int) pageNumber withPage:(int) pageSize;


@end

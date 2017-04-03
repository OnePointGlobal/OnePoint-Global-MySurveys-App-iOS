//
//  SqlQueryParameter.h
//  OnePointFramework
//
//  Created by Chinthan on 10/10/13.
//  Copyright (c) 2013 OnePoint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IQueryParameter.h"
#import "QueryDbType.h"

@interface SqlQueryParameter : NSObject<IQueryParameter>{
    NSString *paramName;
    QueryDbType paramDataType;
    int paramSize;
    NSString *paramAltName;
    QueryParameterDirection paramDirection;
    id paramValue;
    
}

@property(nonatomic,readwrite) NSString *paramName;
@property(nonatomic,assign) QueryDbType paramDataType;
@property(nonatomic,assign) QueryParameterDirection paramDirection;
@property(nonatomic,assign) int paramSize;
@property(nonatomic,readwrite) NSString *paramAltName;
@property(nonatomic,readwrite) id paramValue;

- (id)initWithSqlQueryParameter: (NSString *)name withQueryDb:(QueryDbType)dataType withSize:(int)size;
- (id)initWithSqlQueryParameter: (NSString *)name withQueryDb:(QueryDbType)dataType withSize:(int)size withAltName:(NSString *)altName;

-(id)Value;
-(NSString *)AltName;
-(void)setValue: (id) value;
-(void)setName:(NSString *)value;
-(NSString *)Name;


@end

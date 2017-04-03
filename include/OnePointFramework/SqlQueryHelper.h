//
//  SqlQueryHelper.h
//  OnePointFramework
//
//  Created by Chinthan on 10/10/13.
//  Copyright (c) 2013 OnePoint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IQueryHelper.h"
#import "IQueryCommand.h"
#import "SortDefinition.h"
static NSString *TokenEndIdentifier = @"}";
static NSString *TokenStartIdentifier = @"$DB{";

@interface SqlQueryHelper : NSObject<IQueryHelper>{
  
    @private NSString *query;
    
    /// <summary>
    /// The command.
    /// </summary>
    @private id<IQueryCommand> command;
    
}

@property(nonatomic,strong)id<IQueryCommand> command;
@property(nonatomic,strong)NSString *query;

- (id)initWithSqlQueryCommand: (id<IQueryCommand>) Command;
- (id)initWithSqlQuery: (NSString *) Query;


- (NSString *)Statement;
-(void)setStatement:(NSString *) value;

- (NSString *)ToText;
-(NSString *)AddIdentityRequest;

-(NSString *)cleanOnce:(NSString *)statement;
@end

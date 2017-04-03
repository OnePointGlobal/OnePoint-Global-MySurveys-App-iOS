//
//  SqlQueryReader.h
//  OnePointFramework
//
//  Created by Chinthan on 10/10/13.
//  Copyright (c) 2013 OnePoint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDataReader.h"
#import "QueryDbType.h"
#import "QueryParameterDirection.h"
#import <sqlite3.h>

@interface SqlQueryReader : NSObject<IDataReader>{
    @private NSString *paramName;
	@private QueryDbType paramDataType;
	@private int paramSize;
	@private NSString *paramAltName;
	@private QueryParameterDirection paramDirection;
	@private id paramValue;
    sqlite3_stmt *compiledStatement;
    NSString *commandText;
    sqlite3 *sqlCommand;
    

}

@property(nonatomic,readwrite) sqlite3_stmt *compiledStatement;;
@property(nonatomic,strong) NSString *commandText;
@property(nonatomic,readwrite) sqlite3 *sqlCommand;

- (id)initWithSqlQueryReader: (NSString *)aCommandText withSqlCommand:(sqlite3 *)aSqlCommand withCompiledStatement:(sqlite3_stmt *)aCompiledStatement;

@end

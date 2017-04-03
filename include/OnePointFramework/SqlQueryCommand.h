//
//  SqlQueryCommand.h
//  OnePointFramework
//
//  Created by Chinthan on 10/10/13.
//  Copyright (c) 2013 OnePoint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IQueryCommand.h"
#import "SqlQueryCommand.h"
#import "QueryCommandType.h"
#import "IDataReader.h"
#import <sqlite3.h>
#import "SqlQueryHelper.h"
#import "SqlQueryReader.h"

static NSString *DbName=@"Framework.db";
@interface SqlQueryCommand : NSObject<IQueryCommand>{
    NSString *ConfigConnectionString;
    //@private SqlCommand sqlCommand;
    QueryCommandType CommandType;
    id<IDataReader> DataReader;
    NSMutableArray *_parameters;
    sqlite3 *sqlCommand;
    sqlite3_stmt *compiledStatement;

    NSNumber *isDbOpen;

}

@property(readonly,strong) NSString *ConfigConnectionString;
@property(nonatomic,assign) QueryCommandType CommandType;
@property(readwrite,strong) id<IDataReader> DataReader;
@property(readwrite,strong) NSMutableArray *_parameters;
+(void)setDbName:(NSString*)name;
+(NSString*)getDbName;
//- (NSString *)getCommandText;
//-(void)setCommandText:(NSString *) value;
-(void)Close;
-(NSMutableArray*)getParameters;
@end

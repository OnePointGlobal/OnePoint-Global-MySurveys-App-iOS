//
//  DataHandler.h
//  OnePointFramework
//
//  Created by Chinthan on 10/10/13.
//  Copyright (c) 2013 OnePoint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDisposable.h"
#import "IQueryCommand.h"
#import "IDataReader.h"
#import "IQueryHelper.h"

@interface DataHandler : NSObject <IDisposable>{
    id<IQueryCommand> command;
    id<IQueryHelper> queryHelper;
    int recCount;
    id<IDataReader> DataReader;

}

@property (readwrite, strong) id<IDataReader> DataReader;
@property (readwrite, strong) id<IQueryCommand> command;
@property (nonatomic, retain) id<IQueryHelper> queryHelper;
@property(nonatomic, assign) int recCount;
-(id)initWithDataHandler:(NSString*)storedProcedure;
-(void)CloseConnection;
-(void)ExecuteAsDataReader;
-(void)ExecuteNonQuery;
-(id)ExecuteScalar;
-(int)getRecCount;
-(void)CreateCommand;
-(id<IQueryCommand>)Command;
- (NSString *)CommandText;
-(void)setCommandText:(NSString *) value;

-(id<IQueryHelper>)QueryHelper;
-(void)setQueryHelper:(id<IQueryHelper>)value;

-(void)AddInParameter:(NSString *)parameterName withQueryDbType:(QueryDbType)databaseType withSize:(int)size withvalue:(id)value;
-(void)AddInParameter:(NSString *)parameterName withQueryDbType:(QueryDbType)databaseType withSize:(int)size withAltname:(NSString *)altName withvalue:(id)value;
-(void)AddOutParameter:(NSString *)parameterName withQueryDbType:(QueryDbType)databaseType withSize:(int)size withvalue:(id)value;
-(void)AddParameter:(id<IQueryParameter>)param;
-(void)AddParameter:(NSString *)parameterName withQueryDbType:(QueryDbType)databaseType withDirection:(QueryParameterDirection)direction withSize:(int)size withAltname:(NSString *)altName withvalue:(id)value;

@end

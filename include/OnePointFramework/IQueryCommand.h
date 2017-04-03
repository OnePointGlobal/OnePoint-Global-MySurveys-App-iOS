//
//  IQueryCommand.h
//  OnePointFramework
//
//  Created by Chinthan on 10/10/13.
//  Copyright (c) 2013 OnePoint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDisposable.h"
#import "IDataReader.h"
#import "QueryCommandType.h"
#import "IQueryParameter.h"

@protocol IQueryCommand <NSObject,IDisposable>

//region Public Properties
//region Public Functions
@optional

@property (readwrite, strong) NSString *CommandText;
@property (nonatomic,assign) QueryCommandType CommandType;
@property (readwrite, strong) id<IDataReader> DataReader;
@property (readwrite, strong) NSMutableArray *Parameters;

//-(NSMutableArray*)Parameters;
//-(void)setParameters:(NSMutableArray *)Parameters;
-(void)Close;
-(void)Dispose;
-(id<IDataReader>)ExecuteAsDataReader:(BOOL) closeConnection;
-(void)executeNonQuery;
-(id<IDataReader>)ExecuteReader;
-(id)ExecuteScalar;
-(void)Open;

@end

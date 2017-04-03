//
//  DataObjectFactory.h
//  OnePointFramework
//
//  Created by Chinthan on 10/10/13.
//  Copyright (c) 2013 OnePoint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataObject.h"
#import "DataHandler.h"
#import "DataMode.h"
#import "IDataReader.h"


@protocol DataObjectFactory
    @property (readonly,strong) NSString *SelectAllStatement;
    @property (readonly,strong) NSString *TableName;
    @property (readonly,strong) NSString *ByPkClause;
    @property (readonly,strong) NSString *InsertStatement;
    @property (readonly,strong) NSString *UpdateStatement;
    @property (readonly,strong) NSString *DeleteStatement;

-(id)find:(NSString *)attributeName AttributeValue:(id)attributeValue;//modified by babu
-(void)AppendSqlParameters:(DataHandler *)dataHandler withDataObject:(DataObject *)dataObject withDataMode:(DataMode)mode;
-(id)createObjectFromDataReader:(id<IDataReader>)reader withPopulate:(BOOL)populateRelatedObject;

@end

@interface DataObjectFactory: NSObject<DataObjectFactory>{
    @private DataHandler *dataHandler;
    @private BOOL hasAutoIncrementPk;
}

@property(readwrite,strong) DataHandler *dataHandler;
@property(readwrite,assign) BOOL hasAutoIncrementPk;


-(DataHandler *)CreateDataHandler;
-(id)Find:(DataHandler *) currentDataHandler;
-(id)Find:(NSMutableArray *)colList withPageNum:(int)pageNumber withPageSize:(int)pageSize;
-(BOOL)Save:(DataObject *)dataObject;
-(BOOL) Delete:(DataObject *)dataObject;

-(id)FindAllObjects;
-(id)FindAllObjects:(NSString *) orderByField;
-(id)FindAllObjects:(NSString *) orderByField withResultLimit:(int)resultLimit;
-(id)BuildArray:(DataHandler *)currentDataHandler withCloseConnection:(BOOL)closeConnection;

@end

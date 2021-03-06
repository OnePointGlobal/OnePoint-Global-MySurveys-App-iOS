// --------------------------------------------------------------------------------------------------------------------
// <copyright file="model.cs" company="OnePoint Global">
//   Copyright (c) 2012 OnePoint Global Ltd. All rights reserved.
// </copyright>
// <summary>
//   This file was autogenerated and you should not edit it. It will be 
//   regenerated whenever the schema changes.
//   All changes should be made in LabelRelationship.cs and the mode.xml. 
// </summary>
// --------------------------------------------------------------------------------------------------------------------


#import <Foundation/Foundation.h>
#import <OnePointFramework/DataObjectFactory.h>
#import "ILabelRelationshipData.h"
#import "ILabelRelationshipFactoryBase.h"

//package OnePoint.PROM.Model; 
  

/// <summary>
/// Creates and finds LabelRelationship objects
/// </summary>



@interface  LabelRelationshipFactoryBase : DataObjectFactory<ILabelRelationshipData,ILabelRelationshipFactoryBase>
{
}

+(NSString*)  FIELD_NAME_LABELRELATIONSHIPID;
+(NSString*)  FIELD_NAME_LABELID;
+(NSString*)  FIELD_NAME_IDENTFIERID;
+(NSString*)  FIELD_NAME_CREATEDDATE;
+(NSString*)  FIELD_NAME_LASTUPDATEDDATE;
+(NSString*) PARAMETER_NAME_LABELRELATIONSHIPID;
+(NSString*) PARAMETER_NAME_LABELID;
+(NSString*) PARAMETER_NAME_IDENTFIERID;
+(NSString*) PARAMETER_NAME_CREATEDDATE;
+(NSString*) PARAMETER_NAME_LASTUPDATEDDATE;

/// <summary>
/// The Microsoft SQL statement to join one table to another and perform it.
/// </summary>
-(BOOL) DeleteByPk :(NSNumber *) keyLabelRelationshipID ;
//-(BOOL) DeleteByPk:(NSNumber *) keyLabelRelationshipID;
// Define input parameters once only so they can be reused by other methods
-(void) AddLabelRelationshipIDParameter:(DataHandler *) dataHandler valLabelRelationshipID:(NSNumber *) valLabelRelationshipID;	

-(void) AddLabelIDParameter:(DataHandler *) dataHandler valLabelID:(NSNumber *) valLabelID;	

-(void) AddIdentfierIDParameter:(DataHandler *) dataHandler valIdentfierID:(NSNumber *) valIdentfierID;	

-(void) AddCreatedDateParameter:(DataHandler *) dataHandler valCreatedDate: (NSDate *) valCreatedDate;	

-(void) AddLastUpdatedDateParameter:(DataHandler *) dataHandler valLastUpdatedDate: (NSDate *) valLastUpdatedDate;	

-(BOOL) ProcessPkStatement :(NSNumber *) keyLabelRelationshipID   query:(NSString *) query;
//-(BOOL) ProcessPkStatement:(NSNumber *) keyLabelRelationshipID query:(NSString *) query;

-(id<ILabelRelationshipData>) Find:(NSString *) attributeName attributeValue:(id) attributeValue;

-(id<ILabelRelationshipData>) FindByLabelRelationshipID:(NSNumber *) fieldValue;
-(id<ILabelRelationshipData>) FindByLabelID:(NSNumber *) fieldValue;
-(id<ILabelRelationshipData>) FindByIdentfierID:(NSNumber *) fieldValue;
-(id<ILabelRelationshipData>) FindByCreatedDate:(NSDate *) fieldValue;  
-(id<ILabelRelationshipData>) FindByLastUpdatedDate:(NSDate *) fieldValue;  
-(void) AppendSqlParameters:(DataHandler *) dataHandler dataObject:(DataObject *)dataObject mode:(DataMode *) mode;      
-(id<ILabelRelationshipData>) FindObject :(NSNumber *) keyLabelRelationshipID ;
        
-(id<ILabelRelationshipData>) Find:(DataHandler *) dataHandler;
        
-(id<ILabelRelationshipData>) FindAllObjects;

-(id<ILabelRelationshipData>) FindAllObjects:(NSString *) orderByField;

-(id<ILabelRelationshipData>) FindAllObjects:(NSString *) orderByField resultLimit:(int)resultLimit;	

-(id<ILabelRelationshipData>) CreateLabelRelationship:(id<IDataReader>) reader;
		
-(id<ILabelRelationshipData>) createObjectFromDataReader:(id<IDataReader>) reader withPopulate:(BOOL)populateRelatedObject;

-(id<ILabelRelationshipData>) Build:(DataHandler *) currentDataHandler closeConnection:(BOOL)closeConnection;
       
@end
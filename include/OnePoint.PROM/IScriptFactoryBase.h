// --------------------------------------------------------------------------------------------------------------------
// <copyright file="IScript" company="OnePoint Global">
//   Copyright (c) 2012 OnePoint Global Ltd. All rights reserved.
// </copyright>
// <summary>
//   This file was autogenerated and you should not edit it. It will be 
//   regenerated whenever the schema changes.
//   All changes should be made in Script.cs and the mode.xml. 
// </summary>
// --------------------------------------------------------------------------------------------------------------------


/// <summary>
/// The IScript Interface Data Object Base
/// </summary>

#import <Foundation/Foundation.h>


/// <summary>
/// The IScriptFactoryBase Interface Data Object Base
/// </summary>
	
@protocol IScriptFactoryBase <NSObject>
   
-(NSString *) SelectAllStatement;
-(NSString *)TableName;
-(NSString *)ByPkClause;
-(NSString *)InsertStatement;
-(NSString *)UpdateStatement;
-(NSString *)DeleteStatement;
-(NSString *)DeleteByPk;


-(void) AddScriptIDParameter:(DataHandler *) dataHandler withScriptID:(NSNumber*) ScriptID;     
-(void) AddUserIDParameter:(DataHandler *) dataHandler withUserID:(NSNumber*) UserID;     
-(void) AddNameParameter:(DataHandler *) dataHandler withName:(NSString *) Name;  
-(void) AddDescriptionParameter:(DataHandler *) dataHandler withDescription:(NSString *) Description;  
-(void) AddIsDeletedParameter:(DataHandler *) dataHandler withIsDeleted:(NSNumber*) IsDeleted;     
-(void) AddCreatedDateParameter:(DataHandler *) dataHandler withCreatedDate:(NSDate *) CreatedDate; 
-(void) AddLastUpdatedDateParameter:(DataHandler *) dataHandler withLastUpdatedDate:(NSDate *) LastUpdatedDate; 
-(id<IScriptData>) FindByScriptID:(NSNumber *) fieldValue;
        
-(id<IScriptData>) FindByUserID:(NSNumber *) fieldValue;
        
-(id<IScriptData>) FindByName:(NSString *) fieldValue;
        
-(id<IScriptData>) FindByDescription:(NSString *) fieldValue;
        
-(id<IScriptData>) FindByIsDeleted:(NSNumber *) fieldValue;
        
-(id<IScriptData>) FindByCreatedDate:(NSDate *) fieldValue;
        
-(id<IScriptData>) FindByLastUpdatedDate:(NSDate *) fieldValue;
        
-(id<IScriptData>) CreateScript:(id<IDataReader>)reader;

@end
    

   
    


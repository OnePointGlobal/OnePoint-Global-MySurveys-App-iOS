// --------------------------------------------------------------------------------------------------------------------
// <copyright file="IGroups" company="OnePoint Global">
//   Copyright (c) 2012 OnePoint Global Ltd. All rights reserved.
// </copyright>
// <summary>
//   This file was autogenerated and you should not edit it. It will be 
//   regenerated whenever the schema changes.
//   All changes should be made in Groups.cs and the mode.xml. 
// </summary>
// --------------------------------------------------------------------------------------------------------------------


/// <summary>
/// The IGroups Interface Data Object Base
/// </summary>

#import <Foundation/Foundation.h>


/// <summary>
/// The IGroupsFactoryBase Interface Data Object Base
/// </summary>
	
@protocol IGroupsFactoryBase <NSObject>
   
-(NSString *) SelectAllStatement;
-(NSString *)TableName;
-(NSString *)ByPkClause;
-(NSString *)InsertStatement;
-(NSString *)UpdateStatement;
-(NSString *)DeleteStatement;
-(NSString *)DeleteByPk;


-(void) AddGroupIDParameter:(DataHandler *) dataHandler withGroupID:(NSNumber*) GroupID;     
-(void) AddUserIDParameter:(DataHandler *) dataHandler withUserID:(NSNumber*) UserID;     
-(void) AddNameParameter:(DataHandler *) dataHandler withName:(NSString *) Name;  
-(void) AddDescriptionParameter:(DataHandler *) dataHandler withDescription:(NSString *) Description;  
-(void) AddCreatedDateParameter:(DataHandler *) dataHandler withCreatedDate:(NSDate *) CreatedDate; 
-(void) AddLastUpdatedDateParameter:(DataHandler *) dataHandler withLastUpdatedDate:(NSDate *) LastUpdatedDate; 
-(void) AddParentGroupIDParameter:(DataHandler *) dataHandler withParentGroupID:(NSNumber*) ParentGroupID;     
-(void) AddLevelParameter:(DataHandler *) dataHandler withLevel:(NSNumber*) Level;     
-(void) AddRefIDParameter:(DataHandler *) dataHandler withRefID:(NSNumber*) RefID;     
-(id<IGroupsData>) FindByGroupID:(NSNumber *) fieldValue;
        
-(id<IGroupsData>) FindByUserID:(NSNumber *) fieldValue;
        
-(id<IGroupsData>) FindByName:(NSString *) fieldValue;
        
-(id<IGroupsData>) FindByDescription:(NSString *) fieldValue;
        
-(id<IGroupsData>) FindByCreatedDate:(NSDate *) fieldValue;
        
-(id<IGroupsData>) FindByLastUpdatedDate:(NSDate *) fieldValue;
        
-(id<IGroupsData>) FindByParentGroupID:(NSNumber *) fieldValue;
        
-(id<IGroupsData>) FindByLevel:(NSNumber *) fieldValue;
        
-(id<IGroupsData>) FindByRefID:(NSNumber *) fieldValue;
        
-(id<IGroupsData>) CreateGroups:(id<IDataReader>)reader;

@end
    

   
    


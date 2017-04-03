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
/// The IGroupsData Interface Data Object Base
/// </summary>
@protocol IGroupsData <NSObject>
    
-(NSNumber *) GroupID;
-(void) setGroupID:(NSNumber *) value;
-(NSNumber *) UserID;
-(void) setUserID:(NSNumber *) value;
-(NSString *) NameSpecified;
-(void) setNameSpecified:(NSString *) value;
-(NSString *) DescriptionSpecified;
-(void) setDescriptionSpecified:(NSString *) value;
-(NSDate *) CreatedDate;
-(void) setCreatedDate:(NSDate *) value;
-(NSDate *) LastUpdatedDate;
-(void) setLastUpdatedDate:(NSDate *) value;
-(NSNumber *) ParentGroupID;
-(void) setParentGroupID:(NSNumber *) value;
-(NSNumber *) Level;
-(void) setLevel:(NSNumber *) value;
-(NSNumber *) RefID;
-(void) setRefID:(NSNumber *) value;

@end
   

   
    


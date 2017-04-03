// --------------------------------------------------------------------------------------------------------------------
// <copyright file="IProjectSurvey" company="OnePoint Global">
//   Copyright (c) 2012 OnePoint Global Ltd. All rights reserved.
// </copyright>
// <summary>
//   This file was autogenerated and you should not edit it. It will be 
//   regenerated whenever the schema changes.
//   All changes should be made in ProjectSurvey.cs and the mode.xml. 
// </summary>
// --------------------------------------------------------------------------------------------------------------------


/// <summary>
/// The IProjectSurvey Interface Data Object Base
/// </summary>

#import <Foundation/Foundation.h>


/// <summary>
/// The IProjectSurveyFactoryBase Interface Data Object Base
/// </summary>
	
@protocol IProjectSurveyFactoryBase <NSObject>
   
-(NSString *) SelectAllStatement;
-(NSString *)TableName;
-(NSString *)ByPkClause;
-(NSString *)InsertStatement;
-(NSString *)UpdateStatement;
-(NSString *)DeleteStatement;
-(NSString *)DeleteByPk;


-(void) AddProjectSurveyIDParameter:(DataHandler *) dataHandler withProjectSurveyID:(NSNumber*) ProjectSurveyID;     
-(void) AddProjectIDParameter:(DataHandler *) dataHandler withProjectID:(NSNumber*) ProjectID;     
-(void) AddSurveyIDParameter:(DataHandler *) dataHandler withSurveyID:(NSNumber*) SurveyID;     
-(void) AddExcludedParameter:(DataHandler *) dataHandler withExcluded:(NSNumber*) Excluded;     
-(void) AddExcludedNullParameter:(DataHandler *) dataHandler;
-(void) AddIsDeletedParameter:(DataHandler *) dataHandler withIsDeleted:(NSNumber*) IsDeleted;     
-(void) AddCreatedDateParameter:(DataHandler *) dataHandler withCreatedDate:(NSDate *) CreatedDate; 
-(void) AddLastUpdatedDateParameter:(DataHandler *) dataHandler withLastUpdatedDate:(NSDate *) LastUpdatedDate; 
-(id<IProjectSurveyData>) FindByProjectSurveyID:(NSNumber *) fieldValue;
        
-(id<IProjectSurveyData>) FindByProjectID:(NSNumber *) fieldValue;
        
-(id<IProjectSurveyData>) FindBySurveyID:(NSNumber *) fieldValue;
        
-(id<IProjectSurveyData>) FindByExcluded:(NSNumber *) fieldValue;
        
-(id<IProjectSurveyData>) FindByIsDeleted:(NSNumber *) fieldValue;
        
-(id<IProjectSurveyData>) FindByCreatedDate:(NSDate *) fieldValue;
        
-(id<IProjectSurveyData>) FindByLastUpdatedDate:(NSDate *) fieldValue;
        
-(id<IProjectSurveyData>) CreateProjectSurvey:(id<IDataReader>)reader;

@end
    

   
    


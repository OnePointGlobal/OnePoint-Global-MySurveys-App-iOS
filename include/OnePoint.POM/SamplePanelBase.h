// --------------------------------------------------------------------------------------------------------------------
// <copyright file="SamplePanelBase.java" company="OnePoint Global">
//   Copyright (c) 2012 OnePoint Global Ltd. All rights reserved.
// </copyright>
// <summary>
//   This file was autogenerated and you should not edit it. It will be 
//   regenerated whenever the schema changes.
//   All changes should be made in SamplePanel.cs and the mode.xml. 
// </summary>
// --------------------------------------------------------------------------------------------------------------------

#import <Foundation/Foundation.h>
#import <OnePointFramework/DataObject.h>
#import "ISamplePanelData.h"




//package OnePoint.POM.Model 
    


    
@interface  SamplePanelBase : DataObject<DataObject, ISamplePanelData>
{
@private NSNumber *SamplePanelID;
        
@private NSNumber *SampleID;
        
@private NSNumber *PanelID;
        
@private NSNumber *IsDeleted;
        
@private NSDate *CreatedDate;
        
@private NSDate *LastUpdatedDate;
        
}


	  
/// <summary>
/// Gets or sets the 
/// </summary>

	@property(nonatomic,retain) NSNumber *SamplePanelID;

	
	@property(nonatomic,retain) NSNumber *SampleID;

	
	@property(nonatomic,retain) NSNumber *PanelID;

	
	@property(nonatomic,retain) NSNumber *IsDeleted;

	
	@property(readwrite,strong) NSDate *CreatedDate;

	
	@property(readwrite,strong) NSDate *LastUpdatedDate;

	@end
         

    

    
// --------------------------------------------------------------------------------------------------------------------
// <copyright file="PanelListTokenBase.java" company="OnePoint Global">
//   Copyright (c) 2012 OnePoint Global Ltd. All rights reserved.
// </copyright>
// <summary>
//   This file was autogenerated and you should not edit it. It will be 
//   regenerated whenever the schema changes.
//   All changes should be made in PanelListToken.cs and the mode.xml. 
// </summary>
// --------------------------------------------------------------------------------------------------------------------

#import <Foundation/Foundation.h>
#import <OnePointFramework/DataObject.h>
#import "IPanelListTokenData.h"




//package OnePoint.POM.Model 
    


    
@interface  PanelListTokenBase : DataObject<DataObject, IPanelListTokenData>
{
@private NSNumber *PanellistTokenID;
        
@private NSNumber *PanellistID;
        
@private NSString *TokenText;
        
@private NSDate *CreatedDate;
        
@private NSDate *LastUpdatedDate;
        
}


	  

	@property(nonatomic,retain) NSNumber *PanellistTokenID;

	
	@property(nonatomic,retain) NSNumber *PanellistID;

	/// <summary>
/// Gets or sets the 
/// </summary>

	@property(readwrite,strong) NSString *TokenText;

	
	@property(readwrite,strong) NSDate *CreatedDate;

	
	@property(readwrite,strong) NSDate *LastUpdatedDate;

	@end
         

    

    
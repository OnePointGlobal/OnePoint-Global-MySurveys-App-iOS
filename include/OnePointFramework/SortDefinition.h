//
//  SortDefinition.h
//  OnePointFramework
//
//  Created by Chinthan on 10/10/13.
//  Copyright (c) 2013 OnePoint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SortOrder.h"

@interface SortDefinition : NSObject{
    
    @private DataSortOrder sortOrder;// = SortOrder.Ascending;
    NSString *ColumnNameWithoutAlias;
}
@property (readwrite,assign) DataSortOrder sortOrder;

@property (readwrite,strong) NSString *ColumnNameWithoutAlias;


- (id)initWithSortDefinition: (NSString*) columnName withOrder:(DataSortOrder) order;

- (NSString *) ColumnName;
- (void) setColumnName:(NSString *) value;

- (DataSortOrder) Order;
- (void) setOrder:(DataSortOrder) value;

-(DataSortOrder)ReverseOrder;



@end

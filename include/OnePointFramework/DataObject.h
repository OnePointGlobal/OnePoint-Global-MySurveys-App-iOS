//
//  DataObject.h
//  OnePointFramework
//
//  Created by Chinthan on 10/10/13.
//  Copyright (c) 2013 OnePoint. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol DataObject
    @property (nonatomic,retain) id PrimaryKey;
@end



@interface DataObject : NSObject<DataObject>{
    BOOL isNew;
    BOOL isModified;
    BOOL IsModified;
    BOOL IsNew;
}

- (BOOL) IsModified;
- (void) setIsModified:(BOOL) value;

- (BOOL) IsNew;
- (void) setIsNew:(BOOL) value;

-(BOOL)Delete;
-(BOOL)Save;

@end

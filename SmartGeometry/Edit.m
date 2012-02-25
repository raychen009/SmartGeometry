//
//  Edit.m
//  SmartGeometry
//
//  Created by kwan terry on 12-2-25.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Edit.h"

@implementation Edit

@synthesize whichLineRectangle,inWhichFrame;
@synthesize position,position1,position2,position3,positionTemp,positionTemp1,positionTemp2,positionTemp3;
@synthesize editParameters,stretchGraphList,recordOperationVector1,recordOperationVector2,recordOperationVector3,recordOperationVectorTemp;

- (id)init
{
    self = [super init];
    if (self) 
    {
        // Initialization code here.
        bool editMode[7];
        editParameters = editMode;
        position1 = 0;
        position2 = 0;
        position3 = 0;
        positionTemp1 = 0;
        positionTemp2 = 0;
        positionTemp3 = 0;
        inWhichFrame = 1;
        whichLineRectangle = -1;
        [self clearEditParametersWithPosition:0 Size:7];
    }
    
    return self;
}

-(void)dealloc
{
    positionTemp1 = -1;
    inWhichFrame = 1;
    [self eraseOpertaion2];
    positionTemp2 = -1;
    inWhichFrame = 2;
    [self eraseOpertaion2];
    positionTemp3 = 1;
    inWhichFrame = 3;
    [self eraseOpertaion2];
    [recordOperationVector1 removeAllObjects];
    [recordOperationVector2 removeAllObjects];
    [recordOperationVector3 removeAllObjects];
}

-(void)clearEditParametersWithPosition:(int)positionLocal Size:(int)size
{
    for(int i=positionLocal; i<=size; i++)
    {
        editParameters[i] = NO;
    }
}

-(void)scanSelectedList:(NSMutableArray *)selectedList
{
    if([selectedList count] == 0)
        return;
    editParameters[0] = YES;
    editParameters[6] = YES;
    SCGraph* graphTemp = [selectedList objectAtIndex:0];
    [graphTemp setIsSelected:YES];
    
    [self searchConstraintWithGraph:graphTemp SelectedList:selectedList];
}

-(void)searchConstraintWithGraph:(SCGraph *)graph SelectedList:(NSMutableArray *)selectedList
{
    for(int i=0; i<[graph.constraintList count]; i++)
    {
        Constraint* constraint = [graph.constraintList objectAtIndex:i];
        if(!constraint.relatedGraph.isSelected)
        {
            [constraint.relatedGraph setIsSelected:YES];
            [selectedList addObject:constraint.relatedGraph];
            [self searchConstraintWithGraph:constraint.relatedGraph SelectedList:selectedList];
        }
    }
}

//在touchbegin调用
//三条直线交于一点时限制(只是例子)
-(void)isMoveOrStretchWithPoint1:(SCPoint *)point1 SelectedList:(NSMutableArray *)selectedList;
{
    SCPoint* p = [[SCPoint alloc]initWithX:point1.x andY:point1.y];
    for(int i=0; i<[selectedList count]; i++)
    {
        SCGraph* graphTemp = [selectedList objectAtIndex:i];
        if([graphTemp isKindOfClass:[SCCurveGraph class]])
        {
            SCCurveGraph* curveGraphTemp = (SCCurveGraph*)graphTemp;
            
        }
    }
}

@end

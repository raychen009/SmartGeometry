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
            [curveGraphTemp.curveUnit antiTranslateWith:p Theta:curveGraphTemp.curveUnit.alpha Point:curveGraphTemp.curveUnit.move];
            if([Threshold Distance:p :curveGraphTemp.curveUnit.end] < IS_SELECT_POINT)
            {
                [stretchGraphList addObject:curveGraphTemp];
                editParameters[2] = YES;
                return;
            }
        }
    }
    for(int i=0; i<[selectedList count]; i++)
    {
        SCGraph* graphTemp = [selectedList objectAtIndex:i];
        if([graphTemp isKindOfClass:[SCPointGraph class]])
        {
            SCPointGraph* pointGraphTemp = (SCPointGraph*)graphTemp;
            if(pointGraphTemp.freedomType > 2)
            {
                editParameters[1] = true;
                return;
            }
        }
    }
    for(int i=0; i<[selectedList count]; i++)
    {
        SCGraph* graphTemp = [selectedList objectAtIndex:i];
        if([graphTemp isKindOfClass:[SCPointGraph class]])
        {
            SCPointGraph* pointGraphTemp = (SCPointGraph*)graphTemp;
            bool isStretchCutLine = NO;
            for(int i=0; i<[pointGraphTemp.constraintList count]; i++)
            {
                Constraint* constraint = [pointGraphTemp.constraintList objectAtIndex:i];
                if([constraint.relatedGraph isKindOfClass:[SCLineGraph class]])
                {
                    SCLineGraph* lineGraphTemp = (SCLineGraph*)constraint.relatedGraph;
                    if(lineGraphTemp.lineUnit.isCutLine)
                    {
                        isStretchCutLine = YES;
                    }
                }
            }
            if(isStretchCutLine)
                continue;
            if(pointGraphTemp.freedomType < 2)
            {
                float distance = [Threshold Distance:pointGraphTemp.pointUnit.start :[[SCPoint alloc]initWithX:p.x andY:p.y]];
                if(distance < IS_SELECT_POINT)
                {
                    editParameters[2] = true;
                    [stretchGraphList addObject:pointGraphTemp];
                    return;
                }
            }
        }
    }
    for(int i=0; i<[selectedList count]; i++)
    {
        SCGraph* graphTemp = [selectedList objectAtIndex:i];
        if([graphTemp isKindOfClass:[SCRectangleGraph class]])
        {
            SCRectangleGraph* rectangleGraph = (SCRectangleGraph*)graphTemp;
            float distanceTemp = 0.0;
            for(int i=0; i<4; i++)
            {
                LineUnit* line = [rectangleGraph.rec_lines objectAtIndex:i];
                distanceTemp += [Threshold Distance:line.start :line.end]*[Threshold pointToLIne:[[SCPoint alloc]initWithX:p.x andY:p.y] :line];
            }
            SCPoint* vertex0 = [rectangleGraph.rec_vertexes objectAtIndex:0];
            SCPoint* vertex1 = [rectangleGraph.rec_vertexes objectAtIndex:1];
            SCPoint* vertex2 = [rectangleGraph.rec_vertexes objectAtIndex:2];
            SCPoint* vertex3 = [rectangleGraph.rec_vertexes objectAtIndex:3];
            LineUnit* line = [[LineUnit alloc]initWithStartPoint:vertex0 endPoint:vertex2];
            float s = [Threshold Distance:vertex0 :vertex2]*[Threshold pointToLIne:vertex1 :line]
                    + [Threshold Distance:vertex0 :vertex2]*[Threshold pointToLIne:vertex3 :line];
            [line release];
            line = NULL;
            if(distanceTemp/s < 1.2)
            {
                for(int i=0; i<4; i++)
                {
                    LineUnit* line = [rectangleGraph.rec_lines objectAtIndex:i];
                    if([Threshold pointToLIne:[[SCPoint alloc]initWithX:p.x andY:p.y] :line] < IS_SELECT_LINE)
                    {
                        [stretchGraphList addObject:rectangleGraph];
                        whichLineRectangle = i;
                        editParameters[2] = YES;
                        return;
                    }
                }
            }
            
        }
    }
    if(!editParameters[2])
    {
        editParameters[1] = YES;
    }
}

//在touchmove调用
-(void)selectedMoveOrStretchWithPrePoint:(SCPoint *)prePoint LastPoint:(SCPoint *)lastPoint SelectedList:(NSMutableArray *)selectedList
{
    if(editParameters[1])
    {
        [self selectedGraphListMoveWithPoint:[[SCPoint alloc]initWithX:lastPoint.x-prePoint.x andY:lastPoint.y-prePoint.y] SelectedList:selectedList];
    }
    else if(editParameters[2])
    {
        for(int i=0; i<[stretchGraphList count]; i++)
        {
            SCGraph* graphTemp = [stretchGraphList objectAtIndex:i];
            if([graphTemp isKindOfClass:[SCPointGraph class]])
            {
                SCPointGraph* pointGraph = (SCPointGraph*)graphTemp;
                if(pointGraph.vertexOfSpecialLine == NO && pointGraph.vertexOfCurveCenter == NO)
                {
                    SCPoint* pointTemp = [[SCPoint alloc]initWithX:prePoint.x andY:prePoint.y];
                    [pointGraph setPoint:pointTemp];
                    [pointGraph keepConstraintWithPoint:pointTemp]; 
                }
            }
            else if([graphTemp isKindOfClass:[SCTriangleGraph class]])
            {
                SCTriangleGraph* triangleGraph = (SCTriangleGraph*)graphTemp;
                
            }
        }
    }
}

@end

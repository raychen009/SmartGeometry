//
//  SCGraph.h
//  SmartGeometry
//
//  Created by kwan terry on 11-12-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constraint.h"
#import "ConstraintGraph.h"
#import "Gunit.h"

@class Constraint;
@class ConstraintGraph;
@interface SCGraph : NSObject
{
    int local_graph_id;

    //用于存储时标识出图形的类型
    //0 PointGraph 1 LineGraph 2 CurveGraph 3 TriangleGraph 4 RectangleGraph 5 OtherGraph
    GraphType graphType;
    
    NSMutableArray* constraintList;
    
    bool isDraw;
}

@property (retain)    NSMutableArray*   constraintList;
@property (readwrite) int               local_graph_id;
@property (readwrite) GraphType         graphType;
@property (readwrite) bool              isDraw;

-(id)initWithId:(int)temp_local_graph_id;
-(id)initWithId:(int)temp_local_graph_id andType:(GraphType)graphType1;
-(void)clearConstraint;
-(void)constructConstraintGraph1:(SCGraph*)graph1 Type1:(ConstraintType)type1 Graph2:(SCGraph*)graph2 Type2:(ConstraintType)type2;
-(void)drawWithContext:(CGContextRef)context;

@end

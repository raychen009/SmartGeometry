//
//  SCLineGraph.h
//  SmartGeometry
//
//  Created by kwan terry on 11-12-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LineUnit.h"
#import "SCGraph.h"
#import "SCPointGraph.h"

@class LineUnit;
@interface SCLineGraph : SCGraph
{
    LineUnit* lineUnit;
    
    //用于识别约束时表示直线的端点有没有跟点列表的点图形连到一起
    bool hasStart;
    bool hasEnd;
}

@property (retain) LineUnit* lineUnit;
@property (readwrite) bool      hasStart;
@property (readwrite) bool      hasEnd;

-(id)initWithLine:(LineUnit*)lineUnit1 andId:(int)temp_local_graph_id;

-(void)drawWithContext:(CGContextRef)context;

-(void)recognizeConstraint:(NSMutableArray*)plist;
-(void)adjustVertex:(SCPoint*)point :(int)num;

-(Boolean)recognizeConstraintWithGraph:(SCGraph*)graph List:(NSMutableArray*)plist;
-(Boolean)recognizeConstraintWithLineGraph:(SCLineGraph*)lineGraph List:(NSMutableArray*)plist;
-(int)judgeLegalIntersectionWithLine1:(LineUnit*)line1 Line2:(LineUnit*)line2 Point:(SCPoint*)p2;
-(Boolean)judgeLegalIntersectionWithPoint:(SCPoint*)p;

@end

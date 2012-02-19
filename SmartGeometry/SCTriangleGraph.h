//
//  SCTriangleGraph.h
//  SmartGeometry
//
//  Created by kwan terry on 11-12-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SCGraph.h"
#import "LineUnit.h"
#import "Gunit.h"

@interface SCTriangleGraph : SCGraph
{
    NSMutableArray* triangleLines;
    NSMutableArray* triangleVertexes;
    NSMutableArray* triangleAngles;
    NSMutableArray* triangleLineDistance;
}

@property (retain) NSMutableArray* triangleLines;
@property (retain) NSMutableArray* triangleVertexes;
@property (retain) NSMutableArray* triangleAngles;
@property (retain) NSMutableArray* triangleLineDistance;

-(id)initWithLine0:(LineUnit*)line0 Line1:(LineUnit*)line1 Line2:(LineUnit*)line2 Id:(int)temp_local_graph_id Vertex0:(SCPoint*)vertex0 Vertex1:(SCPoint*)vertex1 Vertex2:(SCPoint*)vertex2;
-(void)initValuesWithLine0:(LineUnit *)line0 Line1:(LineUnit *)line1 Line2:(LineUnit *)line2;
-(void)drawWithContext:(CGContextRef)context;
-(void)setVertex;

@end

//
//  SCRectangleGraph.h
//  SmartGeometry
//
//  Created by kwan terry on 11-12-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SCGraph.h"
#import "LineUnit.h"
#import "Gunit.h"

@interface SCRectangleGraph : SCGraph
{
    NSMutableArray* rec_vertexes;
    NSMutableArray* rec_lines;
}

@property (retain) NSMutableArray* rec_vertexes;
@property (retain) NSMutableArray* rec_lines;

-(id)initWithLine0:(LineUnit*)line0 Line1:(LineUnit*)line1 Line2:(LineUnit*)line2 Line3:(LineUnit*)line3 Id:(int)temp_local_id;
-(void)setLinePointsLine0:(LineUnit*)line1 Line1:(LineUnit*)line2 Line2:(LineUnit*)line3 Line3:(LineUnit*)line4;
-(Boolean)is_not_connect:(LineUnit*)line1 :(LineUnit*)line2;
-(Boolean)is_anticloclkwise:(SCPoint*)v0 :(SCPoint*)v1 :(SCPoint*)v2;
-(void)drawWithContext:(CGContextRef)context;

@end

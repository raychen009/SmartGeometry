//
//  SCPointGraph.h
//  SmartGeometry
//
//  Created by kwan terry on 11-12-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SCGraph.h"
#import "SCPoint.h"
#import "PointUnit.h"
#import "LineUnit.h"
#import "Threshold.h"
#import "SCLineGraph.h"

@class LineUnit;
@interface SCPointGraph : SCGraph
{
    PointUnit* pointUnit;
    
    int freedomType;
    
    bool is_vertex;
    bool is_on_line;
    bool is_on_circle;
    bool belong_to_triangle;
    bool belong_to_rectangle;
    bool in_graph_list;
    
}

@property (retain)      PointUnit*      pointUnit;
@property (readwrite)   int             freedomType;
@property (readwrite)   bool            is_vertex;
@property (readwrite)   bool            is_on_line;
@property (readwrite)   bool            is_on_circle;
@property (readwrite)   bool            belong_to_triangle;
@property (readwrite)   bool            belong_to_rectangle;
@property (readwrite)   bool            in_graph_list;

-(id)initWithUnit:(PointUnit*)pointUnit andId:(int)temp_local_graph_id;

-(void)setPoint:(SCPoint*)point;
-(Boolean)isUndo;
-(Boolean)isRedo;
-(void)resetAttribute;

-(void)drawWithContext:(CGContextRef)context;
-(void)draw_extension_line:(CGContextRef)context;
-(void)draw_dot_lineFromStart:(SCPoint*)startPoint ToEnd:(SCPoint*)endPoint WithContext:(CGContextRef)context;
-(void)draw_line_dot_extension_line:(LineUnit*)lineUnit WithContext:(CGContextRef)context;

@end

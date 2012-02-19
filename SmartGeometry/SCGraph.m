//
//  SCGraph.m
//  SmartGeometry
//
//  Created by kwan terry on 11-12-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SCGraph.h"

@implementation SCGraph

@synthesize constraintList;
@synthesize local_graph_id;
@synthesize graphType;
@synthesize isDraw;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(id)initWithId:(int)temp_local_graph_id
{
    local_graph_id = temp_local_graph_id;
    isDraw = YES;
}

-(id)initWithId:(int)temp_local_graph_id andType:(GraphType)graphType1
{
    self.local_graph_id = temp_local_graph_id;
    self.graphType      = graphType1;
    isDraw              = YES;
    constraintList      = [[NSMutableArray alloc]init];
    
    [self init];
    
    return self;
}

-(void)clearConstraint
{
    [constraintList removeAllObjects];
}

-(void)constructConstraintGraph1:(SCGraph *)graph1 Type1:(ConstraintType)type1 Graph2:(SCGraph *)graph2 Type2:(ConstraintType)type2
{
    Constraint* constraint1      = [[Constraint alloc]init];
    constraint1.constraintType   = type1;
    constraint1.related_graph_id = graph2.local_graph_id;
    constraint1.relatedGraph     = graph2;
    
    Constraint* constraint2 = [[Constraint alloc]init];
    constraint2.constraintType   = type2;
    constraint2.related_graph_id = graph1.local_graph_id;
    constraint2.relatedGraph     = graph1;
    
    [graph1.constraintList addObject:constraint1];
    [graph2.constraintList addObject:constraint2];
    
}

@end

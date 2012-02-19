//
//  SCCurveGraph.h
//  SmartGeometry
//
//  Created by kwan terry on 12-1-19.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "SCGraph.h"
#import "CurveUnit.h"

@interface SCCurveGraph : SCGraph
{
    CurveUnit* curveUnit;
}

-(id)initWithCurveUnit:(CurveUnit*)curveUnitLocal ID:(int)tempLocalGraphID;

-(void)drawWithContext:(CGContextRef)context;

-(void)getCurveUnitByUnit:(CurveUnit*)tempCurveUnit;
-(void)setOrigalMajorMinorAxis;

@property (retain)  CurveUnit* curveUnit;

@end

//
//  SCTriangleGraph.h
//  SmartGeometry
//
//  Created by kwan terry on 11-12-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SCGraph.h"
#import "SCRectangleGraph.h"
#import "SCCurveGraph.h"
#import "LineUnit.h"
#import "Gunit.h"
#import "Constraint.h"

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

//约束部分的相关函数
//使得三角形的边和顶点为严格的逆时针
-(void)setVertex;
//获得三角形的三条边
-(void)getLinesWithLine1:(LineUnit*)line1 Line2:(LineUnit*)line2 Line3:(LineUnit*)line3;
//根据直线和三角形的位置范围来判断是否应该进行具体的约束识别
-(Boolean)judgeRecognizationWithLineGraph:(SCLineGraph*)lineGraph;
-(void)recognizeCommonConstraintWithLineGraph:(SCLineGraph*)lineGraph PointList:(NSMutableArray*)pointList;
-(Boolean)recognizeConstraintWithCurveGraph:(SCCurveGraph*)curveGraph PointList:(NSMutableArray*)pointList;
-(Boolean)recognizeConstraintWithGraph:(SCGraph*)graphTemp PointList:(NSMutableArray*)pointList;
//确定哪种类型的约束会被识别
-(Boolean)willRecognizeType;

//保持约束部分
-(void)followPointGraph:(SCPointGraph*)pointGraph WithVertexIndex:(int)vertexIndex;
-(void)followPointGraph;
-(void)adjustPointGraph;
-(void)keepConstraintWithGraph:(SCGraph*)graphTemp;
-(void)keepConstraintWithGraph:(SCGraph*)graphTemp Angle:(const float)angle RotationCenter:(const SCPoint*)rotaitonCenter;
-(void)keepPointOnTriangleLine:(LineUnit*)lineUnit PointGraph:(SCPointGraph*)pointGraph;
-(void)keepIntersectionOnTriangleLineWithConstraint:(Constraint*)constraint LineUnit:(LineUnit*)lineUnit Point:(SCPoint*)pointTemp;
-(Boolean)recognizeConstraintWithTriangleGraph:(SCTriangleGraph*)triangleGrpah PointList:(NSMutableArray*)pointList;
-(Boolean)recognizeConstraintWithRectangleGraph:(SCRectangleGraph*)rectangleGraph PointList:(NSMutableArray*)pointList;

@end

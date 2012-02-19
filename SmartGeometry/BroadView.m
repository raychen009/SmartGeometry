//
//  BroadView.m
//  SmartGeometry
//
//  Created by kwan terry on 11-12-10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SmartGeometryViewController.h"
#import "BroadView.h"
#import "SCPoint.h"
#import "PenInfo.h"
#import "Threshold.h"
#import "UnitFactory.h"

@implementation BroadView

@synthesize arrayAbandonedStrokes,arrayStrokes;
@synthesize currentColor,currentSize;
@synthesize undoButton,redoButton,deleteButton;
@synthesize owner;
@synthesize unitList,graphList,newGraphList,pointGraphList,saveGraphList;
@synthesize context;
@synthesize factory;

-(BOOL)isMultipleTouchEnabled {
	return NO;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
    }
    return self;
}

-(void) viewJustLoaded 
{
    //NSLog(@"%d",111);
    self.arrayStrokes = [[NSMutableArray alloc]init];
    self.arrayAbandonedStrokes = [[NSMutableArray alloc]init];
    
    self.currentSize = 5.0f;
    self.currentColor= [UIColor blackColor];
    
    factory = [[UnitFactory alloc]init];
    
    self.unitList = [[NSMutableArray alloc]init];
    self.graphList = [[NSMutableArray alloc]init];
    self.newGraphList = [[NSMutableArray alloc]init];
    self.pointGraphList = [[NSMutableArray alloc]init];
    self.saveGraphList = [[NSMutableArray alloc]init];
    
    UIImage* undoImg = [UIImage imageNamed:@"undo.png"];
    undoButton = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, 648.0f, 100.0f, 100.0f)];
    [undoButton setImage:undoImg forState:UIControlStateNormal];
    [undoButton addTarget:self action:@selector(undoFunc:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:undoButton];
    
    UIImage* redoImg = [UIImage imageNamed:@"redo.png"];
    redoButton = [[UIButton alloc]initWithFrame:CGRectMake(100.0f, 648.0f, 100.0f, 100.0f)];
    [redoButton setImage:redoImg forState:UIControlStateNormal];
    [redoButton addTarget:self action:@selector(redoFunc:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:redoButton];
    
    UIImage* deleteImg = [UIImage imageNamed:@"delete.png"];
    deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(200.0f, 648.0f, 100.0f, 100.0f)];
    [deleteButton setImage:deleteImg forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteFunc:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteButton];
}

-(void)undoFunc:(id)sender
{
    if ([arrayStrokes count]>0)
    {
		NSMutableDictionary* dictAbandonedStroke = [arrayStrokes lastObject];
		[self.arrayAbandonedStrokes addObject:dictAbandonedStroke];
		[self.arrayStrokes removeLastObject];
		[self setNeedsDisplay];
    }
    
    if([graphList count] != 0)
    {
        [saveGraphList addObject:[graphList lastObject]];
        [graphList removeLastObject];
    }
    [self setNeedsDisplay];
    
}

-(void)redoFunc:(id)sender
{
    if ([arrayAbandonedStrokes count]>0) 
    {
		NSMutableDictionary* dictReusedStroke = [arrayAbandonedStrokes lastObject];
		[self.arrayStrokes addObject:dictReusedStroke];
		[self.arrayAbandonedStrokes removeLastObject];
		[self setNeedsDisplay];
	}
    
    if([saveGraphList count] != 0)
    {
        [graphList addObject:[saveGraphList lastObject]];
        [saveGraphList removeLastObject];
    }
    [self setNeedsDisplay];
    
    
}

-(void)deleteFunc:(id)sender
{
    [self.arrayStrokes removeAllObjects];
	[self.arrayAbandonedStrokes removeAllObjects];
	[self setNeedsDisplay];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSMutableArray*      arrayPointsInStroke = [[NSMutableArray alloc]init];
    NSMutableDictionary* dictStroke          = [[NSMutableDictionary alloc]init];
    [dictStroke setObject:arrayPointsInStroke forKey:@"points"];
    
    CGPoint point = [[touches anyObject] locationInView:self];
    SCPoint* scpoint = [[SCPoint alloc]initWithX:point.x andY:point.y];
    [arrayPointsInStroke addObject:scpoint];
    
    [self.arrayStrokes addObject:dictStroke];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject]locationInView:self];
    CGPoint prevPoint = [[touches anyObject]previousLocationInView:self];
    SCPoint* scpoint = [[SCPoint alloc]initWithX:point.x andY:point.y];
    
    NSMutableArray* arrayPointsInStroke = [[self.arrayStrokes lastObject]objectForKey:@"points"];
    [arrayPointsInStroke addObject:scpoint];
    
    CGRect rectToRedraw = CGRectMake(
                                     ((prevPoint.x>point.x)?point.x:prevPoint.x)-currentSize,
									 ((prevPoint.y>point.y)?point.y:prevPoint.y)-currentSize,
									 fabs(point.x-prevPoint.x)+2*currentSize,
									 fabs(point.y-prevPoint.y)+2*currentSize
                                     );
    [self setNeedsDisplayInRect:rectToRedraw];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.arrayAbandonedStrokes removeAllObjects];
    
    NSDictionary* dictStroke = [arrayStrokes lastObject];
    NSMutableArray* arrayPointsInStroke = [dictStroke objectForKey:@"points"];
    
    [factory createWithPoint:arrayPointsInStroke Unit:unitList Graph:graphList PointGraph:pointGraphList NewGraph:newGraphList];

    [arrayStrokes removeLastObject];
    
    [self setNeedsDisplay];

}

-(void)drawRect:(CGRect)rect
{
    context = UIGraphicsGetCurrentContext();
    NSLog(@"list:%d",graphList.count);
    
    for(int i=0; i<graphList.count; i++)
    {
        SCGraph* graph = [graphList objectAtIndex:i];
        [graph drawWithContext:context];
    }
    
    if(self.arrayStrokes)
    {
        [currentColor set];
        
        int arraynum = 0;
        for(NSDictionary* dictStroke in self.arrayStrokes)
        {
            NSMutableArray* arrayPointsInStroke = [dictStroke objectForKey:@"points"];
            
            CGContextSetRGBFillColor(context, 0, 0, 0, 1.0);
            SCPoint* scpointStart = [arrayPointsInStroke objectAtIndex:0];
            CGContextMoveToPoint(context, scpointStart.x, scpointStart.y);
            CGContextSetLineWidth(context, 5.0f);
        
            for(int i=0; i<(arrayPointsInStroke.count - 1); i++)
            {
                SCPoint* scpointNext = [arrayPointsInStroke objectAtIndex:i+1];
                CGContextAddLineToPoint(context, scpointNext.x, scpointNext.y);
            }
            CGContextStrokePath(context);
            
            arraynum++;
        }
    }
}

-(void)dealloc
{
    [super dealloc];
    
    [arrayStrokes release];
    [arrayAbandonedStrokes release];
    
    [currentColor release];
}

@end

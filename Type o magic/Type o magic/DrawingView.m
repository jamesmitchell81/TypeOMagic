//
//  DrawingView.m
//  ImageCropUI
//
//  Created by James Mitchell on 14/04/2016.
//  Copyright © 2016 James Mitchell. All rights reserved.
//

#import "DrawingView.h"

@implementation DrawingView

@synthesize drawingData;

- (id) initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    
    if ( self )
    {
        // init code.
    }
    
    return self;
}

- (void) setDrawingData:(NSArray *)data
{
    drawingData = data;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
//    NSRect viewSize = self.bounds;
    
    [[NSColor whiteColor] setFill];
    NSRectFill(dirtyRect);
    
    if ( !drawingData ) return;
    
    // REFERENCE: //developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CocoaDrawingGuide/Transforms/Transforms.html#//apple_ref/doc/uid/TP40003290-CH204-BCIHDAIJ
    NSRect frameRect = [self bounds];
    NSAffineTransform* flip = [NSAffineTransform transform];
    [flip translateXBy:0.0 yBy:frameRect.size.height];
    [flip scaleXBy:2.0 yBy:-2.0];
    [flip concat];
    
    NSColor* fillColor = [NSColor colorWithCalibratedRed: 0 green: 0 blue: 0 alpha: 1];
    NSBezierPath* path = [NSBezierPath bezierPath];
    
    NSPoint n;
    NSValue *value;
    
    value = [drawingData objectAtIndex:0];
    [value getValue:&n];
    [path moveToPoint:n];
    
    for ( int i = 0; i < [drawingData count]; i++ )
    {
        value = [drawingData objectAtIndex:i];
        [value getValue:&n];
        [path lineToPoint:n];
    }
    
//    [hPath curveToPoint: NSMakePoint(13.41, 32.69) controlPoint1: NSMakePoint(1.59, 27.53) controlPoint2: NSMakePoint(6.5, 32.69)];
//    [hPath curveToPoint: NSMakePoint(24.47, 21.66) controlPoint1: NSMakePoint(19.97, 32.69) controlPoint2: NSMakePoint(24.47, 28.5)];

    [path closePath];
    [path setWindingRule: NSEvenOddWindingRule];
    [path setLineWidth:0.5];
    [fillColor setStroke];
    [path stroke];
}

@end

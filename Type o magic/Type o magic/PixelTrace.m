//
//  PixelTrace.m
//  ImageCropUI
//
//  Created by James Mitchell on 13/04/2016.
//  Copyright © 2016 James Mitchell. All rights reserved.
//

#import "PixelTrace.h"
#import "ImageRepresentation.h"

@implementation PixelTrace

- (void) tracePixelsOfImage:(NSImage*)image
{
    NSBitmapImageRep *representation = [ImageRepresentation grayScaleRepresentationOfImage:image];
    unsigned char *data = [representation bitmapData];
    
    int width = image.size.width;
    int height = image.size.height;
    int index = 0;
    int searchPixel = 0;
    BOOL match = NO;
    
    NSMutableArray* points = [[NSMutableArray alloc] init];
   
    // find the first black pixel.
    // or collect all the balck points.
    for ( int y = 0; y < height; y++ )
    {
        for ( int x = 0; x < width; x++ )
        {
            index = x + y * width;
            
            if ( data[index] == searchPixel )
            {
                match = YES;
                NSPoint point = NSMakePoint(x, y);
                NSValue *p = [NSValue valueWithPoint:point];
                [points addObject:p];
//                break;
            }
        }
//        if ( match ) break;
    }
     
    
//    struct PointNode *head = nil;
    
    [points sortUsingComparator: ^NSComparisonResult(id v1, id v2) {
        NSPoint point1;
        [v1 getValue:&point1];
        
        NSPoint point2;
        [v2 getValue:&point2];
        
        return point1.x > point2.x;
    }];

    for ( NSValue *val in points)
    {
        NSPoint current;
        [val getValue:&current];
        
        NSLog(@"%f, %f", current.x, current.y);
    }
    
}

- (NSArray*) mooreNeighborContorTraceOfImage:(NSImage*)image
{
    NSBitmapImageRep *representation = [ImageRepresentation grayScaleRepresentationOfImage:image];
    unsigned char *data = [representation bitmapData];
    
    int width = image.size.width;
    int height = image.size.height;
    int index = 0;
    int searchPixel = 0;
    BOOL match = NO;
    int x = 0, y = 0;

    NSPoint start, last;
    
    NSMutableArray* points = [[NSMutableArray alloc] init];
    
    // find the first black pixel.
    for (y = 0; y < height; y++ )
    {
        for (x = 0; x < width; x++ )
        {
            index = x + y * width;
            
            if ( data[index] == searchPixel )
            {
                match = YES;
                start = NSMakePoint(x, y);
                NSValue *p = [NSValue valueWithPoint:start];
                [points addObject:p];
                break;
            } else {
                last = NSMakePoint(x, y);
            }
            
        }
        if ( match ) break;
    }
    
    int next = 0;
    NSPoint offsets[] = {NSMakePoint(-1, -1),
                         NSMakePoint(-1, 0),
                         NSMakePoint(-1, 1),
                         NSMakePoint(0, 1),
                         NSMakePoint(1, 1),
                         NSMakePoint(1, 0),
                         NSMakePoint(1, -1),
                         NSMakePoint(0, -1)};
    
    NSPoint current = start;
    NSPoint consider = last;
    NSPoint backtrackPosition = last;
    NSPoint backtrackOffset = NSMakePoint(last.x - start.x, last.y - start.y);

    for ( int i = 0; i < 8; i++ )
    {
        if ( CGPointEqualToPoint(backtrackOffset, offsets[i]) )
        {
            next = i;
        }
    }

    BOOL run = YES;
    while ( run )
    {
        index = consider.x + consider.y * width;
        
        if ( data[index] == searchPixel )
        {
            // stopping critria
            if ( CGPointEqualToPoint(start, consider) )
            {
                run = NO;
                break;
            }
            
            NSValue *val = [[NSValue alloc] init];
            val = [NSValue valueWithPoint:consider];
            [points addObject:val];
           
            current = consider;
            backtrackOffset = NSMakePoint(backtrackPosition.x - current.x, backtrackPosition.y - current.y);
            
            for ( int i = 0; i < 8; i++ )
            {
                if ( CGPointEqualToPoint(backtrackOffset, offsets[i]) )
                {
                    next = i; //(i + 1) < 8 ? (i + 1) : 0;
                    break;
                }
            }
            consider = NSMakePoint(current.x + offsets[next].x, current.y + offsets[next].y);
        } else {
            backtrackPosition = consider;
            next++;
            if ( next == 8 ) next = 0;
            consider = NSMakePoint(current.x + offsets[next].x, current.y + offsets[next].y);
        }
    }
    
    NSOrderedSet* set = [NSOrderedSet orderedSetWithArray:points];
    NSArray* distinctPoints = [set array];
    
    return distinctPoints;
}



@end

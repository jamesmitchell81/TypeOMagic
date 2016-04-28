//
//  PixelTrace.h
//  ImageCropUI
//
//  Created by James Mitchell on 13/04/2016.
//  Copyright © 2016 James Mitchell. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PixelTrace : NSObject

- (void) tracePixelsOfImage:(NSImage*)image;
- (NSArray*) mooreNeighborContorTraceOfImage:(NSImage*)image;

@end

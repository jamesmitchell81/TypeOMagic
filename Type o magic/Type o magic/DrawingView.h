//
//  DrawingView.h
//  ImageCropUI
//
//  Created by James Mitchell on 14/04/2016.
//  Copyright © 2016 James Mitchell. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DrawingView : NSView
{
    NSArray* drawingData;
}

@property (nonatomic) NSArray* drawingData;

- (void) setDrawingData:(NSArray*)data;

@end

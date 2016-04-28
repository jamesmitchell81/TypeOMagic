//
//  DropZoneView.h
//  ImageCropUI
//
//  Created by James Mitchell on 26/01/2016.
//  Copyright © 2016 James Mitchell. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MainWindowController.h"

@interface DropZoneView : NSView <NSDraggingDestination>
{
    NSImage* image;
}

@property (nonatomic, strong) NSImage* image;

@property (assign) BOOL successDisplay;
@property (assign) BOOL defaultDisplay;
@property (assign) BOOL errorDisplay;

//- (NSString*) name;

@end

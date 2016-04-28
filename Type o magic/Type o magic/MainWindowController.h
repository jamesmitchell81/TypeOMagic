//
//  JMWindowController.h
//  ImageCropUI
//
//  Created by James Mitchell on 22/01/2016.
//  Copyright © 2016 James Mitchell. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DropZoneView;
@class ImageCropView;
@class ImageManipulationView;
@class ToolWindowController;
@class ImageRepresentation;

@interface MainWindowController : NSWindowController
{
    ImageRepresentation* representation;
    IBOutlet NSView* containerView;
    ToolWindowController* toolWindowController;
}

@property (nonatomic) ImageRepresentation* representation;
@property (nonatomic) DropZoneView* dropZoneView;
@property (nonatomic) ImageManipulationView* imgManipView;
@property (nonatomic) ImageCropView* imageCropView;
@property (nonatomic) NSScrollView* scrollView;

- (NSRect) determineViewBounds;
- (void) changeToDropZoneController;
- (void) handleDroppedImage;
- (void) imageFromDropZone;
- (void) displayToolWindow;
- (void) setImageManipulationView;
- (void) setCropView;

@end


// DropZoneView
// ImageCropView
// ImageRepresentation
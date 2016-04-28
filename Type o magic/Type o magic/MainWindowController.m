//
//  JMWindowController.m
//  ImageCropUI
//
//  Created by James Mitchell on 22/01/2016.
//  Copyright © 2016 James Mitchell. All rights reserved.
//

#import "MainWindowController.h"
#import "DropZoneView.h"
#import "ImageCropView.h"
#import "ImageManipulationView.h"
#import "ToolWindowController.h"
#import "ImageRepresentation.h"
#import "PixelTrace.h"

@implementation MainWindowController

@synthesize representation;
@synthesize dropZoneView;
@synthesize imgManipView;
@synthesize imageCropView;
@synthesize scrollView;

- (void)awakeFromNib
{
    // REFERENCE: stackoverflow.com/questions/25250762/xcode-swift-window-without-title-bar-but-with-close-minimize-and-resize-but
    self.window.titleVisibility = NSWindowTitleHidden;
    self.window.titlebarAppearsTransparent = YES;
    self.window.styleMask |= NSFullSizeContentViewWindowMask;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeToDropZoneController)
                                                 name:@"ViewChangeDropZoneReciever"
                                               object:nil];
}

- (void) windowDidLoad
{
    [super windowDidLoad];
    [self changeToDropZoneController];
}

- (void) changeToDropZoneController
{
    NSArray* subviews = [containerView subviews];
    dropZoneView = [[DropZoneView alloc] initWithFrame:[containerView bounds]];
    
    if ( [subviews count] != 0 )
    {
        [containerView replaceSubview:[subviews objectAtIndex:0] with:dropZoneView];
    } else {
        [containerView addSubview:dropZoneView];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDroppedImage)
                                                 name:@"ImageUploadReciever"
                                               object:nil];
    
    [self.window setContentView:dropZoneView];
    [dropZoneView setNeedsDisplay:YES];
}

- (void) handleDroppedImage
{
    [self imageFromDropZone];
    [dropZoneView removeFromSuperview];
    [self setImageManipulationView];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ImageUploadReciever" object:nil];
}

- (void) updateImage
{
    [imgManipView setImage:representation.subject];
    [imgManipView setNeedsDisplay:YES];
}

- (void) imageFromDropZone
{
    representation = [[ImageRepresentation alloc] init];
    [representation setSubject:[dropZoneView image]];
    [representation setOriginal:[dropZoneView image]];
    [representation setCurrent:[dropZoneView image]];
}


- (void) displayToolWindow
{
    if ( !toolWindowController )
    {
        toolWindowController = [[ToolWindowController alloc] initWithWindowNibName:@"ToolView"];
        [toolWindowController showWindow:nil];
    }

    [toolWindowController setRepresentation:representation];
}

- (void) setImageManipulationView
{
    NSRect viewBounds = [self determineViewBounds];
    imgManipView = [[ImageManipulationView alloc] initWithFrame:viewBounds];
    [imgManipView setImage:representation.subject];
    [imgManipView setNeedsDisplay:YES];
    
    // add the new view.
    scrollView = [[NSScrollView alloc] initWithFrame:viewBounds];
    [scrollView setHasVerticalScroller:YES];
    [scrollView setHasHorizontalScroller:YES];
    [scrollView setDocumentView:imgManipView];
    
    [containerView setBounds:viewBounds];
    [containerView addSubview:scrollView];
    [self.window setContentView:scrollView];
    
    NSRect frame = [self.window frame];
    frame.size = viewBounds.size;
    [self.window setFrame:frame display:YES animate:NO];
   
    [self displayToolWindow];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateImage)
                                                 name:@"ImageUpdateReciever"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setCropView)
                                                 name:@"CropImageToolSelection"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setImageManipulationView)
                                                 name:@"ResetOriginalImage"
                                               object:nil];
}

- (void) setCropView
{
    NSRect viewBounds = [self determineViewBounds];
    
    [imgManipView removeFromSuperview];

    imageCropView = [[ImageCropView alloc] initWithFrame:viewBounds];
    [imageCropView setImage:representation.subject];

    scrollView = [[NSScrollView alloc] initWithFrame:viewBounds];
    [scrollView setHasVerticalScroller:YES];
    [scrollView setHasHorizontalScroller:YES];
    
    [scrollView setDocumentView:imageCropView];
    [containerView addSubview:scrollView];
    [self.window setContentView:scrollView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(imageFromCrop)
                                                 name:@"ImageCropComplete"
                                               object:nil];
    
    [[NSApp mainWindow] makeKeyWindow];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CropImageToolSelection" object:nil];
}

- (void) imageFromCrop
{
    [representation setSubject:[imageCropView croppedImage]];
    [representation setCurrent:[imageCropView croppedImage]];
    [imageCropView removeFromSuperview];
    
    [self setImageManipulationView];
}

/*
 * Where the image is larger then the container window
 * set the destination view to be the size of the image.
 */
- (NSRect) determineViewBounds
{
    NSRect viewBounds;
    int viewWidth;
    int viewHeight;
    
    int maxWidth = 1000;
    int maxHeight = 1000;
    
    if ( maxHeight < representation.subject.size.height )
    {
        viewHeight = maxHeight;
    } else {
        viewHeight = representation.subject.size.height;
    }
    
    if ( maxWidth < representation.subject.size.width )
    {
        viewWidth = maxWidth;
    } else {
        viewWidth = representation.subject.size.width;
    }
    
    viewBounds = NSMakeRect(0, 0, viewWidth, viewHeight);
    
    return viewBounds;
}

@end

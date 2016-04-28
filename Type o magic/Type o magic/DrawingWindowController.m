//
//  TracedWindowController.m
//  ImageCropUI
//
//  Created by James Mitchell on 14/04/2016.
//  Copyright © 2016 James Mitchell. All rights reserved.
//

#import "DrawingWindowController.h"
#import "DrawingView.h"

@implementation DrawingWindowController

@synthesize drawingData;
@synthesize drawingView;
@synthesize scrollView;

- (void)windowDidLoad {
    [super windowDidLoad];
    
//    drawingView = [[DrawingView alloc] initWithFrame:[self.window frame]];
//    [[self.window contentView] addSubview:drawingView];
//    [drawingView setNeedsDisplay:YES];
    
    if ( drawingData )
    {
        [drawingView setDrawingData:drawingData];
    }
}

- (void)awakeFromNib
{
//     REFERENCE: stackoverflow.com/questions/25250762/xcode-swift-window-without-title-bar-but-with-close-minimize-and-resize-but
    self.window.titleVisibility = NSWindowTitleHidden;
    self.window.titlebarAppearsTransparent = YES;
    self.window.styleMask |= NSFullSizeContentViewWindowMask;
    
    NSRect viewBounds = self.window.frame;
    
    drawingView = [[DrawingView alloc] initWithFrame:viewBounds];
    [drawingView setNeedsDisplay:YES];
    
    // add the new view.
    scrollView = [[NSScrollView alloc] initWithFrame:viewBounds];
    [scrollView setHasVerticalScroller:YES];
    [scrollView setHasHorizontalScroller:YES];
    [scrollView setDocumentView:drawingView];
    
    [containerView setBounds:viewBounds];
    [containerView addSubview:scrollView];
    [self.window setContentView:scrollView];
}

@end

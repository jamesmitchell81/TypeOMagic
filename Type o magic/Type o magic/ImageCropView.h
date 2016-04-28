//
//  ImageCropView.h
//  ImageCropUI
//
//  Created by James Mitchell on 26/01/2016.
//  Copyright © 2016 James Mitchell. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ImageCropView : NSImageView
{
    NSPoint start;
    NSPoint current;
    BOOL cropHasStarted;
    NSImage* _croppedImage;
}

@property (nonatomic, strong) NSImage* croppedImage;

@end

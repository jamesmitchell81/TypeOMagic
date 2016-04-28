//
//  AppDelegate.m
//  ImageCropUI
//
//  Created by James Mitchell on 21/01/2016.
//  Copyright © 2016 James Mitchell. All rights reserved.
//

#import "AppDelegate.h"
#import "MainWindowController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void) applicationWillFinishLaunching:(NSNotification *)notification
{
    mainWindowController = [[MainWindowController alloc] initWithWindowNibName:@"MainWindow"];
    [mainWindowController showWindow:self];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

- (IBAction) newDropZone:(id)sender
{
    [mainWindowController changeToDropZoneController];
}

- (IBAction) showToolWindow:(id)sender
{
    [mainWindowController displayToolWindow];
}

@end

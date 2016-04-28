//
//  ToolViewController.m
//  ImageCropUI
//
//  Created by James Mitchell on 08/04/2016.
//  Copyright © 2016 James Mitchell. All rights reserved.
//

#import "ToolWindowController.h"
#import "DrawingWindowController.h"
#import "ImageProcessing.h"
#import "ImageAnalysis.h"
#import "ImageRepresentation.h"
#import "Morphology.h"
#import "ZhangSuenThin.h"
#import "PixelTrace.h"
#import "IntArrayUtil.h"

@implementation ToolWindowController

@synthesize representation;

- (IBAction) applyAveragingFilter:(id)sender
{
    int filterSize = [sender intValue];
    
    if ( filterSize != 0 )
    {
        if ( !imageProcessing )
        {
            imageProcessing = [[ImageProcessing alloc] init];
        }
        
        // set other filters to 1
        [medianFilterSlider setIntValue:1];
        [maxFilterSlider setIntValue:1];
        [minFilterSlider setIntValue:1];
        
        // reset the filter.
        representation.filtered = nil;
        
        // apply the filter to the origianal image.
        NSImageRep* rep = [representation.subject.representations objectAtIndex:0];
        [representation.subject removeRepresentation:rep];
        [representation.subject addRepresentation:[imageProcessing simpleAveragingFilterOfSize:filterSize
                                                                                       onImage:representation.current]];
    } else {
        [representation setSubject:representation.current];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ImageUpdateReciever" object:self];
}

- (IBAction) applyMedianFilter:(id)sender
{
    int filterSize = [sender intValue];
    
    if ( filterSize != 1 )
    {
        if ( !imageProcessing )
        {
            imageProcessing = [[ImageProcessing alloc] init];
        }
        
        // set other filters to 1
        [aveFilterSlider setIntValue:1];
        [maxFilterSlider setIntValue:1];
        [minFilterSlider setIntValue:1];
        
        // reset the filter.
        representation.filtered = nil;
        
        NSImageRep* rep = [representation.subject.representations objectAtIndex:0];
        [representation.subject removeRepresentation:rep];
        [representation.subject addRepresentation:[imageProcessing medianFilterOfSize:filterSize
                                                                              onImage:representation.current]];
    } else {
        [representation setSubject:representation.current];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ImageUpdateReciever"
                                                        object:self];
}

- (IBAction) applyMaxFilter:(id)sender
{
    int filterSize = [sender intValue];
    
    if ( filterSize != 1 )
    {
        if ( !imageProcessing )
        {
            imageProcessing = [[ImageProcessing alloc] init];
        }
        
        // set other filters to 1
        [aveFilterSlider setIntValue:1];
        [medianFilterSlider setIntValue:1];
        [minFilterSlider setIntValue:1];
        
        // reset the filter.
        representation.filtered = nil;
        
        NSImageRep* rep = [representation.subject.representations objectAtIndex:0];
        [representation.subject removeRepresentation:rep];
        [representation.subject addRepresentation:[imageProcessing maxFilterOfSize:filterSize
                                                                           onImage:representation.current]];
    } else {
        [representation setSubject:representation.current];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ImageUpdateReciever"
                                                        object:self];
}

- (IBAction) applyMinFilter:(id)sender
{
    int filterSize = [sender intValue];
    
    if ( filterSize != 1 )
    {
        if ( !imageProcessing )
        {
            imageProcessing = [[ImageProcessing alloc] init];
        }
        
        // set other filters to 1
        [aveFilterSlider setIntValue:1];
        [medianFilterSlider setIntValue:1];
        [maxFilterSlider setIntValue:1];
        
        // reset the filter.
        representation.filtered = nil;
        
        NSImageRep* rep = [representation.subject.representations objectAtIndex:0];
        [representation.subject removeRepresentation:rep];
        [representation.subject addRepresentation:[imageProcessing minFilterOfSize:filterSize
                                                                           onImage:representation.current]];
    } else {
        [representation setSubject:representation.current];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:@"ImageUpdateReciever"
                                                        object:self];
}

- (IBAction) threshold:(id)sender
{
    int thresholdValue = [sender intValue];
    
    if ( !imageProcessing)
    {
        imageProcessing = [[ImageProcessing alloc] init];
    }
    
    if ( !representation.filtered )
    {
        NSImageRep* rep = [representation.subject.representations objectAtIndex:0];
        representation.filtered = [ImageRepresentation cacheImageFromRepresentation:(NSBitmapImageRep*)rep];
    }
    
    NSBitmapImageRep* newRep = [imageProcessing threshold:representation.filtered atValue:thresholdValue];
    NSImageRep* oldRep = [representation.subject.representations objectAtIndex:0];
    [representation.subject removeRepresentation:oldRep];
    [representation.subject addRepresentation:newRep];
    [representation setCurrent:representation.subject];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"ImageUpdateReciever" object:self];
}

- (IBAction) erode:(id)sender
{
    int size = [sender intValue];
    
    if ( size != 1 ) {
        
        if ( !morph )
        {
            morph = [[Morphology alloc] init];
        }
        
//        representation.filtered = nil;
        
        NSBitmapImageRep* newRep = [morph simpleErosionOfImage:representation.current withNeighbourhoodSize:size];
        NSImageRep* rep = [representation.subject.representations objectAtIndex:0];
        [representation.subject removeRepresentation:rep];
        [representation.subject addRepresentation:newRep];
    } else {
        [representation setSubject:representation.current];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ImageUpdateReciever" object:self];
}

- (IBAction) dilate:(id)sender
{
    int size = [sender intValue];
    
    if ( size != 1 ) {
        
        if ( !morph )
        {
            morph = [[Morphology alloc] init];
        }
        
        NSBitmapImageRep* newRep = [morph simpleDilationOfImage:representation.current withNeighbourhoodSize:size];
        NSImageRep* rep = [representation.subject.representations objectAtIndex:0];
        [representation.subject removeRepresentation:rep];
        [representation.subject addRepresentation:newRep];
    } else {
        [representation setSubject:representation.current];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ImageUpdateReciever" object:self];
}

- (IBAction) open:(id)sender
{
    int size = [sender intValue];
    
    if ( size != 1 ) {
        
        if ( !morph )
        {
            morph = [[Morphology alloc] init];
        }
        
        NSBitmapImageRep* newRep = [morph openingOnImage:representation.current withNeighbourhoodSize:size];
        NSImageRep* rep = [representation.subject.representations objectAtIndex:0];
        [representation.subject removeRepresentation:rep];
        [representation.subject addRepresentation:newRep];
    } else {
        [representation setSubject:representation.current];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ImageUpdateReciever"
                                                        object:self];
}


- (IBAction) close:(id)sender
{
    int size = [sender intValue];
    
    if ( size != 1 ) {
        
        if ( !morph )
        {
            morph = [[Morphology alloc] init];
        }
        
        NSBitmapImageRep* newRep = [morph closingOnImage:representation.current
                                   withNeighbourhoodSize:size];
        NSImageRep* rep = [representation.subject.representations objectAtIndex:0];
        [representation.subject removeRepresentation:rep];
        [representation.subject addRepresentation:newRep];
    } else {
        [representation setSubject:representation.current];
    }
    
    NSLog(@"%d", size);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ImageUpdateReciever"
                                                        object:self];
}

- (IBAction) switchPolarity:(id)sender
{
    
}

- (IBAction) thin:(id)sender
{
    ZhangSuenThin* zst = [[ZhangSuenThin alloc] init];
    
    NSBitmapImageRep* newRep = [zst thinImage:representation.subject];
    NSImageRep* rep = [representation.subject.representations objectAtIndex:0];
    [representation.subject removeRepresentation:rep];
    [representation.subject addRepresentation:newRep];
    
    [representation setCurrent:representation.subject];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ImageUpdateReciever"
                                                        object:self];
}

- (IBAction) crop:(id)sender
{
    representation.filtered = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CropImageToolSelection"
                                                        object:self];
}

- (IBAction) resetImage:(id)sender
{
    [aveFilterSlider setIntValue:1];
    [medianFilterSlider setIntValue:1];
    [maxFilterSlider setIntValue:1];
    [minFilterSlider setIntValue:1];
    
    [thresholdSlider setIntValue:128];
    
    [erodeFilterSlider setIntValue:1];
    [dilateFilterSlider setIntValue:1];
    [openFilterSlider setIntValue:1];
    [closeFilterSlider setIntValue:1];
    
    // cropped bit.
    
    [self resetToOriginal];
}

- (IBAction) pinCurrent:(id)sender
{
    [representation setCurrent:representation.subject];
}

- (void) resetToOriginal
{
    [representation resetSubject];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ResetOriginalImage" object:self];
}

- (IBAction) trace:(id)sender
{
    PixelTrace* tracer = [[PixelTrace alloc] init];
    NSArray* tracedPoints = [tracer mooreNeighborContorTraceOfImage:representation.subject];
    
    // line simplification here
    
    dwc = [[DrawingWindowController alloc] initWithWindowNibName:@"DrawingWindow"];
    [dwc setDrawingData:tracedPoints];
    [dwc showWindow:nil];
}

- (IBAction) lineDensityHistorgram:(id)sender
{
    if ( !imageProcessing )
    {
        imageProcessing = [[ImageProcessing alloc] init];
    }
    
    if ( !imageAnalysis )
    {
        imageAnalysis = [[ImageAnalysis alloc] init];
    }
    
    int height = representation.subject.size.height;
    int* areaDensity = [imageAnalysis pixelAreaDensityOfImage:representation.subject];
    int maxDensity = [IntArrayUtil maxFromArray:areaDensity ofSize:height];

    NSBitmapImageRep* areaDensityHistogramRep = [imageAnalysis histogramRepresentationOfData:areaDensity
                                                                                   withWidth:maxDensity
                                                                                   andHeight:height];
    
    [ImageRepresentation saveImageFileFromRepresentation:areaDensityHistogramRep
                                                fileName:@"area"];
}

- (IBAction) greylevelHistogram:(id)sender
{
    
    if ( !imageProcessing )
    {
        imageProcessing = [[ImageProcessing alloc] init];
    }
    
    if ( !imageAnalysis )
    {
        imageAnalysis = [[ImageAnalysis alloc] init];
    }
    
    int* contrast = [imageProcessing contrastHistogramOfImage:representation.subject];
    contrast = [imageProcessing normaliseConstrastHistogramData:contrast ofSize:256];
    int maxValue = [IntArrayUtil maxFromArray:contrast ofSize:256];
    
    NSBitmapImageRep* contrastHistogram = [imageAnalysis histogramRepresentationOfData:contrast
                                                                                   withWidth:maxValue
                                                                                   andHeight:256];
    
    [ImageRepresentation saveImageFileFromRepresentation:contrastHistogram fileName:@"contrast"];
}


@end

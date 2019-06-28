//
//  DBLengendViewBuilder.m
//  DBLineChart
//
//  Created by bob on 2019/6/28.
//

#import "DBLengendViewBuilder.h"
#import "NSString+CoreText.h"
#import "DBPlot.h"

@implementation DBLengendViewBuilder

- (instancetype)init {
    self = [super init];
    if (self) {
        self.textAndPointGap = 5.0;
        self.plotGap = 10.0;
        self.circleUnitWidth = 50;
        self.plotHeight = 30.0;
        self.squareWidth = 10.0;
    }
    
    return self;
}

- (CTLineRef)lineWithTitle:(NSString *)title size:(CGSize *)size {
    CFAttributedStringRef plotTitleString = [title createCFStringWithFont:self.legendFont color:self.legendFontColor];
    CTFramesetterRef frameLabel = CTFramesetterCreateWithAttributedString(plotTitleString);
    CGSize textLabelSize = CTFramesetterSuggestFrameSizeWithConstraints(frameLabel,
                                                                        CFRangeMake(0,CFAttributedStringGetLength(plotTitleString)),
                                                                        NULL,
                                                                        CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX),
                                                                        NULL);
    CTLineRef line = CTLineCreateWithAttributedString(plotTitleString);
    CFRelease(frameLabel);
    CFRelease(plotTitleString);
    if (size) {
        *size = textLabelSize;
    }

    return line;
}

#pragma mark - view

- (UIView *)buildLengendView  {
    CGFloat widthUnit = self.style == DBLengendViewStyleCirclePointWithLine ? self.circleUnitWidth : self.squareWidth ;
    CGFloat heightUnit = self.plotHeight;

    NSUInteger plotCount = self.plots.count;
    NSUInteger index = 0;
    NSUInteger lineCount = self.row;
    NSUInteger columnCount = ceil(1.0 * plotCount/lineCount);
    CTLineRef *textLines = malloc(sizeof(CTLineRef) * plotCount);
    CGFloat maxTextWidth = 0;
    CGFloat maxTextHeight = 0;

    CGSize textLabelSize = CGSizeZero;
    for (DBPlot *plot in self.plots) {
        textLines[index++] = [self lineWithTitle:plot.plotTitle size:&textLabelSize];
        maxTextWidth = MAX(textLabelSize.width, maxTextWidth);
        maxTextHeight = MAX(textLabelSize.height, maxTextHeight);
    }
    // keep gap
    maxTextWidth += (self.plotGap + self.textAndPointGap);
    heightUnit = MAX(heightUnit, maxTextHeight + self.plotGap);
    CGFloat textTop = heightUnit/2 - self.legendFont.pointSize/2 + 1;

    CGFloat columnWidth = widthUnit + maxTextWidth;
    CGSize aSize = CGSizeMake(columnWidth * columnCount, lineCount * heightUnit);
    UIGraphicsBeginImageContextWithOptions(aSize, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGAffineTransform flip = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, aSize.height);
    CGContextConcatCTM(context, flip);
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);

    CGFloat squareTop = (heightUnit - widthUnit)/2;

    for (index = 0; index< plotCount; index++) {
        DBPlot *plot = self.plots[index];
        CGFloat plotX = columnWidth * (index % columnCount);
        CGFloat plotY = heightUnit * (lineCount - 1 - floor(1.0 * index/columnCount));

        if (self.style == DBLengendViewStyleCirclePointWithLine) {
            [plot.lineColor set];
            CGContextSetLineWidth(context, plot.lineWidth);
            CGContextMoveToPoint(context, plotX, plotY + heightUnit/2);
            CGContextAddLineToPoint(context, plotX + widthUnit, plotY + heightUnit/2);
            CGContextStrokePath(context);

            CGFloat pointRadius = plot.pointRadius;
            [plot.pointColor set];
            CGContextFillEllipseInRect(context, CGRectMake(plotX + widthUnit/2 - pointRadius/2, plotY + heightUnit/2 - pointRadius/2, pointRadius, pointRadius));
            CGContextStrokePath(context);
        } else  if (self.style == DBLengendViewStyleSquareWithoutLine) {
            [plot.lineColor set];
            CGContextFillRect(context, CGRectMake(plotX, plotY + squareTop, widthUnit, widthUnit));
        }

        CTLineRef line = textLines[index];
        CGContextSetTextPosition(context, plotX + widthUnit + self.textAndPointGap, plotY + textTop);
        CTLineDraw(line, context);
        CFRelease(line);
    }

    free(textLines);
    UIImage *squareImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    UIImageView *squareImageView = [[UIImageView alloc] initWithImage:squareImage];
    [squareImageView setFrame:CGRectMake(0, 0, aSize.width, aSize.height)];

    return squareImageView;
}

@end

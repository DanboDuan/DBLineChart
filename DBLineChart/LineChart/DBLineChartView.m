//
//  DBLineChart.m
//  DBLineChart
//
//  Created by bob on 2019/3/21.
//

#import "DBLineChartView.h"
#import "NSString+CoreText.h"
#import "DBPlot+Calculate.h"
#import "DBLegendViewBuilder.h"

@interface DBLineChartView ()

@property (nonatomic, strong) NSMutableArray<DBPlot *> *internalPlots;
@property (nonatomic, assign) NSInteger xAxisCount;

@end

@implementation DBLineChartView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildDefaultValues];
    }
    return self;
}

- (void)buildDefaultValues {
    self.backgroundColor = [UIColor whiteColor];
    self.axisColor = [UIColor blackColor];
    self.axisLineWidth = 1.0f;
    self.axisMarginBottom = 1.0f;
    self.axisMarginLeft = 1.0f;
    self.axisMarginTop = 20.0f;
    self.axisMarginRight = 20.0f;

    self.legendFont = [UIFont systemFontOfSize:12.0];
    self.legendFontColor = [UIColor blackColor];
    self.legendStyle = DBLegendViewStyleCirclePointWithLine;
    
    self.xAxisLabelFont = [UIFont systemFontOfSize:12.0];
    self.xAxisLabelColor = [UIColor blackColor];

    self.yAxisLabelFont = [UIFont systemFontOfSize:12.0];
    self.yAxisLabelColor = [UIColor blackColor];
    self.yAxisLabelFormat = @"%.1f";
    self.yMin = 0.0f;
    self.yMax = 0.0f;
    self.yAxisValuesCastToInt = NO;

    self.showXGridLine = YES;
    self.showYGridLine = YES;
    self.yGridLineCount = 5;
    self.xGridLineCount = 1;
    self.xGridLineColor = [UIColor blackColor];
    self.yGridLineColor = [UIColor blackColor];
    self.xGridLineWidth = 1.0f;
    self.yGridLineWidth = 1.0f;

    self.internalPlots = [NSMutableArray array];
}

- (CGFloat)axisMarginTop {
    return MAX(_axisMarginTop, 20.0f);
}

- (CGFloat)axisMarginRight {
    return MAX(_axisMarginRight, 20.0f);
}

- (NSInteger)xGridLineCount {
    return MAX(_xGridLineCount, 1);
}

- (NSInteger)yGridLineCount {
    return MAX(_yGridLineCount, 1);
}

#pragma mark - public

- (void)addPlot:(DBPlot *)plot {
    [self.internalPlots addObject:plot];
}

- (void)setPlots:(NSArray<DBPlot *> *)plots {
    [self.internalPlots removeAllObjects];
    [self.internalPlots addObjectsFromArray:plots];
}

- (NSArray<DBPlot *> *)plots {
    return [self.internalPlots copy];
}

- (void)drawLineChart {
    [self setNeedsDisplay];
    //    [self setNeedsLayout];
    //    [self layoutIfNeeded];
}

#pragma mark - draw plots

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    CGFloat height = self.bounds.size.height;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGAffineTransform flip = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, height);
    CGContextConcatCTM(context, flip);
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);

    if (self.internalPlots.count) {
        [self drawAxisWithContext:context];
        [self drawPlotWithContext:context];
    }

    CGContextRestoreGState(context);
}

//

- (void)drawPlotWithContext:(CGContextRef)context {
    // coordinate
    CGFloat axisYZero = self.axisMarginBottom;
    CGFloat axisXZero = self.axisMarginLeft;
    CGFloat axisY = self.bounds.size.height - self.axisMarginTop;
    CGFloat axisX = self.bounds.size.width - self.axisMarginRight;
    CGFloat axisYLength = axisY - axisYZero;
    CGFloat axisXLength = axisX - axisXZero;
    CGFloat minY = self.yMin;
    CGFloat maxY = self.yMax;

    CGFloat xAxisStep = axisXLength/(self.xAxisCount - 1);
    for (DBPlot *plot in self.internalPlots) {
        if (!plot.plotValues.count) continue;

        NSUInteger plotIndex = 0;
        CGFloat yValueStart = plot.plotValues.firstObject.doubleValue;
        CGFloat yValueStartPosition = axisYLength * (yValueStart - minY)/(maxY - minY) + axisYZero;
        CGFloat xValueStartPosition = axisXZero + plotIndex * xAxisStep;


        CGPoint *xyPoint = malloc(sizeof(CGPoint) * plot.plotValues.count);
        [plot.lineColor set];
        CGContextSetLineWidth(context, plot.lineWidth);
        CGContextMoveToPoint(context, xValueStartPosition, yValueStartPosition);
        for (NSNumber *plotValue in plot.plotValues) {
            CGFloat yValue = plotValue.doubleValue;
            CGFloat yValuePosition = axisYLength * (yValue - minY)/(maxY - minY) + axisYZero;
            CGFloat xValuePosition = axisXZero + plotIndex * xAxisStep;
            CGContextAddLineToPoint(context, xValuePosition, yValuePosition);
            xyPoint[plotIndex] = CGPointMake(xValuePosition, yValuePosition);
            plotIndex++;
        }
        CGContextStrokePath(context);

        if (plot.showCirclePoint) {
            CGFloat pointRadius = plot.pointRadius;
            [plot.pointColor set];
            for (NSUInteger index = 0; index< plotIndex; index++) {
                CGPoint point = xyPoint[index];
                CGContextFillEllipseInRect(context, CGRectMake(point.x - pointRadius/2, point.y - pointRadius/2, pointRadius, pointRadius));
            }
            CGContextStrokePath(context);
        }

        if(plot.showPointLabel) {
            CGFloat pointFontSize = plot.pointLabelFont.pointSize;
            CGPoint lastPoint = xyPoint[0];
            for (NSUInteger index = 0; index< plotIndex; index++) {
                CGPoint point = xyPoint[index];
                CGFloat yValue = plot.plotValues[index].doubleValue;
                CFAttributedStringRef yValuString = [[NSString stringWithFormat:plot.pointLabelFormat, yValue] createCFStringWithFont:plot.pointLabelFont color:plot.pointLabelColor];
                CTLineRef line = CTLineCreateWithAttributedString(yValuString);

                CGFloat pointLabelY = point.y;
                CGFloat pointLabelX = point.x;
                if (pointLabelY > lastPoint.y) {
                    pointLabelY += pointFontSize/2;
                    pointLabelX -= pointFontSize/2;
                } else {
                    pointLabelY -= pointFontSize/2;
                    pointLabelX += pointFontSize/2;
                }
                if (pointLabelY < axisYZero) {
                    pointLabelY = axisYZero + pointFontSize/2;
                }

                CGContextSetTextPosition(context, pointLabelX, pointLabelY);
                CTLineDraw(line, context);
                CFRelease(line);
                CFRelease(yValuString);

                lastPoint = point;
            }

        }

        free(xyPoint);
    }

}

// draw Axis
- (void)drawAxisWithContext:(CGContextRef)context {
    [self calculateAxisLabelSize];
    // draw x and y Axis
    CGFloat axisYZero = self.axisMarginBottom;
    CGFloat axisXZero = self.axisMarginLeft;
    CGFloat axisMarginTop = self.axisMarginTop;
    CGFloat axisMarginRight = self.axisMarginRight;

    CGFloat axisY = self.bounds.size.height - axisMarginTop;
    CGFloat axisX = self.bounds.size.width - axisMarginRight;
    CGFloat axisYLength = axisY - axisYZero;
    CGFloat axisXLength = axisX - axisXZero;


    [self.axisColor set];
    CGContextSetLineWidth(context, self.axisLineWidth);
    // y Axis
    CGContextMoveToPoint(context, axisXZero, axisY + axisMarginTop/2);
    CGContextAddLineToPoint(context, axisXZero, axisYZero);
    // x Axis
    CGContextAddLineToPoint(context, axisX + axisMarginRight/2, axisYZero);

    // y arrow
    CGContextMoveToPoint(context, axisXZero - 3, axisY + axisMarginTop/2 - 6);
    CGContextAddLineToPoint(context, axisXZero, axisY + axisMarginTop/2);
    CGContextAddLineToPoint(context, axisXZero + 3, axisY + axisMarginTop/2 - 6);
    //  x arrow
    CGContextMoveToPoint(context, axisX + axisMarginRight/2 - 6, axisYZero - 3);
    CGContextAddLineToPoint(context, axisX + axisMarginRight/2, axisYZero);
    CGContextAddLineToPoint(context, axisX + axisMarginRight/2 - 6, axisYZero + 3);


    CGContextStrokePath(context);

    CGFloat dash[] = {6, 5};
    // draw y Grid Line
    CGFloat yGridLineStep = axisYLength/self.yGridLineCount;
    [self.yGridLineColor set];
    CGContextSetLineWidth(context, self.yGridLineWidth);
    // dash and cap
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineDash(context, 0.0, dash, 2);
    for (CGFloat yGridLineY = axisYZero + yGridLineStep; yGridLineY < axisY + 1; yGridLineY +=yGridLineStep) {
        CGContextMoveToPoint(context, axisXZero, yGridLineY);
        CGContextAddLineToPoint(context, axisX, yGridLineY);
    }
    CGContextStrokePath(context);

    // draw x Grid Line
    CGFloat xGridLineStep = axisXLength/self.xGridLineCount;
    [self.xGridLineColor set];
    CGContextSetLineWidth(context, self.xGridLineWidth);

    for (CGFloat xGridLineX = axisXZero + xGridLineStep; xGridLineX < axisX + 1; xGridLineX +=xGridLineStep) {
        CGContextMoveToPoint(context, xGridLineX, axisYZero);
        CGContextAddLineToPoint(context, xGridLineX, axisY);
    }
    CGContextStrokePath(context);

    // cancel dash
    CGContextSetLineDash(context, 0, dash, 0);

    // draw y label
    [self.yAxisLabelColor set];
    CGFloat minY = self.yMin;
    CGFloat maxY = self.yMax;
    for (NSNumber *yAxisValue in self.yAxisValues) {
        CGFloat yValue = yAxisValue.doubleValue;
        if (yValue < minY || yValue > maxY) continue;

        CGFloat yValuePosition = axisYLength * (yValue - minY)/(maxY - minY) + axisYZero;
        CFAttributedStringRef yValuString = [[NSString stringWithFormat:self.yAxisLabelFormat, yValue] createCFStringWithFont:self.yAxisLabelFont color:self.yAxisLabelColor];
        CTLineRef line = CTLineCreateWithAttributedString(yValuString);
        CGContextSetTextPosition(context, ceil(axisXZero * 0.3), yValuePosition);
        CTLineDraw(line, context);
        CFRelease(line);
        CFRelease(yValuString);
    }

    // draw x label
    NSUInteger xAxisIndex = 0;
    NSUInteger xAxisLabelCount = 0;
    for (NSString *label in self.xAxisLabels) {
        if (label.length > 0) {
            xAxisLabelCount++;
        }
    }
    NSCAssert(xAxisLabelCount > 1, @"xAxisLabels should be at least two not empty");
    CGFloat xAxisLabelStep = axisXLength/(self.xAxisLabels.count - 1);
    CGFloat widthConstraint = axisXLength/(xAxisLabelCount -1);
    [self.xAxisLabelColor set];
    for (NSString *xAxisLabel in self.xAxisLabels) {
        if (xAxisLabel.length > 0) {
            CFAttributedStringRef xValueString = [xAxisLabel createCFStringWithFont:self.xAxisLabelFont color:self.xAxisLabelColor];
            CTFramesetterRef xValueFramesetter = CTFramesetterCreateWithAttributedString(xValueString);
            CGSize xAxisLabelSize = CTFramesetterSuggestFrameSizeWithConstraints(xValueFramesetter,
                                                                                 CFRangeMake(0,CFAttributedStringGetLength(xValueString)),
                                                                                 NULL,
                                                                                 CGSizeMake(widthConstraint, CGFLOAT_MAX),
                                                                                 NULL);
            CGFloat xValuePosition = axisXZero + xAxisLabelStep * xAxisIndex - xAxisLabelSize.width/2;
            CGMutablePathRef xValuePath = CGPathCreateMutable();
            CGPathAddRect(xValuePath, NULL, CGRectMake(xValuePosition, 0, xAxisLabelSize.width, axisYZero * 0.8));

            CTFrameRef xValueFrame = CTFramesetterCreateFrame(xValueFramesetter, CFRangeMake(0, CFAttributedStringGetLength(xValueString)), xValuePath, NULL);
            CTFrameDraw(xValueFrame, context);
            CFRelease(xValueFrame);
            CFRelease(xValueFramesetter);
            CFRelease(xValuePath);
            CFRelease(xValueString);
        }
        xAxisIndex++;
    }
}

// calculate axisMarginBottomHeight and axisMarginLeft
- (void)calculateAxisLabelSize {
    // y Axis Label size
    CGFloat max = self.internalPlots.firstObject.maxPlotValue;
    CGFloat min = self.internalPlots.firstObject.minPlotValue;
    for (DBPlot *plot in self.internalPlots) {
        max = MAX(plot.maxPlotValue, max);
        min = MIN(plot.minPlotValue, min);
    }
    self.yMax = max;
    self.yMin = min;

    NSString *yAxisLabel = [NSString stringWithFormat:self.yAxisLabelFormat, self.yMax];
    CFAttributedStringRef attrYAxisLabel = [yAxisLabel createCFStringWithFont:self.yAxisLabelFont color:self.yAxisLabelColor];
    CTFramesetterRef frameYAxisLabel = CTFramesetterCreateWithAttributedString(attrYAxisLabel);
    CGSize yAxisLabelSize = CTFramesetterSuggestFrameSizeWithConstraints(frameYAxisLabel,
                                                                         CFRangeMake(0,CFAttributedStringGetLength(attrYAxisLabel)),
                                                                         NULL,
                                                                         CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX),
                                                                         NULL);
    CFRelease(frameYAxisLabel);
    CFRelease(attrYAxisLabel);
    // multi 2 to make enough width
    self.axisMarginLeft = ceil(MAX(self.axisMarginLeft, yAxisLabelSize.width * 2));

    // set default y Axis Labels
    if (!self.yAxisValues.count) {
        NSMutableArray<NSNumber *>* yAxisValues = [NSMutableArray array];
        CGFloat startY = self.yMin;
        CGFloat stepY = (self.yMax - self.yMin)/self.yGridLineCount;
        if (self.yAxisValuesCastToInt) {
            startY = floor(startY);
            stepY = ceil(stepY);
        }
        do {
            [yAxisValues addObject:@(startY)];
            startY += stepY;
        } while (startY <= self.yMax);
        self.yAxisValues = yAxisValues;
    }

    // set default x Axis Labels
    NSInteger count = 0;
    for (DBPlot *plot in self.internalPlots) {
        count = MAX(plot.plotValues.count, count);
    }
    self.xAxisCount = count;
    if (!self.xAxisLabels.count) {
        NSMutableArray<NSString *> *xAxisLabels = [NSMutableArray array];
        for (NSInteger index = 0; index < count; index++ ) {
            [xAxisLabels addObject:@(index).stringValue];
        }
        self.xAxisLabels = xAxisLabels;
    }

    // x Axis Label size
    // might be empty for some x label
    NSString *xAxisLabel = nil;
    NSUInteger xAxisLabelCount = 0;
    for (NSString *label in self.xAxisLabels) {
        if (label.length > 0) {
            xAxisLabelCount++;
        }
        if (label.length > xAxisLabel.length) {
            xAxisLabel = label;
        }
    }
    CFAttributedStringRef attrXAxisLabel = [xAxisLabel createCFStringWithFont:self.xAxisLabelFont color:self.xAxisLabelColor];
    CTFramesetterRef frameXAxisLabel = CTFramesetterCreateWithAttributedString(attrXAxisLabel);
    CGFloat widthConstraint = (self.bounds.size.width - self.axisMarginRight - self.axisMarginLeft)/xAxisLabelCount;
    CGSize xAxisLabelSize = CTFramesetterSuggestFrameSizeWithConstraints(frameXAxisLabel,
                                                                         CFRangeMake(0,CFAttributedStringGetLength(attrXAxisLabel)),
                                                                         NULL,
                                                                         CGSizeMake(widthConstraint, CGFLOAT_MAX),
                                                                         NULL);
    CFRelease(frameXAxisLabel);
    CFRelease(attrXAxisLabel);
    // multi 2 to make enough width
    self.axisMarginBottom = ceil(MAX(self.axisMarginBottom, xAxisLabelSize.height * 2));

    // set default x Grid Line Count value
    if (self.xGridLineCount == 1) {
        self.xGridLineCount = self.xAxisLabels.count - 1;
    }
}

- (UIView *)legendViewWithRowCount:(NSUInteger)row {
    DBLegendViewBuilder *builder = [DBLegendViewBuilder new];
    builder.row = row;
    builder.legendFontColor = self.legendFontColor;
    builder.legendFont = self.legendFont;
    builder.style = self.legendStyle;
    builder.plots = self.internalPlots;

    return [builder buildLegendView];
}

@end

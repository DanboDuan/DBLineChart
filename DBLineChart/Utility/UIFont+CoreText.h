//
//  UIFont+CoreText.h
//  DBLineChart
//
//  Created by bob on 2019/3/23.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (CoreText)

- (CTFontRef)createCTFont;

+ (CTFontRef)bundledFontNamed:(NSString *)name size:(CGFloat)size;

@end

NS_ASSUME_NONNULL_END

//
//  NSString+CoreText.m
//  DBLineChart
//
//  Created by bob on 2019/3/25.
//

#import "NSString+CoreText.h"
#import "UIFont+CoreText.h"

@implementation NSString (CoreText)

- (CFAttributedStringRef)createCFStringWithFont:(UIFont *)font color:(UIColor *)color {
    CFStringRef keys[] = { kCTFontAttributeName, kCTForegroundColorAttributeName};
    CTFontRef cFont = [font createCTFont];
    CFTypeRef values[] = { cFont, color.CGColor};

    CFDictionaryRef attributes = CFDictionaryCreate(kCFAllocatorDefault,
                                                    (const void**)&keys,
                                                    (const void**)&values,
                                                    sizeof(keys) / sizeof(keys[0]),
                                                    &kCFTypeDictionaryKeyCallBacks,
                                                    &kCFTypeDictionaryValueCallBacks);
    
    CFAttributedStringRef attrString = CFAttributedStringCreate(kCFAllocatorDefault, (__bridge CFStringRef)self, attributes);
    CFRelease(cFont);
    CFRelease(attributes);
    return attrString;
}

@end

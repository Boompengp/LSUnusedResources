//
//  StringUtils.m
//  LSUnusedResources
//
//  Created by lslin on 15/9/1.
//  Copyright (c) 2015年 lessfun.com. All rights reserved.
//

#import "StringUtils.h"

static NSString * const kSuffix2x = @"@2x";
static NSString * const kSuffix3x = @"@3x";

@implementation StringUtils

+ (NSString *)stringByRemoveResourceSuffix:(NSString *)str {
    NSString *suffix = [str pathExtension];
    return [self stringByRemoveResourceSuffix:str suffix:suffix];
}

+ (NSString *)stringByRemoveResourceSuffix:(NSString *)str suffix:(NSString *)suffix {
    NSString *keyName = str;
    
    if (suffix.length && [keyName hasSuffix:suffix]) {
        keyName = [keyName stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@".%@", suffix] withString:@""];
    }
    if ([keyName hasSuffix:kSuffix2x]) {
        keyName = [keyName stringByReplacingOccurrencesOfString:kSuffix2x withString:@""];
    } else if ([keyName hasSuffix:kSuffix3x]) {
        keyName = [keyName stringByReplacingOccurrencesOfString:kSuffix3x withString:@""];
    }
    return keyName;
}

+ (BOOL)isImageTypeWithName:(NSString *)name {
    static NSArray *imageSuffixs = nil;

    if (!imageSuffixs) {
        imageSuffixs = @[@"png", @"jpg", @"jpeg", @"gif", @"bmp", @"pdf"];
    }

    NSString *ext = [[name pathExtension] lowercaseString];
    if (ext.length && [imageSuffixs containsObject:ext]) {
        return YES;
    }
    return NO;
}

+ (NSString *)snakeCaseToCamelCase:(NSString *)input {
    if (!input || input.length == 0) {
        return input;
    }

    NSArray *components = [input componentsSeparatedByString:@"_"];
    if (components.count == 0) {
        return input;
    }

    NSMutableString *result = [NSMutableString string];

    // 处理所有部分
    for (NSInteger i = 0; i < components.count; i++) {
        NSString *part = components[i];
        if (part.length > 0) {
            // 处理数字和字母混合的情况（如 "1v1" -> "1V1"）
            NSMutableString *processedPart = [NSMutableString string];
            BOOL lastWasDigit = NO;

            for (NSInteger j = 0; j < part.length; j++) {
                unichar ch = [part characterAtIndex:j];
                BOOL isDigit = (ch >= '0' && ch <= '9');

                if (i == 0 && j == 0) {
                    // 第一个部分的首字母必须小写（ImageResource 规则）
                    [processedPart appendString:[[NSString stringWithFormat:@"%C", ch] lowercaseString]];
                } else if (j == 0 || lastWasDigit) {
                    // 其他部分的首字母或数字后的字母大写
                    [processedPart appendString:[[NSString stringWithFormat:@"%C", ch] uppercaseString]];
                } else {
                    // 保持原样（不改变大小写）
                    [processedPart appendFormat:@"%C", ch];
                }
                lastWasDigit = isDigit;
            }

            [result appendString:processedPart];
        }
    }
    return result;
}

+ (NSArray<NSString *> *)resourceNameVariants:(NSString *)resourceName {
    if (!resourceName || resourceName.length == 0) {
        return @[];
    }

    NSMutableArray *variants = [NSMutableArray array];

    // 1. 原始名称
    [variants addObject:resourceName];

    // 2. 驼峰名称
    NSString *camelName = [self snakeCaseToCamelCase:resourceName];
    if (![variants containsObject:camelName]) {
        [variants addObject:camelName];
    }

    // 3. 如果名称以 _image 结尾，生成去掉 _image 后缀的变体
    // 因为 ImageResource 会自动去掉 _image 后缀
    if ([resourceName hasSuffix:@"_image"]) {
        NSString *withoutImageSuffix = [resourceName substringToIndex:resourceName.length - 6]; // "_image" 长度为 6
        if (![variants containsObject:withoutImageSuffix]) {
            [variants addObject:withoutImageSuffix];
        }

        NSString *camelWithoutImageSuffix = [self snakeCaseToCamelCase:withoutImageSuffix];
        if (![variants containsObject:camelWithoutImageSuffix]) {
            [variants addObject:camelWithoutImageSuffix];
        }
    }

    return variants;
}

@end

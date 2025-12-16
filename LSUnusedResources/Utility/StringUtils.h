//
//  StringUtils.h
//  LSUnusedResources
//
//  Created by lslin on 15/9/1.
//  Copyright (c) 2015年 lessfun.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringUtils : NSObject

+ (NSString *)stringByRemoveResourceSuffix:(NSString *)str;

+ (NSString *)stringByRemoveResourceSuffix:(NSString *)str suffix:(NSString *)suffix;

+ (BOOL)isImageTypeWithName:(NSString *)name;

/**
 * 将 snake_case 字符串转换为 camelCase
 * 支持数字和字母混合的情况，如 "image_1v1_ic" -> "image1V1Ic"
 * @param input 输入的 snake_case 字符串
 * @return 转换后的 camelCase 字符串
 */
+ (NSString *)snakeCaseToCamelCase:(NSString *)input;

/**
 * 生成资源名称的所有可能变体（用于 ImageResource 匹配）
 * 包括：原始名称、驼峰名称、去掉 _image 后缀的名称等
 * @param resourceName 资源名称
 * @return 所有可能的变体数组
 */
+ (NSArray<NSString *> *)resourceNameVariants:(NSString *)resourceName;

@end

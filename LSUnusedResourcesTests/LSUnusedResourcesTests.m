//
//  LSUnusedResourcesTests.m
//  LSUnusedResourcesTests
//
//  Created by lslin on 15/8/31.
//  Copyright (c) 2015年 lessfun.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "StringUtils.h"

@interface LSUnusedResourcesTests : XCTestCase

@end

@implementation LSUnusedResourcesTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Snake Case to Camel Case Tests

- (void)testSnakeCaseToCamelCase_BasicConversion {
    // 测试基本的 snake_case 转 camelCase
    NSString *result = [StringUtils snakeCaseToCamelCase:@"icon_home"];
    XCTAssertEqualObjects(result, @"iconHome", @"基本 snake_case 转换失败");
}

- (void)testSnakeCaseToCamelCase_MultipleUnderscores {
    // 测试多个下划线
    NSString *result = [StringUtils snakeCaseToCamelCase:@"btn_normal_press"];
    XCTAssertEqualObjects(result, @"btnNormalPress", @"多个下划线转换失败");
}

- (void)testSnakeCaseToCamelCase_WithNumbers {
    // 测试数字和字母混合 - 这是主要的修复点
    NSString *result = [StringUtils snakeCaseToCamelCase:@"image_1v1_ic"];
    XCTAssertEqualObjects(result, @"image1V1Ic", @"数字字母混合转换失败：应该是 image1V1Ic");
}

- (void)testSnakeCaseToCamelCase_MultipleDigitLetterMix {
    // 测试多个数字字母混合
    NSString *result = [StringUtils snakeCaseToCamelCase:@"icon_2x2_grid"];
    XCTAssertEqualObjects(result, @"icon2X2Grid", @"多个数字字母混合转换失败");
}

- (void)testSnakeCaseToCamelCase_StartingWithNumber {
    // 测试以数字开头的部分
    NSString *result = [StringUtils snakeCaseToCamelCase:@"image_3d_view"];
    XCTAssertEqualObjects(result, @"image3DView", @"数字开头的部分转换失败");
}

- (void)testSnakeCaseToCamelCase_NoUnderscores {
    // 测试没有下划线的情况
    NSString *result = [StringUtils snakeCaseToCamelCase:@"image"];
    XCTAssertEqualObjects(result, @"image", @"无下划线字符串应保持不变");
}

- (void)testSnakeCaseToCamelCase_EmptyString {
    // 测试空字符串
    NSString *result = [StringUtils snakeCaseToCamelCase:@""];
    XCTAssertEqualObjects(result, @"", @"空字符串应返回空字符串");
}

- (void)testSnakeCaseToCamelCase_NilInput {
    // 测试 nil 输入
    NSString *result = [StringUtils snakeCaseToCamelCase:nil];
    XCTAssertNil(result, @"nil 输入应返回 nil");
}

- (void)testSnakeCaseToCamelCase_FirstLetterUppercase {
    // 测试首字母大写的情况 - 应该转换为小写
    NSString *result = [StringUtils snakeCaseToCamelCase:@"Pk_res_top1_icon"];
    XCTAssertEqualObjects(result, @"pkResTop1Icon", @"首字母大写应转换为小写：应该是 pkResTop1Icon");
}

- (void)testSnakeCaseToCamelCase_AllUppercase {
    // 测试全大写的情况（罕见场景，保持原样除了需要改变的位置）
    NSString *result = [StringUtils snakeCaseToCamelCase:@"ICON_HOME"];
    XCTAssertEqualObjects(result, @"iCONHOME", @"全大写：首字母小写，其他部分首字母大写，内部保持原样");
}

- (void)testSnakeCaseToCamelCase_MixedCase {
    // 测试混合大小写（保留原有的驼峰结构）
    NSString *result = [StringUtils snakeCaseToCamelCase:@"MyIcon_Home_Image"];
    XCTAssertEqualObjects(result, @"myIconHomeImage", @"混合大小写：保留原有驼峰结构");
}

- (void)testSnakeCaseToCamelCase_CamelCaseInParts {
    // 测试部分本身就是驼峰命名的情况 - 这是新发现的问题
    NSString *result = [StringUtils snakeCaseToCamelCase:@"goldenSlot_game_bg"];
    XCTAssertEqualObjects(result, @"goldenSlotGameBg", @"应保留 goldenSlot 中的大写 S");
}

- (void)testSnakeCaseToCamelCase_MultipleCamelParts {
    // 测试多个驼峰部分
    NSString *result = [StringUtils snakeCaseToCamelCase:@"userInfo_dataModel_viewController"];
    XCTAssertEqualObjects(result, @"userInfoDataModelViewController", @"应保留所有部分的内部大小写");
}

#pragma mark - Resource Name Variants Tests

- (void)testResourceNameVariants_BasicName {
    // 测试基本名称的变体生成
    NSArray *variants = [StringUtils resourceNameVariants:@"icon_home"];
    XCTAssertTrue([variants containsObject:@"icon_home"], @"应包含原始名称");
    XCTAssertTrue([variants containsObject:@"iconHome"], @"应包含驼峰名称");
}

- (void)testResourceNameVariants_WithImageSuffix {
    // 测试带 _image 后缀的名称 - 这是第二个主要修复点
    NSArray *variants = [StringUtils resourceNameVariants:@"icon_home_image"];

    // 应该包含以下变体：
    // 1. 原始名称: icon_home_image
    // 2. 驼峰名称: iconHomeImage
    // 3. 去掉 _image 后缀: icon_home
    // 4. 去掉 _image 后缀后的驼峰: iconHome

    XCTAssertTrue([variants containsObject:@"icon_home_image"], @"应包含原始名称");
    XCTAssertTrue([variants containsObject:@"iconHomeImage"], @"应包含驼峰名称");
    XCTAssertTrue([variants containsObject:@"icon_home"], @"应包含去掉 _image 后缀的名称");
    XCTAssertTrue([variants containsObject:@"iconHome"], @"应包含去掉 _image 后缀后的驼峰名称");
    XCTAssertEqual(variants.count, (NSUInteger)4, @"应该有4个变体");
}

- (void)testResourceNameVariants_WithImageSuffixAndNumbers {
    // 测试同时包含数字和 _image 后缀的复杂情况
    NSArray *variants = [StringUtils resourceNameVariants:@"image_1v1_ic_image"];

    // 应该包含：
    // 1. image_1v1_ic_image
    // 2. image1V1IcImage
    // 3. image_1v1_ic
    // 4. image1V1Ic

    XCTAssertTrue([variants containsObject:@"image_1v1_ic_image"], @"应包含原始名称");
    XCTAssertTrue([variants containsObject:@"image1V1IcImage"], @"应包含驼峰名称");
    XCTAssertTrue([variants containsObject:@"image_1v1_ic"], @"应包含去掉 _image 后缀的名称");
    XCTAssertTrue([variants containsObject:@"image1V1Ic"], @"应包含去掉 _image 后缀后的驼峰名称");
}

- (void)testResourceNameVariants_WithoutImageSuffix {
    // 测试不带 _image 后缀的名称
    NSArray *variants = [StringUtils resourceNameVariants:@"image_1v1_ic"];

    // 应该只有2个变体：
    // 1. image_1v1_ic
    // 2. image1V1Ic

    XCTAssertTrue([variants containsObject:@"image_1v1_ic"], @"应包含原始名称");
    XCTAssertTrue([variants containsObject:@"image1V1Ic"], @"应包含驼峰名称");
    XCTAssertEqual(variants.count, (NSUInteger)2, @"应该有2个变体");
}

- (void)testResourceNameVariants_EmptyString {
    // 测试空字符串
    NSArray *variants = [StringUtils resourceNameVariants:@""];
    XCTAssertEqual(variants.count, (NSUInteger)0, @"空字符串应返回空数组");
}

- (void)testResourceNameVariants_NilInput {
    // 测试 nil 输入
    NSArray *variants = [StringUtils resourceNameVariants:nil];
    XCTAssertEqual(variants.count, (NSUInteger)0, @"nil 输入应返回空数组");
}

#pragma mark - Resource Pattern Regex Tests

- (void)testResourcePatternRegex_ObjCImageNamed {
    // 测试 Objective-C 的 imageNamed: 模式
    NSString *pattern = @"imageNamed:@\"(.*?)\"";
    NSString *content = @"UIImage *image = [UIImage imageNamed:@\"icon_home\"];";

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSArray *matches = [regex matchesInString:content options:0 range:NSMakeRange(0, content.length)];

    XCTAssertEqual(matches.count, (NSUInteger)1, @"应该匹配到1个 imageNamed:");
    if (matches.count > 0) {
        NSTextCheckingResult *match = matches[0];
        NSString *captured = [content substringWithRange:[match rangeAtIndex:1]];
        XCTAssertEqualObjects(captured, @"icon_home", @"应该捕获到 icon_home");
    }
}

- (void)testResourcePatternRegex_XIBImageName {
    // 测试 XIB/Storyboard 的 <image name="xxx"> 模式
    NSString *pattern = @"<image[^>]*?\\sname=\"([^\"]+)\"";
    NSString *content = @"<image key=\"image\" name=\"icon_home\"/>";

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSArray *matches = [regex matchesInString:content options:0 range:NSMakeRange(0, content.length)];

    XCTAssertEqual(matches.count, (NSUInteger)1, @"应该匹配到1个 image 元素的 name 属性");
    if (matches.count > 0) {
        NSTextCheckingResult *match = matches[0];
        NSString *captured = [content substringWithRange:[match rangeAtIndex:1]];
        XCTAssertEqualObjects(captured, @"icon_home", @"应该捕获到 icon_home");
    }
}

- (void)testResourcePatternRegex_StoryboardImageName {
    // 测试 Storyboard 的另一种格式
    NSString *pattern = @"image(?:Name)?=\"([^\"]+)\"";
    NSString *content = @"<imageView imageName=\"background_image\" />";

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSArray *matches = [regex matchesInString:content options:0 range:NSMakeRange(0, content.length)];

    XCTAssertGreaterThan(matches.count, (NSUInteger)0, @"应该匹配到 imageName");
    BOOL foundBackground = NO;
    for (NSTextCheckingResult *match in matches) {
        NSString *captured = [content substringWithRange:[match rangeAtIndex:1]];
        if ([captured isEqualToString:@"background_image"]) {
            foundBackground = YES;
            break;
        }
    }
    XCTAssertTrue(foundBackground, @"应该捕获到 background_image");
}

- (void)testResourcePatternRegex_SwiftImageResource {
    // 测试 Swift 的 ImageResource 属性访问
    NSString *pattern = @"\\.(\\w+)";
    NSString *content = @"imageView.image = UIImage(resource: .iconHome)";

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSArray *matches = [regex matchesInString:content options:0 range:NSMakeRange(0, content.length)];

    XCTAssertGreaterThan(matches.count, (NSUInteger)0, @"应该匹配到点语法");
    BOOL foundIconHome = NO;
    for (NSTextCheckingResult *match in matches) {
        NSString *captured = [content substringWithRange:[match rangeAtIndex:1]];
        if ([captured isEqualToString:@"iconHome"]) {
            foundIconHome = YES;
            break;
        }
    }
    XCTAssertTrue(foundIconHome, @"应该捕获到 iconHome");
}

- (void)testResourcePatternRegex_XIBNormalImage {
    // 测试 XIB 中的 normalImage 属性
    NSString *pattern = @"(?:normal|selected|highlighted|background)?[iI]mage(?:Name)?=\"([^\"]+)\"";
    NSString *content = @"<button normalImage=\"btn_normal\" />";

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSArray *matches = [regex matchesInString:content options:0 range:NSMakeRange(0, content.length)];

    XCTAssertGreaterThan(matches.count, (NSUInteger)0, @"应该匹配到 normalImage");
    BOOL found = NO;
    for (NSTextCheckingResult *match in matches) {
        if (match.numberOfRanges > 1) {
            NSString *captured = [content substringWithRange:[match rangeAtIndex:1]];
            if ([captured isEqualToString:@"btn_normal"]) {
                found = YES;
                break;
            }
        }
    }
    XCTAssertTrue(found, @"应该捕获到 btn_normal");
}

- (void)testResourcePatternRegex_XIBSelectedImage {
    // 测试 XIB 中的 selectedImage 属性
    NSString *pattern = @"(?:normal|selected|highlighted|background)?[iI]mage(?:Name)?=\"([^\"]+)\"";
    NSString *content = @"<button selectedImage=\"btn_selected\" />";

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSArray *matches = [regex matchesInString:content options:0 range:NSMakeRange(0, content.length)];

    XCTAssertGreaterThan(matches.count, (NSUInteger)0, @"应该匹配到 selectedImage");
    BOOL found = NO;
    for (NSTextCheckingResult *match in matches) {
        if (match.numberOfRanges > 1) {
            NSString *captured = [content substringWithRange:[match rangeAtIndex:1]];
            if ([captured isEqualToString:@"btn_selected"]) {
                found = YES;
                break;
            }
        }
    }
    XCTAssertTrue(found, @"应该捕获到 btn_selected");
}

- (void)testResourcePatternRegex_XIBBackgroundImage {
    // 测试 XIB 中的 backgroundImage 属性
    NSString *pattern = @"(?:normal|selected|highlighted|background)?[iI]mage(?:Name)?=\"([^\"]+)\"";
    NSString *content = @"<view backgroundImage=\"bg_pattern\" />";

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSArray *matches = [regex matchesInString:content options:0 range:NSMakeRange(0, content.length)];

    XCTAssertGreaterThan(matches.count, (NSUInteger)0, @"应该匹配到 backgroundImage");
    BOOL found = NO;
    for (NSTextCheckingResult *match in matches) {
        if (match.numberOfRanges > 1) {
            NSString *captured = [content substringWithRange:[match rangeAtIndex:1]];
            if ([captured isEqualToString:@"bg_pattern"]) {
                found = YES;
                break;
            }
        }
    }
    XCTAssertTrue(found, @"应该捕获到 bg_pattern");
}

- (void)testResourcePatternRegex_XIBMultipleImages {
    // 测试 XIB 中同时包含多个图片引用
    NSString *pattern = @"(?:normal|selected|highlighted|background)?[iI]mage(?:Name)?=\"([^\"]+)\"";
    NSString *content = @"<button normalImage=\"btn_normal\" selectedImage=\"btn_selected\" highlightedImage=\"btn_highlighted\" />";

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSArray *matches = [regex matchesInString:content options:0 range:NSMakeRange(0, content.length)];

    XCTAssertEqual(matches.count, (NSUInteger)3, @"应该匹配到3个图片引用");

    NSMutableSet *captured = [NSMutableSet set];
    for (NSTextCheckingResult *match in matches) {
        if (match.numberOfRanges > 1) {
            NSString *value = [content substringWithRange:[match rangeAtIndex:1]];
            [captured addObject:value];
        }
    }

    XCTAssertTrue([captured containsObject:@"btn_normal"], @"应该包含 btn_normal");
    XCTAssertTrue([captured containsObject:@"btn_selected"], @"应该包含 btn_selected");
    XCTAssertTrue([captured containsObject:@"btn_highlighted"], @"应该包含 btn_highlighted");
}

- (void)testResourcePatternRegex_XIBImageElementWithAttributes {
    // 测试 XIB 中 image 元素包含多个属性的情况
    NSString *pattern = @"<image[^>]*?\\sname=\"([^\"]+)\"";
    NSString *content = @"<image name=\"app_icon\" width=\"60\" height=\"60\" />";

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSArray *matches = [regex matchesInString:content options:0 range:NSMakeRange(0, content.length)];

    XCTAssertEqual(matches.count, (NSUInteger)1, @"应该匹配到1个 image 元素");
    if (matches.count > 0) {
        NSTextCheckingResult *match = matches[0];
        NSString *captured = [content substringWithRange:[match rangeAtIndex:1]];
        XCTAssertEqualObjects(captured, @"app_icon", @"应该捕获到 app_icon");
    }
}

- (void)testResourcePatternRegex_XIBCamelCaseImageName {
    // 测试 XIB 中使用驼峰命名的图片（ImageResource 格式）
    NSString *pattern = @"<image[^>]*?\\sname=\"([^\"]+)\"";
    NSString *content = @"<image name=\"iconHome\" />";

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSArray *matches = [regex matchesInString:content options:0 range:NSMakeRange(0, content.length)];

    XCTAssertEqual(matches.count, (NSUInteger)1, @"应该匹配到驼峰命名的图片");
    if (matches.count > 0) {
        NSTextCheckingResult *match = matches[0];
        NSString *captured = [content substringWithRange:[match rangeAtIndex:1]];
        XCTAssertEqualObjects(captured, @"iconHome", @"应该捕获到 iconHome");
    }
}

#pragma mark - Integration Tests

- (void)testIntegration_RealWorldScenario1 {
    // 场景1：ImageResource 会将 image_1v1_ic 转换为 .image1V1Ic
    NSArray *variants = [StringUtils resourceNameVariants:@"image_1v1_ic"];
    NSString *imageResourceName = @"image1V1Ic";

    XCTAssertTrue([variants containsObject:imageResourceName],
                  @"应该能匹配 ImageResource 生成的名称 .image1V1Ic");
}

- (void)testIntegration_RealWorldScenario2 {
    // 场景2：ImageResource 会将 icon_home_image 的 _image 后缀去掉，变为 .iconHome
    NSArray *variants = [StringUtils resourceNameVariants:@"icon_home_image"];
    NSString *imageResourceName = @"iconHome";

    XCTAssertTrue([variants containsObject:imageResourceName],
                  @"应该能匹配 ImageResource 去掉 _image 后缀后的名称 .iconHome");
}

- (void)testIntegration_RealWorldScenario3 {
    // 场景3：复杂情况 - image_2x3_grid_image
    NSArray *variants = [StringUtils resourceNameVariants:@"image_2x3_grid_image"];

    // ImageResource 去掉 _image 后缀，变为 .image2X3Grid
    NSString *imageResourceName = @"image2X3Grid";

    XCTAssertTrue([variants containsObject:imageResourceName],
                  @"应该能匹配复杂情况下的 ImageResource 名称");
}

- (void)testIntegration_RealWorldScenario4 {
    // 场景4：首字母大写的情况 - Pk_res_top1_icon
    NSArray *variants = [StringUtils resourceNameVariants:@"Pk_res_top1_icon"];

    // ImageResource 会转换为 .pkResTop1Icon（首字母转小写）
    NSString *imageResourceName = @"pkResTop1Icon";

    XCTAssertTrue([variants containsObject:imageResourceName],
                  @"应该能匹配首字母大写的 ImageResource 名称 .pkResTop1Icon");
}

- (void)testIntegration_RealWorldScenario5 {
    // 场景5：部分已经是驼峰命名 - goldenSlot_game_bg
    NSArray *variants = [StringUtils resourceNameVariants:@"goldenSlot_game_bg"];

    // ImageResource 会转换为 .goldenSlotGameBg（保留内部的驼峰结构）
    NSString *imageResourceName = @"goldenSlotGameBg";

    XCTAssertTrue([variants containsObject:imageResourceName],
                  @"应该能匹配保留驼峰结构的 ImageResource 名称 .goldenSlotGameBg");
}

#pragma mark - XIB Integration Tests

- (void)testXIBIntegration_SnakeCaseResourceInXIB {
    // 场景：XIB 中使用 snake_case 格式的资源名称，资源文件也是 snake_case
    // 这是最常见的情况
    NSArray *variants = [StringUtils resourceNameVariants:@"icon_home"];

    // XIB 中可能使用：<image name="icon_home" />
    XCTAssertTrue([variants containsObject:@"icon_home"], @"应该包含原始的 snake_case 名称");
    // 或者使用驼峰格式：<image name="iconHome" />
    XCTAssertTrue([variants containsObject:@"iconHome"], @"应该包含驼峰格式的名称");
}

- (void)testXIBIntegration_CamelCaseResourceInXIB {
    // 场景：XIB 中使用 camelCase 格式（ImageResource 生成），但资源文件是 snake_case
    // 资源文件：icon_home.png
    // XIB 中：<image name="iconHome" />（由 ImageResource 自动生成）
    NSArray *variants = [StringUtils resourceNameVariants:@"icon_home"];

    XCTAssertTrue([variants containsObject:@"iconHome"],
                  @"应该能匹配 XIB 中 ImageResource 生成的驼峰名称");
}

- (void)testXIBIntegration_ResourceWithImageSuffix {
    // 场景：资源文件有 _image 后缀，XIB 中使用去掉后缀的名称
    // 资源文件：icon_home_image.png
    // XIB 中：<image name="iconHome" />（ImageResource 会去掉 _image 后缀）
    NSArray *variants = [StringUtils resourceNameVariants:@"icon_home_image"];

    XCTAssertTrue([variants containsObject:@"iconHome"],
                  @"应该能匹配去掉 _image 后缀后的驼峰名称");
    XCTAssertTrue([variants containsObject:@"icon_home"],
                  @"应该能匹配去掉 _image 后缀的 snake_case 名称");
}

- (void)testXIBIntegration_ResourceWithNumbersInXIB {
    // 场景：资源名称包含数字，XIB 中使用驼峰格式
    // 资源文件：image_1v1_ic.png
    // XIB 中：<image name="image1V1Ic" />
    NSArray *variants = [StringUtils resourceNameVariants:@"image_1v1_ic"];

    XCTAssertTrue([variants containsObject:@"image1V1Ic"],
                  @"应该能匹配包含数字的驼峰名称");
}

- (void)testXIBIntegration_ButtonStates {
    // 场景：按钮的多个状态图片，XIB 中同时使用多个图片
    // 资源文件：btn_normal.png, btn_selected.png, btn_highlighted.png
    // XIB 中：<button normalImage="btnNormal" selectedImage="btnSelected" highlightedImage="btnHighlighted" />

    NSArray *normalVariants = [StringUtils resourceNameVariants:@"btn_normal"];
    NSArray *selectedVariants = [StringUtils resourceNameVariants:@"btn_selected"];
    NSArray *highlightedVariants = [StringUtils resourceNameVariants:@"btn_highlighted"];

    XCTAssertTrue([normalVariants containsObject:@"btnNormal"],
                  @"应该能匹配 normalImage 的驼峰名称");
    XCTAssertTrue([selectedVariants containsObject:@"btnSelected"],
                  @"应该能匹配 selectedImage 的驼峰名称");
    XCTAssertTrue([highlightedVariants containsObject:@"btnHighlighted"],
                  @"应该能匹配 highlightedImage 的驼峰名称");
}

- (void)testXIBIntegration_MixedCaseResource {
    // 场景：资源名称本身包含大写字母（驼峰）
    // 资源文件：goldenSlot_bg.png
    // XIB 中：<image name="goldenSlotBg" />
    NSArray *variants = [StringUtils resourceNameVariants:@"goldenSlot_bg"];

    XCTAssertTrue([variants containsObject:@"goldenSlotBg"],
                  @"应该能匹配保留原始驼峰结构的名称");
}

- (void)testXIBIntegration_FirstLetterUppercase {
    // 场景：资源名称首字母大写（不规范但存在的情况）
    // 资源文件：Pk_res_icon.png
    // XIB 中：<image name="pkResIcon" />（ImageResource 会将首字母转为小写）
    NSArray *variants = [StringUtils resourceNameVariants:@"Pk_res_icon"];

    XCTAssertTrue([variants containsObject:@"pkResIcon"],
                  @"应该能匹配首字母转小写后的驼峰名称");
}

@end

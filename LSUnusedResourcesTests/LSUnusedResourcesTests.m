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

@end

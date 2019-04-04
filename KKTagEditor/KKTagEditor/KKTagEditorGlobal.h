//
//  KKTagEditorGlobalConstant.h
//  PepsiTagEditor
//
//  Created by KingKong on 16/7/25.
//  Copyright © 2016年 KingKong. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSUInteger kCellTextPadding = 10;
static NSUInteger kCellHeight = 25;
static NSUInteger kCellSpace = 8;
static NSUInteger kLineSpace = 8;
static NSUInteger kLineTopMargin = 13;
static NSUInteger kLineButtomMargin = 13;
static NSUInteger kLineLeftRightMargin = 13;
static NSUInteger kSectionHeaderHeight = 25 + 13;  //暂未用到

/**
 *  标签库静态常量值，所有参数阀值为50
 */
@interface KKTagEditorGlobal : NSObject

//默认10
+ (NSUInteger)cellTextPadding;
+ (void)setCellTextPadding:(NSUInteger)temp;

//默认25
+ (NSUInteger)cellHeight;
+ (void)setCellHeight:(NSUInteger)temp;

//默认8
+ (NSUInteger)cellSpace;
+ (void)setCellSpace:(NSUInteger)temp;

//默认8
+ (NSUInteger)lineSpace;
+ (void)setLineSpace:(NSUInteger)temp;

//默认13
+ (NSUInteger)lineTopMargin;
+ (void)setLineTopMargin:(NSUInteger)temp;

//默认13
+ (NSUInteger)lineButtomMargin;
+ (void)setLineButtomMargin:(NSUInteger)temp;

//默认13
+ (NSUInteger)lineLeftRightMargin;
+ (void)setLineLeftRightMargin:(NSUInteger)temp;

//默认38
+ (NSUInteger)sectionHeaderHeight;
+ (void)setSectionHeaderHeight:(NSUInteger)temp;

@end

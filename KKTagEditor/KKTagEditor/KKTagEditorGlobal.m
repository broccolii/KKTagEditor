//
//  KKTagEditorGlobalConstant.m
//  PepsiTagEditor
//
//  Created by KingKong on 16/7/25.
//  Copyright © 2016年 KingKong. All rights reserved.
//

#import "KKTagEditorGlobal.h"

static NSUInteger kMaxValue = 50;  //阀值

@implementation KKTagEditorGlobal

+ (NSUInteger)cellTextPadding {
    return kCellTextPadding;
}
+ (void)setCellTextPadding:(NSUInteger)temp {
    if (temp > kMaxValue) {
        return;
    }
    kCellTextPadding = temp;
}

+ (NSUInteger)cellHeight {
    return kCellHeight;
}
+ (void)setCellHeight:(NSUInteger)temp {
    if (temp > kMaxValue) {
        return;
    }
    kCellHeight = temp;
}

+ (NSUInteger)cellSpace {
    return kCellSpace;
}
+ (void)setCellSpace:(NSUInteger)temp {
    if (temp > kMaxValue) {
        return;
    }
    kCellSpace = temp;
}

+ (NSUInteger)lineSpace {
    return kLineSpace;
}
+ (void)setLineSpace:(NSUInteger)temp {
    if (temp > kMaxValue) {
        return;
    }
    kLineSpace = temp;
}

+ (NSUInteger)lineTopMargin {
    return kLineTopMargin;
}
+ (void)setLineTopMargin:(NSUInteger)temp {
    if (temp > kMaxValue) {
        return;
    }
    kLineTopMargin = temp;
}

+ (NSUInteger)lineButtomMargin {
    return kLineButtomMargin;
}
+ (void)setLineButtomMargin:(NSUInteger)temp {
    if (temp > kMaxValue) {
        return;
    }
    kLineButtomMargin = temp;
}

+ (NSUInteger)lineLeftRightMargin {
    return kLineLeftRightMargin;
}
+ (void)setLineLeftRightMargin:(NSUInteger)temp {
    if (temp > kMaxValue) {
        return;
    }
    kLineLeftRightMargin = temp;
}

+ (NSUInteger)sectionHeaderHeight {
    return kSectionHeaderHeight;
}
+ (void)setSectionHeaderHeight:(NSUInteger)temp {
    if (temp > kMaxValue) {
        return;
    }
    kSectionHeaderHeight = temp;
}

@end

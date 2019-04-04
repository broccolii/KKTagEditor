//
//  KDCustomTagButtonCell.m
//  Koudaitong
//
//  Created by KingKong on 15/9/29.
//  Copyright © 2015年 qima. All rights reserved.
//

#import "KKTagNormalCell.h"
#import "KKTagEditorGlobal.h"

@interface KKTagNormalCell()
@property (nonatomic, weak) IBOutlet KKTagLabel *tagLbl;
@end

@implementation KKTagNormalCell

- (void)awakeFromNib {
    [self.tagLbl.layer setMasksToBounds:YES];
    [self.tagLbl.layer setBorderWidth:[self.cellColor.borderWidth floatValue]];
    [self.tagLbl.layer setCornerRadius:KKTagEditorGlobal.cellHeight * 1.0f / 2];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self changeColorWithSelected:selected];
}

#pragma mark - Public Method

- (void)setText:(NSString *)text {
    [self.tagLbl setText:text];
}

- (NSString *)getText {
    return self.tagLbl.text;
}

#pragma mark - Private Method

- (void)changeColorWithSelected:(BOOL)selected {
    if (!selected) {
        if (!CGColorEqualToColor(self.tagLbl.textColor.CGColor, self.cellColor.normalTextColor.CGColor)) {
            [self.tagLbl setTextColor:self.cellColor.normalTextColor];
        }
        if (!CGColorEqualToColor(self.tagLbl.backgroundColor.CGColor, self.cellColor.normalBackgroundColor.CGColor)) {
            [self.tagLbl setBackgroundColor:self.cellColor.normalBackgroundColor];
        }
        if (!CGColorEqualToColor(self.tagLbl.layer.borderColor, self.cellColor.normalBorderColor.CGColor)) {
            [self.tagLbl.layer setBorderColor:self.cellColor.normalBorderColor.CGColor];
        }
    } else {
        if (!CGColorEqualToColor(self.tagLbl.textColor.CGColor, self.cellColor.selectTextColor.CGColor)) {
            [self.tagLbl setTextColor:self.cellColor.selectTextColor];
        }
        if (!CGColorEqualToColor(self.tagLbl.backgroundColor.CGColor, self.cellColor.selectBackgroundColor.CGColor)) {
            [self.tagLbl setBackgroundColor:self.cellColor.selectBackgroundColor];
        }
        if (!CGColorEqualToColor(self.tagLbl.layer.borderColor, self.cellColor.selectBorderColor.CGColor)) {
            [self.tagLbl.layer setBorderColor:self.cellColor.selectBorderColor.CGColor];
        }
    }
}

#pragma mark - Getter And Setter

- (KKCellParam *)cellColor {
    if (!_cellColor) {
        _cellColor = [KKCellParam new];
    }
    return _cellColor;
}

@end

#import "KKTagEditorColor.h"

@implementation KKCellParam

- (UIColor *)normalBackgroundColor {
    if (!_normalBackgroundColor) {
        _normalBackgroundColor = [UIColor whiteColor];
    }
    return _normalBackgroundColor;
}

- (UIColor *)normalTextColor {
    if (!_normalTextColor) {
        _normalTextColor = KKTagEditorUIColorFromRGB(KKNormalCellRed);
    }
    return _normalTextColor;
}

- (UIColor *)normalBorderColor {
    if (!_normalBorderColor) {
        _normalBorderColor = KKTagEditorUIColorFromRGB(KKNormalCellRed);
    }
    return _normalBorderColor;
}

- (UIColor *)selectBackgroundColor {
    if (!_selectBackgroundColor) {
        _selectBackgroundColor = KKTagEditorUIColorFromRGB(KKNormalCellRed);
    }
    return _selectBackgroundColor;
}

- (UIColor *)selectTextColor {
    if (!_selectTextColor) {
        _selectTextColor = [UIColor whiteColor];
    }
    return _selectTextColor;
}

- (UIColor *)selectBorderColor {
    if (!_selectBorderColor) {
        _selectBorderColor = KKTagEditorUIColorFromRGB(KKNormalCellRed);
    }
    return _selectBorderColor;
}

- (NSNumber *)borderWidth {
    if (!_borderWidth) {
        _borderWidth = [NSNumber numberWithFloat:0.5f];
    }
    return _borderWidth;
}

@end

@implementation KKTagLabel

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = { 0, KKTagEditorGlobal.cellTextPadding, 0, KKTagEditorGlobal.cellTextPadding };
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end

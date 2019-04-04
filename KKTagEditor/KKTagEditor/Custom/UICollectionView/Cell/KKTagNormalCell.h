//
//  KDCustomTagButtonCell.h
//  Koudaitong
//
//  Created by KingKong on 15/9/29.
//  Copyright © 2015年 qima. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KKCellParam;
@interface KKTagNormalCell : UICollectionViewCell
/**
 *  颜色配置
 */
@property (strong, nonatomic) KKCellParam *cellColor;

- (void)setText:(NSString *)text;
- (NSString *)getText ;
@end

@interface KKCellParam : NSObject
@property (strong, nonatomic) UIColor *normalBackgroundColor;
@property (strong, nonatomic) UIColor *normalTextColor;
@property (strong, nonatomic) UIColor *normalBorderColor;
@property (strong, nonatomic) UIColor *selectBackgroundColor;
@property (strong, nonatomic) UIColor *selectTextColor;
@property (strong, nonatomic) UIColor *selectBorderColor;
@property (strong, nonatomic) NSNumber *borderWidth;
@end

@interface KKTagLabel : UILabel
@end

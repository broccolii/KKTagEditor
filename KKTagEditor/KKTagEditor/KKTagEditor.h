//
//  KKTagEditor.h
//  PepsiTagEditor
//
//  Created by KingKong on 16/7/13.
//  Copyright © 2016年 KingKong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKTagNormalCell.h"

@class KKTag,KKTagEditor;

@protocol KKTagEditorDelegate <NSObject>

@required
- (void)tagEditor:(KKTagEditor *)tagEditor didRemoveTag:(KKTag *)tag;
- (void)tagEditor:(KKTagEditor *)tagEditor didRemoveLastTag:(KKTag *)tag;
- (BOOL)tagEditor:(KKTagEditor *)tagEditor shouldAddTag:(KKTag *)tag;//能否添加
- (void)tagEditor:(KKTagEditor *)tagEditor didAddTag:(KKTag *)tag;
- (void)tagEditor:(KKTagEditor *)tagEditor didInputChanged:(NSString *)input;
- (void)tagEditor:(KKTagEditor *)tagEditor didHeightChanged:(CGFloat)height;

@optional
- (void)tagEditor:(KKTagEditor *)tagEditor failAddTag:(KKTag *)tag;

@end

@interface KKTagEditor : UIView

@property (weak, nonatomic) id<KKTagEditorDelegate> delegate;
/**
 *  标签数据源
 */
@property (strong, nonatomic) NSArray<NSString *> *tags;
/**
 *  标签长度限制，默认是30
 */
@property (assign, nonatomic) NSUInteger maxTagLenth;
/**
 *  标签视图的最大高度，默认是150
 */
@property (assign, nonatomic) CGFloat maxViewHeight;
/**
 *  操作标签数据源时，是否开启去重检查，默认是YES开启
 *  @remark 判断依据是标签名
 */
@property (assign, nonatomic) BOOL isDeduplication;
/**
 *  cell颜色配置，可自定义配置选中普通两种状态下的背景色、文本色、边框色，有默认值
 */
@property (strong, nonatomic) KKCellParam *nromalCellParams;
/**
 *  输入cell的边框颜色，默认是0xeeeeee
 */
@property (strong, nonatomic) UIColor *inputCellBorderColor;

- (BOOL)insertTag:(NSString *)tag atIndex:(NSUInteger)index;
- (BOOL)addTag:(NSString *)tag;
- (BOOL)replaceTagAtIndex:(NSUInteger)index withTag:(NSString *)tag;
- (BOOL)removeTag:(NSString *)tag; /**< 若标签名不去重，删除时会删除所有该名称的标签*/
- (BOOL)removeTagAtIndex:(NSUInteger)index;

- (void)hideKeyboard;
- (void)reloadData;
- (void)clearInputAndReload;

@end



@interface KKTag : NSObject

@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) NSUInteger index;

- (instancetype)initWithName:(NSString *)name index:(NSUInteger)index;

@end

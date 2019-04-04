//
//  KKTagFlowLayout.m
//  PepsiTagEditor
//
//  Created by KingKong on 16/7/14.
//  Copyright © 2016年 KingKong. All rights reserved.
//

#import "KKTagFlowLayout.h"
#import "KKTagEditorGlobal.h"

@interface KKTagFlowLayout()
@property (nonatomic, strong) NSMutableArray *itemWidthArray;
@property (nonatomic, strong) NSArray *itemFrameArray;
@end
@implementation KKTagFlowLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        _itemWidthArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark UICollectionViewFlowLayoutDelegate

- (void)prepareLayout {
    [super prepareLayout];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    [self.itemWidthArray removeAllObjects];
    for (int i = 0 ; i < count; i++) {
        CGFloat cellWidth = 0;
        if ([self.delegate respondsToSelector:@selector(collectionView:widthForItemAtIndexPath:)]) {
            cellWidth = [self.delegate collectionView:self.collectionView widthForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        }
        [self.itemWidthArray addObject:@(cellWidth)];
    }
    
    self.itemFrameArray = [self pCalculateAllItemFrame];
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.frame.size.width, [self pTotalHeight]);
}


- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [NSMutableArray array];
    // Cells
    for (NSInteger i = 0 ; i < [self.itemWidthArray count]; i++) {//可优化为每次只计算可视cell的属性
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    // Header
    if ([self.collectionView.dataSource respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        UICollectionViewLayoutAttributes *headerAttributes = [self layoutAttributesForSupplementaryViewOfKind:@"HeaderView" atIndexPath:indexPath];
        [attributes addObject:headerAttributes];
    }
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *cellAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    cellAttributes.frame = [self pFrameForItemWithIndexPath:indexPath];
    return cellAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
    if ([kind isEqualToString:@"HeaderView"]) {
        attributes.frame = CGRectMake(0, 0, self.collectionView.frame.size.width, KKTagEditorGlobal.sectionHeaderHeight);
    }
    return attributes;
}

#pragma mark - Private Method

- (NSArray *)pCalculateAllItemFrame {
    NSMutableArray *itemFrameArrayTemp = [NSMutableArray array];
    CGFloat totalWidth = self.collectionView.frame.size.width;
    [self.itemWidthArray enumerateObjectsUsingBlock:^(NSNumber *itemWidthNumber, NSUInteger idx, BOOL *stop) {
        CGFloat itemWidth = MIN([itemWidthNumber floatValue], totalWidth - KKTagEditorGlobal.lineLeftRightMargin * 2);
        CGRect frameTemp;
        if (idx == 0) {
            if ([self.collectionView.dataSource respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)]) {
                frameTemp = CGRectMake(KKTagEditorGlobal.lineLeftRightMargin,
                                       KKTagEditorGlobal.lineTopMargin + KKTagEditorGlobal.sectionHeaderHeight,
                                       itemWidth, KKTagEditorGlobal.cellHeight);  //
            } else {
                frameTemp = CGRectMake(KKTagEditorGlobal.lineLeftRightMargin, KKTagEditorGlobal.lineTopMargin,
                                       itemWidth, KKTagEditorGlobal.cellHeight);
            }
        } else {
            CGRect preItemFrame = [itemFrameArrayTemp[idx-1] CGRectValue];
            if (preItemFrame.origin.x + preItemFrame.size.width + KKTagEditorGlobal.cellSpace + itemWidth +
                KKTagEditorGlobal.lineLeftRightMargin <=
                totalWidth) {  //放得下
                frameTemp = CGRectMake(preItemFrame.origin.x + preItemFrame.size.width + KKTagEditorGlobal.cellSpace,
                                       preItemFrame.origin.y, itemWidth, KKTagEditorGlobal.cellHeight);
            } else { //另起一行
                frameTemp = CGRectMake(KKTagEditorGlobal.lineLeftRightMargin,
                                       preItemFrame.origin.y + preItemFrame.size.height + KKTagEditorGlobal.lineSpace,
                                       itemWidth, KKTagEditorGlobal.cellHeight);
            }
        }

        [itemFrameArrayTemp addObject:[NSValue valueWithCGRect:frameTemp]];
    }];
    return [itemFrameArrayTemp copy];
}


- (CGFloat)pTotalHeight {
    CGRect lastItemFrame = [[self.itemFrameArray lastObject] CGRectValue];
    return lastItemFrame.origin.y + lastItemFrame.size.height + KKTagEditorGlobal.lineButtomMargin;
}

- (CGRect)pFrameForItemWithIndexPath:(NSIndexPath *)indexPath {
    return [self.itemFrameArray[indexPath.row] CGRectValue];
}

#pragma mark - Getter And Setter

- (void)setItemFrameArray:(NSArray *)itemFrameArray {
    _itemFrameArray = itemFrameArray;
    if ([self.delegate respondsToSelector:@selector(collectionView:didHeightChangeTo:)]) {
        [self.delegate collectionView:self.collectionView didHeightChangeTo:[self pTotalHeight]];
    }
}

@end

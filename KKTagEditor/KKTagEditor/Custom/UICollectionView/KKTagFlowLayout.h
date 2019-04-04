//
//  KKTagFlowLayout.h
//  PepsiTagEditor
//
//  Created by KingKong on 16/7/14.
//  Copyright © 2016年 KingKong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KKTagFlowLayoutDelegate <NSObject>
@required
- (CGFloat)collectionView:(UICollectionView *)collectionView widthForItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView didHeightChangeTo:(CGFloat)newHeight;
@end

@interface KKTagFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, weak) id<KKTagFlowLayoutDelegate> delegate;
@end

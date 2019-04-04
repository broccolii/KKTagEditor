//
//  KKTagEditor.m
//  PepsiTagEditor
//
//  Created by KingKong on 16/7/13.
//  Copyright © 2016年 KingKong. All rights reserved.
//

#import "KKTagEditor.h"
#import "KKTagEditor.h"
#import "KKTagFlowLayout.h"
#import "KKTagInvisibleCell.h"
#import "KKTagTextField.h"
#import "KKTagEditorColor.h"
#import "KKTagEditorGlobal.h"

#ifdef DEBUG
#define KKTagLog(...) NSLog(__VA_ARGS__)
#else
#define KKTagLog(...)
#endif

static BOOL defaultIsDeduplication = YES;
static NSString *defaultInputTextFieldContent = @"输入标签";
static NSUInteger inputReserveWidth = 8;  //预留8px

@interface KKTagEditor () <KKTagFlowLayoutDelegate,UICollectionViewDataSource, UICollectionViewDelegate,KKTagTextFieldDelegate>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) KKTagTextField *inputTextField;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) NSMutableArray<NSString *> *dataSource;//tag
@end

@implementation KKTagEditor

#pragma mark - LifeCycle

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupDefaultValue];
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefaultValue];
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupDefaultValue];
        [self setupView];
    }
    return self;
}

#pragma mark - Public Method

- (BOOL)insertTag:(NSString *)tag atIndex:(NSUInteger)index {
    if (![self checkIfTagValid:tag]) {
        return NO;
    }
    @try {
        [self.dataSource insertObject:tag atIndex:index];
        [self reloadData];
    } @catch (NSException *exception) {
        KKTagLog(@"%s,%@", __FUNCTION__, exception);
        return NO;
    }

    return YES;
}

- (BOOL)addTag:(NSString *)tag {
    if (![self checkIfTagValid:tag]) {
        return NO;
    }
    @try {
        [self.dataSource addObject:tag];
        [self reloadData];
    } @catch (NSException *exception) {
        KKTagLog(@"%s,%@", __FUNCTION__, exception);
        return NO;
    }
    return YES;
}

- (BOOL)replaceTagAtIndex:(NSUInteger)index withTag:(NSString *)tag {
    if (![self checkIfTagValid:tag]) {
        return NO;
    }
    @try {
        [self.dataSource replaceObjectAtIndex:index withObject:tag];
        [self reloadData];
    } @catch (NSException *exception) {
        KKTagLog(@"%s,%@", __FUNCTION__, exception);
        return NO;
    }
    return YES;
}

- (BOOL)removeTag:(NSString *)tag{
    @try {
        if (![self.dataSource containsObject:tag]) {
            return NO;
        }
        [self.dataSource removeObject:tag];
        [self reloadData];
    } @catch (NSException *exception) {
        KKTagLog(@"%s,%@", __FUNCTION__, exception);
        return NO;
    }
    return YES;
}

- (BOOL)removeTagAtIndex:(NSUInteger)index {
    @try {
        [self.dataSource removeObjectAtIndex:index];
        [self reloadData];
    } @catch (NSException *exception) {
        KKTagLog(@"%s,%@", __FUNCTION__, exception);
        return NO;
    }
    return YES;
}

- (void)hideKeyboard {
    [self resignResponder];
}

- (void)reloadData {
    [self deselectCellAndHideMenu];
    [self.inputTextField setFrame:CGRectZero];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       [self.collectionView reloadData];
                   });
}

- (void)clearInputAndReload {
    [self.inputTextField setText:@""];
    [self reloadData];
}

#pragma mark - UICollectionView Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = self.dataSource.count+1;
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.dataSource.count) {
        KKTagInvisibleCell *cell = (KKTagInvisibleCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([KKTagInvisibleCell class]) forIndexPath:indexPath];
        [self.inputTextField setFrame:cell.frame];
        [self.inputTextField.layer setBorderColor:[self isStringEmpty:self.inputTextField.text]
                                                  ? [UIColor whiteColor].CGColor
                                                  : self.inputCellBorderColor.CGColor];
        return cell;
    } else {
        KKTagNormalCell *cell = (KKTagNormalCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([KKTagNormalCell class]) forIndexPath:indexPath];
        [cell setCellColor:self.nromalCellParams];
        [cell setSelected:[indexPath isEqual:self.selectedIndexPath]];
        [cell setText:self.dataSource[indexPath.row]];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (![indexPath isEqual:self.selectedIndexPath] && indexPath.row != self.dataSource.count) {//最后一个cell不能被选择
        [self deselectCellAndHideMenu];
        self.selectedIndexPath = indexPath;
        
        KKTagNormalCell *cell = (KKTagNormalCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [self becomeFirstResponder];
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        UIMenuItem *menuItem =
        [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteMenuItemAction:)];
        [menuController setMenuItems:@[menuItem]];
        [menuController setTargetRect:cell.frame inView:self.collectionView];
        [menuController setMenuVisible:YES animated:YES];
        
    } else {
        [self deselectCellAndHideMenu];
    }
}

#pragma mark - KKTagFlowLayout Delegate

- (CGFloat)collectionView:(UICollectionView *)collectionView widthForItemAtIndexPath:(NSIndexPath *)indexPath {//界面出来之前被调用
    if (indexPath.row == self.dataSource.count) {
        return [self invisibleCellWidth];
    } else {
        NSString *rightBtnText = self.dataSource[indexPath.row];
        return [self normalCellWidthWithText:rightBtnText] + KKTagEditorGlobal.cellTextPadding * 2;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didHeightChangeTo:(CGFloat)newHeight {
    CGRect oldFrame = self.collectionView.frame;
    CGRect tempFrame = oldFrame;
    CGFloat autualHeight = MIN(newHeight, self.maxViewHeight);
    if (tempFrame.size.height != autualHeight) {
        tempFrame.size.height = autualHeight;
        [self.collectionView setFrame:tempFrame];
        if ([self.delegate respondsToSelector:@selector(tagEditor:didHeightChanged:)]) {
            [self.delegate tagEditor:self didHeightChanged:autualHeight];
        }
    }
    
}

#pragma mark - UIMenuController

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if ([self respondsToSelector:action]) {
        return YES;
    }
    return NO;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark - KKTagTextField Delegate & Action

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self deselectCellAndHideMenu];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    [self deselectCellAndHideMenu];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self pFinishInputTag];
    return YES;
}

- (void)deleteWithEmptyContentInKKTagTextField:(UITextField *)textField {
    [self deleteWithEmptyContent];
}

- (void)textFieldDidEndChanging:(UITextField *)textField {
    // limit
    BOOL hasCut = [self cutInputWithTextField:textField];

    //
    [self reloadLastItemAndScrollToButtomIfNeed];

    //若截断过 不通知
    if (!hasCut && [self.delegate respondsToSelector:@selector(tagEditor:didInputChanged:)]) {
        [self.delegate tagEditor:self didInputChanged:textField.text];
    }
}

#pragma mark - Action

- (void)handleTapPressGesture:(UITapGestureRecognizer *)gestureRecognizer {
    [self pFinishInputTag];
}

- (void)deleteMenuItemAction:(id)sender {
    KKTag *tagModel = [[KKTag alloc] initWithName:self.dataSource[self.selectedIndexPath.row] index:self.selectedIndexPath.row];
    if (self.isDeduplication) {
        [self.dataSource removeObject:tagModel.name];
    } else {
        [self.dataSource removeObjectAtIndex:tagModel.index];
    }
    if ([self.delegate respondsToSelector:@selector(tagEditor:didRemoveTag:)]) {
        [self.delegate tagEditor:self didRemoveTag:tagModel];
    }
    
    self.selectedIndexPath = nil;
    [self.collectionView reloadData];
}

#pragma mark - Private Method

- (void)setupDefaultValue {
    _isDeduplication = defaultIsDeduplication;
}

- (void)setupView {
    [self addSubview:self.collectionView];
    
    //add gesture
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapPressGesture:)];
    [self.collectionView setBackgroundView:[[UIView alloc]initWithFrame:CGRectZero]];
    [self.collectionView.backgroundView setUserInteractionEnabled:YES];
    [self.collectionView.backgroundView addGestureRecognizer:tapGesture];
    
    [self.collectionView addSubview:self.inputTextField];
    
}

/**
 *  检查标签是否可用
 *
 *  @param tagName 标签名
 *
 *  @return
 */
- (BOOL)checkIfTagValid:(NSString *)tagName {
    if (self.isDeduplication && [self.dataSource containsObject:tagName]) {
        return NO;
    }
    if (tagName.length > self.maxTagLenth) {
        return NO;
    }
    return YES;
}

/**
 *  退出编辑模式
 */
- (void)resignResponder {
    [self.inputTextField resignFirstResponder];
}

/**
 *  取消选中当前cell
 */
- (void)deselectCellAndHideMenu {
    [self.collectionView deselectItemAtIndexPath:self.selectedIndexPath animated:NO];
    self.selectedIndexPath = nil;
    //
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setMenuVisible:NO animated:YES];
}

/**
 *  空内容时点击删除事件
 */
- (void)deleteWithEmptyContent {
    if (self.dataSource.count < 1) {
        return;
    }
    NSIndexPath *last = [NSIndexPath indexPathForItem:self.dataSource.count-1 inSection:0];
    KKTagNormalCell *cell = (KKTagNormalCell *)[self.collectionView cellForItemAtIndexPath:last];
    if (cell.isSelected) {
        [self deselectCellAndHideMenu];
        KKTag *tagModel = [[KKTag alloc] initWithName:self.dataSource.lastObject index:self.dataSource.count-1];
        [self.dataSource removeLastObject];
        if ([self.delegate respondsToSelector:@selector(tagEditor:didRemoveLastTag:)]) {
            [self.delegate tagEditor:self didRemoveLastTag:tagModel];
        }
        
        [self.collectionView reloadData];
        [self.inputTextField becomeFirstResponder];
        
    } else {
        self.selectedIndexPath = last;
        [self.collectionView selectItemAtIndexPath:last animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
}

- (void)pFinishInputTag {
    [self deselectCellAndHideMenu];
    [self resignResponder];

    if (self.inputTextField.text.length == 0) {
        return;
    }

    KKTag *tagModel =
    [[KKTag alloc] initWithName:self.inputTextField.text index:self.dataSource.count];

    BOOL canAdd = [self checkIfTagValid:tagModel.name];
    if (canAdd && [self.delegate respondsToSelector:@selector(tagEditor:shouldAddTag:)]) {
        canAdd = [self.delegate tagEditor:self shouldAddTag:tagModel];
    }
    if (canAdd) {
        [self.dataSource addObject:tagModel.name];
        if ([self.delegate respondsToSelector:@selector(tagEditor:didAddTag:)]) {
            [self.delegate tagEditor:self didAddTag:tagModel];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(tagEditor:failAddTag:)]) {
            [self.delegate tagEditor:self failAddTag:tagModel];
        }
    }

    [self clearInputAndReload];
}

/**
 *  输入框宽度
 *
 *  @return
 */
- (CGFloat)invisibleCellWidth {
    return MAX([self normalCellWidthWithText:self.inputTextField.text],
               [self normalCellWidthWithText:defaultInputTextFieldContent]) +
           KKTagEditorGlobal.cellTextPadding * 2 + inputReserveWidth;
}

/**
 *  普通cell宽度
 *
 *  @param text 内容
 *
 *  @return 宽
 */
- (CGFloat)normalCellWidthWithText:(NSString *)text {
    NSDictionary *attributest = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]};
    CGSize size = [text sizeWithAttributes:attributest];
    return ceil(size.width);
    
}

/**
 *  是否空字符串
 *
 *  @param string 字符串
 *
 *  @return
 */
- (BOOL)isStringEmpty:(NSString *)string {
    if (string && string.length != 0) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)cutInputWithTextField:(UITextField *)textField {
    BOOL isCut = NO;
    // lineBreakModel
    if (textField.text.length > self.maxTagLenth) {
        isCut = YES;
        // crash in iOS 7
        if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                textField.text = [textField.text substringToIndex:self.maxTagLenth];
            });
        } else {
            textField.text = [textField.text substringToIndex:self.maxTagLenth];
        }
        
    }

    CGFloat maxWidthSpace =
    self.frame.size.width - KKTagEditorGlobal.lineLeftRightMargin * 2 - KKTagEditorGlobal.cellTextPadding * 2;
    if ([self normalCellWidthWithText:textField.text] >= maxWidthSpace) {
        isCut = YES;
        NSString *text = textField.text;
        for (int i = 1; i < text.length; i++) {
            NSString *testString = [text substringToIndex:text.length - i];
            if ([self normalCellWidthWithText:testString] < maxWidthSpace) {
                // crash in iOS 7
                if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        textField.text = testString;
                    });
                } else {
                    textField.text = testString;
                }
                
                break;
            }
        }
    }
    return isCut;
}

- (void)reloadLastItemAndScrollToButtomIfNeed {
    // change frame
    [UIView animateWithDuration:0 animations:^{//no animation
        [self.collectionView performBatchUpdates:^{
            NSIndexPath *last = [NSIndexPath indexPathForItem:self.dataSource.count inSection:0];
            [self.collectionView reloadItemsAtIndexPaths:@[last]];
            
        } completion:^(BOOL finished){
            // if new line
            NSIndexPath *last = [NSIndexPath indexPathForItem:self.dataSource.count inSection:0];
            KKTagInvisibleCell *cell = (KKTagInvisibleCell *)[self.collectionView cellForItemAtIndexPath:last];
            if ((self.collectionView.contentOffset.y + self.collectionView.frame.size.height) < (cell.frame.origin.y + cell.frame.size.height)) {
                [self.collectionView scrollToItemAtIndexPath:last atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
            }
        }];
    }];
}


#pragma mark - Getter And Setter

- (NSMutableArray<NSString *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSArray<NSString *> *)tags {
    return [self.dataSource copy];
}

- (void)setTags:(NSArray<NSString *> *)tags {
    [self setDataSource:[NSMutableArray arrayWithArray:tags]];
}

- (NSUInteger)maxTagLenth {
    if (!_maxTagLenth ) {
        _maxTagLenth = 30;
    }
    return _maxTagLenth;
}

- (CGFloat)maxViewHeight {
    if (!_maxViewHeight) {
        _maxViewHeight = 150.0f;
    }
    return _maxViewHeight;
}

- (KKTagTextField *)inputTextField {
    if (!_inputTextField) {
        _inputTextField = [KKTagTextField new];
        [_inputTextField setPlaceholder:defaultInputTextFieldContent];
        [_inputTextField setFont:[UIFont systemFontOfSize:14.0f]];
        [_inputTextField.layer setCornerRadius:12.5f];
        [_inputTextField.layer setBorderWidth:0.5f];
        [_inputTextField.layer setBorderColor:[UIColor whiteColor].CGColor];
        [_inputTextField setReturnKeyType:UIReturnKeyDone];
        [_inputTextField setTagDelegate:self];
        [_inputTextField addTarget:self action:@selector(textFieldDidEndChanging:) forControlEvents:UIControlEventEditingChanged];
    }
    return _inputTextField;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        KKTagFlowLayout *flowLayout = [KKTagFlowLayout new];
        [flowLayout setDelegate:self];

        CGRect frame = self.frame;
        frame.origin.y = 0;
        frame.origin.x = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([KKTagInvisibleCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([KKTagInvisibleCell class])];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([KKTagNormalCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([KKTagNormalCell class])];
    }
    return _collectionView;
}

- (UIColor *)inputCellBorderColor {
    if (!_inputCellBorderColor) {
        _inputCellBorderColor = KKTagEditorUIColorFromRGB(KKLastCellBorderColor);
    }
    return _inputCellBorderColor;
}

@end


@implementation KKTag

- (instancetype)initWithName:(NSString *)name index:(NSUInteger)index {
    self = [super init];
    if (self) {
        _name = name;
        _index = index;
    }
    return self;
}

@end

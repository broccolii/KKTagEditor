//
//  KKTagEditorTextField.m
//  PepsiTagEditor
//
//  Created by KingKong on 16/7/13.
//  Copyright © 2016年 KingKong. All rights reserved.
//

#import "KKTagTextField.h"
#import "KKTagEditorGlobal.h"

@implementation KKTagTextField

#pragma mark - LifeCycle

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupEdge];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupEdge];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setupEdge];
    }
    return self;
}

- (BOOL)keyboardInputShouldDelete:(UITextField *)textField {
    BOOL isTextFieldEmpty = (self.text.length == 0);
    if (isTextFieldEmpty){
        if ([self.tagDelegate respondsToSelector:@selector(deleteWithEmptyContentInKKTagTextField:)]){
            [self.tagDelegate deleteWithEmptyContentInKKTagTextField:self];
        }
    }
    return YES;
}

#pragma mark - Private Method

- (void)setupEdge {
    UIView *spaceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KKTagEditorGlobal.cellTextPadding, 0)];

    [self setLeftViewMode:UITextFieldViewModeAlways];
    [self setLeftView:spaceView];
    
    [self setRightView:spaceView];
    [self setRightViewMode:UITextFieldViewModeAlways];
}

#pragma mark - Getter And Setter

- (void)setTagDelegate:(id<KKTagTextFieldDelegate>)tagDelegate {
    _tagDelegate = tagDelegate;
    self.delegate = tagDelegate;
}


@end

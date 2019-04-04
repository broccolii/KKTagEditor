//
//  KKTagEditorTextField.h
//  PepsiTagEditor
//
//  Created by KingKong on 16/7/13.
//  Copyright © 2016年 KingKong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KKTagTextField;
@protocol KKTagTextFieldDelegate <UITextFieldDelegate>
@required
- (void)deleteWithEmptyContentInKKTagTextField:(KKTagTextField *)textField;
@end

@interface KKTagTextField : UITextField
@property (weak, nonatomic) id<KKTagTextFieldDelegate> tagDelegate;
@end

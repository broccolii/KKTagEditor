//
//  KKTagEditorColor.h
//  PepsiTagEditor
//
//  Created by KingKong on 16/7/14.
//  Copyright © 2016年 KingKong. All rights reserved.
//

#ifndef KKTagEditorColor_h
#define KKTagEditorColor_h

#define KKTagEditorUIColorFromRGB(rgbValue)                                                              \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0                           \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0                              \
blue:((float)(rgbValue & 0xFF)) / 255.0                                       \
alpha:1.0]

#define KKNormalCellRed 0xff5050
#define KKLastCellBorderColor 0xeeeeee


#endif /* KKTagEditorColor_h */

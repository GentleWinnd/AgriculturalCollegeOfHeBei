//
//  MacroDefineHeader.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/22.
//  Copyright © 2016年 YH. All rights reserved.
//

#ifndef MacroDefineHeader_h
#define MacroDefineHeader_h

/**
 Generate weakOject

 @param o need weak object
 @return weakObject
 */
#define WeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;

#define StrongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;





#endif /* MacroDefineHeader_h */

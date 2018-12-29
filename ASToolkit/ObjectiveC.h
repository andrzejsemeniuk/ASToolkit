//
//  ObjectiveC.h
//  ASToolkit
//
//  Created by andrzej semeniuk on 12/29/18.
//  Copyright © 2018 Andrzej Semeniuk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ObjectiveC : NSObject

+ (BOOL)catchException:(void(^)(void))tryBlock error:(__autoreleasing NSError **)error;

@end

NS_ASSUME_NONNULL_END

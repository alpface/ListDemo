//
//  List.h
//  ListDemo
//
//  Created by xiaoyuan on 2019/1/9.
//  Copyright © 2019 xiaoyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 数组是一块连续的内存，每个元素只接收一个对象的地址，所谓修改数组中的每个元素只是修改数组中每个地址所保存的地址

@interface List<__covariant ObjectType> : NSObject <NSCopying, NSMutableCopying, NSFastEnumeration, NSSecureCoding>
{
@private
    void **_dataPtr;    // 数据区 存放数据的内存首地址
    NSUInteger _count;  // 元素的个数
    NSUInteger _capacity;  // 最大容量个数
}

@property (nonatomic, readonly) NSUInteger count;
@property (nonatomic, readonly) NSUInteger capacity;
@property (nullable, nonatomic, readonly) ObjectType firstObject;
@property (nullable, nonatomic, readonly) ObjectType lastObject;
@property (nonatomic, readonly, getter=isEmpty) BOOL empty;

// 初始化
- (instancetype)init;
- (instancetype)initWithCapacity:(NSUInteger)capacity;

// 重置数组容量
- (void)setAvailableCapacity:(NSUInteger)numSlots;

// 按照索引操作list
- (ObjectType)objectAtIndex:(NSUInteger)index;
- (void)addObject:(ObjectType)anObject;
- (void)addObjectIfAbsent:(ObjectType)anObject;
- (void)insertObject:(ObjectType)anObject atIndex:(NSUInteger)index;
- (ObjectType)removeObjectAtIndex:(NSUInteger)index;
- (ObjectType)removeLastObject;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(ObjectType)newObject;
- (void)addObjectsFromList:(List *)otherList;

// 按照元素操作list
- (NSUInteger)indexOfObject:(ObjectType)anObject;
- (id)removeObject:(ObjectType)anObject;
- (void)replaceObject:(ObjectType)anObject withObject:(ObjectType)newObject;

// 给所有元素发送消息
- (void)makeObjectsPerform:(SEL)aSelector;
- (void)makeObjectsPerform:(SEL)aSelector with:(id)anObject;

- (void)enumerateObjectsUsingBlock:(void ( ^)(id obj, NSUInteger idx, BOOL *stop))block;

- (void)sortedListUsingComparator:(NSComparator)cmptr;

/// 重载[]操作符  operator []：相当于中括号下标访问格式（array[index]），返回指定索引元素。等效于 objectAtIndex。
- (ObjectType)objectAtIndexedSubscript:(NSUInteger)idx;
@end

NS_ASSUME_NONNULL_END

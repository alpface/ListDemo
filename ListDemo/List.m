//
//  List.m
//  ListDemo
//
//  Created by xiaoyuan on 2019/1/9.
//  Copyright © 2019 xiaoyuan. All rights reserved.
//

#import "List.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

// 计算list中所有元素的内存大小，每个元素都是指针
#define kDataSize(count) ((count) * sizeof(void **))

@implementation List
- (instancetype)init
{
    return [self initWithCapacity:0];
}

- (instancetype)initWithCapacity:(NSUInteger)capacity {
    if (self = [super init]) {
        _capacity = capacity;
        _count = 0;
        // 按照capacity分配内存
        _dataPtr = (void **)malloc(kDataSize(capacity));
        memset(_dataPtr, 0, kDataSize(capacity));
    }
    return self;
}

- (void)dealloc {
    [self freeDataPtr];
}

- (void)freeDataPtr {
    if (NULL != _dataPtr) {
        free(_dataPtr);
        _dataPtr = NULL;
    }
}

- (BOOL)isEqual:(id)object {
    List *other;
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    other = object;
    return (self.count == other->_count) && (bcmp((const char *)_dataPtr, (const char *)other->_dataPtr, kDataSize(self.count)) == 0);
}
- (NSUInteger)capacity {
    return _capacity;
}
- (NSUInteger)count {
    return _count;
}

- (id)objectAtIndex:(NSUInteger)index {
    if (index >= _count) {
        NSString *reson = [NSString stringWithFormat:@"%s: index %ld beyond bounds [%d .. %ld]", __FUNCTION__, index, 0, _count-1];
        @throw [NSException exceptionWithName:NSRangeException reason:reson userInfo:nil];
    }
    
    return (__bridge id)*(_dataPtr+index);
}

- (NSUInteger)indexOfObject:(id)anObject {
    if (anObject == NULL) {
        return NSIntegerMax;
    }
    void **this = _dataPtr;
    // 最后一个元素的地址
    void **last = this + (_count - 1);
    while (this <= last) {
        if (*this == (__bridge void *)(anObject)) {
            return this - _dataPtr;
        }
        this++;
    }
    return NSIntegerMax;
}

- (id)lastObject {
    if (!_count) {
        return nil;
    }
    return (__bridge id _Nullable)*(_dataPtr+(_count - 1));
}

- (id)firstObject {
    if (!_count) {
        return nil;
    }
    return (__bridge id _Nullable)(*_dataPtr);
}

- (void)setAvailableCapacity:(NSUInteger)numSlots {
    void **tempDataPtr;
    if (numSlots < _count) {
        return;
    }
    tempDataPtr = (void **)realloc(_dataPtr, kDataSize(numSlots));
    _dataPtr = tempDataPtr;
    _capacity = numSlots;
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
    void **this;
    if (!anObject) {
        return;
    }
    if (index > _count) {
        return;
    }
    if ((_count + 1) > _capacity)  {
        // 超出数组的容量，重新分配更大的内存
        void **tempDataPtr;
        _capacity += _capacity + 1;
        tempDataPtr = (void **)realloc(_dataPtr, kDataSize(_capacity));
        _dataPtr = tempDataPtr;
    }
    // 计算元素需要插入在内存中的地址
    this = _dataPtr + index; // 首地址 偏移 指针步长 每个元素都是指针，指针的大小为8，步长加1就是地址加上8
    
    if (_count > 0 && index < (_count - 1)) {
        // 最后一个元素的地址
        void **last = _dataPtr + (_count - 1);
        // 如果当前元素后面还有元素 就让插入元素后面的所有元素往后移动1位
        while (*last != NULL && last >= this) {
            *(last+1) = *last;
            last--;
        }
    }
    *this = (__bridge void *)(anObject);
    _count++;
}

- (void)addObject:(id)anObject {
    [self insertObject:anObject atIndex:_count];
}

- (void)addObjectIfAbsent:(id)anObject {
    void **this, **last;
    if (!anObject) {
        return;
    }
    
    // 从第一个元素开始遍历，如果找到与anObject相同的，则不添加，一直遍历到最后一个元素
    this = _dataPtr;
    last = _dataPtr + (_count - 1);
    while (this <= last) {
        if (*this == (__bridge void *)(anObject)) {
            // 如果已存在，则return，不插入相同的元素
            return;
        }
        this++;
    }
    [self insertObject:anObject atIndex:_count];
}

- (id)removeObjectAtIndex:(NSUInteger)index {
    void **this, **last, **next;
    void *retval;
    if (index >= _count) {
        return nil;
    }
    // 定义临时指针变量，让index以后的每个元素向前移动一位
    this = _dataPtr + index;
    last = _dataPtr + (_count - 1);
    next = this + 1;
    retval = *this;
    // 移除的元素 后面的所有元素向前移动一位
    while (next <= last) {
        *this++ = *next++;
    }
    _count--;
    return (__bridge id _Nonnull)(retval);
}

- (id)removeObject:(id)anObject {
    void **this, **last;
    this = _dataPtr;
    last = _dataPtr + (_count - 1);
    while (this <= last) {
        if (*this == (__bridge void *)(anObject)) {
            return [self removeObjectAtIndex:this - _dataPtr];
        }
        this++;
    }
    return nil;
}

- (id)removeLastObject {
    if (_count == 0) {
        return nil;
    }
    return [self removeObjectAtIndex:_count - 1];
}

- (BOOL)isEmpty {
    return _count == 0;
}

- (void)replaceObject:(id)anObject withObject:(id)newObject {
    if (newObject == nil) {
        return;
    }
    void **this, **last;
    this = _dataPtr;
    last = _dataPtr + (_count - 1);
    while (this <= last) {
        if (*this == (__bridge void *)(anObject)) {
            *this = (__bridge void *)(newObject);
            return;
        }
        this++;
    }
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)newObject {
    void **this, *retval;
    if (!newObject) {
        return;
    }
    if (index > _count) {
        return;
    }
    this = _dataPtr + index;
    retval = *this;
    *this = (__bridge void *)(newObject);
}

- (void)makeObjectsPerform:(SEL)aSelector with:(id)anObject {
    NSInteger count = _count;
    while (count--) {
        id objc_obj = (__bridge id)_dataPtr[count];
        IMP imp = [objc_obj methodForSelector:aSelector];
        void (*func)(id, SEL, id) = (void *)imp;
        if (func != NULL) {
            func(objc_obj, aSelector, anObject);
        }
    }
}

- (void)makeObjectsPerform:(SEL)aSelector {
    NSInteger count = _count;
    while (count--) {
        id objc_obj = (__bridge id)_dataPtr[count];
        IMP imp = [objc_obj methodForSelector:aSelector];
        void (*func)(id, SEL) = (void *)imp;
        if (func != NULL) {
            func(objc_obj, aSelector);
        }
    }
}

- (void)addObjectsFromList:(List *)otherList {
    if (otherList.count == 0) {
        return;
    }
    NSUInteger i, count;
    for (i = 0, count = otherList.count; i < count; i++) {
        [self addObject:[otherList objectAtIndex:i]];
    }
}

- (void)enumerateObjectsUsingBlock:(void (^)(id, NSUInteger, BOOL *))block {
    if (_count == 0) {
        return;
    }
    void **tempDataPtr = _dataPtr;
    int index = 0;
    BOOL stop = NO;
    while (index < _count) {
        if (stop == YES) {
            return;
        }
        if (block) {
            block((__bridge id)(*tempDataPtr), index, &stop);
        }
        index++;
        tempDataPtr++;
    }
}

////////////////////////////////////////////////////////////////////////
#pragma mark - NSFastEnumeration
////////////////////////////////////////////////////////////////////////

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id __unsafe_unretained [])stackbuf
                                    count:(NSUInteger)stackbufLength
{
    NSUInteger count = 0;
    unsigned long countOfItemsAlreadyEnumerated = state->state;
    
    
    if(countOfItemsAlreadyEnumerated == 0)
    {
        state->mutationsPtr = &state->extra[0];
    }
    // 利用了参数中的缓冲数组
    if(countOfItemsAlreadyEnumerated < _count)
    {
        state->itemsPtr = stackbuf;
        while((countOfItemsAlreadyEnumerated < _count) && (count < stackbufLength))
        {
            stackbuf[count] = (__bridge id)(_dataPtr[countOfItemsAlreadyEnumerated]);
            countOfItemsAlreadyEnumerated++;
            
            count++;
        }
    }
    else
    {
        count = 0;
    }
    state->state = countOfItemsAlreadyEnumerated;
    return count;
}

- (void)sortedListUsingComparator:(NSComparator)cmptr {

    // 使用冒泡排序，在冒泡排序的过程中，关键字较小的记录好比水中的气泡逐趟向上漂浮，而关键字较大的记录好比石块往下沉，每一趟有一块“最大”的石头沉到水底。

    for(NSUInteger i=0;i<_count-1;i++) {
        for(NSUInteger j=_count-1;j>i;j--) {
            id value1Ptr = (__bridge id)(*(_dataPtr + j));
            id value2Ptr = (__bridge id)(*(_dataPtr + j - 1));
            NSComparisonResult result = cmptr(value1Ptr, value2Ptr);
            if(result == NSOrderedDescending)
            {
                void *temp=*(_dataPtr+j);
                *(_dataPtr+j)= *(_dataPtr + j - 1);
                *(_dataPtr+j-1)=temp;
            }
        }
    }
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    return [self objectAtIndex:idx];
}

////////////////////////////////////////////////////////////////////////
#pragma mark - NSCopying
////////////////////////////////////////////////////////////////////////

- (id)copyWithZone:(NSZone *)zone {
    return self;
}
////////////////////////////////////////////////////////////////////////
#pragma mark - NSMutableCopying
////////////////////////////////////////////////////////////////////////

- (id)mutableCopyWithZone:(NSZone *)zone {
    
    List *newList = [[[self class] alloc] initWithCapacity:_count];
    newList->_count = _count;
    bcopy(((const char *)_dataPtr), (char *)newList->_dataPtr, kDataSize(_count));
    return newList;
}

#pragma mark *** NSSecureCoding ***

+ (BOOL)supportsSecureCoding {
    return YES;
}


@end

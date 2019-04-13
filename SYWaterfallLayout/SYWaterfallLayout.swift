//
//  SYWaterfallLayout.swift
//
//  Created by ShiY on 2019/4/13.
//  Copyright © 2019 XR. All rights reserved.
//  UICollectionView瀑布流

import UIKit

@objc protocol SYWaterfallLayoutDelegate {
    /// 外部计算返回item高度
    func waterfallLayoutItemHeight(with layout: SYWaterfallLayout, width: CGFloat, indexPath: IndexPath) -> CGFloat
}

class SYWaterfallLayout: UICollectionViewLayout {
    /// 列数
    @objc public var columnCount = 0
    /// 行距
    @objc public var lineSpacing: CGFloat = 0.0
    /// 列距
    @objc public var itemSpacing: CGFloat = 0.0
    /// 内部边距
    @objc public var sectionInsets = UIEdgeInsets.zero
    
    @objc public weak var delegate: SYWaterfallLayoutDelegate?
    
    private var heightDic = [Int: CGFloat]()
    private var attributesArr = [UICollectionViewLayoutAttributes]()
    
    @objc class func layoutWithColumn(column: Int) -> SYWaterfallLayout{
        let layout = SYWaterfallLayout.init()
        layout.columnCount = column
        return layout
    }
    
    override func prepare() {
        super.prepare()
        
        for i in 0..<columnCount{
            heightDic[i] = sectionInsets.top
        }
        
        guard let cv = collectionView else { return }
        attributesArr.removeAll()
        for i in 0..<cv.numberOfItems(inSection: 0){
            let attr = self.layoutAttributesForItem(at: IndexPath.init(row: i, section: 0))!
            attributesArr.append(attr)
        }
    }
    
    override var collectionViewContentSize: CGSize{
        var maxHIndex = 0
        for (key, value) in heightDic{
            if heightDic[maxHIndex]! < value{
                maxHIndex = key
            }
        }
        return CGSize.init(width: 0, height: heightDic[maxHIndex]! + sectionInsets.bottom)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let cv = collectionView else { return nil }
        
        let attr = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        var minHIndex = 0
        for (key, value) in heightDic{
            if heightDic[minHIndex]! > value{
                minHIndex = key
            }
        }
        
        let allItemsSpacing = CGFloat(columnCount - 1) * itemSpacing
        let width = (cv.bounds.width - sectionInsets.left - sectionInsets.right - allItemsSpacing) / CGFloat(columnCount)
        let height = delegate?.waterfallLayoutItemHeight(with: self, width: width, indexPath: indexPath) ?? 0
        
        let itemX = sectionInsets.left + (width + itemSpacing) * CGFloat(minHIndex)
        let itemY = heightDic[minHIndex]! + lineSpacing
        
        attr.frame = CGRect.init(x: itemX, y: itemY, width: width, height: height)
        
        heightDic[minHIndex] = attr.frame.maxY
        
        return attr
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesArr
    }
    
}

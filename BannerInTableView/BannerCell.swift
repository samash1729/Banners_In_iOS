//
//  BannerCell.swift
//  BannerInTableView
//
//  Created by Ashish Samanta on 20/04/20.
//  Copyright © 2020 Nuclei. All rights reserved.
//

import UIKit

class BannerCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var collectionViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var pageIndicator: UIPageControl!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
    
    private var indexOfCellBeforeDragging = 0
    
    var collectionViewTimer:Timer?
    
    var imageURL = "https://images.unsplash.com/photo-1587888967232-e9df7b0b551c?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1950&q=80"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.collectionView?.backgroundColor = UIColor.lightGray
        self.collectionView.register(UINib(nibName: "CollectionViewBannerCell", bundle: Bundle(for: CollectionViewBannerCell.self) ), forCellWithReuseIdentifier: "CollectionViewBannerCell")
        pageIndicator.numberOfPages = 7
        pageIndicator.currentPage = 0
        startTimer()
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(longPressGR:)))
        longPress.minimumPressDuration = 0.7
        longPress.delaysTouchesBegan = true
        self.collectionView.addGestureRecognizer(longPress)
    }
    
    @objc
    func handleLongPress(longPressGR: UILongPressGestureRecognizer){
        
        if longPressGR.state == .began{
            print("ITEM NO : " + String(indexOfCellBeforeDragging))
            stopTimer()
        }
        
        if longPressGR.state == .ended{
            startTimer()
        }
    }
    
    func startTimer() {
        
        guard collectionViewTimer == nil else{
            return
        }
        collectionViewTimer =  Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
    }
    
    func stopTimer(){
        if collectionViewTimer != nil{
            collectionViewTimer?.invalidate()
            collectionViewTimer = nil
        }
    }
    
    @objc func scrollAutomatically(){
        
        pageIndicator.currentPage = indexOfCellBeforeDragging
        
        if pageIndicator.currentPage > 5{
            pageIndicator.currentPage = 0
        }
        else{
            pageIndicator.currentPage += 1
        }
        
        DispatchQueue.main.async{
            self.collectionViewLayout.collectionView!.scrollToItem(at: IndexPath(item: self.pageIndicator.currentPage, section: 0), at: .centeredHorizontally, animated: true)
        }
        
        indexOfCellBeforeDragging = pageIndicator.currentPage
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewBannerCell", for: indexPath) as! CollectionViewBannerCell
        cell.colourView.backgroundColor = cell.setColour(indexPath.item)
        cell.colourView.layer.cornerRadius = 12

        DispatchQueue.global().async {
            
            let url = URL(string: "https://images.unsplash.com/photo-1587888967232-e9df7b0b551c?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1950&q=80")
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                cell.bannerImage.image = UIImage(data: data!)
                cell.bannerImage.contentMode = .scaleAspectFill
                cell.bannerImage.layer.cornerRadius = 12
                cell.bannerImage.backgroundColor = UIColor.black
            }
        }
//        let image = UIImage(imageLiteralResourceName: "unsplash")
 //       cell.bannerImage.image = image //.rotate(radians: 1.57)
//        cell.bannerImage.contentMode = .scaleAspectFill
//        cell.bannerImage.layer.cornerRadius = 12
//        cell.bannerImage.backgroundColor = UIColor.black
        return cell
    }
    
    private func calculateSectionInset() -> CGFloat {
        
        let cellBodyWidth: CGFloat = collectionView.frame.width / 1.4
        let inset = (collectionView.frame.width - cellBodyWidth) / 4
        return inset
    }
    
//    func collectionView(_ collectionView: UICollectionView,
//               layout collectionViewLayout: UICollectionViewLayout,
//               insetForSectionAt section: Int){
//        let inset: CGFloat = calculateSectionInset() // This inset calculation is some magic so the next and the previous cells will peek from the sides. Don't worry about it
//        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
//    }
    
    private func configureCollectionViewLayoutItemSize() {
        let inset: CGFloat = calculateSectionInset() // This inset calculation is some magic so the next and the previous cells will peek from the sides. Don't worry about it
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        collectionViewLayout.itemSize = CGSize(width: collectionView.frame.size.width - inset * 2, height: collectionView.frame.height)
    }
    
    private func indexOfMajorCell() -> Int {
        let itemWidth = collectionViewLayout.itemSize.width
        let proportionalOffset = collectionView.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(6, index))
        return safeIndex
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
        indexOfCellBeforeDragging = indexOfMajorCell()
    }
    
    override func layoutSubviews() {
        configureCollectionViewLayoutItemSize()
    }

    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        startTimer()
        // Stop scrollView sliding:
        targetContentOffset.pointee = scrollView.contentOffset
        
        // calculate where scrollView should snap to:
        let indexOfMajorCell = self.indexOfMajorCell()
        
        // calculate conditions:
        let swipeVelocityThreshold: CGFloat = 0.5 // after some trail and error
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < 7 && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        
        if didUseSwipeToSkipCell {
            
            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            let toValue = collectionViewLayout.itemSize.width * CGFloat(snapToIndex)
            
         //   pageIndicator.currentPage = snapToIndex
            // Damping equal 1 => no oscillations => decay animation:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                scrollView.layoutIfNeeded()
            }, completion: nil)
            pageIndicator.currentPage = snapToIndex
            
        } else {
            // This is a much better way to scroll to a cell:
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            collectionViewLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            pageIndicator.currentPage = indexOfMajorCell
           // pageIndicator.currentPage = indexOfMajorCell
        }
    }
    
}

extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return rotatedImage ?? self
        }

        return self
    }
}

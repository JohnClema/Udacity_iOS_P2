//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by John Clema on 18/11/2015.
//  Copyright © 2015 JohnClema. All rights reserved.
//

import Foundation
import UIKit

class SentMemesCollectionViewController : UICollectionViewController {
    var memes: [Meme]! {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    var segueMeme: Meme!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.reloadData()
        let space: CGFloat = 3.0
        let widthDimension = (self.view.frame.size.width - (2 * space)) / 3.0
        //        let heightDimension = (self.view.frame.size.height - (2 * space)) / 3.0
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(widthDimension, widthDimension)

    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("memeCollectionCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.item]
        cell.topTextLabel.text = meme.topText
        cell.bottomTextLabel.text = meme.bottomText
        cell.memeImage.image = meme.initalImage
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
//        let object: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier("VillainDetailVC")
//        let detailVC = object as! VillainDetailViewController
//        
//        //Populate view controller with data from the selected item
//        detailController.villain = self.allVillains[indexPath.row]
//        
//        //Present the view controller using navigation
//        self.navigationController!.pushViewController(detailController, animated: true)
        segueMeme = memes[indexPath.row]
        
        performSegueWithIdentifier("showDetailFromCollection", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "showDetailFromCollection") {
            let vc = segue.destinationViewController as! MemeDetailViewController
            vc.meme = segueMeme
        }
        
    }
    
}
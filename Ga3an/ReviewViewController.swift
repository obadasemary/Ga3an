//
//  ReviewViewController.swift
//  Ga3an
//
//  Created by Abdelrahman Mohamed on 4/13/16.
//  Copyright © 2016 Abdelrahman Mohamed. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    
    @IBOutlet var backgroundImageView:UIImageView!
    @IBOutlet var ratingStackView:UIStackView!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var greatButton: UIButton!
    
    var rating: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        let blurEffect = UIBlurEffect(style: .Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
//        ratingStackView.transform = CGAffineTransformMakeScale(0.0, 0.0)
//        ratingStackView.transform = CGAffineTransformMakeTranslation(0, 500)
        
//        let scale = CGAffineTransformMakeScale(0.0, 0.0)
//        let translate = CGAffineTransformMakeTranslation(0, 500)
//        ratingStackView.transform = CGAffineTransformConcat(scale, translate)
        
        let translate = CGAffineTransformMakeTranslation(0, 500)
        dislikeButton.transform = translate
        goodButton.transform = translate
        greatButton.transform = translate
    }
    
//    override func viewWillAppear(animated: Bool) {
//        
////        UIView.animateWithDuration(1.0, delay: 0.0, options: [], animations: {
////            
////            self.ratingStackView.transform = CGAffineTransformIdentity
////            }, completion: nil)
//        
//        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: [], animations: {
//            
//            self.ratingStackView.transform = CGAffineTransformIdentity
//            }, completion: nil)
//    }

    override func viewDidAppear(animated: Bool) {
        
        // Spring animation
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            
            self.dislikeButton.transform = CGAffineTransformIdentity
            
            }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            
            self.goodButton.transform = CGAffineTransformIdentity
            
            }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 0.4, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            
            self.greatButton.transform = CGAffineTransformIdentity
            
            }, completion: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ratingSelected(sender: UIButton) {
        
        switch (sender.tag) {
        case 100:
            rating = "dislike"
        case 200:
            rating = "good"
        case 300:
            rating = "great"
        default:
            break
        }
        
        performSegueWithIdentifier("unwindToDetailView", sender: sender)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

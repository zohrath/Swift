//
//  SignupViewController.swift
//  Beertastic
//
//  Created by Adam Woods on 2018-03-15.
//  Copyright © 2018 Adam Woods. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var bottomBar: UIView!
    
    
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func chatButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func uploadButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func userButtonPressed(_ sender: UIButton) {
    }
    
    private var beerContent: [Beer]? {
        didSet {
            DispatchQueue.main.async {
                self.collection.reloadData()
                print("Reloaded")
            }
        }
    }
    
    private let reuseIdentifier = "BeerCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView() {
        setupButtons()
        
        collection.backgroundColor = .clear
        bottomBar.backgroundColor = UIColor.buttonBG
        
    }
    
    func setupButtons() {
        let insets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        userButton.imageView?.contentMode = .scaleAspectFit
        backButton.imageView?.contentMode = .scaleAspectFit
        
        uploadButton.layer.cornerRadius = 0.5 * uploadButton.bounds.size.width
        uploadButton.backgroundColor = UIColor.buttonBG
        uploadButton.contentEdgeInsets = insets
        
        searchButton.layer.cornerRadius = 0.5 * searchButton.bounds.size.width
        searchButton.backgroundColor = UIColor.buttonBG
        searchButton.contentEdgeInsets = insets
        
        chatButton.layer.cornerRadius = 0.5 * chatButton.bounds.width
        chatButton.backgroundColor = UIColor.buttonBG
        chatButton.contentEdgeInsets = insets
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BeerCell
        
        cell.beer = beerContent?[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        let selectedCell = collection.cellForItem(at: indexPath) as! BeerCell
//        guard let cellImageView = selectedCell.imageTitle else { return }
//        let description = selectedCell.textField.text
//        self.selectedImage = cellImageView
//        self.selectedDescription = description
//
//        performSegue(withIdentifier: "showSingleBeer", sender: Any?.self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension UIColor {
    static let buttonBG = UIColor(red:0.93, green:0.67, blue:0.00, alpha:1.0)
}

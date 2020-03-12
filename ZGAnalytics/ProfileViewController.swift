//
//  ProfileViewController.swift
//  ZGAnalytics
//
//  Created by Bharathimohan on 02/12/19.
//  Copyright © 2019 Bharathimohan. All rights reserved.
//

import UIKit


class profileViewCell: UITableViewCell {
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImg: UIImageView!
}


class profileInfoViewCell: UITableViewCell {
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileTypeImg: UIImageView!
}

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileTableview: UITableView!
    
    var profileArray = ["Vikas Alagarsamy", "9600094457", "vikas@gmail.com", "East of NGEF Layout, kasturi Nagar, Bangalore, karnataka 560043"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func logOut(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let promotionCell = profileTableview.dequeueReusableCell(withIdentifier: "profileIdentifier", for: indexPath) as? profileViewCell else {
                return UITableViewCell()
            }
            promotionCell.profileView.layer.borderWidth = 1
            promotionCell.profileView.layer.masksToBounds = false
            promotionCell.profileView.layer.borderColor = UIColor.lightGray.cgColor
            promotionCell.profileView.layer.cornerRadius = promotionCell.profileView.frame.height/2
            promotionCell.profileView.clipsToBounds = true
            if let templateImage = UIImage(named: "userIcon")?.withRenderingMode(.alwaysTemplate) {            let imageView = UIImageView(image: templateImage)
                promotionCell.profileImg.image = imageView.image
                promotionCell.profileImg.tintColor = UIColor(red: 241/255.0, green: 107/255.0, blue: 182/255.0, alpha: 1)
            }
            return promotionCell
        } else {
            guard let promotionCell = profileTableview.dequeueReusableCell(withIdentifier: "profileInfoIdentifier", for: indexPath) as? profileInfoViewCell else {
                return UITableViewCell()
            }
            promotionCell.profileName.text = profileArray[indexPath.row]
            if let templateImage = UIImage(named: "userIcon")?.withRenderingMode(.alwaysTemplate) {            let imageView = UIImageView(image: templateImage)
                promotionCell.profileTypeImg.image = imageView.image
                promotionCell.profileTypeImg.tintColor = UIColor(red: 241/255.0, green: 107/255.0, blue: 182/255.0, alpha: 1)
            }
            return promotionCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 160 : 60
    }

}

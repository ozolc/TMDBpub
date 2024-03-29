//
//  PersonDetailCell.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 26/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit
import SDWebImage

class PersonDetailCell: UICollectionViewCell {
    
    let personImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 12
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    var isAddSeparator = false
    
    let nameLabel = UILabel(text: "",
                            font: .systemFont(ofSize: 20, weight: .bold), numberOfLines: 2)
    
    let biographyLabel = UILabel(text: "",
                            font: .systemFont(ofSize: 18))
    let genderLabel = UILabel(text: "Пол: ", font: .systemFont(ofSize: 14))
    let knowForDepartmentLabel = UILabel(text: "Известен за: ", font: .systemFont(ofSize: 16))
    let birthdayLabel = UILabel(text: "Дата: ", font: .systemFont(ofSize: 14), numberOfLines: 0)
    let popularityLabel = UILabel(text: "Популярность: ", font: .systemFont(ofSize: 14), numberOfLines: 2)
    let placeOfBirthLabel = UILabel(text: "Место рождения: ", font: .systemFont(ofSize: 14), numberOfLines: 3)
    let knownAsLabel = UILabel(text: "Известен как: ", font: .systemFont(ofSize: 14), numberOfLines: 4)
    
    let biographyTextView: UITextView = {
        let tv = UITextView()
        tv.textColor = UIColor.black
        tv.font = .systemFont(ofSize: 16)
        tv.textContainerInset = UIEdgeInsets.zero
        tv.textContainer.lineFragmentPadding = 0
        tv.sizeToFit()
        tv.isScrollEnabled = false
        tv.isEditable = false
        return tv
    }()
    
    let backgroundImageView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        setupUI()
        
        setupBackgroundImageView()
    }
    
    fileprivate func setupBackgroundImageView() {
        
        self.backgroundImageView.addSubview(personImageView)
        personImageView.fillSuperview()
        
        self.backgroundImageView.backgroundColor = .white
        self.backgroundImageView.layer.cornerRadius = 16
        
        self.backgroundImageView.layer.shadowOpacity = 0.4
        self.backgroundImageView.layer.shadowRadius = 10
        self.backgroundImageView.layer.shadowOffset = .init(width: 0, height: 10)
        self.backgroundImageView.layer.shouldRasterize = true
    }
    
    fileprivate let dictionaryGender: [Int: String] = [
        0: "",
        1: "жен.",
        2: "муж."
    ]
    
    func configureCell(person: Person) {
        isAddSeparator = true
        
        let oldGenderText = genderLabel.text ?? ""
        guard let genderString = dictionaryGender[person.gender] else { return }
        genderLabel.text = oldGenderText + genderString
        
        if let knownForDepartment = person.knownForDepartment {
            let oldText = knowForDepartmentLabel.text ?? ""
            knowForDepartmentLabel.text = oldText + knownForDepartment
        }
        
        if let birthday = person.birthday {
            let oldText = birthdayLabel.text ?? ""
            birthdayLabel.text = oldText + birthday.replaceHyphenToDot()
        }
        
        let popularity = String(person.popularity.truncate(to: 1))
        let oldPopularityText = popularityLabel.text ?? ""
        popularityLabel.text = oldPopularityText + popularity
        
        if let place_of_birth = person.place_of_birth {
            let oldText = placeOfBirthLabel.text ?? ""
            placeOfBirthLabel.text = oldText + place_of_birth
        }
        if let knownAsArray = person.also_known_as {
            knownAsArray.forEach { (knownAs) in
                let oldText = knownAsLabel.text ?? ""
                knownAsLabel.text = oldText + knownAs + "\n"
            }
        }
        
        if let personImageViewUrl = URL(string: Constants.fetchPosterUrl(withPosterPath: person.profile_path ?? "", posterSize: Constants.PersonImageSize.w300_and_h450_bestv2.rawValue)) {
            
            personImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            personImageView.sd_setImage(with: personImageViewUrl)
            }
        
        nameLabel.text = person.name
        biographyTextView.text = person.biography
    }
    
    fileprivate func setupUI() {
        backgroundImageView.constrainWidth(constant: 150)
        backgroundImageView.constrainHeight(constant: 200)
        
        let labelRightStackView = VerticalStackView(arrangedSubviews: [
                genderLabel,
//                knowForDepartmentLabel,
                birthdayLabel,
                popularityLabel,
                placeOfBirthLabel,
                knownAsLabel
            ], spacing: 2)
        labelRightStackView.distribution = .equalSpacing
        labelRightStackView.alignment = .leading
        labelRightStackView.backgroundColor = .green
        
        let topstackView = UIStackView(arrangedSubviews: [
            backgroundImageView,
            labelRightStackView,
            ])
        topstackView.spacing = 16
        topstackView.alignment = .top
        topstackView.constrainHeight(constant: 210)
        
        let bottomstackView = VerticalStackView(arrangedSubviews: [
            nameLabel,
            biographyLabel,
            biographyTextView
            ], spacing: 2)
        bottomstackView.distribution = .fill
        bottomstackView.alignment = .top
        
        let overallStackView = VerticalStackView(arrangedSubviews: [
            topstackView,
            bottomstackView
            ], spacing: 16)
        overallStackView.alignment = .top
        overallStackView.distribution = .fill
        
        addSubview(overallStackView)
        overallStackView.fillSuperview(padding: .init(top: 4, left: 15, bottom: 0, right: 15))
        
//        addSubview(topstackView)
//        topstackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 4, left: 15, bottom: 0, right: 15))
//
//        addSubview(bottomstackView)
//        bottomstackView.anchor(top: topstackView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 4, left: 15, bottom: 4, right: 15))
        
//        if isAddSeparator {
        addSeparator(at: [.bottom],
                     color: UIColor.init(white: 0.75, alpha: 1),
                     weight: 1,
                     insets: .init(top: 0, left: 15, bottom: -4, right: 20))
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

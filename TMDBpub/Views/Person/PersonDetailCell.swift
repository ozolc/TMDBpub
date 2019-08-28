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
        iv.backgroundColor = .white
        iv.constrainWidth(constant: 150)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let nameLabel = UILabel(text: "Sophie Rundle",
                            font: .systemFont(ofSize: 20, weight: .bold))
    
    let biographyLabel = UILabel(text: "Биография:",
                            font: .systemFont(ofSize: 16))
    let genderLabel = UILabel(text: "Пол: ", font: .systemFont(ofSize: 16))
    let knowForDepartmentLabel = UILabel(text: "Известен за: ", font: .systemFont(ofSize: 16))
    let birthdayLabel = UILabel(text: "Дата рождения: ", font: .systemFont(ofSize: 16))
    let popularityLabel = UILabel(text: "Популярность: ", font: .systemFont(ofSize: 16))
    let placeOfBirthLabel = UILabel(text: "Место рождения: ", font: .systemFont(ofSize: 16), numberOfLines: 2)
    let knownAsLabel = UILabel(text: "Также известен как: ", font: .systemFont(ofSize: 16), numberOfLines: 2)
    
    let biographyTextView: UITextView = {
        let tv = UITextView()
        tv.textColor = UIColor.black
        tv.backgroundColor = .clear
        tv.font = .systemFont(ofSize: 16)
        tv.text = "Рыбным текстом называется текст, служащий для временного наполнения макета в публикациях или производстве веб-сайтов, пока финальный текст еще не создан. Рыбный текст также известен как текст-заполнитель или же текст-наполнитель. Иногда текст-«рыба» также используется композиторами при написании музыки."
        tv.sizeToFit()
        tv.isScrollEnabled = false
        tv.isEditable = false
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        setupUI()
    }
    
    fileprivate let dictionaryGender: [Int: String] = [
        0: "",
        1: "жен.",
        2: "муж."
    ]
    
    func configureCell(person: Person) {
        
        let oldGenderText = genderLabel.text ?? ""
        guard let genderString = dictionaryGender[person.gender] else { return }
        genderLabel.text = oldGenderText + genderString
        
        if let knownForDepartment = person.knownForDepartment {
            let oldText = knowForDepartmentLabel.text ?? ""
            knowForDepartmentLabel.text = oldText + knownForDepartment
        }
        
        if let birthday = person.birthday {
            let oldText = birthdayLabel.text ?? ""
            birthdayLabel.text = oldText + birthday
        }
        
        let popularity = String(person.popularity.truncate(to: 1))
        let oldPopularityText = popularityLabel.text ?? ""
        popularityLabel.text = oldPopularityText + popularity
        
        if let place_of_birth = person.place_of_birth {
            let oldText = placeOfBirthLabel.text ?? ""
            placeOfBirthLabel.text = oldText + place_of_birth
        }
        
        if let personImageViewUrl = URL(string: Constants.fetchPosterUrl(withPosterPath: person.profile_path ?? "", posterSize: Constants.PersonImageSize.w185_and_h278_bestv2.rawValue)) {
            
            personImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            personImageView.sd_setImage(with: personImageViewUrl)
            }
        
        nameLabel.text = person.name
        biographyTextView.text = person.biography
    }
    
    fileprivate func setupUI() {
        
        personImageView.backgroundColor = .white
        
        let labelRightStackView = VerticalStackView(arrangedSubviews: [
            genderLabel,
            knowForDepartmentLabel,
            birthdayLabel,
            popularityLabel,
            placeOfBirthLabel,
            knownAsLabel
            ], spacing: 2)
        labelRightStackView.distribution = .equalSpacing
        
        let topstackView = UIStackView(arrangedSubviews: [
            personImageView,
            labelRightStackView
            ])
        topstackView.spacing = 4
        topstackView.backgroundColor = .purple
        topstackView.alignment = .center
        
        let bottomstackView = VerticalStackView(arrangedSubviews: [
            nameLabel,
            biographyLabel,
            biographyTextView
            ], spacing: 2)
        bottomstackView.backgroundColor = .gray
        
        let overallStackView = VerticalStackView(arrangedSubviews: [
            topstackView,
            bottomstackView
            ], spacing: 8)
        
        addSubview(overallStackView)
        overallStackView.fillSuperview(padding: .init(top: 4, left: 15, bottom: 4, right: 15))
        
        addSeparator(at: [.bottom],
                     color: UIColor.init(white: 0.75, alpha: 1),
                     weight: 1,
                     insets: .init(top: 0, left: 15, bottom: 2, right: 20))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

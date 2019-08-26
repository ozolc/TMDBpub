//
//  PersonGroupCell.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 26/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class PersonGroupCell: UICollectionViewCell {
    
    let personImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "person"))
        iv.backgroundColor = .white
        iv.constrainWidth(constant: 150)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let nameLabel = UILabel(text: "Sophie Rundle",
                            font: .systemFont(ofSize: 20, weight: .bold))
    
    let biographyLabel = UILabel(text: "Биография:",
                            font: .systemFont(ofSize: 16))
    let genderLabel = UILabel(text: "Пол: ",
                            font: .systemFont(ofSize: 16))
    let knowForDepartmentLabel = UILabel(text: "Известен за: ", font: .systemFont(ofSize: 16))
    let birthdayLabel = UILabel(text: "Дата рождения: ", font: .systemFont(ofSize: 16))
    let popularityLabel = UILabel(text: "Популярность: ", font: .systemFont(ofSize: 16))
    let placeOfBirthLabel = UILabel(text: "Место рождения: ", font: .systemFont(ofSize: 16))
    let knownAsLabel = UILabel(text: "Также известен как: ", font: .systemFont(ofSize: 16))
    
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
        
        backgroundColor = UIColor.yellow
        
        setupUI()
    }
    
    fileprivate func setupUI() {
        
        personImageView.backgroundColor = .blue
        
        let labelRightStackView = VerticalStackView(arrangedSubviews: [
            genderLabel,
            knowForDepartmentLabel,
            birthdayLabel,
            popularityLabel,
            placeOfBirthLabel,
            knownAsLabel
            ], spacing: 2)
        
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

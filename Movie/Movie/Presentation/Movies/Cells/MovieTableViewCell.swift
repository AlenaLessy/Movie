//
//  MovieTableViewCell.swift
//  Movie
//
//  Created by Алена Панченко on 25.10.2022.
//

import UIKit

final class MovieTableViewCell: UITableViewCell {
    // MARK: - Private Outlets

    private var movieImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .green
        return image
    }()

    private var movieNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "rfrfarg  l`sfgnbzl"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 17)
        return label
    }()

    private var movieDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "rfrfarg  l`sfgnbzlafakkvkfvkvfkvkvkv"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 5
        return label
    }()

    private var movieRatingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "5"
        label.textColor = .yellow
        label.textAlignment = .left
        label.font = UIFont(name: "Arial", size: 20)
        return label
    }()

    // MARK: - LifeCycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubviews()
        configureLayoutAnchor()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func addSubviews() {
        addSubview(movieImageView)
        addSubview(movieNameLabel)
        addSubview(movieDescriptionLabel)
        addSubview(movieRatingLabel)
    }

    func update(_ movie: Movie) {
//        movieImageView.image = UIImage(named: movieCell.movieImageName)
        movieNameLabel.text = movie.title
        movieDescriptionLabel.text = movie.overview
        movieRatingLabel.text = movie.rating.description
    }

    // Constrains

    private func configureLayoutAnchor() {
        let constraint = movieImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        constraint.priority = UILayoutPriority(999)
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            movieImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            movieImageView.heightAnchor.constraint(equalToConstant: 150),
            movieImageView.widthAnchor.constraint(equalToConstant: 120),
            constraint,
//            movieImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)

            movieNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            movieNameLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 16),
            movieNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            movieDescriptionLabel.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: 5),
            movieDescriptionLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 16),
            movieDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            movieRatingLabel.topAnchor.constraint(equalTo: movieDescriptionLabel.bottomAnchor, constant: 5),
            movieRatingLabel.leadingAnchor.constraint(equalTo: movieDescriptionLabel.leadingAnchor),
            movieRatingLabel.trailingAnchor.constraint(equalTo: movieDescriptionLabel.trailingAnchor),
            movieRatingLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}

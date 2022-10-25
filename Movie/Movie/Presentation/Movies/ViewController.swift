//
//  ViewController.swift
//  Movie
//
//  Created by Алена Панченко on 25.10.2022.
//

import UIKit

// Экран выбора фильма
final class ViewController: UIViewController {
    // MARK: - Private Outlets

    private var topRatedButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .magenta
        btn.layer.cornerRadius = 5
        btn.setTitle("C лучшим рейтингом", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitleColor(.cyan, for: .selected)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.numberOfLines = 0
        return btn
    }()

    private var popularButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .magenta
        btn.layer.cornerRadius = 5
        btn.setTitle("Популярное", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitleColor(.cyan, for: .selected)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.numberOfLines = 0
        return btn
    }()

    private var upCommingButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .magenta
        btn.layer.cornerRadius = 5
        btn.setTitle("Скоро", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitleColor(.cyan, for: .selected)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.numberOfLines = 0
        return btn
    }()

    private var movieTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: - Private Properties

    var movies: [Movie] = []
    var movieDetails: MovieDetails?

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configureLayoutAnchor()
        configureTableView()

        networkService.requestMovies { [weak self] result in
            switch result {
            case let .success(movies):
                DispatchQueue.main.async {
                    self?.movies = movies
                    self?.movieTableView.reloadData()
                }
            case let .failure(error):
                print("test failure \(error)")
            }
        }
    }

    private let networkService = NetworkService.shared

    // MARK: - Private Methods

    private func addSubviews() {
        view.addSubview(topRatedButton)
        view.addSubview(popularButton)
        view.addSubview(upCommingButton)
        view.addSubview(movieTableView)
    }

    private func configureTableView() {
        movieTableView.dataSource = self
        movieTableView.delegate = self
        movieTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "test")
    }

    // MARK: - Constrains

    private func configureLayoutAnchor() {
        NSLayoutConstraint.activate([
            topRatedButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            topRatedButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            topRatedButton.heightAnchor.constraint(equalToConstant: 50),
            topRatedButton.widthAnchor.constraint(equalToConstant: 110),

            popularButton.topAnchor.constraint(equalTo: topRatedButton.topAnchor),
            popularButton.leadingAnchor.constraint(equalTo: topRatedButton.trailingAnchor, constant: 15),
            popularButton.heightAnchor.constraint(equalToConstant: 50),
            popularButton.widthAnchor.constraint(equalToConstant: 110),

            upCommingButton.topAnchor.constraint(equalTo: topRatedButton.topAnchor),
            upCommingButton.leadingAnchor.constraint(equalTo: popularButton.trailingAnchor, constant: 15),
            upCommingButton.heightAnchor.constraint(equalToConstant: 50),
            upCommingButton.widthAnchor.constraint(equalToConstant: 110),

            movieTableView.topAnchor.constraint(equalTo: topRatedButton.bottomAnchor, constant: 20),
            movieTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            movieTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            movieTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)

        ])
    }
}

/// UITableViewDataSource
extension ViewController: UITableViewDataSource {
    // возвращает количество ячеек в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }

    /// задаю каждую ячейку для секции и номера ячейки дай мне ячейку для первой секции и первой ячейки например
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = movies[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "test")
            as? MovieTableViewCell else { return UITableViewCell() }
        cell.update(model)
        return cell
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        print(movie.id)
        networkService.requestMovie(id: movie.id) { result in
            switch result {
            case .failure(.urlFailure):
                print("error")
            case let .success(movieDetails):
                print(movieDetails)
            default:
                break
            }
        }
    }
}

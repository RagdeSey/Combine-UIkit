//
//  ViewController.swift
//  Combine-UIKit
//
//  Created by Emilio Vásquez on 9/13/20.
//  Copyright © 2020 Emilio Vásquez. All rights reserved.
//

import UIKit
import Combine
import CombineCocoa

class ViewController: UIViewController {
    typealias CharacterDataSource = UITableViewDiffableDataSource<Section, Character>

    enum Section {
        case main
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var acitivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cleanButton: UIButton!

    var subscriptions = Set<AnyCancellable>()
    var viewModel = CharacterViewModel()
    var dataSource: CharacterDataSource?

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()


        tableView.delegate = self
        bindAddAction()
        bindDelete()
        bindClear()
        configurateDataSource()
    }

    // MARK: Binding
    func bindAddAction() {
        // Calling the viewModel publisher on local scope variable in order to avoid any retain cycle
        let tapPublisher = addButton.tapPublisher
        let publisher = viewModel.fetchCharacter(input: tapPublisher)
        //.debounce(for: 0.3, scheduler: DispatchQueue.main) //Use this operator in order to avoid any user taping event that could cause spam.

        // Create the subscription for fetch data when add button is tapped
        publisher.receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                self?.acitivityIndicator.stopAnimating()

                switch result {
                case .success(let character):
                    guard let firstCharacter = character.first, let currentCharacters = self?.viewModel.breakingBadCharacters else {
                        return
                    }
                    if currentCharacters.contains(firstCharacter) {
                        self?.viewModel.breakingBadCharacters.removeAll(where: { $0 == firstCharacter })
                        self?.viewModel.breakingBadCharacters.insert(firstCharacter, at: 0)
                    } else {
                        self?.viewModel.breakingBadCharacters.insert(firstCharacter, at: 0)
                    }
                    self?.dataSource?.defaultRowAnimation = .top
                    self?.updateContent()
                case .failure(let error):
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Close" , style: .cancel, handler: nil)

                    alert.addAction(action)
                    self?.present(alert, animated: true, completion: nil)
                }
        }.store(in: &subscriptions)

        //create subscription when add button is tapped and start the animated the activity indicator.
        tapPublisher.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.acitivityIndicator.startAnimating()
        }.store(in: &subscriptions)
    }

    func bindDelete() {
        let publisher = deleteButton.tapPublisher

        //create the subscription for delete button tap action
        publisher.receive(on: DispatchQueue.main).sink { [weak self] _ in
            guard let currentCharacters = self?.viewModel.breakingBadCharacters, currentCharacters.count > 0  else { return }
            let rand = Int.random(in: 0..<currentCharacters.count )
            self?.viewModel.breakingBadCharacters.remove(at: rand)
            self?.dataSource?.defaultRowAnimation = .middle
            self?.updateContent()
        }.store(in: &subscriptions)
    }

    func bindClear() {
        let publisher = cleanButton.tapPublisher

        //create the subscription for clear button tap action
        publisher.receive(on: DispatchQueue.main).sink { [weak self] _ in
            self?.viewModel.breakingBadCharacters.removeAll()
            self?.clearAnimatedUpdate()
        }.store(in: &subscriptions)
    }

    // MARK: Update
    func clearAnimatedUpdate() {
        dataSource?.defaultRowAnimation = .bottom
        updateContent()
    }

    func updateContent() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Character>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.breakingBadCharacters)
        dataSource?.apply(snapshot)
    }

    // MARK: Datasource
    func configurateDataSource() {
        dataSource = CharacterDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "CharactersTableViewCell", for: indexPath) as? CharactersTableViewCell
            cell?.configureCell(imageURL: item.img, name: item.name, ocupation: item.occupation?.first , portrayed: item.portrayed, status: item.status)
            return cell
        })
    }
}

// MARK: Delegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Selected", message: "Selected Row is: \(indexPath.row)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Close" , style: .cancel, handler: nil)

        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}


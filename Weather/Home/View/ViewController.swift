//
//  ViewController.swift
//  Weather
//
//  Created by Madhuri Agrawal on 20/02/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var latLongLabel: UILabel!
    @IBOutlet private weak var sunriseSunsetLabel: UILabel!

    private var viewModel: HomeViewModel = HomeViewModel()

    static func instance(_ viewModel: HomeViewModel) -> ViewController {
        let vc = ViewControllerAccessors.getViewController(ViewController.self, storyboard: .main)
        vc.viewModel = viewModel
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Weather"
        self.initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeViewState()
        viewModel.getWeather(cityName: viewModel.defaultCity)
    }

    private func initialSetup() {
        self.selectCitySetup()
        self.tableViewSetup()
    }

    private func tableViewSetup() {
        tableView.registerNib(WeatherDetailTableViewCell.self)
        tableView.register(
            WeatherTableHeaderView.nib,
            forHeaderFooterViewReuseIdentifier: WeatherTableHeaderView.identifier
        )
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func observeViewState() {
        self.viewModel.onViewStateChange = { _ in
            self.onStateChange()
        }
        onStateChange()
    }

    private func onStateChange() {
        if viewModel.viewState.isLoading {
            // show Loader
        } else {
            // hide Loader
        }
        switch viewModel.viewState {
        case .empty: break
        case .ready(let state):
            switch state {
            case .getWeatherData:
                self.setupWeatherHeader()
                self.tableView.reloadData()
            }
        case .error(let error):
            if let weatherError = error as? WeatherError {
                self.showAlert(message: weatherError.errorDescription)
            } else {
                self.showAlert(message: error.localizedDescription)
            }
        default: break
        }
    }

    private func showAlert(title: String = "Weather", message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }

    private func selectCitySetup() {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "mappin.and.ellipse"), for: .normal)
        button.tintColor = .black
        button.sizeToFit()
        button.addTarget(self, action: #selector(self.redirectToChoseCity), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItems = [barButton]
    }

    @objc func redirectToChoseCity() {
        self.presentSearchCityAlert()
    }

    private func presentSearchCityAlert() {
        let alert = UIAlertController(
            title: "Select City",
            message: "Please enter city to get weather results. i.e. Delhi, Jaipur, Mumbai ",
            preferredStyle: .alert
        )

        let searchAction = UIAlertAction(title: "Search", style: .default) { [weak self] _ in
            guard let textField = alert.textFields?.first,
                  let searchText = textField.text,
                  let self = self else { return }
            self.viewModel.getWeather(cityName: searchText)
        }
        alert.addAction(searchAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alert.addTextField { textField in
            textField.placeholder = "please enter city"
        }

        self.present(alert, animated: true, completion: nil)
    }

    private func setupWeatherHeader() {
        self.cityLabel.text = viewModel.weatherHeaderModel?.cityText ?? ""
        self.latLongLabel.text = viewModel.weatherHeaderModel?.latLongText ?? ""
        self.sunriseSunsetLabel.text = viewModel.weatherHeaderModel?.sunriseSunsetText ?? ""
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.weatherModelList.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let weatherModelList = viewModel.weatherModelList[safe: section]?.lists {
            return weatherModelList.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            WeatherDetailTableViewCell.self,
            indexPath: indexPath
        )
        if let weatherModel = viewModel.weatherModelList[safe: indexPath.section]?.lists[safe: indexPath.row] {
            cell.configure(data: weatherModel)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: WeatherTableHeaderView.identifier
        ) as? WeatherTableHeaderView {
            if let data = viewModel.weatherModelList[safe: section] {
                headerView.configure(data: data)
            }
            return headerView
        }
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

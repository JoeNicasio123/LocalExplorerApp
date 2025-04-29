//
//  SettingsViewController.swift
//  LocalExplorer
//
//  Created by Ajdin Seho on 4/28/25.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var pckSortField: UIPickerView!
    @IBOutlet weak var swAscending: UISwitch!

    let sortOrderItems: [String] = ["locationName", "city"]

    override func viewDidLoad() {
        super.viewDidLoad()

        pckSortField.dataSource = self
        pckSortField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let settings = UserDefaults.standard
        swAscending.setOn(settings.bool(forKey: Constants.kSortDirectionAscending), animated: true)

        let sortField = settings.string(forKey: Constants.kSortField) ?? "locationName"
        pckSortField.reloadComponent(0)

        if let index = sortOrderItems.firstIndex(of: sortField) {
            pckSortField.selectRow(index, inComponent: 0, animated: false)
        }
    }

    @IBAction func sortDirectionChanged(_ sender: Any) {
        let settings = UserDefaults.standard
        settings.set(swAscending.isOn, forKey: Constants.kSortDirectionAscending)
        settings.synchronize()
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortOrderItems.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortOrderItems[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let sortField = sortOrderItems[row]
        let settings = UserDefaults.standard
        settings.set(sortField, forKey: Constants.kSortField)
        settings.synchronize()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        let settings = UserDefaults.standard
        let selectedRow = pckSortField.selectedRow(inComponent: 0)
        let sortField = sortOrderItems[selectedRow]

        settings.set(sortField, forKey: Constants.kSortField)
        settings.set(swAscending.isOn, forKey: Constants.kSortDirectionAscending)
        settings.synchronize()
    }
}

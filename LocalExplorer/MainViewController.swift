//
//  MainViewController.swift
//  LocalExplorer
//
//  Created by user272075 on 4/28/25.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UITextFieldDelegate {
    var currentLocation: Location?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var takePicButton: UIButton!
    @IBOutlet weak var txtZip: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var sgmtEditMode: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.changeEditMode(self)

        let textFields: [UITextField] = [txtName, txtAddress, txtCity, txtState, txtZip]
        for textfield in textFields {
            textfield.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
        }
    }
    
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        if currentLocation == nil {
            let context = appDelegate.persistentContainer.viewContext
            currentLocation = Location(context: context)
        }
        currentLocation?.locationName = txtName.text
        currentLocation?.streetAddress = txtAddress.text
        currentLocation?.city = txtCity.text
        currentLocation?.state = txtState.text
        currentLocation?.zipCode = txtZip.text
    }
    
    @objc func saveLocation() {
        appDelegate.saveContext()
        sgmtEditMode.selectedSegmentIndex = 0
        changeEditMode(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func changeEditMode(_ sender: Any) {
        let textFields: [UITextField] = [txtName, txtAddress, txtCity, txtState, txtZip]
        if sgmtEditMode.selectedSegmentIndex == 0 {
            for textField in textFields {
                textField.isEnabled = false
                textField.borderStyle = .none
            }
            takePicButton.isHidden = true
            navigationItem.rightBarButtonItem = nil
        }
        else if sgmtEditMode.selectedSegmentIndex == 1 {
            for textField in textFields {
                textField.isEnabled = true
                textField.borderStyle = .roundedRect
            }
            takePicButton.isHidden = false
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveLocation))
        }
    }
}

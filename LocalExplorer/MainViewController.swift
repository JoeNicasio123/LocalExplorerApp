//
//  MainViewController.swift
//  LocalExplorer
//
//  Created by user272075 on 4/28/25.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var takePicButton: UIButton!
    @IBOutlet weak var txtZip: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var sgmtEditMode: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.sgmtEditMode(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func sgmtEditMode(_ sender: Any) {
        let textFields: [UITextField] = [txtName, txtAddress, txtCity, txtState, txtZip]
        if sgmtEditMode.selectedSegmentIndex == 0 {
            for textField in textFields {
                textField.isEnabled = false
                textField.borderStyle = UITextField.BorderStyle.none
            }
            takePicButton.isHidden = true
        }
        else if sgmtEditMode.selectedSegmentIndex == 1 {
            for textField in textFields {
                textField.isEnabled = true
                textField.borderStyle = UITextField.BorderStyle.roundedRect
            }
            takePicButton.isHidden = false
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

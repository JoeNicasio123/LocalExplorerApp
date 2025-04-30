//
//  MapViewController.swift
//  LocalExplorer
//
//  Created by user272075 on 4/28/25.
//

import UIKit
import MapKit
import CoreData
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
   
    var locationManager = CLLocationManager()
    var savedLocations: [Location]=[]

    @IBOutlet weak var newMapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization()
                newMapView.delegate = self


        // Do any additional setup after loading the view.
    }
   
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            fetchAndDisplayLocations()
        }

   
    func fetchAndDisplayLocations() {
           let appDelegate = UIApplication.shared.delegate as! AppDelegate
           let context = appDelegate.persistentContainer.viewContext
           let request = NSFetchRequest<NSManagedObject>(entityName: "Location")
           
           do {
               let fetchedObjects = try context.fetch(request)
               savedLocations = fetchedObjects as! [Location]
           } catch let error as NSError {
               print("Could not fetch. \(error), \(error.userInfo)")
           }

           newMapView.removeAnnotations(newMapView.annotations)

           for location in savedLocations {
               let fullAddress = "\(location.streetAddress ?? ""), \(location.city ?? "") \(location.state ?? "")"
               let geoCoder = CLGeocoder()
               geoCoder.geocodeAddressString(fullAddress) { (placemarks, error) in
                   self.handleGeocodingResult(location, placemarks: placemarks, error: error)
               }
           }
       }
    func handleGeocodingResult(_ location: Location, placemarks: [CLPlacemark]?, error: Error?) {
            if let error = error {
                print("Geocoding error: \(error)")
                return
            }

            guard let coordinate = placemarks?.first?.location?.coordinate else {
                print("No coordinates found.")
                return
            }

            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = location.locationName
            annotation.subtitle = "\(location.streetAddress ?? ""), \(location.city ?? "")"
            newMapView.addAnnotation(annotation)
        }
    func mapView(_ newMapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            let region = MKCoordinateRegion(center: userLocation.coordinate,
                                            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
            newMapView.setRegion(region, animated: true)
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

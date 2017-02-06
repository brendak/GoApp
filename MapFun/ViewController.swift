//
//  ViewController.swift
//  GoApp
//
//  Created by X on 12/9/16.
//  Copyright © 2016 Brenda Kaing. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData
import Alamofire

class SweetMapsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, SwitchDelegate, DeleteFromMyListDelegate {
    
    //****************** MARK: Variables
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager:CLLocationManager = CLLocationManager()
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var myEvents: [Event] = []
    var allEvents: [Entry] = [] //all events from json
    var tomorrow = Date()
    
    //****************** MARK: Fixture
    
    var categories: [String] = []
    var otherEntries: [Entry] = []
    var myEntries: [Entry] = []
    var myEntriesID: [String] = []
    
    //**************** MARK: Request to Back-end
    
    func alamofireSWAPI(){
        print("In swapi")
        Alamofire.request("http://localhost:8000/showevents", method: .get, parameters: nil, headers: nil).responseJSON { response in
            // Perform action on API data
            if let jsonResult = response.result.value as? NSDictionary {
                print(jsonResult)
                
                if let results = jsonResult["events"] {
                    let resultsArray = results as! NSArray
                    
                    for x in resultsArray {
                        let thisEvent = x as! NSDictionary
                        let addressObject: NSDictionary = [:]
                        
                        var titleSave = "none"
                        var detailSave = "none"
                        var dateSave = Date()
                        var latSave = "none"
                        var longSave = "none"
                        var addressSaver = ["city":"none","street":"none","zip":"none"]
                        var addressSave: String = ""
                        var categorySave = "none"
                        var idSave = "none"
                        
                        if let title = thisEvent["title"]{
                            titleSave = title as! String
                        }
                        
                        if let detail = thisEvent["detail"]{
                            detailSave = detail as! String
                        }
                        
                        if let longitude = thisEvent["coordinatesLong"]{
                            longSave = longitude as! String
                        }
                        
                        if let latitude = thisEvent["coordinatesLat"]{
                            latSave = latitude as! String
                        }
                        
                        if let addressObject = thisEvent["address"]{
                            addressSaver = (addressObject as! NSDictionary) as! [String : String]
                            addressSave = ("\(addressSaver["street"]!), \n\(addressSaver["city"]!), \n\(addressSaver["zip"]!)")
                        }
                        
                        if let date = thisEvent["date"]{
                            dateSave = self.NSDateFormat(date: date as! String) as Date
                        }
                        
                        if let category = thisEvent["category"]{
                            categorySave = category as! String
                        }
                        
                        if let id = thisEvent["_id"]{
                            idSave = id as! String
                        }
                        
                        self.allEvents.append(Entry(title: titleSave, detail: detailSave, date: dateSave, coordinate: CLLocationCoordinate2D(latitude: Double(latSave)!, longitude: Double(longSave)! ), address: addressSave, category: categorySave, id: idSave))
                    }
                    DispatchQueue.main.async {
                        self.filterResults()
                        self.categoryFinder()
                        self.plotView()
                        self.categoryTableView.reloadData()
                    }
                }
            }
        }
    }
    
    //****************** MARK: UI Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alamofireSWAPI()
        DispatchQueue.main.async {
            self.plotView()
            self.categoryTableView.reloadData()
        }
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.determineCurrentLocation()
        mapView.delegate = self
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        dateSetter()
        self.sideViewLeadingConstraint.constant = -self.sideView.frame.width
        self.flag = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //****************** MARK: An Event deleted from My Events
    
    func deletedAnEvent(controller: tableViewController){
        print("delete command received")
        self.filterResults()
        self.plotView()
    }
    
    //****************** MARK: Map View : This takes all the entries in allEvents and pushes to otherEntry to display on Map
    var filteredOtherEntries: [Entry] = []
    var myPins: [Entry] = []
    func plotView() {
        self.filterResults()
        filteredOtherEntries = []
        for entry in otherEntries {
            let tomorrowTomorrow = Calendar.current.date(byAdding: .day, value: 1, to: tomorrow)
            if entry.date >= tomorrow && entry.date <= tomorrowTomorrow! && categories.contains(entry.category){
                filteredOtherEntries.append(entry)
            } else if sliderSlider.value == 0 && categories.contains(entry.category) {
                if entry.date >= today {
                    filteredOtherEntries.append(entry)
                }
            }
        }
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(filteredOtherEntries)
        
        // Add user selected events - this displays only myEntry
        fetchData()
        myPins = []
        for entry in myEntries {
            let tomorrowTomorrow = Calendar.current.date(byAdding: .day, value: 1, to: tomorrow)
            if entry.date >= tomorrow && entry.date <= tomorrowTomorrow! && categories.contains(entry.category){
                myPins.append(entry)
            } else if sliderSlider.value == 0 && categories.contains(entry.category) {
                if entry.date >= today {
                    myPins.append(entry)
                }
            }
        }
        mapView.addAnnotations(myPins)
    }
    
    //    //****************** MARK: Map View
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Entry"
    
        let annotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:identifier)
        //        if (annotation is Entry && annotation is not MyEntry) {
        if !annotation.isKind(of: Entry.self) {
            return nil
        }
        else if filteredOtherEntries.contains(annotation as! Entry) {
            annotationView.pinTintColor = UIColor(red:0.00, green:0.52, blue:1.00, alpha:1.0)
            annotationView.isEnabled = true
            annotationView.canShowCallout = true
        } else if myPins.contains(annotation as! Entry) {
            annotationView.pinTintColor = UIColor(red:0.79, green:0.24, blue:0.36, alpha:1.0)
            annotationView.isEnabled = true
            annotationView.canShowCallout = true

        }
        else {
            return nil
        }
        let btn = UIButton(type: .detailDisclosure)
        annotationView.rightCalloutAccessoryView = btn
        let button = UIButton(type: .detailDisclosure)
        button.setImage(UIImage(named: "Go-1"), for: .normal)
        annotationView.leftCalloutAccessoryView = button

        
        btn.tintColor = UIColor(red:0.00, green:0.52, blue:1.00, alpha:1.0)
        button.tintColor = UIColor(red:0.79, green:0.24, blue:0.36, alpha:1.0)
        return annotationView
    }
    
    //****************** MARK: Map View Action
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView{
            let event = view.annotation as! Entry
            let eventName = event.title!
            let date = dateFormatToString(date: event.date)
            let eventInfo = String("\(event.subtitle!)" + "\n" + "\(date)" + "\n" + "\(event.address)")
            let ac = UIAlertController(title: eventName, message: eventInfo!, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let event = view.annotation as! Entry
            let entry = NSEntityDescription.insertNewObject(forEntityName: "Event", into: managedObjectContext) as! Event
            entry.title = event.title
            entry.detail = event.subtitle
            entry.date = event.date as NSDate?
            entry.address = event.address
            entry.longitude = event.coordinate.longitude
            entry.latitude = event.coordinate.latitude
            entry.category = event.category
            entry.id = event.id
            if managedObjectContext.hasChanges {
                do {
                    try managedObjectContext.save()
                    print("Success")
                } catch {
                    print("\(error)")
                }
            }
            print("left button clicked")
            let ac = UIAlertController(title: "Added", message: "Event saved to My Events", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            plotView()
        }
    }
    
    //****************** MARK: Sideview
    var flag: Bool?
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var sideViewLeadingConstraint: NSLayoutConstraint!
    
    @IBAction func categoryButtonPressed(_ sender: UIBarButtonItem) {
        if self.flag! {
            self.sideViewLeadingConstraint.constant = -50
            self.flag = false
        }else{
            self.sideViewLeadingConstraint.constant = -self.sideView.frame.width
            self.flag = true
        }
        self.view.setNeedsLayout()
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: [UIViewAnimationOptions.allowUserInteraction], animations: {
            self.view.layoutIfNeeded()
            
        }) { (finished) in
            if finished{
            }
        }
    }
    
    func switchChanged(controller: customSideViewCell, selectedCategory category: String){
        if categories.contains(category) {
            let index = categories.index(of: category)
            categories.remove(at: index!)
            print ("removed category")
        }else{
            categories.append(category)
            print ("added category")
        }
        plotView()
    }
    
    //****************** MARK: Prepare for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let controller = navigationController.topViewController as! tableViewController
        controller.delegate = self
    }
    
    //    ****************** MARK: Table
    
    @IBOutlet weak var categoryTableView: UITableView!
    
    func tableView(_ categoryTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ categoryTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTableView.dequeueReusableCell(withIdentifier: "MyCell") as! customSideViewCell
        cell.model = categories[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    //****************** MARK: User Location
    
    func determineCurrentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    var userLocation:CLLocation = CLLocation()
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        locationManager.stopUpdatingLocation()
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25))
        mapView.setRegion(region, animated: true)
        // Drop a pin at user's Current Location
        //        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        //        myAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        //        myAnnotation.title = "Current location"
        //        mapView.addAnnotation(myAnnotation)
        mapView.showsUserLocation = true
    }
    
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error \(error)")
    }
    
    //****************** MARK: Search Bar
    
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    @IBAction func showSearchBar(_ sender: UIBarButtonItem) {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        //2
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            //3
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
        }
    }
    
    //****************** MARK: Slider
    
    @IBOutlet weak var lowerLabel: UILabel!
    @IBOutlet weak var sliderSlider: UISlider!
    let today = Date()
    
    @IBAction func dateSlider(_ sender: UISlider) {
        tomorrow = Calendar.current.date(byAdding: .day, value: Int(sliderSlider.value), to: today)!
        let roundedValue = round(sliderSlider.value / 1.0) * 1.0
        sliderSlider.value = roundedValue
        dateSetter()
        plotView()
    }
    
    //**************************** MARK: - Core Location Delegate Methods
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    // do stuff
                }
            }
        }
    }
    
    //**************************** MARK: - Helper Functions
    
    //MARK: Fetch Core CoreData
    
    func fetchData() {
        myEntries = []
        myEntriesID = []
        let eventRequest = NSFetchRequest<Event>(entityName: "Event")
        do {
            let results = try managedObjectContext.fetch(eventRequest as! NSFetchRequest<NSFetchRequestResult>)
            myEvents = results as! [Event]
        } catch {
            print("\(error)")
        }
        for event in myEvents {
            let entry = Entry(title: event.title!, detail: event.detail!, date: event.date! as Date, coordinate: CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude), address: event.address!, category: event.category!, id: event.id!) as Entry
            myEntries.append(entry)
            myEntriesID.append(event.id!)
        }
    }
    //MARK: Initial Data Setup
    func filterResults() {
        fetchData()
        otherEntries = []
        for event in allEvents{
            if !myEntriesID.contains(event.id){
                otherEntries.append(event)
            }
        }
    }
    
    func categoryFinder() {
        for event in allEvents{
            if !categories.contains(event.category){
                categories.append(event.category)
            }
        }
    }
    
    //MARK: Date Formatting
    
    func dateFormat (date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateFromString = dateFormatter.date(from: date)
        return dateFromString!
    }
    func dateFormatToString (date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateFromString = dateFormatter.string(from: date)
        return dateFromString
    }
    
    func dateSetter (){
        let tomorrowTomorrow = Calendar.current.date(byAdding: .day, value: 1, to: tomorrow)
        let formatter = DateFormatter()
        if sliderSlider.value != 0 {
            formatter.dateStyle = .medium
            lowerLabel.text = formatter.string(from: tomorrowTomorrow!)
        }
        else {
            formatter.dateFormat = "yyyy"
            lowerLabel.text = formatter.string(from: tomorrowTomorrow!)
        }
    }
    
    func NSDateFormat (date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSS"
        return dateFormatter.date(from: String(date.characters.dropLast(1)))!
        
    }
    
    
}


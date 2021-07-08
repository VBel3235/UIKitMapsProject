//
//  ViewController.swift
//  M10HomeWorkMaps
//
//  Created by Владислав Белов on 04.07.2021.
//

import UIKit
import MapKit
import CoreLocation

class AppleMapsViewController: UIViewController {
    
    private let map: MKMapView = {
        let map = MKMapView()
        
        
        return map
    }()
    
    private let centerButton: UIButton = {
        let centerButton = UIButton()
        centerButton.setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .normal)
        centerButton.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        centerButton.translatesAutoresizingMaskIntoConstraints = false
        centerButton.setImage(UIImage(systemName: "dot.circle.fill"), for: .normal)
        centerButton.contentVerticalAlignment = .fill
        centerButton.contentHorizontalAlignment = .fill
        centerButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        
        return centerButton
    }()
    
    private let zoomInButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .normal)
        button.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        
        
        return button
    }()
    
    private let zoomOutButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .normal)
        button.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "minus.circle"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        
        
        return button
    }()
    
    let coordinate = CLLocationCoordinate2D(latitude: 31.224361, longitude: 121.469170)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(map)
        map.addSubview(centerButton)
        map.addSubview(zoomInButton)
        map.addSubview(zoomOutButton)
        map.delegate = self
        title = "Shanghai"
        map.setRegion(MKCoordinateRegion(center: coordinate,
                                         span: MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7)),
                                        animated: true)
        LocationManager.shared.getUserLocation { [weak self] location in
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.addMapPin(location: location)
                
            }
        }
        
        addAttractionsPins()
        addConstraints()
        configureButtons()
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        map.frame = view.bounds
    }
    
    func configureButtons(){
        centerButton.addTarget(self, action: #selector(clickOnCenterButton), for: .touchUpInside)
        zoomInButton.addTarget(self, action: #selector(zoomIn), for: .touchUpInside)
        zoomOutButton.addTarget(self, action: #selector(zoomOut), for: .touchUpInside)
    }
    
    @objc func clickOnCenterButton(){
        LocationManager.shared.getUserLocation { [weak self] location in
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                strongSelf.map.setRegion(MKCoordinateRegion(center: location.coordinate,
                                                 span: MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7)),
                                                animated: true)
                LocationManager.shared.resolveLoactionName(with: location) { [weak self] name in
                    strongSelf.title = name
                }
                
            }
        }
    }
    
    @objc func zoomIn(){
        print("zoomed in")
       
            var region: MKCoordinateRegion = self.map.region
            var span: MKCoordinateSpan = map.region.span
        span.latitudeDelta *= 0.6
        span.longitudeDelta *= 0.6
            region.span = span
            map.setRegion(region, animated: true)
        
        
    }
    
    @objc func zoomOut(){
        print("zoomed out")
        var region: MKCoordinateRegion = self.map.region
        var span: MKCoordinateSpan = map.region.span
        span.latitudeDelta /= 0.6
        span.longitudeDelta /= 0.6
        region.span = span
        map.setRegion(region, animated: true)
        
    }
    
    func addConstraints(){
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(centerButton.heightAnchor.constraint(equalToConstant: 60))
        constraints.append(centerButton.widthAnchor.constraint(equalToConstant: 60))
        
       // constraints.append(centerButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 350))
        constraints.append(centerButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor))
      //  constraints.append(centerButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 540))
        constraints.append(centerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80))
        
        constraints.append(zoomOutButton.widthAnchor.constraint(equalToConstant: 60))
        
       // constraints.append(zoomOutButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 350))
      //  constraints.append(zoomOutButton.trailingAnchor.constraint(equalTo: zoomInButton.leadingAnchor, constant: 10))
        constraints.append(zoomOutButton.heightAnchor.constraint(equalTo: zoomInButton.heightAnchor))
        constraints.append(zoomOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10))
        
       constraints.append(zoomInButton.leadingAnchor.constraint(equalTo: zoomOutButton.trailingAnchor, constant: -8))
      constraints.append(zoomInButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -4))
        constraints.append(zoomInButton.topAnchor.constraint(equalTo: centerButton.bottomAnchor, constant: 8))
        constraints.append(zoomInButton.widthAnchor.constraint(equalTo: zoomOutButton.widthAnchor))
        constraints.append(zoomInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10))
        
        
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func addAttractionsPins(){
        let bund = Annotation(coordinate: CLLocationCoordinate2D(latitude: 31.224361, longitude: 121.439170), title: "Набережная Вайтан", subtitle: "Популярная пещеходная улица", annotationImage: UIImage(named: "hangzhou")!)
        let zoo = Annotation(coordinate: CLLocationCoordinate2D(latitude: 31.0524, longitude: 121.6948), title: "Парк дикой природы", subtitle: "Один из самых крупных зоопарков мира", annotationImage: UIImage(named: "panda")!)
        let tower = Annotation(coordinate: CLLocationCoordinate2D(latitude: 31.239752, longitude: 121.499588), title: "Восточная жемчужина", subtitle: "Известная телевизионная башня", annotationImage: UIImage(named: "shanghai")!)
        let temple = Annotation(coordinate: CLLocationCoordinate2D(latitude: 31.143549, longitude: 121.262590), title: "Храм Нефритового будды", subtitle: "Известный буддийский храм", annotationImage: UIImage(named: "monument")!)
        let noodleRestaraunt = Annotation(coordinate: CLLocationCoordinate2D(latitude: 31.043549, longitude: 121.33590), title: "ВейСянЧжай", subtitle: "Лучший рестаран с лапшой в Шанхае", annotationImage: UIImage(named: "noodles")!)
        
        map.addAnnotation(bund)
        map.addAnnotation(zoo)
        map.addAnnotation(tower)
        map.addAnnotation(temple)
        map.addAnnotation(noodleRestaraunt)
        
    }
    
    func addMapPin(location: CLLocation){
        let pin = MKPointAnnotation()
        pin.coordinate = location.coordinate
      

        map.addAnnotation(pin)
        
       
    }

}

extension AppleMapsViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Annotation else {
                return nil
            }
        var annotationView = map.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        annotationView?.canShowCallout = true
        
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
            annotationView?.image = annotation.annotationImage
        } else {
            annotationView?.annotation = annotation
            annotationView?.image = annotation.annotationImage
        }
        
        annotationView?.image = annotation.annotationImage
     
        annotationView?.annotation = annotation
        
       
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let title = view.annotation?.title{
            if let subtitle = view.annotation?.subtitle{
                let ac = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
                  ac.addAction(UIAlertAction(title: "OK", style: .default))
                  present(ac, animated: true)
            }
        }
    }
    
}


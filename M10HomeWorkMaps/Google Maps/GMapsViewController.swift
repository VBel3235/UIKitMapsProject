//
//  GMapsViewController.swift
//  M10HomeWorkMaps
//
//  Created by Владислав Белов on 05.07.2021.
//

import UIKit
import GoogleMaps

class GMapsViewController: UIViewController {
    
    var mapView = GMSMapView()
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        GMSServices.provideAPIKey("AIzaSyBGDWX1lD9pZVrASq9seNH9O7RQDVnMYZg")
       title = "Шанхай"
        let camera = GMSCameraPosition.camera(withLatitude: 31.224361, longitude: 121.469170, zoom: 9.6)
        mapView = GMSMapView.map(withFrame: view.frame, camera: camera)
            self.view.addSubview(mapView)
        mapView.addSubview(centerButton)
        mapView.addSubview(zoomInButton)
        mapView.addSubview(zoomOutButton)
         
            /*let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
            marker.title = "Sydney"
            marker.snippet = "Australia"
            marker.map = mapView */
        
        
        LocationManager.shared.getUserLocation { location in
            let marker = GMSMarker()
            marker.position = location.coordinate
            marker.title = "Моё местоположение"
            marker.snippet = ""
            marker.map = self.mapView
            
        
        }
        
        
        addConstraints()
        configureButtons()
        createAttractions()
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
                let camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 15)
                strongSelf.mapView.camera = camera
                
                LocationManager.shared.resolveLoactionName(with: location) { [weak self] name in
                    strongSelf.title = name
                }
                
            }
        }
    }
    
    @objc func zoomIn(){
        print("zoomed in")
        
        let cameraUpdate = GMSCameraUpdate.zoomIn()
        mapView.animate(with: cameraUpdate)
       
    }
    
    @objc func zoomOut(){
        let cameraUpdate = GMSCameraUpdate.zoomOut()
        mapView.animate(with: cameraUpdate)
    }
    
    func createAttractions(){
        let AttOne = GMSMarker()
        AttOne.position = CLLocationCoordinate2D(latitude: 31.224361, longitude: 121.439170)
        AttOne.title = "Набережная Вайтан"
        AttOne.snippet = "Популярная пещеходная улица"
        AttOne.icon = UIImage(named: "hangzhou")!
        AttOne.map = self.mapView
        
        let AttTwo = GMSMarker()
        AttTwo.position = CLLocationCoordinate2D(latitude: 31.0524, longitude: 121.6948)
        AttTwo.title = "Парк дикой природы"
        AttTwo.snippet = "Один из самых крупных зоопарков мира"
        AttTwo.icon = UIImage(named: "panda")!
        AttTwo.map = self.mapView
        
        let AttThree = GMSMarker()
        AttThree.position = CLLocationCoordinate2D(latitude: 31.239752, longitude: 121.499588)
        AttThree.title = "Восточная жемчужина"
        AttThree.snippet = "Известная телевизионная башня"
        AttThree.icon = UIImage(named: "shanghai")!
        AttThree.map = self.mapView
        
        let AttFour = GMSMarker()
        AttFour.position = CLLocationCoordinate2D(latitude: 31.143549, longitude: 121.262590)
        AttFour.title = "Храм Нефритового будды"
        AttFour.snippet = "Известный буддийский храм"
        AttFour.icon = UIImage(named: "monument")!
        AttFour.map = self.mapView
        
        let AttFive = GMSMarker()
        AttFive.position = CLLocationCoordinate2D(latitude: 31.043549, longitude: 121.33590)
        AttFive.title = "ВейСянЧжай"
        AttFive.snippet = "Лучший рестаран с лапшой в Шанхае"
        AttFive.icon = UIImage(named: "noodles")!
        AttFive.map = self.mapView
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

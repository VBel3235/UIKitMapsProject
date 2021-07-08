//
//  YMapsViewController.swift
//  M10HomeWorkMaps
//
//  Created by Владислав Белов on 06.07.2021.
//

import UIKit
import YandexMapsMobile

class YMapsViewController: UIViewController, YMKUserLocationObjectListener {
    func onObjectRemoved(with view: YMKUserLocationView) {
        
    }
    
    func onObjectUpdated(with view: YMKUserLocationView, event: YMKObjectEvent) {
        
    }
    
  
    
    
    
    
    var mapView = YMKMapView()
    
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
  
        
        view.addSubview(mapView)
        mapView.frame = view.bounds
        mapView.addSubview(centerButton)
        mapView.addSubview(zoomInButton)
        mapView.addSubview(zoomOutButton)
        mapView.mapWindow.map.move(
            with: YMKCameraPosition.init(target: YMKPoint(latitude: 31.224361, longitude: 121.469170), zoom: 8, azimuth: 0, tilt: 0),
               animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 5),
               cameraCallback: nil)
       
        let scale = UIScreen.main.scale
        let mapKit = YMKMapKit.sharedInstance()
        
        let userLocationLayer = mapKit.createUserLocationLayer(with: mapView.mapWindow)

        userLocationLayer.setVisibleWithOn(true)
        userLocationLayer.isHeadingEnabled = true
   
        userLocationLayer.setObjectListenerWith(self)
        
configureButtons()
        
        addAttractions()
        addConstraints()
        // Do any additional setup after loading the view.
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
                strongSelf.mapView.mapWindow.map.move(with: YMKCameraPosition.init(target: YMKPoint.init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), zoom: 8, azimuth: 0, tilt: 0))
                
                LocationManager.shared.resolveLoactionName(with: location) { [weak self] name in
                    strongSelf.title = name
                }
                
            }
        }
    }
    
    @objc func zoomIn(){
        print("zoomed in")
        let zoom = mapView.mapWindow.map.cameraPosition
        mapView.mapWindow.map.move(with: YMKCameraPosition.init(target: YMKPoint.init(latitude: mapView.mapWindow.map.cameraPosition.target.latitude, longitude: mapView.mapWindow.map.cameraPosition.target.longitude), zoom: zoom.zoom + 1.5, azimuth: 0, tilt: 0))
       
    }
    
    @objc func zoomOut(){
        let zoom = mapView.mapWindow.map.cameraPosition
        mapView.mapWindow.map.move(with: YMKCameraPosition.init(target: YMKPoint.init(latitude: mapView.mapWindow.map.cameraPosition.target.latitude, longitude: mapView.mapWindow.map.cameraPosition.target.longitude), zoom: zoom.zoom - 1.5, azimuth: 0, tilt: 0))
    }
    
    func addAttractions(){
        let mapObjects = mapView.mapWindow.map.mapObjects
        let style = YMKIconStyle(
            anchor: CGPoint(x: 5, y: 5) as NSValue,
            rotationType:YMKRotationType.rotate.rawValue as NSNumber,
            zIndex: 5,
            flat: true,
            visible: true,
            scale: 5,
            tappableArea: nil)
        
        let textViewOne =
            UITextView(frame: CGRect(x: 0, y: 0, width: 200, height: 30));
        let pointOne = YMKPoint(latitude: 31.224361, longitude: 121.469170)
        textViewOne.text = "Набережная Вайтан"
        let viewProviderOne = YRTViewProvider(uiView: textViewOne)!;
        let placemarkOne = mapObjects.addPlacemark(with: pointOne, view: viewProviderOne)
        placemarkOne.opacity = 1
        placemarkOne.isDraggable = true
        placemarkOne.setIconStyleWith(style)
        placemarkOne.setIconWith(UIImage(named: "hangzhou")!)
        
        let textViewTwo =
            UITextView(frame: CGRect(x: 0, y: 0, width: 200, height: 30));
        let pointTwo = YMKPoint(latitude: 31.0524, longitude: 121.6948)
        textViewTwo.text = "Парк дикой природы"
        let viewProviderTwo = YRTViewProvider(uiView: textViewOne)!;
        let placemarkTwo = mapObjects.addPlacemark(with: pointTwo, view: viewProviderTwo)
        placemarkTwo.opacity = 1
        placemarkTwo.isDraggable = true
        placemarkTwo.setIconStyleWith(style)
        placemarkTwo.setIconWith(UIImage(named: "panda")!)
        
        let textViewThree =
            UITextView(frame: CGRect(x: 0, y: 0, width: 200, height: 30));
        let pointThree = YMKPoint(latitude: 31.239752, longitude: 121.499588)
        textViewTwo.text = "Восточная жемчужина"
        let viewProviderThree = YRTViewProvider(uiView: textViewThree)!;
        let placemarkThree = mapObjects.addPlacemark(with: pointThree, view: viewProviderThree)
        placemarkThree.opacity = 1
        placemarkThree.isDraggable = true
        placemarkThree.setIconStyleWith(style)
        placemarkThree.setIconWith(UIImage(named: "shanghai")!)
        
        
        let textViewFour =
            UITextView(frame: CGRect(x: 0, y: 0, width: 200, height: 30));
        let pointFour = YMKPoint(latitude: 31.143549, longitude: 121.262590)
        textViewTwo.text = "Храм Нефритового будды"
        let viewProviderFour = YRTViewProvider(uiView: textViewFour)!;
        let placemarkFour = mapObjects.addPlacemark(with: pointFour, view: viewProviderFour)
        placemarkFour.opacity = 1
        placemarkFour.isDraggable = true
        placemarkFour.setIconStyleWith(style)
        placemarkFour.setIconWith(UIImage(named: "monument")!)
        
        
        let textViewFive =
            UITextView(frame: CGRect(x: 0, y: 0, width: 200, height: 30));
        let pointFive = YMKPoint(latitude: 31.043549, longitude: 121.33590)
        textViewTwo.text = "ВейСянЧжай"
        let viewProviderFive = YRTViewProvider(uiView: textViewFive)!;
        let placemarkFive = mapObjects.addPlacemark(with: pointFive, view: viewProviderFive)
        placemarkFive.opacity = 1
        placemarkFive.isDraggable = true
        placemarkFive.setIconStyleWith(style)
        placemarkFive.setIconWith(UIImage(named: "noodles")!)
        
        
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
    
    func onObjectAdded(with view: YMKUserLocationView) {
        view.arrow.setIconWith(UIImage(named:"UserArrow")!)
        
        let pinPlacemark = view.pin.useCompositeIcon()
        
        pinPlacemark.setIconWithName("icon",
            image: UIImage(named:"UserArrow")!,
            style:YMKIconStyle(
                anchor: CGPoint(x: 0, y: 0) as NSValue,
                rotationType:YMKRotationType.rotate.rawValue as NSNumber,
                zIndex: 0,
                flat: true,
                visible: true,
                scale: 1.5,
                tappableArea: nil))
        
    

        view.accuracyCircle.fillColor = UIColor.blue
    }

}

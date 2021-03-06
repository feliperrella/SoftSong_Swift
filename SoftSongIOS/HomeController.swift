//
//  HomeController.swift
//  SoftSongIOS
//
//  Created by Felipe  Perrella on 15/05/19.
//  Copyright © 2019 Felipe Perrella. All rights reserved.
//

import UIKit

extension UIView {
    func elevate(elevation: Double) {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: elevation)
        self.layer.shadowRadius = abs(CGFloat(elevation))
        
        self.layer.shadowOpacity = 0.24
    }
}

class HomeController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(self.IDPost.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "post", for: indexPath) as! HomeTableViewCell
        cell.txtUsername?.text = (Username[indexPath.row])
        cell.txtLikes?.text = Int(Likou[indexPath.row]) == 1 ? "\(Likou[indexPath.row]) like" : "\(Likou[indexPath.row]) likes"
        cell.txtPost?.text = ("\(Username[indexPath.row]): \(Legenda[indexPath.row])")
        cell.txtData?.text = (Data_Horario[indexPath.row])
        cell.postID = IDPost[indexPath.row]
        if(Likou[indexPath.row] == "1")
        {
            cell.liked = true
            cell.btnLike.setImage(UIImage(named: "icons8-copas-100-2"), for: UIControl.State.normal)
        }
        let urll : NSURL! = NSURL(string: "http://\(ViewController.IP)/slider.php?id=\(IDPost[indexPath.row])")
        cell.controller = "home"
        cell.Slider.loadRequest(NSURLRequest(url: urll as URL) as URLRequest)
        cell.Slider.scalesPageToFit = true;
        let u = "http://\(ViewController.IP)/pictures/\(Caminho_imagem[indexPath.row])"
        print(u)
        let url = URL(string: u)
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                cell.PicPerfil.image = UIImage(data: data!)
            }
        }
        
        return(cell)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    @IBAction func btnReload(_ sender: Any) {
        self.DownloadJSON()
    }

    
    @IBOutlet var MainView: UIView!
    @IBOutlet weak var tblPosts: UITableView!
    var Curtidas = [String]()
    var Likou = [String]()
    var Username = [String]()
    var Caminho_imagem = [String]()
    var ID_Usuario = [String]()
    var IDPost = [String]()
    var Titulo = [String]()
    var Legenda = [String]()
    var Data_Horario = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        let userLogged = defaults.string(forKey: "id")
        print(userLogged!)
        DownloadJSON()
    }
    
    static func Comentar()
    {
         print(HomeTableViewCell.idp)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "comments") as! CommentsController
        appDelegate.window? = UIWindow(frame: UIScreen.main.bounds)
        appDelegate.window?.rootViewController = initialViewControlleripad
        appDelegate.window?.makeKeyAndVisible()
    }
    
    func DownloadJSON()
    {
        Curtidas.removeAll()
        Likou.removeAll()
        Username.removeAll()
        Caminho_imagem.removeAll()
        ID_Usuario.removeAll()
        IDPost.removeAll()
        Titulo.removeAll()
        Legenda.removeAll()
        Data_Horario.removeAll()



        let defaults = UserDefaults.standard
        let userLogged = defaults.string(forKey: "id")
        let url = NSURL(string: "http://\(ViewController.IP)/PostDeals.php?id=\(userLogged!)")
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                print(jsonObj.value(forKey: "posts") as Any)
                
                if let actorArray = jsonObj.value(forKey: "posts") as? NSArray {
                    for actor in actorArray{
                        if let actorDict = actor as? NSDictionary {
                            if let name = actorDict.value(forKey: "curtidas") {
                                self.Curtidas.append(name as! String)
                            }
                            if let name = actorDict.value(forKey: "likou") {
                                self.Likou.append(name as! String)
                            }
                            if let name = actorDict.value(forKey: "username") {
                                self.Username.append(name as! String)
                            }
                            if let name = actorDict.value(forKey: "caminho_imagem") {
                                self.Caminho_imagem.append(name as! String)
                            }
                            if let name = actorDict.value(forKey: "ID_Usuario") {
                                self.ID_Usuario.append(name as! String)
                            }
                            if let name = actorDict.value(forKey: "IDPost") {
                                self.IDPost.append(name as! String)
                            }
                            if let name = actorDict.value(forKey: "legenda") {
                                self.Legenda.append(name as! String)
                            }
                            if let name = actorDict.value(forKey: "data_horario") {
                                self.Data_Horario.append(name as! String)
                            }
                            
                        }
                    }
                    //print(self.Username[2])
                }
                
                OperationQueue.main.addOperation({
                    self.tblPosts.reloadData()
                })
            }
        }).resume()
    }
    

}

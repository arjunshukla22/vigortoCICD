//
//  createPostViewController.swift
//  SmileIndia
//
//  Created by Sakshi Gothi on 28/01/21.
//  Copyright © 2021 Na. All rights reserved.

import UIKit
import MaterialComponents.MaterialChips
import BSImagePicker
import Photos
import OpalImagePicker



class createPostViewController: UIViewController,UITextViewDelegate,TagListViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate , UICollectionViewDelegateFlowLayout, tagSearchVCDelegate {
    
    //var tagarray =
    var insuranceListforSearch = [InsuranceList]()
    var insurancePlanID = 0
    var memberFiles = [MemberFiles]()
    var selectedAssets = [PHAsset]()
    var imageArray = [UIImage]()
    var taglist = [String]()
    var tagListID = [String]()
    var dict = [String: Any]()
    let viewmodel = SignupViewModel()
    let pvStart = UIPickerView()
    var spid = 0
    var recBlog : ListPost?
    
    var TagID = [Int]()
    var array = [[String: Int]]()
    var selectedStart = 0
    var selectedID = 0
    var doctor: DoctorData?
    var allowEditing = true
    var dpurl = ""
    lazy var pickerController: UIImagePickerController = {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.allowsEditing = self.allowEditing
        return controller
    }()
    
    @IBOutlet weak var TagScrollView: UIScrollView!
    @IBOutlet weak var addImageBtn: UIButton!
    @IBOutlet weak var postTextBodyTF: UITextView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var TagListView: TagListView!
    @IBOutlet weak var tagtf: CustomTextfield!
    @IBOutlet weak var tittleTextField: UITextField!
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var tagDropButton: UIButton!
    // @IBOutlet weak var chipview: MDCChipView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        hideKeyboardWhenTappedAround()
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        
        
        
        profileName.text = "\(Authentication.customerName ?? "") "
        tittleTextField.text = /recBlog?.Title
        if /recBlog?.Body?.isEmpty{
            postTextBodyTF.textColor = UIColor.lightGray
        }
        else{
            postTextBodyTF.text = /recBlog?.Body
        }
        // taglist = recBlog?.CategoryArray ?? []
        
        
        
        
        postTextBodyTF.delegate = self
        tittleTextField.delegate = self
        //    postTextBodyTF.text = "What is in your mind ?"
        //   postTextBodyTF.textColor = UIColor.lightGray
        hideKeyboardWhenTappedAround()
        
        setStatusBar(color: .themeGreen)
        
        TagListView.delegate = self
        if (recBlog?.CategoryArray == []){
            
        }
        else{
            taglist = recBlog?.CategoryArray ?? []
            print(taglist)
            tagListID = recBlog?.CategoryIdArray ?? []
            print(taglist)
            let tagids = recBlog?.CategoryIdArray ?? []
            for tagid in tagids {
                array.append(["tagID": tagid.toInt() ?? 0])
                TagID.append(tagid.toInt() ?? 0)
            }
            let names = recBlog?.CategoryArray ?? []
            for name in names {
                
                TagListView.addTag(name ?? "")
                
            }
        }
        
        viewmodel.getTag(){
            
            self.createPicker()
            self.dismissPickerView()
            
            self.view.activityStopAnimating()
        }
        activityIndicator.hideLoader()
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.getprofile()
        self.profileImage.sd_setImage(with: self.doctor?.profileImageURL, placeholderImage: UIImage.init(named: "doctor-avtar"))
        
    }
    func getprofile(){
        WebService.getDoctorProfile(queryItems: ["LoginKey": Authentication.token ?? "YXNob2ttaXR0YWxAZ21haWwuY29tOjEyMzQ1Ng=="]) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if let user = response.object {
                        self.doctor = user
                        self.dpurl = user.ProfileImage ?? ""
                        self.setView()
                        print(self.dpurl)
                    } else {
                    }
                case .failure(let error):
                    print(error.message)
                    
                }
            }
        }
    }
    func setView(){
        DispatchQueue.main.async {
            self.profileImage.sd_setImage(with: self.doctor?.profileImageURL, placeholderImage: UIImage.init(named: "i"))
        }
        
    }
    
    @IBAction func didTapTags(_ sender: Any) {
        self.presentInsuranceSreen()
    }
    
    
    func presentInsuranceSreen(){
        let showItemStoryboard = UIStoryboard(name: "insurance", bundle: nil)
        let showItemNavController = showItemStoryboard.instantiateViewController(withIdentifier: "tagSearchVC") as! tagSearchVC
        showItemNavController.insuranceList = self.insuranceListforSearch
        showItemNavController.delegate = self
        present(showItemNavController, animated: true, completion: nil)
    }
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = !tagView.isSelected
        print(self.taglist)
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        sender.removeTagView(tagView)
        print(tagView.titleLabel?.text)
        let indexOfA = self.taglist.index(of: tagView.titleLabel?.text ?? "")
        self.taglist.remove(at: (indexOfA ?? 0))
        self.TagID.remove(at: (indexOfA ?? 0))
        self.array.remove(at: (indexOfA ?? 0))
        print(array)
        
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if ((recBlog?.Body?.isEmpty) != nil){
            if postTextBodyTF.text == "What's on your mind" {
                postTextBodyTF.text = nil
                if #available(iOS 13.0, *) {
                    postTextBodyTF.textColor = UIColor.label
                } else {
                    postTextBodyTF.textColor = UIColor.darkGray
                }
            }
        }
        else{
            postTextBodyTF.textColor = UIColor.darkGray
        }
        
    }
    
    func createPicker() -> Void {
        pvStart.delegate = self
        tagtf.rightViewMode = UITextField.ViewMode.always
        tagtf.rightView = UIImageView(image: UIImage(named: "dropdown"))
        tagtf.inputView = pvStart
        
        
    }
    func dismissPickerView() {
        
        
        
        //tagtf.inputView = pickerView
        // tagtf.inputAccessoryView = toolBar
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let button = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.action))
        let button2 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action1))
        button.tintColor = .lightGray
        button2.tintColor = .darkGray
        toolBar.setItems([button], animated: true)
        toolBar.setItems([button2], animated: true)
        toolBar.isUserInteractionEnabled = true
        tagtf.inputAccessoryView = toolBar
        print(self.taglist)
        
    }
    @objc func action1() {
        if tagtf.isEditing == true {
            //   TagID.append(self.viewmodel.socioTags[selectedStart].Id ?? 0)
            
            if taglist.count < 10 {
                let item = /self.viewmodel.socioTags[selectedStart].id
                print(taglist)
                if TagID.contains(item) {
                    self.view.endEditing(true)
                    print(TagID)
                }else{
                    
                    taglist.append(self.viewmodel.socioTags[selectedStart].name ?? "")
                    print(taglist)
                    TagListView.addTag(self.viewmodel.socioTags[selectedStart].name ?? "")
                    array.append(["tagID": self.viewmodel.socioTags[selectedStart].id ?? 0])
                    TagID.append(self.viewmodel.socioTags[selectedStart].id ?? 0)
                    print(self.viewmodel.socioTags[selectedStart].name ?? "")
                    
                    //  print(TagID)
                    print(array)
                    print(taglist)
                    self.view.endEditing(true)
                    
                }
                
                
            }else{
                AlertManager.showAlert(type: .custom("Maximum 10 tags can be Selected!"))
                self.view.endEditing(true)
                TagListView.sizeToFit()
                TagListView.layoutIfNeeded()
                TagListView.layoutSubviews()
                
                print(TagListView)
            }
            
        }
        
    }
    
    
    @objc func action() {
        if tagtf.isEditing == true {
            self.dismissPickerView()
            
        }
        
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        NavigationHandler.pop()
    }
    @IBAction func didTapImage(_ sender: Any) {
        self.showOptions()
    }
    
    @IBAction func didTapDropTag(_ sender: Any) {
        
        
    }
    
    //this method is for the size of items
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //   let width = collectionView.frame.width/3
        //   let height : CGFloat = 180.0
        return CGSize(width: 80, height: 80)
    }//these methods are to configure the spacing between items
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
        // return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let memberFiles = self.imageArray[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemberFilesCell", for: indexPath) as! MemberFilesCell
        
        cell.img.image = imageArray[indexPath.row]
        
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action:  #selector(deleteBtnPressed(sender:)), for: .touchUpInside)
        // cell.viewfullBtn.tag = indexPath.row
        // cell.viewfullBtn.addTarget(self, action:  #selector(viewfullBtnPressed(sender:)), for: .touchUpInside)
        
        cell.deleteBtn.isHidden = (Authentication.customerType == "Doctor")
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    @objc func deleteBtnPressed(sender: UIButton) {
        AlertManager.showAlert(type: .custom("Are you sure to delete this file ?"), actionTitle: AlertBtnTxt.okay.localize()) {
            let memberFiles = self.imageArray[sender.tag]
            //  let indexOfA = self.imageArray.index(of: imageArray.titleLabel?.text ?? "")
            //    self.taglist.remove(at: (indexOfA ?? 0))
            
        }
    }
    
    
    func showOptions(){
        let alert:UIAlertController=UIAlertController(title: "Select Images From", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Photo", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openMultipleImageSelector()
        }
        let VideoAction = UIAlertAction(title: "Video", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openVideoGallery()
        }
        
        let cancelAction = UIAlertAction(title: AlertBtnTxt.cancel.localize(), style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(VideoAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        let sourceType =  UIImagePickerController.SourceType.camera
        if  UIImagePickerController.isSourceTypeAvailable(sourceType)  {
            self.pickerController.sourceType = sourceType
            self.present(self.pickerController, animated: true, completion: nil)
        }
        else {
            AlertManager.showAlert(type: Prompt.custom("Don't have camera access"))
        }
    }
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        
        return nil
    }
    func openVideoGallery()
    {
        let picker = UIImagePickerController()
        picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        picker.sourceType = .savedPhotosAlbum
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum)!
        picker.mediaTypes = ["public.movie"]
        
        picker.allowsEditing = false
        present(picker, animated: true, completion: nil)
        
        
    }
    
    
    func openMultipleImageSelector() -> Void {
        
        
        
        let imagePicker = OpalImagePickerController()
        imagePicker.maximumSelectionsAllowed = 5
        presentOpalImagePickerController(imagePicker, animated: true,
                                         select: { (assets) in
                                            //Select Assets
                                            
                                            self.selectedAssets = assets
                                            for i in 0...self.selectedAssets.count-1{
                                                
                                                let manager = PHImageManager.default()
                                                let option = PHImageRequestOptions()
                                                option.isSynchronous = true
                                                option.deliveryMode = .highQualityFormat
                                                option.resizeMode = .exact
                                                
                                                manager.requestImage(for: self.selectedAssets[i], targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: option) { (image, info) in
                                                    self.imageArray.append(image ?? UIImage())
                                                    self.imageCollectionView.reloadData()
                                                }
                                            }
                                            
                                            self.dismiss(animated: true, completion: nil)
                                            
                                         }, cancel: {
                                            //Cancel
                                         })
        
        
    }
    
    
    
    @IBAction func chip(_ sender: Any) {
        let chipView = MDCChipView()
        chipView.titleLabel.text = "Tap me"
        chipView.setTitleColor(UIColor.red, for: .selected)
        chipView.sizeToFit()
        chipView.addTarget(self, action: #selector(didTapChangePassword), for: .touchUpInside)
        self.view.addSubview(chipView)
        /*   MDCChipField = [[MDCChipField, alloc] init]
         chipField.delegate = self;
         chipField.textField.placeholderLabel.text = @"This is a chip field.";
         chipField.showChipsDeleteButton = true
         [chipField sizeToFit];
         [self.view addSubview:chipField];*/
    }
    
    func createdict(){
        if isValid() {
            dict["LoginKey"] = Authentication.token ?? ""
            dict["PostText"] = postTextBodyTF.text
            dict["IsApp"] = "true"
            dict["BlogTitle"] = tittleTextField.text ?? ""
            dict["BlogPostId"] = recBlog?.Id ?? 0
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try! encoder.encode(array)
            let json = String(data: data, encoding: .utf8)!
            dict["TagsJsonList"] = array
            print(json)
            
        }
    }
    func AddpostApiHit(){
        
        let paramItems = dict
        
        
        
        WebService.AddPost(queryItems: paramItems) { (result) in
            
            DispatchQueue.main.async {
                
                switch result {
                
                case .success(let response):
                    
                    print(response.message)
                    
                    AlertManager.showAlert(type: .custom(response.message ?? ""))
                    
                case .failure(let error):
                    
                    AlertManager.showAlert(type: .custom(error.message))
                    
                }
                
            }
            
        }
        
    }
    
    @IBAction func didTapChangePassword(_ sender: Any) {
        print("tapped")
        if isValid() {
            createdict()
            self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
            //  AddpostApiHit()
            self.view.activityStopAnimating()
            print("tapped")
            self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
            let json = try? JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            let parameters = String(data: json ?? Data(), encoding: String.Encoding.utf8) ?? ""
            let postData = parameters.data(using: .utf8)
            
            // print(postData)
            
            let apiUrl = APIConstants.mainUrl + "Api/AddPost"
            var request = URLRequest(url: URL(string: apiUrl)!,timeoutInterval: Double.infinity)
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
            
            request.httpMethod = "POST"
            request.httpBody = postData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    print(String(describing: error))
                    return
                }
                print(String(data: data, encoding: .utf8)!)
                print("**")
                
                DispatchQueue.main.async {
                    
                }
            }
            self.view.activityStopAnimating()
            if recBlog?.Id ?? 0 > 0{
                AlertManager.showAlert(type: .custom("Post Edited successfully !!")){
                    NavigationHandler.pushTo(.feed)
                }
            }
            else{
                AlertManager.showAlert(type: .custom("Post Added successfully !!")){
                    NavigationHandler.pushTo(.feed)
                }
            }
            task.resume()
            
        }
    }
    
    func isValid() -> Bool {
        let trimmed = postTextBodyTF.text.trimmingCharacters(in: .whitespacesAndNewlines)
        print(trimmed)
        if postTextBodyTF.text == "" || trimmed == ""{
            AlertManager.showAlert(type: .custom("Please write what's in your mind."))
            postTextBodyTF.becomeFirstResponder()
            return false
        } else if  postTextBodyTF.textColor == UIColor.lightGray {
            AlertManager.showAlert(type: .custom("Please write what's in your mind."))
            postTextBodyTF.becomeFirstResponder()
            return false
        }
        return true
        
    }
    
    
}


extension createPostViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.viewmodel.socioTags.count
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = .systemFont(ofSize: 014)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = self.viewmodel.socioTags[row].name ?? ""
        return pickerLabel!
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.viewmodel.socioTags[row].name ?? ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedStart = row
    }
    
}
extension createPostViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            DispatchQueue.main.async {
                if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                    self.imageArray.append(image)
                    self.imageCollectionView.reloadData()
                    // self.selectedLabel.text = "You have selected \(self.imageArray.count) files"
                } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    self.imageArray.append(image)
                    self.imageCollectionView.reloadData()
                    // self.selectedLabel.text = "You have selected \(self.imageArray.count) files"
                }
            }
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
extension createPostViewController:InsuranceSearchVCDelegate{
    func selectedInsurance(planName: String, planID: Int, providerID: Int, isAccepted: Bool) {
        self.insurancePlanID = planID
        // self.insuranceBtn.setTitle(planName, for: .normal)
        //  self.clearInsuranceButton.setImage(UIImage(named: "cancel.png"), for: .normal)
        //self.isCheckDoctorAcceptedInsurance(insurancePlanId: planID)
    }
    
}





//
//  DayAddViewController.swift
//  KeKi
//
//  Created by 유상 on 2023/02/03.
//

import UIKit

// 임시 데이터
enum DayType: String {
    case dDay = "디데이"
    case numDay = "날짜수"
    case repeatDay = "매년 반복"
    case none = "기념일 종류"
}


class DayAddViewController: UIViewController {
    
    @IBOutlet weak var dayTypeLabel: UILabel!
    
    @IBOutlet weak var dayTypeSelectButton: UIButton!
    @IBOutlet weak var dDayButton: UIButton!
    @IBOutlet weak var dayNumButton: UIButton!
    @IBOutlet weak var dayRepeatButton: UIButton!
    @IBOutlet weak var selectButtonView: UIView!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var dateSelectButton: UIButton!
    @IBOutlet weak var dateSelectPicker: UIDatePicker!
    @IBOutlet weak var datePickerView: UIView!
    
    @IBOutlet weak var waringView: UIView!
    @IBOutlet weak var waringTextField: UILabel!
    
    @IBOutlet weak var hashTagCV: UICollectionView!
    
    @IBOutlet weak var selectButtonViewHeight: NSLayoutConstraint!
    @IBOutlet weak var datePickerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var waringViewHeight: NSLayoutConstraint!
    // 네비게이션 연결 시 완료 버튼 추가하여 titleLabel 비어있을 시 priority 값 줄여서 나타내기
    
    var isSelectViewOpen = false
    var isDatePickerViewOpen = false
    var isTitleTextWrite = false
    
    var dayType: DayType = .none
    
    var calendar: Calendar?
    var calendarIdx: Int?
    
    let colorList: Array<UIColor> = [
        UIColor(red: 252.0 / 255.0, green: 244.0 / 255.0, blue: 223.0 / 255.0, alpha: 1),
        UIColor(red: 250.0 / 255.0, green: 236.0 / 255.0, blue: 236.0 / 255.0, alpha: 1),
        UIColor(red: 244.0 / 255.0, green: 203.0 / 255.0, blue: 203.0 / 255.0, alpha: 1)
    ]
    
    var hashTagList: Array<(String, Bool)> = []
    
    var selectHashTagCount = 0
    
    var date:Date?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchHashTagList()
        setup()
        setupLayer()
        setupNavigationBar()
    }
    
    // 데이터 연결 할 때 모델 만들어 편집 구현 -> 모델 넘김 받을 시 해당 데이터 모두 표시 / 없다면 지금 이대로 표시
    func setup() {
        hashTagCV.dataSource = self
        hashTagCV.delegate = self
        
        if calendar == nil {
            titleTextField.attributedPlaceholder = NSAttributedString(string: "기념일 제목을 입력해주세요.", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 128.0 / 250.0, green: 128.0 / 250.0, blue: 128.0 / 250.0, alpha: 1)])
            dateSelectButton.setTitle("날짜를 선택해주세요.", for: .normal)
        }else {
            titleTextField.text = calendar?.title
            dateSelectButton.setTitle(calendar?.date, for: .normal)
            
            print(hashTagList.count)
            
            switch calendar?.kindOfCalendar {
                case DayType.dDay.rawValue:
                    dayType = .dDay
                case DayType.numDay.rawValue:
                    dayType = .numDay
                case DayType.repeatDay.rawValue:
                    dayType = .repeatDay
                default:
                    return
            }
            
            selectHashTagCount = calendar?.hashTags.count ?? 0
            
            
            let dateFromat = DateFormatter()
            dateFromat.dateFormat = "yyyy-MM-dd"
            
            date = dateFromat.date(from: calendar?.date ?? "")
            dateSelectPicker.date = date ?? Date()
        }
        
        
        dateSelectPicker.addTarget(self, action: #selector(selectDate), for: .valueChanged)
    }
    
    
    func setupLayer() {
        [dayTypeSelectButton, dDayButton, dayNumButton, dayRepeatButton, titleTextField].forEach {
            $0.contentHorizontalAlignment = .left
        }
        
        [selectButtonView, titleTextField, datePickerView].forEach {
            $0?.layer.shadowColor = CGColor(red: 152.0 / 255.0, green: 113.0 / 255.0, blue: 113.0 / 255.0, alpha: 0.15)
            $0?.layer.shadowOffset = CGSize(width: 3, height: 3)
            $0?.layer.shadowRadius = 13
            $0?.layer.shadowOpacity = 1.0
            $0?.layer.cornerRadius = 10
        }
        dayTypeSelectButton.setTitle(dayType.rawValue, for: .normal)
        dayTypeSelectButton.setImage(UIImage(named: "downButton"), for: .normal)
        dDayButton.setTitle(DayType.dDay.rawValue, for: .normal)
        dayNumButton.setTitle(DayType.numDay.rawValue, for: .normal)
        dayRepeatButton.setTitle(DayType.repeatDay.rawValue, for: .normal)
        
        titleTextField.layer.borderWidth = 0
        titleTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        titleTextField.leftViewMode = .always
        titleTextField.addLeftPadding()
        
        dateSelectButton.setImage(UIImage(named: "calendar"), for: .normal)
        dateSelectButton.titleLabel?.frame = CGRect(x: 40, y: 455, width: 256, height: 20)
        dateSelectButton.imageView?.frame = CGRect(x: 312, y: 453, width: 24, height: 24)
        
        [dDayButton, dayNumButton, dayRepeatButton, dateSelectPicker].forEach {
            $0?.isHidden = true
        }
        
        waringTextField.isHidden = true
        
        selectButtonView.layer.masksToBounds = false
        datePickerView.layer.masksToBounds = false
        waringView.layer.masksToBounds = false
    }
    
    @objc func selectDate() {
        let dateFromat = DateFormatter()
        dateFromat.dateFormat = "yyyy-MM-dd"

        dateSelectButton.setTitle(dateFromat.string(from: dateSelectPicker.date), for: .normal)
        
        date = dateSelectPicker.date
    }
    
    func setupNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
        
        let title = UILabel()
        title.text = "기념일 추가"
        title.font = .systemFont(ofSize: 20, weight: .bold)
        title.textAlignment = .left
        title.sizeToFit()

        let titleItem = UIBarButtonItem(customView: title)
        
        let backButton = UIBarButtonItem(image: UIImage(named: "back"), style: .done, target: self, action: #selector(moveToCalendar))
        backButton.tintColor = .black
        
        self.navigationItem.leftBarButtonItems = [backButton, titleItem]
        
        // action에 addDay 추가 (서버 연결 후)
        let addButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(addDay))
        addButton.tintColor = .black
        
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func moveToCalendar() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addDay() {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let dateText = dateFormat.string(from: date ?? Date())
        var hashTags: [HashTagList] = []
        hashTagList.forEach {
            if $0.1 == true {
                hashTags.append(HashTagList(calendarHashTag: $0.0))
            }
        }
        
        let calendarRequest = CalendarRequest(kindOfCalendar: dayType.rawValue, title: titleTextField.text ?? "", date: dateText, hashTags: hashTags)
        
        if titleTextField.text == nil || titleTextField.text == "" {
            isTitleTextWrite = true
            waringViewHeight.priority = UILayoutPriority(100)
            waringTextField.isHidden = false
            waringView.layer.masksToBounds = false
            
        }
        
        
        if calendar != nil {
            updateDate(calendarRequest: calendarRequest, calendarIdx: calendarIdx ?? 0)
        }else {
            addDate(calendarRequest: calendarRequest)
        }
    }

    
    @IBAction func openDayTypeView(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            if self.isSelectViewOpen == false {
                self.selectButtonViewHeight.priority = UILayoutPriority(100)
                
                [self.dDayButton, self.dayNumButton, self.dayRepeatButton].forEach {
                    $0?.layer.isHidden = false
                }
                self.selectButtonView.layer.masksToBounds = false
                
            }else {
                self.selectButtonViewHeight.priority = UILayoutPriority(1000)
                
                
                [self.dDayButton, self.dayNumButton, self.dayRepeatButton].forEach {
                    $0?.layer.isHidden = true
                }
                self.selectButtonView.layer.masksToBounds = true

            }
        }
        self.view.layoutIfNeeded()
        
        isSelectViewOpen.toggle()
    }
    
    
    @IBAction func openDatePickerView(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            if self.isDatePickerViewOpen == false {
                self.datePickerViewHeight.priority = UILayoutPriority(240)
                
                self.dateSelectPicker.isHidden = false
                self.datePickerView.layer.masksToBounds = false
            }else {
                self.datePickerViewHeight.priority = UILayoutPriority(1000)
        
                self.dateSelectPicker.isHidden = true
                self.datePickerView.layer.masksToBounds = true
            }
        }
        self.view.layoutIfNeeded()
       
        
        isDatePickerViewOpen.toggle()
    }
    
    
    @IBAction func setDayType(_ sender: UIButton) {
        if sender.titleLabel?.text == DayType.dDay.rawValue {
            dayType = .dDay
        }else if sender.titleLabel?.text == DayType.numDay.rawValue {
            dayType = .numDay
        }else if sender.titleLabel?.text == DayType.repeatDay.rawValue {
            dayType = .repeatDay
        }
        dayTypeSelectButton.setTitle(dayType.rawValue, for: .normal)
    }
    
    
    
    
}


extension DayAddViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return hashTagList.count / 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HashTagCell", for: indexPath)
        
        if let hashTag = cell as? HashTagCell {
            
            
            hashTag.backgroundColor = .gray
            
            hashTag.layer.shadowColor = CGColor(red: 152.0 / 255.0, green: 113.0 / 255.0, blue: 113.0 / 255.0, alpha: 0.15)
            hashTag.layer.shadowOffset = CGSize(width: 0, height: 3)
            hashTag.layer.shadowRadius = 6
            hashTag.layer.shadowOpacity = 1.0
            hashTag.layer.masksToBounds = false
            
            if hashTagList[indexPath.row + (indexPath.section * 4)].1 {
                hashTag.backgroundColor = colorList[indexPath.row % 3]
            }
            hashTag.setHashTagLabel(hashTag: "# " + hashTagList[indexPath.row + (indexPath.section * 4)].0)
            
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let labelTmp = UILabel()
        labelTmp.text = "# " + hashTagList[indexPath.row + (indexPath.section * 4)].0
       
        return CGSize(width: labelTmp.intrinsicContentSize.width + 20, height: 26)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        

        if hashTagList[indexPath.row + (indexPath.section * 4)].1 {
            selectHashTagCount -= 1
            hashTagList[indexPath.row].1.toggle()
        }else {
            if selectHashTagCount > 2 {
                return
            }
            selectHashTagCount += 1
            hashTagList[indexPath.row + (indexPath.section * 4)].1.toggle()
        }

        hashTagList.sort {
            $0.1 && !$1.1
        }
        
        collectionView.reloadData()
    }
}

extension DayAddViewController {
    func fetchHashTagList() {
        APIManeger.shared.getData(urlEndpointString: "/calendars/categories", dataType: HashTagListResponse.self, header: APIManeger.buyerTokenHeader) { [weak self] response in

            response.result.forEach { hashTag in
                self?.hashTagList.append((hashTag.tagName, false))
            }
            
            if self?.calendar != nil {
                self?.hashTagList.enumerated().forEach {
                    var hashTag = $1
                    self?.calendar?.hashTags.forEach{
                        if hashTag.0.description == $0.calendarHashTag.description {
                            hashTag.1 = true
                        }
                    }
                    
                    if hashTag.1{
                        self?.hashTagList[$0].1 = true
                    }
                }
            }
            self?.hashTagList.sort {
                $0.1 && !$1.1
            }
            self?.hashTagCV.reloadData()
        }
    }
    
    func updateDate(calendarRequest: CalendarRequest, calendarIdx: Int) {
        APIManeger.shared.patchData(urlEndpointString: "/calendars/\(calendarIdx)/edit", dataType: CalendarRequest.self, header: APIManeger.buyerTokenHeader, parameter: calendarRequest) { [weak self] response in
            if response.isSuccess == true {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func addDate(calendarRequest: CalendarRequest) {
        APIManeger.shared.postData(urlEndpointString: "/calendars", dataType: CalendarRequest.self, header: APIManeger.buyerTokenHeader, parameter: calendarRequest) { [weak self] response in
            if response.isSuccess == true {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}

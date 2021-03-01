//
//  CalendarView.swift
//  TaskList
//
//  Created by Admin on 2021/02/27.
//

import UIKit

class CalendarView: UIView, UIScrollViewDelegate {
    
    var didSelectDate: ((_ date: Date) -> ())?
    
    private let calendarManager = CalendarManager()
    private let weekArray = Date().weeks(.shortStandalone, locale: .japan)
    
    private var currentYear: Int = 0
    private var currentMonth: Int = 0
    private var currentDay: Int = 0
    
    private var currentDate = Date()
    
    private var getNextMonth: Date!
    private var getPrevMonth: Date!
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = UIColor.scheme.secondaryBackground
        sv.isPagingEnabled = true
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    private let prevMonthButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.scheme.secondaryBackground
        let image = UIImage(named: "chevron_left")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.scheme.button
        button.imageEdgeInsets.left = 16
        button.clipsToBounds = true
        return button
    }()
    
    @objc private func handlePrevMonth() {
        // Show previous month calendar
        scrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
    }
    
    private let nextMonthButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.scheme.secondaryBackground
        let image = UIImage(named: "chevron_right")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.scheme.button
        button.imageEdgeInsets.right = 16
        button.clipsToBounds = true
        return button
    }()
    
    @objc private func handleNextMonth() {
        // Show next month calendar
        scrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width * 2, y: 0.0), animated: true)
    }
    
    public var currentMonthView: CalendarCollectionView!
    public var nextMonthView: CalendarCollectionView!
    public var prevMonthView: CalendarCollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        // Set up scrollview
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let screenHeight: CGFloat = 230
        scrollView.contentSize = CGSize(width: screenWidth * 3.0, height: frame.height)
        scrollView.contentOffset = CGPoint(x: screenWidth, y: 0.0)
        scrollView.delegate = self
        
        addSubview(scrollView)
        
        scrollView.fillSuperView()
        
        // Set up calendar
        let calendar = Date().calendar
        currentDate = Date()
        
        getNextMonth = calendar.date(byAdding: .month, value: 1, to: calendar.startOfDay(for: currentDate))
        getPrevMonth = calendar.date(byAdding: .month, value: -1, to: calendar.startOfDay(for: currentDate))
        
        let frame1 = CGRect(x: screenWidth, y: 0, width: screenWidth, height: screenHeight)
        currentMonthView = CalendarCollectionView(frame: frame1, selectedDate: currentDate)
        
        let frame2 = CGRect(x: screenWidth * 2, y: 0, width: screenWidth, height: screenHeight)
        nextMonthView = CalendarCollectionView(frame: frame2, selectedDate: getNextMonth!)
        
        let frame3 = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        prevMonthView = CalendarCollectionView(frame: frame3, selectedDate: getPrevMonth!)
        
        // Share the selected date with each month.
        currentMonthView.didSelectDate = { [weak self] date in
            self?.currentMonthView.selectedDate = date
            self?.prevMonthView.selectedDate = date
            self?.nextMonthView.selectedDate = date
            self?.didSelectDate?(date)
        }
        
        // Share the selected date with each month.
        nextMonthView.didSelectDate = { [weak self] date in
            self?.currentMonthView.selectedDate = date
            self?.prevMonthView.selectedDate = date
            self?.nextMonthView.selectedDate = date
            self?.didSelectDate?(date)
        }
        
        // Share the selected date with each month/
        prevMonthView.didSelectDate = { [weak self] date in
            self?.currentMonthView.selectedDate = date
            self?.prevMonthView.selectedDate = date
            self?.nextMonthView.selectedDate = date
            self?.didSelectDate?(date)
        }
        
        scrollView.addSubview(currentMonthView)
        scrollView.addSubview(nextMonthView)
        scrollView.addSubview(prevMonthView)
        
        // Set up prev button and next button
        let buttonSize = CGSize(width: 40, height: 24)
        prevMonthButton.frame = CGRect(x: 0, y: 12, width: buttonSize.width, height: buttonSize.height)
        nextMonthButton.frame = CGRect(x: screenWidth - buttonSize.width, y: 12, width: buttonSize.width, height: buttonSize.height)
        
        prevMonthButton.addTarget(self, action: #selector(handlePrevMonth), for: .touchUpInside)
        nextMonthButton.addTarget(self, action: #selector(handleNextMonth), for: .touchUpInside)
        
        addSubview(prevMonthButton)
        addSubview(nextMonthButton)
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position: CGFloat = scrollView.contentOffset.x / scrollView.bounds.width
        
        let deff: CGFloat = position - 1.0
        
        if abs(deff) >= 1.0 {
            if (deff > 0) {
                self.showNextMonth()
            } else {
                self.showPrevMonth()
            }
        }
    }
    
    private func showNextMonth() {
        currentMonth += 1
        
        if currentMonth > 12 {
            currentMonth = 1
            currentYear += 1
        }
        
        let tmpView = currentMonthView
        currentMonthView = nextMonthView
        nextMonthView = prevMonthView
        prevMonthView = tmpView
        
        let nextYearAndMonth = self.getNextYearAndMonth()
        nextMonthView.setupDate(nextYearAndMonth)
        
        self.resetContentOffset()
    }
    
    private func showPrevMonth() {
        currentMonth -= 1
        
        if (currentMonth == 0){
            currentMonth = 12
            currentYear -= 1
        }
        
        let tmpView = currentMonthView
        currentMonthView = prevMonthView
        prevMonthView    = nextMonthView
        nextMonthView    = tmpView
        
        let prevYearAndMonth = self.getPrevYearAndMonth()
        prevMonthView.setupDate(prevYearAndMonth)
        
        self.resetContentOffset()
    }
    
    private func getNextYearAndMonth() -> Date {
        var nextYear: Int = currentYear
        var nextMonth: Int = currentMonth + 1
        
        if nextMonth > 12 {
            nextMonth = 1
            nextYear += 1
        }
        
        let calendar = Date().calendar
        let increaseYear = calendar.date(byAdding: .year, value: nextYear, to: calendar.startOfDay(for: currentDate))!
        let increaseMonth = calendar.date(byAdding: .month, value: nextMonth, to: calendar.startOfDay(for: increaseYear))
        return increaseMonth!
    }
    
    private func getPrevYearAndMonth() -> Date {
        var prevYear: Int = currentYear
        var prevMonth: Int = currentMonth - 1
        
        if prevMonth == 0 {
            prevMonth = 12
            prevYear -= 1
        }
        
        let calendar = Date().calendar
        let decreaseYear = calendar.date(byAdding: .year, value: prevYear, to: calendar.startOfDay(for: currentDate))
        let decreaseMonth = calendar.date(byAdding: .month, value: prevMonth, to: calendar.startOfDay(for: decreaseYear!))
        return decreaseMonth!
    }
    
    private func resetContentOffset() {
        // Adjust position
        prevMonthView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        currentMonthView.frame = CGRect(x: frame.width, y: 0, width: frame.width, height: frame.height)
        nextMonthView.frame = CGRect(x: frame.width * 2, y: 0, width: frame.width, height: frame.height)
        
        // Pause scrollview delegate
        let scrollViewDelegate: UIScrollViewDelegate = scrollView.delegate!
        scrollView.delegate = nil
        
        scrollView.contentOffset = CGPoint(x: frame.width, y: 0)
        scrollView.delegate = scrollViewDelegate
    }
}


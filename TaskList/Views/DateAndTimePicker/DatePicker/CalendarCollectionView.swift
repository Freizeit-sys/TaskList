//
//  CalendarCollectionView.swift
//  TaskList
//
//  Created by Admin on 2021/02/27.
//

import UIKit

class CalendarCollectionView: UIView {
    
    private enum Section: Int {
        case week, day
    }
    
    var selectedDate: Date? {
        didSet {
            // Reset selection
            collectionView.reloadData()
        }
    }
    
    var didSelectDate: ((_ date: Date) -> ())?
    
    private let calendarManager = CalendarManager()
    private let padding: CGFloat = 16.0
    private let cellId = "cellId"
    private let headerId = "headerId"
    private var headerView: CalendarHeaderView?
    
    private let weekArray = Date().weeks(.shortStandalone, locale: .japan)
    
    var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.backgroundColor = .clear
        return cv
    }()
    
    convenience init(frame: CGRect, selectedDate: Date) {
        self.init(frame: frame)
        
        self.setupDate(selectedDate)
    }
    
    func setupDate(_ selectedDate: Date) {
        calendarManager.currentMonthOfDates = []
        calendarManager.currentDate = selectedDate
        
        let screenWidth : CGFloat = frame.size.width
        let screenHeight: CGFloat = frame.size.height
        
        collectionView.frame = CGRect(x: screenWidth, y: 0, width: frame.size.width, height: screenHeight)
        collectionView.center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        
        collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(CalendarHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        addSubview(collectionView)
        
        // Reload year, month, days.
        collectionView.reloadData()
    }
}

extension CalendarCollectionView: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 1 {
            return UIEdgeInsets(top: 0, left: padding, bottom: padding / 2, right: padding)
        }
        return UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Show selected view
        let cell = collectionView.cellForItem(at: indexPath) as! CalendarCell
        
        let isSelectedDate = cell.date == selectedDate
        
        if !isSelectedDate {
            cell.showSelectedView()
            
            guard let selectedDate: Date = cell.date else { return }
            didSelectDate?(selectedDate)
        }
    }

    // MARK: - UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .week:
            return calendarManager.daysPerWeek
        case .day:
            return calendarManager.daysAcquisition()
        case .none:
            return .zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CalendarCell

        switch Section(rawValue: indexPath.section) {
        case .week:

            let week = weekArray[indexPath.item]
            cell.week = week
            cell.isUserInteractionEnabled = false

        case .day:

            let date = calendarManager.date(at: indexPath.item)
            cell.date = date

            let isCurrentMonth = cell.date?.month == calendarManager.currentDate.month

            if isCurrentMonth {
                cell.isUserInteractionEnabled = true
            } else {
                cell.date = nil
                cell.isUserInteractionEnabled = false
            }

            let isSelectedDate = date.zeroclock == selectedDate ?? Date().zeroclock
            
            if isCurrentMonth && isSelectedDate {
                cell.showSelectedView()
            } else {
                cell.hideSelectedView()
            }

        case .none:
            break
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as? CalendarHeaderView
        headerView!.date = calendarManager.currentDate
        return headerView!
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (frame.width - 2 * padding) / CGFloat(calendarManager.daysPerWeek)
        let height = (frame.height - 48 - (padding / 2)) // header height - 48

        if calendarManager.daysAcquisition() > 35 {
            // Six week
            return CGSize(width: width, height: height / 7)
        }
        return CGSize(width: width, height: height / 6)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch Section(rawValue: section) {
        case .week:
            return CGSize(width: frame.width, height: 48)
        case .day:
            return .zero
        case .none:
            return .zero
        }
    }
}


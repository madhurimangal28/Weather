//
//  UITableView+Extension.swift
//  Weather
//
//  Created by Madhuri Agrawal on 22/02/24.
//

import UIKit

extension UITableView {

    func registerNib(_ className: AnyClass) {
        let classNameString = String(describing: className.self)
        register(UINib.init(nibName: classNameString, bundle: .main), forCellReuseIdentifier: classNameString)
    }

    func dequeueReusableCell<T: UITableViewCell>(
        _ className: T.Type,
        indexPath: IndexPath
    ) -> T {
        let className = String(describing: className.self)
        return self.dequeueReusableCell(withIdentifier: className, for: indexPath) as! T
    }

    func registerHeaderFooterClass(_ className: AnyClass) {
        let classNameString = String(describing: className.self)
        register(className, forHeaderFooterViewReuseIdentifier: classNameString)
    }

    func dequeueHeaderFooterView<T: UIView>(_ className: T.Type) -> T {
        let className = String(describing: className.self)
        return self.dequeueReusableHeaderFooterView(withIdentifier: className) as! T
    }
}

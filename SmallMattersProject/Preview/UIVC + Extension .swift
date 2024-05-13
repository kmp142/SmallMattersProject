//
//  UIVC + Extension .swift
//  SmallMattersProject
//
//  Created by Dmitry on 06.04.2024.
//

import SwiftUI

extension UIViewController {

    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController

        func makeUIViewController(context: Context) -> some UIViewController {
            viewController
        }

        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

        }
    }

    func showPreview() -> some View {
        Preview(viewController: self).edgesIgnoringSafeArea(.all)
    }
}

//struct ViewControllerProvider: PreviewProvider {
//    static var previews: some View {
//        TabBarAssembly().configureTabBar().showPreview()
//    }
//}

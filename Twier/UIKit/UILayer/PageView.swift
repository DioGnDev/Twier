import SwiftUI

struct PageView<Page: View>: UIViewControllerRepresentable {
  
  var pages: [Page]
  @Binding var currentPage: Int
  
  func makeUIViewController(context: Context) -> UIPageViewController {
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    pageViewController.dataSource = context.coordinator
    pageViewController.delegate = context.coordinator
    
    return pageViewController
  }
  
  func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
    var direction: UIPageViewController.NavigationDirection = .forward
    var animated: Bool = false
    
    if let previousViewController = pageViewController.viewControllers?.first,
       let previousPage = context.coordinator.controllers.firstIndex(of: previousViewController) {
      direction = (currentPage >= previousPage) ? .forward : .reverse
      animated = (currentPage != previousPage)
    }
    
    let currentViewController = context.coordinator.controllers[currentPage]
    pageViewController.setViewControllers([currentViewController], direction: direction, animated: animated)
  }
  
  func makeCoordinator() -> Coordinator {
    return Coordinator(parent: self, pages: pages)
  }
  
  class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var parent: PageView
    // controllers 배열은 재성성을 막기 위해 1회만 생성되는 Coordinator에서 관리해야 한다.
    var controllers: [UIViewController]
    
    init(parent: PageView, pages: [Page]) {
      self.parent = parent
      self.controllers = pages.map({
        let hostingController = UIHostingController(rootView: $0)
        // UIHostingController는 루트 뷰의 기본 배경색이 .white로 설정되어 있다.
        // 개별 Page 뷰에서 뒷배경이 투명하게 보이도록 의도한 경우를 대비하기 위해 hostingController의 배경색을 .clear로 설정한다.
        hostingController.view.backgroundColor = .clear
        return hostingController
      })
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
      guard let index = controllers.firstIndex(of: viewController) else {
        return nil
      }
      if index == 0 {
        return nil
      }
      return controllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
      guard let index = controllers.firstIndex(of: viewController) else {
        return nil
      }
      if index + 1 == controllers.count {
        return nil
      }
      return controllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
      if completed,
         let currentViewController = pageViewController.viewControllers?.first,
         let currentIndex = controllers.firstIndex(of: currentViewController)
      {
        parent.currentPage = currentIndex
      }
    }
  }
}

struct PageView_Previews: PreviewProvider {
  
  @State static private var currentPage = 0
  
  static var previews: some View {
    PageView(pages: [
      Color(.systemRed),
      Color(.systemGreen),
      Color(.systemBlue)
    ], currentPage: $currentPage)
  }
}

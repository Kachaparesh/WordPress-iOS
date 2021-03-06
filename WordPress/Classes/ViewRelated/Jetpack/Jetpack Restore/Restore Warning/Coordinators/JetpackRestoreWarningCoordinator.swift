import Foundation

protocol JetpackRestoreWarningView {
    func showError()
    func showRestoreStatus()
}

class JetpackRestoreWarningCoordinator {

    // MARK: - Properties

    private let service: JetpackRestoreService
    private let site: JetpackSiteRef
    private let rewindID: String?
    private let restoreTypes: JetpackRestoreTypes
    private let view: JetpackRestoreWarningView

    // MARK: - Init

    init(site: JetpackSiteRef,
         restoreTypes: JetpackRestoreTypes,
         rewindID: String?,
         view: JetpackRestoreWarningView,
         service: JetpackRestoreService? = nil,
         context: NSManagedObjectContext = ContextManager.sharedInstance().mainContext) {
        self.service = service ?? JetpackRestoreService(managedObjectContext: context)
        self.site = site
        self.rewindID = rewindID
        self.restoreTypes = restoreTypes
        self.view = view
    }

    // MARK: - Public

    func restoreSite() {
        service.restoreSite(site, rewindID: rewindID, restoreTypes: restoreTypes, success: { [weak self] _, _ in
            self?.view.showRestoreStatus()
        }, failure: { [weak self] error in
            DDLogError("Error restoring site: \(error.localizedDescription)")

            self?.view.showError()
        })
    }
}

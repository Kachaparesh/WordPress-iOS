import Foundation

protocol JetpackBackupOptionsView {
    func showError()
    func showBackupStatus(for downloadID: Int)
}

class JetpackBackupOptionsCoordinator {

    // MARK: - Properties

    private let service: JetpackBackupService
    private let site: JetpackSiteRef
    private let restoreTypes: JetpackRestoreTypes
    private let view: JetpackBackupOptionsView

    // MARK: - Init

    init(site: JetpackSiteRef,
         restoreTypes: JetpackRestoreTypes,
         view: JetpackBackupOptionsView,
         service: JetpackBackupService? = nil,
         context: NSManagedObjectContext = ContextManager.sharedInstance().mainContext) {
        self.service = service ?? JetpackBackupService(managedObjectContext: context)
        self.site = site
        self.restoreTypes = restoreTypes
        self.view = view
    }

    // MARK: - Public

    func prepareBackup() {
        service.prepareBackup(for: site, restoreTypes: restoreTypes, success: { [weak self] backup in
            self?.view.showBackupStatus(for: backup.downloadID)
        }, failure: { [weak self] error in
            DDLogError("Error preparing downloadable backup object: \(error.localizedDescription)")

            self?.view.showError()
        })
    }
}

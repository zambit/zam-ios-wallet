//
//  Paginator.swift
//  wallet
//
//  Created by Alexander Ponomarev on 24/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

/**
 RequestStatus for Paginator

 - None: No pages have been fetched.
 - InProgress: The paginator fetchHandler is in progress.
 - Done: All fetch calls have finished and data exists.
 */
public enum RequestStatus {
    case None, InProgress, Done
}

public class Paginator<Element> {

    /**
     Size of pages.
     */
    public var pageSize = 0

    /**
     Last page fetched. Start at 0, fetch calls use page+1 and increment after.  Read-Only
     */
    public private(set) var page = 0

    /**
     Total number of results.  Must be set with `receivedResults(_:total:)`.  Read-Only
     */
    public private(set) var next: String?

    /**
     The requestStatus defines the current state of the paginator.  If .None, no pages have fetched.
     If .InProgress, incoming `fetchNextPage()` calls are ignored.
     */
    public private(set) var requestStatus: RequestStatus = .None

    /**
     All results in the order they were received.
     */
    public var results: [Element] = []

    /// Shortcuts for the block signatures
    public typealias FetchHandlerType = (_ paginator: Paginator<Element>, _ pageSize: Int, _ nextPage: String?) -> ()
    public typealias ResultsHandler = (Paginator, [Element], Bool) -> ()
    public typealias ResetHandler = (Paginator) -> ()
    public typealias FailureHandler = (Paginator) -> ()

    /**
     The fetchHandler is defined by the user, it defines the behaviour for how to fetch a given page.
     NOTE: `receivedResults(_:total:)` or `failed()` must be called within.
     */
    public var fetchHandler: FetchHandlerType

    /**
     The resultsHandler is called by `receivedResults(_:total:)`. It contains the Array of Elements
     for a given page and `isInitialPage` boolean flag.
     */
    public var resultsHandler: ResultsHandler

    /**
     The resetHandler is called by `reset()`.  Here you can define a callback to be called after
     the paginator has been reset.
     */
    public var resetHandler: ResetHandler?

    /**
     The failureHandler is called by `failed()`.  Here you can define a callback to be called when the
     fetchHandler fails to separate it from fetch logic.
     */
    public var failureHandler: FailureHandler?

    /**
     Creates a Paginator

     - parameter pageSize:       Size of pages
     - parameter fetchHandler:   Block to define fetch behaviour, required.
     NOTE: `receivedResults(_:total:)` or `failed()` must be called within.
     - parameter resultsHandler: Callback to handle new pages of resutls, required.
     - parameter resetHandler:   Callback for `reset()`, will be called after data has been reset, optional.
     - parameter failureHandler: Callback for `failure()`, will be called

     */
    public init(pageSize: Int,
                fetchHandler: @escaping FetchHandlerType,
                resultsHandler: @escaping ResultsHandler,
                resetHandler: ResetHandler? = nil,
                failureHandler: FailureHandler? = nil) {

        self.pageSize = pageSize
        self.fetchHandler = fetchHandler
        self.resultsHandler = resultsHandler
        self.failureHandler = failureHandler
        self.resetHandler = resetHandler
        self.setDefaultValues()

    }

    /**
     Sets default values for total, page, and results.  Called by `reset()` and `init`
     */
    private func setDefaultValues() {
        next = nil
        page = 0
        requestStatus = .None
        results = []
    }

    /**
     Reset the Paginator, clears all results and sets total and page to 0.
     */
    public func reset() {
        setDefaultValues()
        resetHandler?(self)
    }

    /**
     Reset the Paginator, clears all results and sets total and page to 0.
     */
    public func reload() {
        setDefaultValues()
        fetchFirstPage()
    }

    /**
     reachedLastPage: Bool - Boolean indicating all pages have been fetched
     */
    public var reachedLastPage: Bool {
        if requestStatus == .None {
            return false
        }

        return next == ""
    }

    /**
     Fetch the first page.  If requestStatus is not .None, the paginator will be reset.
     */
    public func fetchFirstPage() {
        reset()
        fetchNextPage()
    }

    /**
     Fetch the next page. If no pages are present it will fetch the first page (called by `fetchFirstPage()`
     */
    public func fetchNextPage() {
        if requestStatus == .InProgress {
            return
        }
        if !reachedLastPage {
            requestStatus = .InProgress
            fetchHandler(self, pageSize, next)
        }
    }

    /**
     Public method to be called within a `fetchHandler`.  Lets the paginator and any observers know a new chunk of
     `Element`s are available, as well as indicates the total number of results to the paginator.

     - parameter results: Array of elements fetched within the fetchHandler
     - parameter next:   Link to the next results page. If it's empty, this page is the last.
     */
    public func receivedResults(results: [Element], next: String) {
        self.results.append(contentsOf: results)
        self.next = next
        page += 1
        requestStatus = .Done

        resultsHandler(self, results, page - 1 < 1)
    }

    /**
     Public method to be called within a `fetchHandler`.  Lets the paginator and any obervers know a fetch
     has failed.
     */
    public func failed() {
        requestStatus = .Done
        failureHandler?(self)
    }

}

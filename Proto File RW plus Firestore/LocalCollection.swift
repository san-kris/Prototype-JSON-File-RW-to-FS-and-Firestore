//
//  LocalCollection.swift
//  Proto File RW plus Firestore
//
//  Created by Santosh Krishnamurthy on 2/7/23.
//

import FirebaseFirestore

// A type that can be initialized from a Firestore document.
protocol DocumentSerializable {
    init?(dictionary: [String: Any])
}

// defines a class that can accept any class of type DocumentSerializable
final class LocalCollection<T: DocumentSerializable> {
    
    // items stores array of DocumentSerializable
    private(set) var items: [T]
    // documents store an array of document snapshot
    private(set) var documents: [DocumentSnapshot] = []
    // query is of type Firestore class Query
    let query: Query
    
    // define update handler as a function that has array of Document Change as input and no output
    private let updateHandler: ([DocumentChange]) -> ()
    
    // listner variable is defined and old listner is removed, if it exists
    private var listener: ListenerRegistration? {
        didSet {
            oldValue?.remove()
        }
    }
    
    // count is a computed property
    var count: Int {
        return self.items.count
    }
    
    // defines how to handle [i]
    subscript(index: Int) -> T {
        return self.items[index]
    }
    
    // accepts Query object as input along with closure that can handle update to review
    // @escaping is used when the closure outlives the function its created in
    init(query: Query, updateHandler: @escaping ([DocumentChange]) -> ()) {
        self.items = []
        self.query = query
        self.updateHandler = updateHandler
    }
    
    // find the index of the document from query based on documentID
    func index(of document: DocumentSnapshot) -> Int? {
        return documents.firstIndex(where: { $0.documentID == document.documentID })
    }
    
    
    func listen() {
        // exit if listner is already setup
        guard listener == nil else { return }
        // create a new listner based on query
        listener = query.addSnapshotListener { [unowned self] querySnapshot, error in
            // if the snapshot is empty, print error
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshot results: \(error!)")
                return
            }
            // user the array.map function to convert each of the document to a class instance
            let models = snapshot.documents.map { (document) -> T in
                // call the class init(dictionary:)  method vased
                if let model = T(dictionary: document.data()) {
                    return model
                } else {
                    // handle error
                    fatalError("Unable to initialize type \(T.self) with dictionary \(document.data())")
                }
            }
            
            // set the items property to new class array
            self.items = models
            // save [DocumentSnapshot] into documents
            self.documents = snapshot.documents
            // call the updatehandler function and pass the documentChanges
            self.updateHandler(snapshot.documentChanges)
        }
    }
    
    // remove listner
    func stopListening() {
        listener = nil
    }
    
    // when class is destroyed, stop listner
    deinit {
        stopListening()
    }
}

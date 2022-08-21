# MVVM_Demo
This's small demo illustrated MVVM Architecture and how it works

ViewModel is binding with view through "Observable Object"

class Observable<T> {
    
    var value: T? {
        didSet {
            listener?(value)
        }
    }
    private var listener: ((T?) -> Void)?
    
    init(_ value: T?) {
        self.value = value
    }
    
    public func bind(_ listener: @escaping (T?) -> Void) {
        listener(value)
        self.listener = listener
    }
}

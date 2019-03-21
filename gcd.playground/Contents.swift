import Foundation

func doLongAsyncTaskInSerialQueue() {
   
    let serialQueue = DispatchQueue(label: "com.queue.Serial")
    for i in 1...5 {
        DispatchQueue.main.async {
            
            if Thread.isMainThread{
                print("task running in main thread")
            }else{
                print("task running in background thread")
            }
            let imgURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/0/07/Huge_ball_at_Vilnius_center.jpg")!
            let _ = try! Data(contentsOf: imgURL)
            print("\(i) completed downloading")
        }
        print("\(i) executing")
    }
}
print("start")
doLongAsyncTaskInSerialQueue()
sleep(5)
print("end")

func doLongSyncTaskInSerialQueue() {
    let serialQueue = DispatchQueue(label: "com.queue.Serial")
    for i in 1...5 {
        serialQueue.sync {
            if Thread.isMainThread{
                print("task running in main thread")
            }else{
                print("task running in background thread")
            }
            let imgURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/0/07/Huge_ball_at_Vilnius_center.jpg")!
            let _ = try! Data(contentsOf: imgURL)
            print("\(i) completed downloading")
        }
        print("\(i) executing")
    }
}
//doLongSyncTaskInSerialQueue()

func doLongASyncTaskInConcurrentQueue() {
    let concurrentQueue = DispatchQueue(label: "com.queue.Concurrent", attributes: .concurrent)
    for i in 1...5 {
        concurrentQueue.async {
            
            if Thread.isMainThread{
                print("task running in main thread")
            }else{
                print("task running in background thread")
            }
            let imgURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/0/07/Huge_ball_at_Vilnius_center.jpg")!
            let _ = try! Data(contentsOf: imgURL)
            print("\(i) completed downloading")
        }
        print("\(i) executing")
    }
}
doLongASyncTaskInConcurrentQueue()

func doLongSyncTaskInConcurrentQueue() {
    let concurrentQueue = DispatchQueue(label: "com.queue.Concurrent", attributes: .concurrent)
    for i in 1...5 {
        concurrentQueue.sync {
            
            if Thread.isMainThread{
                print("task running in main thread")
            }else{
                print("task running in background thread")
            }
            let imgURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/0/07/Huge_ball_at_Vilnius_center.jpg")!
            let _ = try! Data(contentsOf: imgURL)
            print("\(i) completed downloading")
        }
        print("\(i) executed")
    }
}
doLongSyncTaskInConcurrentQueue()




//
//  DispatchSemaphore.swift
//  
//
//  Created by Madhvendra raj singh on 15/05/23.
//

import Foundation

// This Semaphore usage shows how we can add dependencies using DispatchSemaphore in combination with a DispatchQueue.
// However, it has one disadvantage when mixed with dispatch queues; some dependencies might not work as expected when using delays, as demonstrated in the commented code below.
// In such cases, a basic implementation of DispatchSemaphore can be used to notify when a task is completed at any level.

class DependentTasks {
    
    func runDependentTasks() {
        // Create DispatchSemaphores for signaling task completion
        let operationASignal = DispatchSemaphore(value: 0)
        let operationBSignal = DispatchSemaphore(value: 0)
        let operationCSignal = DispatchSemaphore(value: 0)
        
        let queue = DispatchQueue(label: "First queue")
        
        // Task A
        queue.async {
            print("Task A")
            operationASignal.signal() // Signal that task A has finished
        }
        
        // Task B
        queue.async {
            operationASignal.wait() // Wait for task A to finish
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                print("Task B")
                operationBSignal.signal() // Signal that task B has finished
            }
        }
        
        // Task C
        queue.async {
            operationBSignal.wait() // Wait for task B to finish
            print("Task C")
            operationCSignal.signal() // Signal that task C has finished
        }
        
        // Task D
        queue.async {
            operationCSignal.wait() // Wait for task C to finish
            print("Task D")
        }
        
        
        // Uncomment the code below to understand the issue with operation blocks and DispatchQueue mixed usage
        /*
         let operationA = BlockOperation {
         print("Task A")
         }
         
         let operationB = BlockOperation {
         DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
         print("Task B")
         }
         }
         
         let operationC = BlockOperation {
         print("Task C")
         }
         
         let operationD = BlockOperation {
         print("Task D")
         }
         
         operationB.addDependency(operationA)
         operationC.addDependency(operationB)
         operationD.addDependency(operationC)
         
         let operationQueue = OperationQueue()
         operationQueue.addOperations([operationA, operationB, operationC, operationD], waitUntilFinished: false)
         */
    }
}

// Create an instance of DependentTasks and run the dependent tasks
let task = DependentTasks()
task.runDependentTasks()




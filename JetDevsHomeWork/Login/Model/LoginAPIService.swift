//
//  LoginAPIService.swift
//  JetDevsHomeWork
//
//  Created by Neel on 12/5/24.
//

import RxSwift

// Define a custom error type
enum CustomError: Error {
    case customMessage(String)
    
    var localizedDescription: String {
        switch self {
        case .customMessage(let message):
            return message
        }
    }
}

protocol LoginServiceProtocol {
    
    func login(loginRequest: LoginRequest) -> Observable<LoginResponse>
}

class LoginService: LoginServiceProtocol {
    
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    // swiftlint:disable function_body_length
    func login(loginRequest: LoginRequest) -> Observable<LoginResponse> {
        guard let url = URL(string: AppURLs.login) else {
            return Observable.error(CustomError.customMessage(APIErrorMessages.invalidUrl))
        }
        
        // Create the request with the proper headers
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(loginRequest)
        
        return Observable.create { observer in
            let dataTask = self.session.dataTask(with: request) { data, response, error in
                
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let data = data else {
                    observer.onError(CustomError.customMessage(APIErrorMessages.serverError))
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    
                    // Handle different status codes
                    switch statusCode {
                    case 200:
                        // Handle the response data
                        do {
                            // Decode the data into LoginResponse
                            let decoder = JSONDecoder()
                            let loginResponse = try decoder.decode(LoginResponse.self, from: data)
                            observer.onNext(loginResponse)
                            observer.onCompleted()
                        } catch {
                            observer.onError(CustomError.customMessage(APIErrorMessages.somethingWrongError))
                        }
                    case 400...599:
                        observer.onError(CustomError.customMessage(APIErrorMessages.invalidCredential))
                    default:
                        observer.onError(CustomError.customMessage(APIErrorMessages.unexpectedError))
                    }
                } else {
                    observer.onError(CustomError.customMessage(APIErrorMessages.serverError))
                }
            }
            
            // Start the data task
            dataTask.resume()
            
            // Return a disposable to cancel the request if needed
            return Disposables.create {
                dataTask.cancel()
            }
        }
    }
    // swiftlint:enable function_body_length
}

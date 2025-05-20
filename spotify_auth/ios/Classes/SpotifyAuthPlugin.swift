import Flutter
import UIKit
import SpotifyiOS

public class SpotifyAuthPlugin: NSObject, FlutterPlugin, UIApplicationDelegate, SPTSessionManagerDelegate, SpotifyAuthApi {
    var sessionManager: SPTSessionManager?
    var authCompletion: ((Result<AuthenticateReply, any Error>) -> Void)?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SpotifyAuthPlugin.init()
        registrar.addApplicationDelegate(instance)
        
        SpotifyAuthApiSetup.setUp(binaryMessenger: registrar.messenger(), api: instance)
    }
    
    public static func detachedFromEngine(_ engine: FlutterEngine) {
        SpotifyAuthApiSetup.setUp(binaryMessenger: engine.binaryMessenger, api: nil)
    }

    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let sessionManager = sessionManager {
            sessionManager.application(app, open: url, options: options)
            return true
        }
        
        return false
    }
    
    public func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        self.sessionManager = nil
        
        if let authCompletion = authCompletion {
            authCompletion(.success(AuthenticateReply(code: nil, refreshToken: session.refreshToken)))
        }
    }
    
    public func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        self.sessionManager = nil
        
        if let authCompletion = authCompletion {
            authCompletion(.failure(error))
        }
    }
    
    public func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
    }
    
    func canAuthenticateUsingSpotifyApp() throws -> Bool {
        let sessionManager = SPTSessionManager(configuration: SPTConfiguration(clientID: "", redirectURL: URL(string: "http://example.com")!), delegate: self)
        return sessionManager.isSpotifyAppInstalled
    }
    
    func authenticate(request: AuthenticateRequest, completion: @escaping (Result<AuthenticateReply, any Error>) -> Void) {
        self.sessionManager = SPTSessionManager(configuration: SPTConfiguration(
            clientID: request.clientId,
            redirectURL: URL(string: request.redirectUri)!
        ), delegate: self)

        authCompletion = completion
        self.sessionManager!.initiateSession(withRawScope: request.scopes.joined(separator: ","), options: .clientOnly, campaign: nil)
    }
}

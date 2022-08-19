//
//

import Foundation

protocol EnefitsWalletConnectDelegate {
    func failedToConnect()
    func didConnect()
    func didDisconnect()
}

public class EnefitsWalletConnect {
    var client: Client!
    public var session: Session!
    var delegate: EnefitsWalletConnectDelegate

    let sessionKey = "sessionKey"

    init(delegate: EnefitsWalletConnectDelegate) {
        self.delegate = delegate
    }

    func connect() -> String {
        // gnosis wc bridge: https://safe-walletconnect.gnosis.io/
        // test bridge with latest protocol version: https://bridge.walletconnect.org
        let wcUrl =  WCURL(topic: UUID().uuidString,
                           bridgeURL: URL(string: "https://bridge.walletconnect.org")!,
                           key: try! randomKey())
        let clientMeta = Session.ClientMeta(name: Enefits.shared.appNameString ?? "",
                                            description: "To connect with wallet",
                                            icons: [],
                                            url: URL(string: "enefits.co")!)
        let dAppInfo = Session.DAppInfo(peerId: UUID().uuidString, peerMeta: clientMeta)
        client = Client(delegate: self, dAppInfo: dAppInfo)

        print("WalletConnect URL: \(wcUrl.absoluteString)")

        try! client.connect(to: wcUrl)
        return wcUrl.absoluteString
    }

    func reconnectIfNeeded() {
        if let oldSessionObject = UserDefaults.standard.object(forKey: sessionKey) as? Data,
            let session = try? JSONDecoder().decode(Session.self, from: oldSessionObject) {
            client = Client(delegate: self, dAppInfo: session.dAppInfo)
            try? client.reconnect(to: session)
        }
    }

    // https://developer.apple.com/documentation/security/1399291-secrandomcopybytes
    private func randomKey() throws -> String {
        var bytes = [Int8](repeating: 0, count: 32)
        let status = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
        if status == errSecSuccess {
            return Data(bytes: bytes, count: 32).toHexString()
        } else {
            // we don't care in the example app
            enum TestError: Error {
                case unknown
            }
            throw TestError.unknown
        }
    }
}

extension EnefitsWalletConnect: ClientDelegate {
    public func client(_ client: Client, didFailToConnect url: WCURL) {
        delegate.failedToConnect()
    }

    public func client(_ client: Client, didConnect url: WCURL) {
        // do nothing
    }

    public func client(_ client: Client, didConnect session: Session) {
        self.session = session
        let sessionData = try! JSONEncoder().encode(session)
        UserDefaults.standard.set(sessionData, forKey: sessionKey)
        delegate.didConnect()
    }

    public func client(_ client: Client, didDisconnect session: Session) {
        UserDefaults.standard.removeObject(forKey: sessionKey)
        delegate.didDisconnect()
    }

    public func client(_ client: Client, didUpdate session: Session) {
        // do nothing
    }
}

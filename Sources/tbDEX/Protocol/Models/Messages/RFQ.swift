import AnyCodable
import Foundation
import TypeID

public typealias RFQ = Message<RFQData>

extension RFQ {

    /// Default Initializer. `protocol` defaults to "1.0" if nil
    public init(
        to: String,
        from: String,
        data: RFQData,
        externalID: String?,
        `protocol`: String?
    ) {
        let id = TypeID(prefix: data.kind().rawValue)!
        self.metadata = MessageMetadata(
            id: id,
            kind: data.kind(),
            from: from,
            to: to,
            exchangeID: id.rawValue,
            createdAt: Date(),
            externalID: externalID,
            protocol: `protocol` ?? "1.0"
        )
        self.data = data
        self.private = nil
    }

}

/// Data that makes up a RFQ Message.
///
/// [Specification Reference](https://github.com/TBD54566975/tbdex/tree/main/specs/protocol#rfq-request-for-quote)
public struct RFQData: MessageData {

    /// Offering which Alice would like to get a quote for.
    public let offeringId: String

    /// Amount of payin currency you want in exchange for payout currency.
    public let payinAmount: String

    /// Specify which payment method to send payin currency.
    public let payinMethod: SelectedPaymentMethod

    /// Specify which payment method to receive payout currency.
    public let payoutMethod: SelectedPaymentMethod
    
    /// An array of claims that fulfill the requirements declared in an Offering.
    public let claims: [String]

    /// Returns the MessageKind of rfq
    public func kind() -> MessageKind {
        return .rfq
    }

    public init(
        offeringId: TypeID,
        payinAmount: String,
        payinMethod: SelectedPaymentMethod,
        payoutMethod: SelectedPaymentMethod,
        claims: [String]
    ) {
        self.offeringId = offeringId.rawValue
        self.payinAmount = payinAmount
        self.payinMethod = payinMethod
        self.payoutMethod = payoutMethod
        self.claims = claims
    }
}

/// Details about a selected payment method
///
/// [Specification Reference](https://github.com/TBD54566975/tbdex/tree/main/specs/protocol#selectedpaymentmethod)
public struct SelectedPaymentMethod: Codable, Equatable {

    /// Type of payment method (i.e. `DEBIT_CARD`, `BITCOIN_ADDRESS`, `SQUARE_PAY`)
    public let kind: String

    /// An object containing the properties defined in an Offering's `requiredPaymentDetails` json schema
    public let paymentDetails: AnyCodable?

    public init(
        kind: String,
        paymentDetails: AnyCodable? = nil
    ) {
        self.kind = kind
        self.paymentDetails = paymentDetails
    }
}

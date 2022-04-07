import Foundation

public enum AppleWatchModel: CustomStringConvertible, Equatable {

  static let identifierPrefix: String = "Watch"

  case series3_38mm
  case series3_42mm
  case series4_40mm
  case series4_44mm
  case series5_40mm
  case series5_44mm
  case series6_40mm
  case series6_44mm
  case seriesSE_40mm
  case seriesSE_44mm
  case series7_41mm
  case series7_45mm
  case unknown(modelNumber: String)

  public var description: String {
    switch self {
    case .series3_38mm: return "Series 3 - 38mm"
    case .series3_42mm: return "Series 3 - 38mm"
    case .series4_40mm: return "Series 4 - 40mm"
    case .series4_44mm: return "Series 4 - 44mm"
    case .series5_40mm: return "Series 5 - 40mm"
    case .series5_44mm: return "Series 5 - 44mm"
    case .series6_40mm: return "Series 6 - 40mm"
    case .series6_44mm: return "Series 6 - 44mm"
    case .seriesSE_40mm: return "Series SE - 40mm"
    case .seriesSE_44mm: return "Series SE - 44mm"
    case .series7_41mm: return "Series 6 - 41mm"
    case .series7_45mm: return "Series 6 - 45mm"
    case .unknown(let modelNumber): return "? (\(modelNumber))"
    }
  }

  public static func inferFrom(modelNumber: String) -> AppleWatchModel {
    switch modelNumber.replacingOccurrences(of: AppleWatchModel.identifierPrefix, with: "") {
    case "3,1", "3,3": return .series3_38mm
    case "3,2", "3,4": return .series3_42mm
    case "4,1", "4,3": return .series4_40mm
    case "4,2", "4,4": return .series4_44mm
    case "5,1", "5,3": return .series5_40mm
    case "5,2", "5,4": return .series5_44mm
    case "6,1", "6,3": return .series6_40mm
    case "6,2", "6,4": return .series6_44mm
    case "5,9", "5,11": return .seriesSE_40mm
    case "5,10", "5,12": return .seriesSE_44mm
    case "6,6", "6,8": return .series7_41mm
    case "6,7", "6,9": return .series7_45mm
    default: return .unknown(modelNumber: modelNumber)
    }
  }
}

import CoreGraphics
import Foundation

public indirect enum Device: CustomStringConvertible, Equatable {
  case iPhone(IPhoneModel)
  case iPad(IPadModel)
  case iPod(IPodModel)
  case appleTV(AppleTVModel)
  case watch
  case mac
  case simulator(device: Device)
  case unknown(identifier: String)
  
  public static let current = Device.infer(from: deviceModelIdentifier)
  
  public static var currentEffective: Device {
    switch current {
    case .simulator(let simulatedDevice): return simulatedDevice
    default: return current
    }
  }
  
  public var description: String {
    switch self {
    case .iPhone(let model): return "iPhone \(model.description)"
    case .iPad(let model): return "iPad \(model.description)"
    case .iPod(let model): return "iPod Touch \(model.description)"
    case .appleTV(let model): return "AppleTV \(model.description)"
    case .watch: return "Watch"
    case .mac: return "Mac"
    case .simulator(let simulatedDevice): return "Simulator (\(simulatedDevice.description))"
    case .unknown(let identifier): return "Unkown Device (\(identifier))"
    }
  }
  
  public var supportsTrueBlack: Bool {
    switch self {
    case .iPhone(let model):
      return [
        .x, .xs, .xsMax,
        ._11Pro, ._11ProMax, ._11,
        ._12mini, ._12, ._12Pro, ._12ProMax,
        ._13mini, ._13, ._13Pro, ._13ProMax].contains(model)
    case .watch:
      return true
    case .simulator(let simulatedDevice): return simulatedDevice.supportsTrueBlack
    default: return false
    }
  }
  
  public var supportsCellularConnections: Bool {
    switch self {
    case .iPhone: return true
    case .simulator(let simulatedDevice): return simulatedDevice.supportsCellularConnections
    default: return false
    }
  }
  
  public var hasSmallScreen: Bool {
    switch self {
    case .iPhone(let model):
      return [.se1].contains(model)
    case .iPod(let model):
      return [.iPod7].contains(model)
    case .simulator(let simulatedDevice): return simulatedDevice.hasSmallScreen
    default: return false
    }
  }
  
  public var appIconSize: CGFloat {
    60
//    switch self {
//    case .iPhone(_), .iPod(_):
//      return 60
//    case .iPad(let model):
//      if [.pro12Inch1, .pro12Inch2, .pro12Inch3, .pro12Inch4].contains(model) {
//        return 83.5
//      } else {
//        return 76
//      }
//    default: return 60
//    }
  }
  
  public var tryBottomHeavy: Bool {
    switch self {
    case .iPhone(_), .iPod(_):
      return true
    case .simulator(let simulatedDevice): return simulatedDevice.tryBottomHeavy
    default: return false
    }
  }
  
  public var isSlow: Bool {
    switch self {
    case .iPhone(let model):
      return [.se1, ._6s, ._6sPlus, ._7, ._7Plus].contains(model)
    case .iPod:
      return true
    case .simulator(let simulatedDevice): return simulatedDevice.isSlow
    default: return false
    }
  }
  
  public var hasHomeButton: Bool {
    screenCornerRadius == 0
  }
  
  public var screenCornerRadius: CGFloat {
    switch self {
    case .iPhone(let iPhoneModel):
      switch iPhoneModel {
      case .x, .xs, .xsMax, ._11Pro, ._11ProMax: return 39
      case ._11, .xr: return 41.5
      case ._12mini, ._13mini: return 44
      case ._12, ._12Pro, ._13, ._13Pro: return 47
      case ._12ProMax, ._13ProMax: return 53
      default: return 0
      }
    case .iPad(let iPadModel):
      switch iPadModel {
      case .air4, .pro11Inch1, .pro11Inch2, .pro12Inch3, .pro12Inch4: return 18
      default: return 0
      }
    case .simulator(let simulatedDevice): return simulatedDevice.screenCornerRadius
    default: return 0
    }
  }
  
  public var homeBarWidth: CGFloat {
    switch self {
    case .iPhone(let iPhoneModel):
      switch iPhoneModel {
      case .x, .xs, ._11Pro: return 134
      case .xsMax, ._11ProMax: return 148
      case ._11, .xr: return 134
      case ._12mini, ._13mini: return 120
      case ._12, ._12Pro, ._13, ._13Pro: return 134
      case ._12ProMax, ._13ProMax: return 152
      default: return 0
      }
    case .iPad(let iPadModel):
      switch iPadModel {
      case .air4, .pro11Inch1, .pro11Inch2, .pro12Inch3, .pro12Inch4: return 134
      default: return 0
      }
    case .simulator(let simulatedDevice): return simulatedDevice.homeBarWidth
    default: return 0
    }
  }
  
  public var notchWidth: CGFloat {
    switch self {
    case .iPhone(let iPhoneModel):
      switch iPhoneModel {
      case .x, .xs, .xsMax: return 209
      case ._11Pro, ._11ProMax: return 214
      case ._11, .xr: return 220
      case ._12mini: return 214
      case ._12, ._12Pro: return 214
      case ._12ProMax: return 214
      case ._13, ._13Pro, ._13ProMax: return 160
      case ._13mini: return 168
      default: return 0
      }
    case .iPad(let iPadModel):
      switch iPadModel {
      case .air4, .pro11Inch1, .pro11Inch2, .pro12Inch3, .pro12Inch4: return 134
      default: return 0
      }
    case .simulator(let simulatedDevice): return simulatedDevice.notchWidth
    default: return 0
    }
  }
  
  public var iconName: String {
    switch self {
    case .iPhone:
      return screenCornerRadius > 0 ? "iphone" : "iphone.homebutton"
    case .iPad:
      return screenCornerRadius > 0 ? "ipad" : "ipad.homebutton"
    case .iPod: return "ipodtouch"
    case .watch: return "applewatch"
    case .appleTV: return "appletv"
    case .mac: return "laptopcomputer"
    case .unknown: return "airplayaudio"
    case .simulator(let simulatedDevice): return simulatedDevice.iconName
    }
  }
  
  public static var deviceModelIdentifier: String {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
      guard let value = element.value as? Int8, value != 0 else { return identifier }
      return identifier + String(UnicodeScalar(UInt8(value)))
    }
    return identifier
  }
  
  static func infer(from id: String) -> Device {
    if id.hasPrefix(IPhoneModel.identifierPrefix) {
      return .iPhone(.inferFrom(modelNumber: id))
    } else if id.hasPrefix(IPadModel.identifierPrefix) {
      return .iPad(.inferFrom(modelNumber: id))
    } else if id.hasPrefix(IPodModel.identifierPrefix) {
      return .iPod(.inferFrom(modelNumber: id))
    } else if id.hasPrefix(AppleTVModel.identifierPrefix) {
      return .appleTV(.inferFrom(modelNumber: id))
    } else if id.hasPrefix("x64_86") || id.hasPrefix("arm64") {
      if let simulatorDeviceModel = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
        return .simulator(device: Device.infer(from: simulatorDeviceModel))
      } else {
        return .mac
      }
    } else {
      return .unknown(identifier: id)
    }
  }
}

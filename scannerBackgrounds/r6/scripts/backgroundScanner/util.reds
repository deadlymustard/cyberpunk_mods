@addMethod(inkTextRef)
public final static func SetLocalizedTextScriptAndFallback(self: inkTextRef, locKey: String, opt textParams: ref<inkTextParams>) -> Void {
    if isLocKey(locKey) {
        inkTextRef.SetLocalizedTextScript(self, locKey, textParams);
    } else {
        inkTextRef.SetText(self, locKey);
    };
}

public static func isLocKey(locKey: String) -> Bool {
    return Equals(GetLocalizedText(locKey), null);
}

public func RandRange(seed: Int32, min: Int32, max: Int32) -> Int32 {
  // Add (max + 1) to account for truncation of floats.
  let val: Int32 = Cast(RandNoiseF(seed, Cast(min), Cast(max + 1)));
  Log("RandRangeVal: " + IntToString(val), shouldPrintDebugLog());
  return val;
}

public func RandTrueFalseWeighted(seed: Int32, opt weight: Int32) -> Bool {
  let val: Int32 = Cast(RandNoiseF(seed, 0.0, 100.0)) + weight;
  Log("RandVal: " + IntToString(val), shouldPrintDebugLog());

  if val > 50 {
    return true;
  } else {
    return false;
  }
}

public func RandTrueFalse(seed: Int32) -> Bool {
  return RandTrueFalseWeighted(seed, 0);
}

public func shouldPrintDebugLog() -> Bool {
  return false;
}

public func Log(log: String, shouldLog: Bool) -> Void {
  if shouldLog {
    Log(log);
  }
}
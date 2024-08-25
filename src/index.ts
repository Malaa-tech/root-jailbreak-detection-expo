import { Platform } from "expo-modules-core";

// Import the native module. On web, it will be resolved to RootJailbreakDetectionExpo.web.ts
// and on native platforms to RootJailbreakDetectionExpo.ts
import RootJailbreakDetectionExpoModule from "./RootJailbreakDetectionExpoModule";
type RootItemResult = {
  check: string;
  detected: boolean;
};

type RootCheckResult = {
  isRooted: boolean;
  details: RootItemResult[];
};

export const rootCheck = async (): Promise<RootCheckResult | null> => {
  if (Platform.OS !== "android") {
    return Promise.resolve(null);
  }

  return RootJailbreakDetectionExpoModule.rootCheck()
    .then((result: RootCheckResult) => result)
    .catch((error: unknown) => {
      if (error instanceof Error) {
        throw new Error(`Root check failed: ${error.message}`);
      } else {
        throw new Error("Root check failed with an unknown error");
      }
    });
};
type JailbreakCheckResult = {
  isJailbroken: boolean;
};
export const jailbreakCheck = async (): Promise<JailbreakCheckResult> => {
  if (Platform.OS !== "ios") return { isJailbroken: false };
  try {
    const result: boolean =
      await RootJailbreakDetectionExpoModule.detectJailbreak();
    return { isJailbroken: result };
  } catch (error) {
    if (error instanceof Error) {
      throw new Error(`Jailbreak detection failed: ${error.message}`);
    } else {
      throw new Error("Jailbreak detection failed with an unknown error");
    }
  }
};

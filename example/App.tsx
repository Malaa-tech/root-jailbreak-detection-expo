import { useEffect, useState } from "react";
import { StyleSheet, Text, View } from "react-native";

import * as RootJailbreakDetectionExpo from "root-jailbreak-detection-expo";

export default function App() {
  const [isRooted, setIsRooted] = useState<boolean | undefined>(undefined);
  useEffect(() => {
    RootJailbreakDetectionExpo.rootCheck()
      .then((result) => {
        if (result === null) {
          setIsRooted(false);
          console.log("Root check is not supported on this platform");
        } else {
          setIsRooted(result.isRooted);
          console.log("Is device rooted?", result.isRooted);
          console.log("Root check details:");
          result.details.forEach((item) => {
            console.log(`${item.check}: ${item.detected}`);
          });
        }
      })
      .catch((error) => {
        console.error("Error during root check:", error);
      });
  }, []);
  return (
    <View style={styles.container}>
      <Text>
        {isRooted === undefined
          ? "Checking"
          : isRooted
          ? "Rooted"
          : "Not rooted"}
      </Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#fff",
    alignItems: "center",
    justifyContent: "center",
  },
});

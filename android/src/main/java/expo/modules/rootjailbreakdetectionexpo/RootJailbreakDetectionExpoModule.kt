package expo.modules.rootjailbreakdetectionexpo


import android.content.Context
import expo.modules.kotlin.modules.Module
import expo.modules.kotlin.modules.ModuleDefinition
import com.kimchangyoun.rootbeerFresh.RootBeer
import expo.modules.kotlin.Promise
import expo.modules.kotlin.exception.Exceptions
import com.kimchangyoun.rootbeerFresh.util.Utils

data class RootCheckResult(
    val isRooted: Boolean,
    val details: List<RootItemResult>
)
private fun performRootCheck(context: Context): RootCheckResult {
    val rootBeer = RootBeer(context)
    val checks = listOf(
        RootItemResult("Root Management Apps", rootBeer.detectRootManagementApps()),
        RootItemResult("Potentially Dangerous Apps", rootBeer.detectPotentiallyDangerousApps()),
        RootItemResult("Root Cloaking Apps", rootBeer.detectRootCloakingApps()),
        RootItemResult("TestKeys", rootBeer.detectTestKeys()),
        RootItemResult("BusyBoxBinary", rootBeer.checkForBusyBoxBinary()),
        RootItemResult("SU Binary", rootBeer.checkForSuBinary()),
        RootItemResult("2nd SU Binary check", rootBeer.checkSuExists()),
        RootItemResult("RW Paths", rootBeer.checkForRWPaths()),
        RootItemResult("Dangerous Props", rootBeer.checkForDangerousProps()),
        RootItemResult("Root via native check", rootBeer.checkForRootNative()),
        RootItemResult("Magisk Binary", rootBeer.checkForMagiskBinary()),
        RootItemResult("Magisk UDS", rootBeer.checkForMagiskNative())
    )

    val isRooted = checks.any { it.detected }
    return RootCheckResult(isRooted, checks)
}

private fun RootCheckResult.toMap(): Map<String, Any> = mapOf(
    "isRooted" to isRooted,
    "details" to details.map { mapOf("check" to it.check, "detected" to it.detected) }
)
data class RootItemResult(val check: String, val detected: Boolean)

class RootJailbreakDetectionExpoModule : Module() {
  private val context: Context
        get() = appContext.reactContext ?: throw Exceptions.ReactContextLost()

  override fun definition() = ModuleDefinition {

          Name("RootJailbreakDetectionExpo")
          AsyncFunction("rootCheck") { promise: Promise ->
              try {
                  val result = performRootCheck(context)
                  promise.resolve(result.toMap())
              } catch (e: Exception) {
                  promise.reject("ROOT_CHECK_ERROR", "An error occurred during root check", e)
              }
        }
  }
}

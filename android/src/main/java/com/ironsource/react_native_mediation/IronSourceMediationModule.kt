package com.ironsource.react_native_mediation

import android.graphics.Color
import android.util.Log
import android.view.Gravity
import android.view.View
import android.widget.FrameLayout
import com.facebook.react.bridge.*
import com.ironsource.adapters.supersonicads.SupersonicConfig
import com.ironsource.mediationsdk.ISBannerSize
import com.ironsource.mediationsdk.IronSource
import com.ironsource.mediationsdk.IronSourceBannerLayout
import com.ironsource.mediationsdk.IronSourceSegment
import com.ironsource.mediationsdk.impressionData.ImpressionData
import com.ironsource.mediationsdk.impressionData.ImpressionDataListener
import com.ironsource.mediationsdk.integration.IntegrationHelper
import com.ironsource.mediationsdk.model.Placement
import com.ironsource.mediationsdk.sdk.InitializationListener
import com.ironsource.react_native_mediation.IronConstants.E_ACTIVITY_IS_NULL
import com.ironsource.react_native_mediation.IronConstants.E_ILLEGAL_ARGUMENT
import com.ironsource.react_native_mediation.IronConstants.E_UNEXPECTED
import com.ironsource.react_native_mediation.Utils.Companion.sendEvent
import java.util.concurrent.Executors
import kotlin.math.abs


class IronSourceMediationModule(reactContext: ReactApplicationContext) :
    ReactContextBaseJavaModule(reactContext),
    LifecycleEventListener,
    ImpressionDataListener,
    InitializationListener {
    // Banner Related Fields
    private var mBannerContainer: FrameLayout? = null
    private var mBanner: IronSourceBannerLayout? = null
    private var mBannerVisibility: Int = View.VISIBLE

    // Listeners
    private val mRVListener: RCTRewardedVideoListener = RCTRewardedVideoListener(reactContext)
    private val mISListener: RCTInterstitialListener = RCTInterstitialListener(reactContext)
    private val mOWListener: RCTOfferwallListener = RCTOfferwallListener(reactContext)
    private val mBNListener: RCTBannerListener =
        RCTBannerListener(reactContext, ::onBannerAdLoadFailed)
    private val mLevelPlayBNListener: RCTLevelPlayBNListener =
        RCTLevelPlayBNListener(reactContext, ::onBannerAdLoadFailed)
    private val mLevelPlayRVListener: RCTLevelPlayRVListener = RCTLevelPlayRVListener(reactContext)
    private val mLevelPlayISListener: RCTLevelPlayISListener = RCTLevelPlayISListener(reactContext)

    init {
        reactContext.addLifecycleEventListener(this)
        setListeners()
    }

    override fun getName(): String {
        return "IronSourceMediation"
    }

    /** Listeners Setup =========================================================================**/
    private fun setListeners() {
        IronSource.setRewardedVideoListener(mRVListener)
        IronSource.setInterstitialListener(mISListener)
        IronSource.setOfferwallListener(mOWListener)
        IronSource.addImpressionDataListener(this)

        // LevelPlay Listeners
        IronSource.setLevelPlayRewardedVideoListener(mLevelPlayRVListener)
        IronSource.setLevelPlayInterstitialListener(mLevelPlayISListener)
    }

    /** ImpressionData Listener =================================================================**/
    override fun onImpressionSuccess(impressionData: ImpressionData?) {
        sendEvent(
            reactApplicationContext,
            IronConstants.ON_IMPRESSION_SUCCESS,
            impressionData?.toReadableMap()
        )
    }

    /** InitializationListener ==================================================================**/
    override fun onInitializationComplete() {
        sendEvent(reactApplicationContext, IronConstants.ON_INITIALIZATION_COMPLETE)
    }


    /** Base API  ============================================================================== **/

    /**
     * @return String? GAID
     */
    @ReactMethod
    fun getAdvertiserId(promise: Promise) {
        currentActivity?.apply {
            val executor = Executors.newSingleThreadExecutor()
            executor.execute {
                // this API MUST be called on a background thread
                val idStr = IronSource.getAdvertiserId(this)
                runOnUiThread { promise.resolve(idStr) }
            }
        } ?: return promise.reject(
            E_ACTIVITY_IS_NULL,
            "Current Activity does not exist."
        )
    }

    /**
     * @return null
     */
    @ReactMethod
    fun validateIntegration(promise: Promise) {
        currentActivity?.apply {
            IntegrationHelper.validateIntegration(this)
            return promise.resolve(null)
        } ?: return promise.reject(
            E_ACTIVITY_IS_NULL,
            "Current Activity does not exist."
        )
    }

    /**
     * @param isEnabled
     * @return null
     */
    @ReactMethod
    fun shouldTrackNetworkState(isEnabled: Boolean, promise: Promise) {
        currentActivity?.apply {
            IronSource.shouldTrackNetworkState(this, isEnabled)
            return promise.resolve(null)
        } ?: return promise.reject(
            E_ACTIVITY_IS_NULL,
            "Current Activity does not exist."
        )
    }

    /**
     * This does not throw when userId is an empty string.
     * @param userId
     * @return null
     */
    @ReactMethod
    fun setDynamicUserId(userId: String, promise: Promise) {
        IronSource.setDynamicUserId(userId)
        return promise.resolve(null)
    }

    /**
     * @param isEnabled
     * @return null
     */
    @ReactMethod
    fun setAdaptersDebug(isEnabled: Boolean, promise: Promise) {
        IronSource.setAdaptersDebug(isEnabled)
        return promise.resolve(null)
    }

    /**
     * @param isConsent
     * @return null
     */
    @ReactMethod
    fun setConsent(isConsent: Boolean, promise: Promise) {
        IronSource.setConsent(isConsent)
        return promise.resolve(null)
    }

    /**
     * JS number values are converted to Double.
     * @param segment ReadableMap
     *      segmentName?: String
     *      gender?: String ('female' | 'male')
     *      age?: Double (originally Int)
     *      level?: Double (originally Int)
     *      isPaying?: Boolean
     *      userCreationDateInMillis?: Double (originally Long number)
     *      iapTotal?: Double
     *      customParameters?: ReadableMap<String, String>
     * @return null
     */
    @ReactMethod
    fun setSegment(segment: ReadableMap, promise: Promise) {
        val iSSegment = IronSourceSegment()
        segment.entryIterator.forEach { entry ->
            when (entry.key) {
                "segmentName" -> entry.value?.let { iSSegment.segmentName = it as String }
                "age" -> entry.value?.let { iSSegment.age = (it as Double).toInt() }
                "gender" -> entry.value?.let { iSSegment.gender = it as String }
                "level" -> entry.value?.let { iSSegment.level = (it as Double).toInt() }
                "isPaying" -> entry.value?.let { iSSegment.setIsPaying(it as Boolean) }
                "userCreationDateInMillis" -> entry.value?.let { iSSegment.setUserCreationDate((it as Double).toLong()) }
                "iapTotal" -> entry.value?.let { iSSegment.setIAPTotal(it as Double) }
                "customParameters" -> entry.value?.let { params ->
                    (params as ReadableMap).entryIterator.forEach { param ->
                        iSSegment.setCustom(param.key, param.value as String)
                    }
                }
                else -> return promise.reject(
                    E_ILLEGAL_ARGUMENT,
                    "Invalid parameter. param: $entry"
                )
            }
        }

        IronSource.setSegment(iSSegment)
        return promise.resolve(null)
    }

    /**
     * @param key
     * @param values Array<String>
     * @return null
     */
    @ReactMethod
    fun setMetaData(key: String, values: ReadableArray, promise: Promise) {
        val strValues = values.toArrayList().map { v ->
            if (v !is String) {
                return promise.reject(
                    E_ILLEGAL_ARGUMENT,
                    "The MetaData value must be string. Value: ${v}"
                )
            } else {
                v
            }
        }
        IronSource.setMetaData(key, strValues)
        return promise.resolve(null)
    }

    /** Init API  ============================================================================== **/

    /**
     * This does not throw when userId is an empty string.
     * @param userId
     * @return null
     */
    @ReactMethod
    fun setUserId(userId: String, promise: Promise) {
        IronSource.setUserId(userId)
        return promise.resolve(null)
    }

    /**
     * @param appKey
     * @return null
     */
    @ReactMethod
    fun init(appKey: String, promise: Promise) {
        currentActivity?.apply {
            if (appKey.isEmpty()) {
                return promise.reject(E_ILLEGAL_ARGUMENT, "appKey must be provided.")
            }
            IronSource.init(this, appKey, this@IronSourceMediationModule)
            return promise.resolve(null)
        } ?: return promise.reject(
            E_ACTIVITY_IS_NULL,
            "Current Activity does not exist."
        )
    }

    /**
     * @param appKey
     * @param adUnits Array<"REWARDED_VIDEO" | "INTERSTITIAL" | "OFFERWALL" | "BANNER">
     * @return null
     */
    @ReactMethod
    fun initWithAdUnits(appKey: String, adUnits: ReadableArray, promise: Promise) {
        currentActivity?.apply {
            if (appKey.isEmpty()) {
                return promise.reject(E_ILLEGAL_ARGUMENT, "appKey must be provided.")
            }
            val parsed = adUnits.toArrayList().map {
                when (it) {
                    "REWARDED_VIDEO" -> IronSource.AD_UNIT.REWARDED_VIDEO
                    "INTERSTITIAL" -> IronSource.AD_UNIT.INTERSTITIAL
                    "OFFERWALL" -> IronSource.AD_UNIT.OFFERWALL
                    "BANNER" -> IronSource.AD_UNIT.BANNER
                    else -> return@initWithAdUnits promise.reject(
                        E_ILLEGAL_ARGUMENT,
                        "Unsupported ad unit: $it"
                    )
                }
            }.toTypedArray()

            IronSource.init(this, appKey, this@IronSourceMediationModule, *parsed)
            return promise.resolve(null)
        } ?: return promise.reject(
            E_ACTIVITY_IS_NULL,
            "Current Activity does not exist."
        )
    }

    /** RV API  ================================================================================ **/

    /**
     * @return null
     */
    @ReactMethod
    fun showRewardedVideo(promise: Promise) {
        currentActivity?.apply {
            IronSource.showRewardedVideo()
            return promise.resolve(null)
        } ?: return promise.reject(
            E_ACTIVITY_IS_NULL,
            "Current Activity does not exist."
        )
    }

    /**
     * @param placementName
     * @return null
     */
    @ReactMethod
    fun showRewardedVideoForPlacement(placementName: String, promise: Promise) {
        currentActivity?.apply {
            IronSource.showRewardedVideo(placementName)
            return promise.resolve(null)
        } ?: return promise.reject(
            E_ACTIVITY_IS_NULL,
            "Current Activity does not exist."
        )
    }

    /**
     * @return boolean - RV availability
     */
    @ReactMethod
    fun isRewardedVideoAvailable(promise: Promise) {
        return promise.resolve(IronSource.isRewardedVideoAvailable())
    }

    /**
     * @param placementName
     * @return ReadableMap? - RV Placement info
     */
    @ReactMethod
    fun getRewardedVideoPlacementInfo(placementName: String, promise: Promise) {
        val placement: Placement? = IronSource.getRewardedVideoPlacementInfo(placementName)
        return promise.resolve(placement?.toReadableMap())
    }

    /**
     * @param placementName
     * @return boolean - RV Placement capped state
     */
    @ReactMethod
    fun isRewardedVideoPlacementCapped(placementName: String, promise: Promise) {
        val isCapped = IronSource.isRewardedVideoPlacementCapped(placementName)
        return promise.resolve(isCapped)
    }

    /**
     * @param params Map<String, String> in ReadableMap
     * @return null
     */
    @ReactMethod
    fun setRewardedVideoServerParams(params: ReadableMap, promise: Promise) {
        val serverParams = mutableMapOf<String, String>()
        params.entryIterator.forEach { entry ->
            if (entry.value !is String) {
                return promise.reject(
                    E_ILLEGAL_ARGUMENT,
                    "Parameter values must be String -> ${entry.key}:${entry.value}"
                )
            }
            serverParams[entry.key] = entry.value as String
        }
        IronSource.setRewardedVideoServerParameters(serverParams)
        return promise.resolve(null)
    }

    /**
     * @return null
     */
    @ReactMethod
    fun clearRewardedVideoServerParams(promise: Promise) {
        IronSource.clearRewardedVideoServerParameters()
        return promise.resolve(null)
    }

    /**
     * @return null
     */
    @ReactMethod
    fun setManualLoadRewardedVideo(promise: Promise) {
        IronSource.setManualLoadRewardedVideo(mRVListener)
        return promise.resolve(null)
    }

    /**
     * Manual Load RV
     * @return null
     */
    @ReactMethod
    fun loadRewardedVideo(promise: Promise) {
        IronSource.loadRewardedVideo()
        return promise.resolve(null)
    }


    /** IS API  ================================================================================ **/

    /**
     * @return null
     */
    @ReactMethod
    fun loadInterstitial(promise: Promise) {
        IronSource.loadInterstitial()
        return promise.resolve(null)
    }

    /**
     * @return null
     */
    @ReactMethod
    fun showInterstitial(promise: Promise) {
        IronSource.showInterstitial()
        return promise.resolve(null)
    }

    /**
     * @param placementName
     * @return null
     */
    @ReactMethod
    fun showInterstitialForPlacement(placementName: String, promise: Promise) {
        currentActivity?.apply {
            IronSource.showInterstitial(placementName)
            return promise.resolve(null)
        } ?: return promise.reject(
            E_ACTIVITY_IS_NULL,
            "Current Activity does not exist."
        )
    }

    /**
     * @return boolean - Interstitial Availability
     */
    @ReactMethod
    fun isInterstitialReady(promise: Promise) {
        return promise.resolve(IronSource.isInterstitialReady())
    }

    /**
     * @param placementName
     * @return boolean - Placement Capping State
     */
    @ReactMethod
    fun isInterstitialPlacementCapped(placementName: String, promise: Promise) {
        val isCapped = IronSource.isInterstitialPlacementCapped(placementName)
        return promise.resolve(isCapped)
    }

    /** BN API ==================================================================================**/

    /**
     * JS number values are converted to Double.
     * @param options ReadableMap
     *      position: String
     *      sizeDescription: String ('BANNER' | 'SMART' | 'RECTANGLE' | 'LARGE')
     *      width: Double (originally Int)
     *      height: Double (originally Int)
     *      verticalOffset: Double (originally Int)
     *      placementName?: String
     * @return null
     */
    @ReactMethod
    fun loadBanner(options: ReadableMap, promise: Promise) {
        // Keys
        val KEY_POSITION = "position"
        val KEY_SIZE_DESCRIPTION = "sizeDescription"
        val KEY_WIDTH = "width"
        val KEY_HEIGHT = "height"
        val KEY_IS_ADAPTIVE = "isAdaptive"
        val KEY_VERTICAL_OFFSET = "verticalOffset"
        val KEY_PLACEMENT_NAME = "placementName"
        // Banner positions
        val BANNER_POSITION_TOP = "TOP"
        val BANNER_POSITION_CENTER = "CENTER"
        val BANNER_POSITION_BOTTOM = "BOTTOM"

        // fallback to BANNER in the case of invalid descriptions
        fun getBannerSize(sizeDescription: String): ISBannerSize {
            return when (sizeDescription) {
                "BANNER" -> ISBannerSize.BANNER
                "SMART" -> ISBannerSize.SMART
                "RECTANGLE" -> ISBannerSize.RECTANGLE
                "LARGE" -> ISBannerSize.LARGE
                else -> ISBannerSize.BANNER
            }
        }

        // fallback to BOTTOM in the case of unsupported strings
        fun getBannerGravity(position: String): Int {
            return when (position) {
                BANNER_POSITION_TOP -> Gravity.TOP
                BANNER_POSITION_CENTER -> Gravity.CENTER
                BANNER_POSITION_BOTTOM -> Gravity.BOTTOM
                else -> Gravity.BOTTOM
            }
        }

        currentActivity?.apply {
            // Default vertical position
            val position = options.getString(KEY_POSITION)
                ?: return promise.reject(E_ILLEGAL_ARGUMENT, "Banner Position must be passed.")
            val bannerGravity = getBannerGravity(position)

            // Banner size
            val sizeDescription: String? = options.getString(KEY_SIZE_DESCRIPTION)
            val hasWidth = options.hasKey(KEY_WIDTH) && !options.isNull(KEY_WIDTH)
            val hasHeight = options.hasKey(KEY_HEIGHT) && !options.isNull(KEY_HEIGHT)
            if (sizeDescription == null && !(hasWidth && hasHeight)) {
                return promise.reject(
                    E_ILLEGAL_ARGUMENT,
                    "Banner sizeDescription or width and height must be passed."
                )
            }
            val bannerSize: ISBannerSize =
                if (sizeDescription != null) getBannerSize(sizeDescription)
                else ISBannerSize(options.getInt(KEY_WIDTH), options.getInt(KEY_HEIGHT))

            // optional params
            val hasVerticalOffset =
                options.hasKey(KEY_VERTICAL_OFFSET) && !options.isNull(KEY_VERTICAL_OFFSET)
            val verticalOffset = if (hasVerticalOffset) options.getInt(KEY_VERTICAL_OFFSET) else 0
            val placementName: String? = options.getString(KEY_PLACEMENT_NAME)
            val hasIsAdaptive = options.hasKey(KEY_IS_ADAPTIVE) && !options.isNull(KEY_IS_ADAPTIVE)
            val isAdaptive: Boolean =
                if (hasIsAdaptive) options.getBoolean(KEY_IS_ADAPTIVE) else false
            bannerSize.isAdaptive = isAdaptive

            runOnUiThread {
                synchronized(this@IronSourceMediationModule) {
                    try {
                        // Create a container
                        if (mBannerContainer == null) {
                            mBannerContainer = FrameLayout(this).apply {
                                fitsSystemWindows = true
                                setBackgroundColor(Color.TRANSPARENT)
                            }
                            mBannerContainer?.visibility = mBannerVisibility
                            this.addContentView(
                                mBannerContainer, FrameLayout.LayoutParams(
                                    FrameLayout.LayoutParams.MATCH_PARENT,
                                    FrameLayout.LayoutParams.MATCH_PARENT
                                )
                            )
                        }

                        // Create banner if not exists yet
                        if (mBanner == null) {
                            mBanner = IronSource.createBanner(this, bannerSize)

                            // Banner layout params
                            val layoutParams = FrameLayout.LayoutParams(
                                FrameLayout.LayoutParams.MATCH_PARENT,
                                FrameLayout.LayoutParams.WRAP_CONTENT,
                                bannerGravity
                            ).apply {
                                // vertical offset
                                if (verticalOffset > 0) {
                                    topMargin = abs(verticalOffset)
                                } else if (verticalOffset < 0) {
                                    bottomMargin = abs(verticalOffset)
                                }
                            }

                            // Add Banner to the container
                            mBannerContainer?.addView(mBanner, 0, layoutParams)

                            // Set listeners
                            mBanner?.bannerListener = mBNListener
                            mBanner?.levelPlayBannerListener = mLevelPlayBNListener
                        }

                        mBanner?.visibility = mBannerVisibility

                        // Load banner
                        // if already loaded, console error would be shown by the iS SDK
                        if (placementName != null) {
                            IronSource.loadBanner(mBanner, placementName)
                        } else {
                            IronSource.loadBanner(mBanner)
                        }

                        promise.resolve(null)
                    } catch (e: Throwable) {
                        Log.e(TAG, e.toString())
                        promise.reject(E_UNEXPECTED, "Failed to load banner", e)
                    }
                }
            }
        } ?: return promise.reject(E_ACTIVITY_IS_NULL, "Current Activity does not exist.")
    }

    /**
     * Called by RCTBannerListener.
     * This is to handle the banner view state only.
     * The JS event is sent by RCTBannerListener.
     */
    private fun onBannerAdLoadFailed() {
        currentActivity?.runOnUiThread {
            synchronized(this@IronSourceMediationModule) {
                mBannerContainer?.removeAllViews()
                if (mBanner != null) {
                    mBanner = null
                }
            }
        }
    }

    /**
     * @return null
     */
    @ReactMethod
    fun destroyBanner(promise: Promise) {
        currentActivity?.apply {
            runOnUiThread {
                synchronized(this@IronSourceMediationModule) {
                    mBannerContainer?.removeAllViews()
                    if (mBanner != null) {
                        IronSource.destroyBanner(mBanner)
                        mBanner = null
                        mBannerVisibility = View.VISIBLE // Reset the visibility
                    }
                    promise.resolve(null)
                }
            }
        } ?: return promise.reject(E_ACTIVITY_IS_NULL, "Current Activity does not exist.")
    }

    /**
     * @return null
     */
    @ReactMethod
    fun displayBanner(promise: Promise) {
        currentActivity?.apply {
            runOnUiThread {
                synchronized(this@IronSourceMediationModule) {
                    mBannerVisibility = View.VISIBLE
                    mBanner?.visibility = View.VISIBLE
                    mBannerContainer?.visibility = View.VISIBLE
                    promise.resolve(null)
                }
            }
        } ?: return promise.reject(E_ACTIVITY_IS_NULL, "Current Activity does not exist.")
    }

    /**
     * @return null
     */
    @ReactMethod
    fun hideBanner(promise: Promise) {
        currentActivity?.apply {
            runOnUiThread {
                synchronized(this@IronSourceMediationModule) {
                    mBannerVisibility = View.GONE
                    mBanner?.visibility = View.GONE
                    mBannerContainer?.visibility = View.GONE
                    promise.resolve(null)
                }
            }
        } ?: return promise.reject(E_ACTIVITY_IS_NULL, "Current Activity does not exist.")
    }

    /**
     * @param placementName
     * @return boolean - Placement capped state
     */
    @ReactMethod
    fun isBannerPlacementCapped(placementName: String, promise: Promise) {
        val isCapped = IronSource.isBannerPlacementCapped(placementName)
        return promise.resolve(isCapped)
    }

    /** OW API ==================================================================================**/

    /**
     * @return null
     */
    @ReactMethod
    fun showOfferwall(promise: Promise) {
        currentActivity?.apply {
            IronSource.showOfferwall()
            return promise.resolve(null)
        } ?: return promise.reject(E_ACTIVITY_IS_NULL, "Current Activity does not exist.")
    }

    /**
     * @param placementName
     * @return null
     */
    @ReactMethod
    fun showOfferwallForPlacement(placementName: String, promise: Promise) {
        currentActivity?.apply {
            IronSource.showOfferwall(placementName)
            return promise.resolve(null)
        } ?: return promise.reject(E_ACTIVITY_IS_NULL, "Current Activity does not exist.")
    }

    /**
     * Credits will be notified through the OW Listener's onOfferwallAdCredited.
     * @return null
     */
    @ReactMethod
    fun getOfferwallCredits(promise: Promise) {
        IronSource.getOfferwallCredits()
        return promise.resolve(null)
    }

    /**
     * @return boolean - Offerwall Availability
     */
    @ReactMethod
    fun isOfferwallAvailable(promise: Promise) {
        return promise.resolve(IronSource.isOfferwallAvailable())
    }

    /**
     * OW Config API
     * must be called before init
     * @return null
     */
    @ReactMethod
    fun setClientSideCallbacks(isEnabled: Boolean, promise: Promise) {
        SupersonicConfig.getConfigObj().clientSideCallbacks = isEnabled
        return promise.resolve(null)
    }

    /**
     * OW Config API
     * @param params Map<String, String> in ReadableMap
     * @return null
     */
    @ReactMethod
    fun setOfferwallCustomParams(params: ReadableMap, promise: Promise) {
        val customParams = mutableMapOf<String, String>()
        params.entryIterator.forEach { entry ->
            if (entry.value !is String) {
                return promise.reject(
                    E_ILLEGAL_ARGUMENT,
                    "Parameter values must be String -> ${entry.key}:${entry.value}"
                )
            }
            customParams[entry.key] = entry.value as String
        }
        SupersonicConfig.getConfigObj().offerwallCustomParams = customParams
        return promise.resolve(null)
    }

    /** Event Emitter Constants ================================================================ **/
    override fun getConstants(): MutableMap<String, Any> {
        return IronConstants.getEventConstants()
    }

    /** LifecycleEventListener ================================================================= **/
    override fun onHostResume() {
        Log.d(TAG, "onHostResume")
        currentActivity?.apply { IronSource.onResume(this) }
    }

    override fun onHostPause() {
        Log.d(TAG, "onHostPause")
        currentActivity?.apply { IronSource.onPause(this) }
    }

    override fun onHostDestroy() {
        Log.d(TAG, "onHostDestroy")
    }

    /** Event Emitter Stubs ==================================================================== **/
    /**
     * These functions are required to suppress warnings:
     * `new NativeEventEmitter()` was called with a non-null argument without the required `removeListeners` method.
     *
     * Inspired by https://github.com/react-native-netinfo/react-native-netinfo/issues/486
     *             https://github.com/react-native-netinfo/react-native-netinfo/pull/487
     */
    @ReactMethod
    fun addListener(eventName: String) {
        // Keep
    }

    @ReactMethod
    fun removeListeners(count: Int) {
        // Keep
    }

    companion object {
        private val TAG = IronSourceMediationModule::class.java.simpleName
    }
}

package io.conekta.rn

import com.facebook.react.bridge.ReadableArray
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.uimanager.events.RCTEventEmitter

class ConektaTokenizerViewManager : SimpleViewManager<ConektaTokenizerNativeView>() {

    override fun getName() = "ConektaTokenizerView"

    override fun createViewInstance(context: ThemedReactContext) =
        ConektaTokenizerNativeView(context).also { view ->
            view.onSuccessEvent = { map ->
                context.getJSModule(RCTEventEmitter::class.java)
                    .receiveEvent(view.id, "onSuccess", map)
            }
            view.onErrorEvent = { map ->
                context.getJSModule(RCTEventEmitter::class.java)
                    .receiveEvent(view.id, "onError", map)
            }
        }

    @ReactProp(name = "publicKey")
    fun setPublicKey(view: ConektaTokenizerNativeView, value: String) =
        view.setPublicKey(value)

    @ReactProp(name = "merchantName")
    fun setMerchantName(view: ConektaTokenizerNativeView, value: String) =
        view.setMerchantName(value)

    @ReactProp(name = "locale")
    fun setLocale(view: ConektaTokenizerNativeView, value: String?) =
        view.setLocale(value)

    @ReactProp(name = "excludeCardNetworks")
    fun setExcludeCardNetworks(view: ConektaTokenizerNativeView, value: ReadableArray?) =
        view.setExcludeCardNetworks(value?.toArrayList()?.map { it.toString() }.orEmpty())

    override fun getExportedCustomDirectEventTypeConstants() = mapOf(
        "onSuccess" to mapOf("registrationName" to "onSuccess"),
        "onError" to mapOf("registrationName" to "onError"),
    )
}

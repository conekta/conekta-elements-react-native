package io.conekta.rn

import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.WritableMap
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.UIManagerHelper
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.uimanager.events.Event

class ConektaTokenizerViewManager : SimpleViewManager<ConektaTokenizerNativeView>() {

    override fun getName() = "ConektaTokenizerView"

    override fun createViewInstance(context: ThemedReactContext) =
        ConektaTokenizerNativeView(context).also { view ->
            view.onSuccessEvent = { map -> view.send(context, "onSuccess", map) }
            view.onErrorEvent = { map -> view.send(context, "onError", map) }
        }

    /** Sends [payload] to the view's JS handler [name] through React Native's event dispatcher. */
    private fun ConektaTokenizerNativeView.send(context: ThemedReactContext, name: String, payload: WritableMap) {
        UIManagerHelper
            .getEventDispatcherForReactTag(context, id)
            ?.dispatchEvent(TokenizerEvent(UIManagerHelper.getSurfaceId(context), id, name, payload))
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

/** One answer of the tokenizer (`onSuccess`, `onError`) on its way to the view's JS handler. */
private class TokenizerEvent(
    surfaceId: Int,
    viewId: Int,
    private val name: String,
    private val payload: WritableMap,
) : Event<TokenizerEvent>(surfaceId, viewId) {
    override fun getEventName(): String = name

    override fun getEventData(): WritableMap = payload
}

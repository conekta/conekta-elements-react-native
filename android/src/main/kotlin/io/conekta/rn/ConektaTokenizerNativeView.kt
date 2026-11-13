package io.conekta.rn

import android.content.Context
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.ui.platform.AbstractComposeView
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.WritableMap
import io.conekta.components.i18n.ComponentsLocale
import io.conekta.components.paymentmethods.card.CardNetwork
import io.conekta.components.tokenizer.models.TokenizerConfig
import io.conekta.components.tokenizer.models.TokenizerError
import io.conekta.compose.tokenizer.ConektaTokenizer

class ConektaTokenizerNativeView(context: Context) : AbstractComposeView(context) {
    private val publicKeyState = mutableStateOf("")
    private val merchantNameState = mutableStateOf("Demo Store")
    private val localeState = mutableStateOf<String?>(null)
    private val excludeCardNetworksState = mutableStateOf(emptyList<String>())

    var onSuccessEvent: ((WritableMap) -> Unit)? = null
    var onErrorEvent: ((WritableMap) -> Unit)? = null

    fun setPublicKey(value: String) {
        publicKeyState.value = value
    }

    fun setMerchantName(value: String) {
        merchantNameState.value = value
    }

    /** The form's language (`es`, `en`); `null` follows the device's. */
    fun setLocale(value: String?) {
        localeState.value = value
    }

    /** The card networks the form refuses (`amex`, `visa_master_card`). */
    fun setExcludeCardNetworks(value: List<String>) {
        excludeCardNetworksState.value = value
    }

    @Composable
    override fun Content() {
        val publicKey = publicKeyState.value
        val merchantName = merchantNameState.value
        if (publicKey.isEmpty()) return
        val config =
                TokenizerConfig(
                        publicKey = publicKey,
                        merchantName = merchantName,
                        locale = localeState.value?.let { ComponentsLocale.of(it) },
                        excludeCardNetworks =
                                excludeCardNetworksState.value.map { CardNetwork.fromSerialName(it) },
                )
        ConektaTokenizer(
                config = config,
                onSuccess = { result ->
                    val map =
                            Arguments.createMap().apply {
                                putString("token", result.token)
                                putString("lastFour", result.lastFour)
                            }
                    onSuccessEvent?.invoke(map)
                },
                onError = { error ->
                    val map =
                            Arguments.createMap().apply {
                                when (error) {
                                    is TokenizerError.ValidationError -> {
                                        putString("type", "ValidationError")
                                        putString("message", error.message)
                                    }
                                    is TokenizerError.NetworkError -> {
                                        putString("type", "NetworkError")
                                        putString("message", error.message)
                                    }
                                    is TokenizerError.ApiError -> {
                                        putString("type", "ApiError")
                                        putString("code", error.code)
                                        putString("message", error.message)
                                    }
                                }
                            }
                    onErrorEvent?.invoke(map)
                },
        )
    }
}

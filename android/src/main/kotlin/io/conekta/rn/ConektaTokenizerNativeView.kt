package io.conekta.rn

import android.content.Context
import androidx.compose.ui.platform.ComposeView
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.WritableMap
import io.conekta.compose.theme.ConektaTheme
import io.conekta.compose.tokenizer.ConektaTokenizer
import io.conekta.elements.tokenizer.models.TokenizerConfig
import io.conekta.elements.tokenizer.models.TokenizerError

class ConektaTokenizerNativeView(context: Context) : ComposeView(context) {
    private var publicKey = ""
    private var merchantName = "Demo Store"

    var onSuccessEvent: ((WritableMap) -> Unit)? = null
    var onErrorEvent: ((WritableMap) -> Unit)? = null

    fun setPublicKey(value: String) {
        publicKey = value
        render()
    }

    fun setMerchantName(value: String) {
        merchantName = value
        render()
    }

    private fun render() {
        if (publicKey.isEmpty()) return
        val config = TokenizerConfig(
            publicKey = publicKey,
            merchantName = merchantName,
        )
        setContent {
            ConektaTheme {
                ConektaTokenizer(
                    config = config,
                    onSuccess = { result ->
                        val map = Arguments.createMap().apply {
                            putString("token", result.token)
                            putString("lastFour", result.lastFour)
                        }
                        onSuccessEvent?.invoke(map)
                    },
                    onError = { error ->
                        val map = Arguments.createMap().apply {
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
    }
}

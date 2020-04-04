package com.elyeproj.sharedpreferences

import android.content.Context

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.core.widget.doAfterTextChanged
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity() {

    companion object {
        const val SharedPreferences = "SharedPreferences"
        const val SharedPreferencesBoolean = "SharedPreferencesBoolean"
        const val SharedPreferencesNumber = "SharedPreferencesNumber"
        const val SharedPreferencesString = "SharedPreferencesString"
    }

    private val sharedPreferences by lazy {
        this.getSharedPreferences(SharedPreferences, Context.MODE_PRIVATE)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        setupSwitch(savedInstanceState)
        setupEditText(savedInstanceState)
        setupEditTextNumber(savedInstanceState)
    }

    private fun setupSwitch(savedInstanceState: Bundle?) {
        savedInstanceState ?: run {
            uiSwitch.isChecked = sharedPreferences.getBoolean(SharedPreferencesBoolean,
                resources.getBoolean(R.bool.default_preference_boolean))
        }

        uiSwitch.setOnCheckedChangeListener { _, isChecked ->
            with(sharedPreferences.edit()) {
                putBoolean(SharedPreferencesBoolean, isChecked)
                commit()
            }
        }
    }

    private fun setupEditText(savedInstanceState: Bundle?) {
        savedInstanceState ?: run {
            uiEditText.setText(sharedPreferences.getString(SharedPreferencesString,
                getString(R.string.default_preference_string)))
        }

        uiEditText.doAfterTextChanged {
            with(sharedPreferences.edit()) {
                putString(SharedPreferencesString, uiEditText.text.toString())
                commit()
            }
        }
    }

    private fun setupEditTextNumber(savedInstanceState: Bundle?) {
        savedInstanceState ?: run {
            uiEditTextNumber.setText(sharedPreferences.getInt(SharedPreferencesNumber,
                resources.getInteger(R.integer.default_preference_number)).toString())
        }

        uiEditTextNumber.doAfterTextChanged {
            if (it.isNullOrBlank()) {
                modifyText(getString(R.string.initial_number_value))
                return@doAfterTextChanged
            }
            val originalText = it.toString()
            try {
                val numberText = originalText.toInt().toString()
                if (originalText != numberText) {
                    modifyText(numberText)
                } else {
                    updateSharedPrefNumber(numberText)
                }
            } catch (e: Exception) {
                modifyText(getString(R.string.initial_number_value))
            }
        }
    }

    private fun modifyText(numberText: String) {
        uiEditTextNumber.setText(numberText)
        uiEditTextNumber.setSelection(numberText.length)
        updateSharedPrefNumber(numberText)
    }

    private fun updateSharedPrefNumber(numberText: String) {
        with(sharedPreferences.edit()) {
            putInt(SharedPreferencesNumber, numberText.toInt())
            commit()
        }
    }
}

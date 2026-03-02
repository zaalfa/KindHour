package com.example.kindhour

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews

class KindHourWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        val prefs: SharedPreferences = context.getSharedPreferences(
            "FlutterSharedPreferences", Context.MODE_PRIVATE
        )

        val message = prefs.getString(
            "flutter.kind_hour_message",
            "You're doing great 🌸"
        )

        val bgColor = prefs.getString("flutter.kind_hour_theme", "pastel")

        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.kind_hour_widget)
            views.setTextViewText(R.id.kind_hour_message, message)

            // Apply background color based on theme + time block
            val timeBlock = prefs.getString("flutter.saved_time_block", "morning")
            val backgroundRes = getBackgroundRes(bgColor ?: "pastel", timeBlock ?: "morning")
            views.setInt(R.id.widget_root, "setBackgroundColor", backgroundRes)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    private fun getBackgroundRes(theme: String, timeBlock: String): Int {
        if (theme == "monochrome") {
            return when (timeBlock) {
                "morning" -> 0xFFF5F5F5.toInt()
                "noon" -> 0xFFEEEEEE.toInt()
                "afternoon" -> 0xFFE0E0E0.toInt()
                "evening" -> 0xFF757575.toInt()
                "night" -> 0xFF424242.toInt()
                else -> 0xFFBDBDBD.toInt()
            }
        }
        return when (timeBlock) {
            "morning" -> 0xFFFFFDE7.toInt()
            "noon" -> 0xFFE8F5E9.toInt()
            "afternoon" -> 0xFFFFF3E0.toInt()
            "evening" -> 0xFFF3E5F5.toInt()
            "night" -> 0xFFE8EAF6.toInt()
            else -> 0xFFFFF0F5.toInt()
        }
    }
}
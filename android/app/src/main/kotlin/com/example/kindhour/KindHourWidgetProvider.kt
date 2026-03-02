package com.example.kindhour

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.widget.RemoteViews

class KindHourWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        val prefs: SharedPreferences = context.getSharedPreferences(
            "HomeWidgetPreferences", Context.MODE_PRIVATE
        )

        val message = prefs.getString("kind_hour_message", "You're doing great 🌸")
        val theme = prefs.getString("kind_hour_theme", "pastel") ?: "pastel"
        val timeBlock = prefs.getString("saved_time_block", "morning") ?: "morning"

        val textColor = if (theme == "monochrome" && (timeBlock == "evening" || timeBlock == "night")) {
            0xFFFFFFFF.toInt()
        } else {
            0xFF333333.toInt()
        }

        // Intent untuk membuka app saat widget diklik
        val intent = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        val pendingIntent = PendingIntent.getActivity(
            context,
            0,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.kind_hour_widget)
            views.setTextViewText(R.id.kind_hour_message, message)
            views.setTextColor(R.id.kind_hour_message, textColor)
            views.setInt(R.id.widget_root, "setBackgroundResource", getBackgroundDrawable(theme, timeBlock))
            
            // Set click listener ke seluruh widget
            views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)
            
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    private fun getBackgroundDrawable(theme: String, timeBlock: String): Int {
        return if (theme == "monochrome") {
            when (timeBlock) {
                "morning" -> R.drawable.widget_bg_morning_mono
                "noon" -> R.drawable.widget_bg_noon_mono
                "afternoon" -> R.drawable.widget_bg_afternoon_mono
                "evening" -> R.drawable.widget_bg_evening_mono
                "night" -> R.drawable.widget_bg_night_mono
                else -> R.drawable.widget_bg_morning_mono
            }
        } else {
            when (timeBlock) {
                "morning" -> R.drawable.widget_bg_morning_pastel
                "noon" -> R.drawable.widget_bg_noon_pastel
                "afternoon" -> R.drawable.widget_bg_afternoon_pastel
                "evening" -> R.drawable.widget_bg_evening_pastel
                "night" -> R.drawable.widget_bg_night_pastel
                else -> R.drawable.widget_bg_morning_pastel
            }
        }
    }
}
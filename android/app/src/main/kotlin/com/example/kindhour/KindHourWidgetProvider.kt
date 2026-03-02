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

        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.kind_hour_widget)
            views.setTextViewText(R.id.kind_hour_message, message)
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
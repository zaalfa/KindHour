package com.example.kindhour

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews

class KindHourWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.kind_hour_widget)
            views.setTextViewText(R.id.kind_hour_message, "KindHour")
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
package com.example.app1

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class AppWidgetProvider : HomeWidgetProvider() {
    val imageList = ArrayList<SlideModel>() // Create image list

// imageList.add(SlideModel("String Url" or R.drawable)
// imageList.add(SlideModel("String Url" or R.drawable, "title") You can add title

imageList.add(SlideModel("https://bit.ly/2YoJ77H", "The animal population decreased by 58 percent in 42 years."))
imageList.add(SlideModel("https://bit.ly/2BteuF2", "Elephants and tigers may become extinct."))
imageList.add(SlideModel("https://bit.ly/3fLJf72", "And people do that."))
imageList.add(SlideModel(R.drawable.img2,"good"))
imageList.add(SlideModel(R.drawable.img3,"good1"))
imageList.add(SlideModel(R.drawable.img4,"good2"))
val imageSlider = findViewById<ImageSlider>(R.id.image_slider)
imageSlider.setImageList(imageList, ScaleTypes.FIT)
   

}


   /* override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {

                // Open App on Widget Click
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(context,
                        MainActivity::class.java)
                setOnClickPendingIntent(R.id.widget_root, pendingIntent)

                val counter = widgetData.getInt("_counter", 0)
                

                var counterText = "Your counter value is: $counter"
                
                 

                if (counter == 0) {
                    counterText = "You have not pressed the counter button"
                }

                setTextViewText(R.id.tv_counter, counterText)

                // Pending intent to update counter on button click
                val backgroundIntent = HomeWidgetBackgroundIntent.getBroadcast(context,
                        Uri.parse("myAppWidget://updatecounter"))
                setOnClickPendingIntent(R.id.bt_update, backgroundIntent)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }*/
}


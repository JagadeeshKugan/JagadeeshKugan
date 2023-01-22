package com.example.chris.fstest;

import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.widget.RemoteViews;
import android.widget.ImageView;

import java.net.URL;

/**
 * Implementation of App Widget functionality.
 */
public class NewAppWidget extends AppWidgetProvider {

     void updateAppWidget(Context context, AppWidgetManager appWidgetManager,
                                int appWidgetId) {

        CharSequence widgetText = context.getString(R.string.appwidget_text);
        // Construct the RemoteViews object
        RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.new_app_widget);

         int[] imageList = {R.drawable.guava, R.drawable.jackfruit, R.drawable.mix_fruit,
                 R.drawable.pomegranate, R.drawable.strawberry, R.drawable.zespri_kiwi};
         for (int image : imageList) {
             RemoteViews viewFlipperImage =new RemoteViews(context.getPackageName(), R.layout.view_notification_image);
             viewFlipperImage.setImageViewResource(R.id.imageView,   image);
             views.addView(R.id.ViewFlipper1, viewFlipperImage);

         }
         



         // Instruct the widget manager to update the widget
        appWidgetManager.updateAppWidget(appWidgetId, views);
    }

    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        // There may be multiple widgets active, so update all of them
        for (int appWidgetId : appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId);
        }
    }

    @Override
    public void onEnabled(Context context) {
        // Enter relevant functionality for when the first widget is created
    }

    @Override
    public void onDisabled(Context context) {
        // Enter relevant functionality for when the last widget is disabled
    }
}
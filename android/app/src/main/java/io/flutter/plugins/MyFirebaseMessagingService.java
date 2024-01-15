//package io.flutter.plugins;
//import android.app.Notification;
//import android.app.NotificationChannel;
//import android.app.NotificationManager;
//import android.content.Context;
//import android.os.Build;
//
//import androidx.core.app.NotificationCompat;
//
//import com.google.firebase.messaging.FirebaseMessagingService;
//import com.google.firebase.messaging.RemoteMessage;
//
//public class MyFirebaseMessagingService extends FirebaseMessagingService {
//    @Override
//    public void onMessageReceived(RemoteMessage remoteMessage) {
//        super.onMessageReceived(remoteMessage);
//
//        String notificationBody = "";
//        if (remoteMessage.getNotification() != null) {
//            notificationBody = remoteMessage.getNotification().getBody();
//        }
//
//        NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
//        String NOTIFICATION_CHANNEL_ID = "my_channel_id_01";
//
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            NotificationChannel channel = new NotificationChannel(NOTIFICATION_CHANNEL_ID,
//                    "My Notifications",
//                    NotificationManager.IMPORTANCE_DEFAULT);
//
//            channel.setDescription("Channel description");
//            notificationManager.createNotificationChannel(channel);
//        }
//
//        NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID);
//
//        notificationBuilder.setAutoCancel(true)
//                .setDefaults(Notification.DEFAULT_ALL)
//                .setWhen(System.currentTimeMillis())
//                .setContentTitle("Nova Notifikacija")
//                .setContentText(notificationBody)
//                .setContentInfo("Info");
//
//
//        notificationManager.notify(/* ID notifikacije */ 1, notificationBuilder.build());
//    }
//
//    @Override
//    public void onNewToken(String token) {
//        super.onNewToken(token);
//    }
//}
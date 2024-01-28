import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

void sendOrderNotification(
    String adminEmail, String orderId, bool isCancelled) async {
  final smtpServer = gmail('rahilahmed1720@gmail.com', 'imoj ervd kkye ronk');

  try {
    // Fetch order data using the orderId
    DocumentSnapshot orderSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId)
        .get();

    if (orderSnapshot.exists) {
      Map<String, dynamic> orderData =
          orderSnapshot.data() as Map<String, dynamic>;

      final message = Message()
        ..from = Address('rahilahmed1720@gmail.com', 'Ghar Ka Bazaar')
        ..recipients.add(orderData['email']) // Buyer's email
        ..recipients.add(adminEmail) // Admin's email
        ..subject = isCancelled ? 'Order Cancelled' : 'Order Confirmed'
        ..html = isCancelled
            ? getCancelledOrderHTML(orderData)
            : getConfirmedOrderHTML(orderData);

      await send(message, smtpServer);
    } else {
      print('Order document does not exist');
    }
  } catch (e) {
    print('Something went wrong while fetching or sending mail');
    print('Error: $e');
  }
}

String getCancelledOrderHTML(Map<String, dynamic> orderData) {
  return '''
    <html>
      <head>
        <style>
          body {
            font-family: 'Arial', sans-serif;
            color: #333;
          }
          h3 {
            color: #cc0000;
          }
          ul {
            list-style-type: none;
            padding: 0;
          }
          li {
            margin-bottom: 8px;
          }
          p {
            margin-top: 16px;
          }
        </style>
      </head>
      <body>
        <h3>Order has been cancelled.</h3>
        <p><strong>Order Details:</strong></p>
        <ul>
          <li><strong>Product Name:</strong> ${orderData['productName']}</li>
          <li><strong>Product Category:</strong> ${orderData['productCategory']}</li>
          <li><strong>Size:</strong> ${orderData['size']}</li>
          <li><strong>Payment Mode:</strong> ${orderData['mode']}</li>
        </ul>
        <p>For further assistance, contact support.</p>
      </body>
    </html>
  ''';
}

String getConfirmedOrderHTML(Map<String, dynamic> orderData) {
  return '''
    <html>
      <head>
        <style>
          body {
            font-family: 'Arial', sans-serif;
            color: #333;
          }
          h3 {
            color: #008000;
          }
          ul {
            list-style-type: none;
            padding: 0;
          }
          li {
            margin-bottom: 8px;
          }
          p {
            margin-top: 16px;
          }
        </style>
      </head>
      <body>
        <h3>Order has been confirmed!</h3>
        <p><strong>Order Details:</strong></p>
        <ul>
          <li><strong>Product Name:</strong> ${orderData['productName']}</li>
          <li><strong>Product Category:</strong> ${orderData['productCategory']}</li>
          <li><strong>Size:</strong> ${orderData['size']}</li>
          <li><strong>Payment Mode:</strong> ${orderData['mode']}</li>
        </ul>
        <p>Thank you for shopping with us!</p>
      </body>
    </html>
  ''';
}

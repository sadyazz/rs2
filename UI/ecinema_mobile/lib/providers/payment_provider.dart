import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import '../models/payment.dart';
import '../config/api_config.dart';
import 'base_provider.dart';

class PaymentProvider extends BaseProvider<Payment> {
  PaymentProvider() : super("Payment");

  @override
  Payment fromJson(data) {
    return Payment.fromJson(data);
  }

  String _extractPaymentIntentId(String clientSecret) {

    return clientSecret.split('_secret_')[0];
  }

  Future<Map<String, dynamic>> createPaymentIntent(int amount) async {
    try {
      final baseUrl = ApiConfig.baseUrl.endsWith("/") 
          ? ApiConfig.baseUrl.substring(0, ApiConfig.baseUrl.length - 1) 
          : ApiConfig.baseUrl;
          
      var url = "$baseUrl/Payment/create-payment-intent";
      var uri = Uri.parse(url);
      var headers = {
        ...createHeaders(),
        'Content-Type': 'application/json',
      };
      
      var request = {
        'amount': amount,
      };

      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(request),
      );

      if (!isValidResponse(response)) {
        throw Exception('Failed to create payment intent: ${response.statusCode} - ${response.body}');
      }

      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['clientSecret'] == null) {
        throw Exception('Invalid response: clientSecret is null');
      }

      final clientSecret = jsonResponse['clientSecret'] as String;
      final paymentIntentId = _extractPaymentIntentId(clientSecret);


      return {
        'clientSecret': clientSecret,
        'id': paymentIntentId,
      };
    } catch (e) {
      print('Error creating payment intent: $e');
      throw Exception('Error creating payment intent: $e');
    }
  }

  Future<String> initializePayment(int amount) async {
    try {
      final paymentIntent = await createPaymentIntent(amount);
      final clientSecret = paymentIntent['clientSecret'];
      final paymentIntentId = paymentIntent['id'];

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'eCinema',
          style: ThemeMode.light,
          appearance: PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: Color(0xFF4F8593),
            ),
          ),
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      return paymentIntentId;
    } catch (e) {
      if (e is StripeException) {
        throw Exception(e.error.localizedMessage);
      }
      throw Exception('Error initializing payment: $e');
    }
  }
}

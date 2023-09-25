

import 'package:flutter/material.dart';
import 'package:easy_upi_payment/easy_upi_payment.dart';

class EasyUpiPayments extends StatefulWidget {
  const EasyUpiPayments({Key? key}) : super(key: key);

  @override
  State<EasyUpiPayments> createState() => _EasyUpiPaymentsState();
}

class _EasyUpiPaymentsState extends State<EasyUpiPayments> {

  var vpaCtrl = TextEditingController();
  var vpaNameCtrl = TextEditingController();
  var vpaAmountCtrl = TextEditingController();
  var vpaDescriptionCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: Column(
                // spacing: 10,
                // direction: Axis.vertical,
                children: [
                  TextField(
                    controller: vpaCtrl,
                    decoration: InputDecoration(
                      labelText: 'VPA Address'
                    ),
                  ),
                  TextField(
                    controller: vpaNameCtrl,
                    decoration: InputDecoration(
                        labelText: 'Name'
                    ),
                  ),
                  TextField(
                    controller: vpaAmountCtrl,
                    decoration: InputDecoration(
                        labelText: 'Amount'
                    ),
                  ),
                  TextField(
                    controller: vpaDescriptionCtrl,
                    decoration: InputDecoration(
                        labelText: 'Description'
                    ),
                  ),
                ],
              ),
            ) ,
            Expanded(
              child: Center(
                child: ElevatedButton(
                  onPressed: onPayment,
                  child: Text('Easy Upi payments'),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }

  void onPayment() async {
    try {
      final res = await EasyUpiPaymentPlatform.instance.startPayment(
        EasyUpiPaymentModel(
          payeeVpa: vpaCtrl.text,
          payeeName: vpaNameCtrl.text,
          amount: double.parse(vpaAmountCtrl.text),
          description: vpaDescriptionCtrl.text,
        ),
      );
      if(res != null) {
        showSuccess(res as TransactionDetailModel);
      }else{
        showFailure();
      }
    } catch(e,s) {
      showFailure();
    }


  }

  void showSuccess(TransactionDetailModel transactionDetailModel) {
    showDialog(context: context,
        builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success or failure'),
          content: Column(
            children: [
              Text('${transactionDetailModel.amount}'),
              Text('${transactionDetailModel.transactionRefId}'),
            ],
          ),
        );
        }
    );
  }

  void showFailure() {
    showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(' failure'),
            content: Column(
              children: [
                Text('Failure')
              ],
            ),
          );
        }
    );
  }
}

class TransactionDetailModel {
  final String? transactionId;
  final String? responseCode;
  final String? approvalRefNo;
  final String? transactionRefId;
  final String? amount;

  const TransactionDetailModel({
    required this.transactionId,
    required this.responseCode,
    required this.approvalRefNo,
    required this.transactionRefId,
    required this.amount,
  });
}

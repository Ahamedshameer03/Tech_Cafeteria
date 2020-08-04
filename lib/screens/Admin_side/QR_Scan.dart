import 'package:cafeteria/components/size_cofig.dart';
import 'package:cafeteria/screens/Admin_side/order_list.dart';
import 'package:cafeteria/services/order_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRscan extends StatefulWidget {
  @override
  _QRscanState createState() => _QRscanState();
}

const flashOn = 'FLASH ON';
const flashOff = 'FLASH OFF';

class _QRscanState extends State<QRscan> {
  OrderServices _orderServices = OrderServices();
  List<DocumentSnapshot> orders = <DocumentSnapshot>[];

  var flashState = flashOn;

  @override
  void initState() {
    getOrders();
    super.initState();
  }

  getOrders() async {
    List<DocumentSnapshot> data = await _orderServices.getOrders();

    setState(() {
      orders = data;
    });
  }

  GlobalKey qrKey = GlobalKey();
  String qrText = "";
  QRViewController controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: SizeConfig.safeBlockVertical * 2,
                    ),
                    InkWell(
                      child: Icon(
                        Icons.close,
                        size: SizeConfig.safeBlockVertical * 5,
                        color: Colors.white,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
            ),
            Expanded(
                flex: 7,
                child: QRView(
                  key: qrKey,
                  overlay: QrScannerOverlayShape(
                    borderRadius: 10,
                    borderColor: Colors.indigo,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: 300,
                  ),
                  onQRViewCreated: _onQRViewCreate,
                )),
            qrText != ""
                ? Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.black,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: SizeConfig.safeBlockVertical * 10,
                            width: SizeConfig.safeBlockVertical * 10,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7)
                              ],
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.indigo,
                                  Colors.blueAccent,
                                  Colors.indigo,
                                ],
                              ),
                            ),
                            child: Center(
                              child: InkWell(
                                child: Text(
                                  'GO',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: SizeConfig.safeBlockVertical * 5,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OrderDetails(
                                                id: qrText,
                                              )));
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.black,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            icon: flashState == flashOff
                                ? Icon(Icons.flash_off)
                                : Icon(Icons.flash_on),
                            color: Colors.white,
                            iconSize: SizeConfig.safeBlockVertical * 5,
                            onPressed: () {
                              if (controller != null) {
                                controller.toggleFlash();
                                if (_isFlashOn(flashState)) {
                                  setState(() {
                                    flashState = flashOff;
                                  });
                                } else {
                                  setState(() {
                                    flashState = flashOn;
                                  });
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  bool _isFlashOn(String current) {
    return flashOn == current;
  }

  void _onQRViewCreate(QRViewController controller) {
    this.controller = controller;
    //navigate(qrText);
    controller.scannedDataStream.listen(
      (scanData) {
        setState(() {
          qrText = scanData;
          // controller.pauseCamera();
        });
      },
      // onDone: () {
      //   print('inside OnDone ');
      //   navigate(qrText);
      // },
    );
  }

  void navigate(String qrText) {
    if (qrText != "") {
      print("inside if: $qrText ");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrderDetails(
                    id: qrText,
                  )));
    }
  }
}

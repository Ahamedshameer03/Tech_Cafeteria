import 'package:cafeteria/components/size_cofig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent.withOpacity(0.1),
      child: Center(
        child: SpinKitWave(
          color: Colors.deepOrange,
          size: SizeConfig.safeBlockVertical * 5,
        ),
      ),
    );
  }
}

class Loading2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.transparent.withOpacity(0.1),
      child: Center(
        child: SpinKitWave(
          color: Colors.deepOrange,
          size: SizeConfig.safeBlockVertical * 2,
        ),
      ),
    );
  }
}

class Loading3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SpinKitWave(
          color: Colors.deepOrange,
          size: SizeConfig.safeBlockVertical * 3,
          duration: Duration(seconds: 1),
        ),
      ),
    );
  }
}

class Loading4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SpinKitWave(
          color: Colors.indigo,
          size: SizeConfig.safeBlockVertical * 3,
          duration: Duration(seconds: 2),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:sample_latest/data/utils/enums.dart';

import '../../utils/enums.dart';

class ExceptionView extends StatelessWidget {
  final DataErrorStateType stateType; 
  
  const ExceptionView(this.stateType, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: switch(stateType){
        
        DataErrorStateType.noInternet  => _buildNoInternetView(context),
         
        DataErrorStateType.serverNotFound => _buildServerNotFound(context),
        
        DataErrorStateType.somethingWentWrong || DataErrorStateType.none || DataErrorStateType.fetchData => _buildUnknownException(context),
        
        DataErrorStateType.unauthorized => _buildUnauthorized(context),

        DataErrorStateType.timeoutException => throw UnimplementedError(),
    }
    );
  }

  Widget _buildNoInternetView(BuildContext context) {
   return Image.asset('asset/exception_error/no_internet.gif');
  }
  
  Widget _buildUnknownException(BuildContext context) {
        return Column(
          children: [
            Text('Some thing went Wrong', style: Theme.of(context).textTheme.headlineMedium),
            Image.asset('asset/exception_error/unknown_error.gif')
          ],
        );
  }
  
  Widget _buildServerNotFound(BuildContext context) {
        return Text('Server Not Found', style: Theme.of(context).textTheme.labelLarge);
  }
  
  Widget _buildUnauthorized(BuildContext context) {
    return  Text('You are not Authorized', style: Theme.of(context).textTheme.labelLarge);
  }

  Widget _buildTimeoutException(BuildContext context) {
    return  Text('Time out', style: Theme.of(context).textTheme.labelLarge);
  }
  
}

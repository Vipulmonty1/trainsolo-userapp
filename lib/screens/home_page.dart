import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainsolo/bloc/login_bloc.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<LoginBloc>(context,listen:false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Email: ${bloc.email}'),
            Divider(),
            Text('Password: ${bloc.password}'),
          ],
        ),
      ),
    );
  }
}

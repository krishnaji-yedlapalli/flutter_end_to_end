

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_latest/core/mixins/loaders.dart';

import 'cubit/on_off_cubit.dart';
import 'cubit/on_off_state.dart';

class OnAndOffView extends StatefulWidget {
  const OnAndOffView({super.key});

  @override
  State<OnAndOffView> createState() => _OnAndOffViewState();
}

class _OnAndOffViewState extends State<OnAndOffView> with Loaders {
  @override
  Widget build(BuildContext context) {
    context.read<OnOffCubit>().loadStatus();
    return BlocBuilder<OnOffCubit, OnOffState>(
        builder: (context, OnOffState state) {
      if (state is CurrentOnOffState) {
        if(state.status) {
          return Center(child: ElevatedButton(onPressed: ()=> context.read<OnOffCubit>().off(), child: Text('Off')));
        }else{
          return Center(child: ElevatedButton(onPressed: ()=> context.read<OnOffCubit>().on(), child: Text('On')));
        }
      } else {
        return circularLoader();
      }
    });
  }
}

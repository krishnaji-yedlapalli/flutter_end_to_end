import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_latest/core/data/base_service.dart';

import '../../../core/local_server/widgets/server_initilize_wrapper.dart';
import '../features/on_and_off/data/respository/on_off_repository.dart';
import '../features/on_and_off/domain/use_cases/on_off_usecase.dart';
import '../features/on_and_off/presentation/cubit/on_off_cubit.dart';
import 'local_server/local_server_handler/local_server_handler.dart';

class SmartControlWrapperPage extends StatefulWidget {
  const SmartControlWrapperPage({super.key, required this.child});

  final Widget child;

  @override
  State<SmartControlWrapperPage> createState() =>
      _SmartControlWrapperPageState();
}

class _SmartControlWrapperPageState extends State<SmartControlWrapperPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return PopScope(
      onPopInvokedWithResult: (status, result) {

      },
      child:  ServerInitializeWrapper(
        serverRequestHandler: SmartControlServerRequestHandler(),
        child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => OnOffCubit(OnOffUsecase(OnOffRepository(BaseService.instance))))
            ],
            child: widget
                .child, // This ensures child routes have access to these blocs
        ),
      ),
    );
  }
}

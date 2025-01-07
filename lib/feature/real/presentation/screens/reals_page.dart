import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clean/core/get_it/get_it.dart'as di;
import 'package:instagram_clean/feature/real/domain/entity/real_entity.dart';
import 'package:instagram_clean/feature/real/presentation/cubit/real_cubit.dart';
import 'package:instagram_clean/feature/real/presentation/widget/single_real_widget.dart';

class RealsPage extends StatefulWidget {
  @override
  State<RealsPage> createState() => _RealsPageState();
}

class _RealsPageState extends State<RealsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .scaffoldBackgroundColor,
      body: BlocProvider<RealCubit>(
        create: (context) {
          final cubit = di.getIt<RealCubit>();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            cubit.getAllReals(real: RealEntity());
          });
          return cubit;
        },
        child: BlocBuilder<RealCubit, RealState>
          (builder: (context, realState) {
          if(realState is RealLoading){
            return Center(child: CircularProgressIndicator(),);
          }
          if(realState is RealFailure){
            print("Some Failure occured while creating the real");
          }
          if(realState is RealLoaded){
            return realState.reals.isEmpty? _noRealsYetWidget() :
                PageView.builder(
                  scrollDirection: Axis.vertical,
                  controller: PageController(
                      initialPage: 0, viewportFraction: 1),
                  itemBuilder: (context, index) {
                    final real = realState.reals[index];
                    return SingleRealWidget(real: real);
                  },
                  itemCount: realState.reals.length,
                );
          }
          return Center(child: CircularProgressIndicator());
        }

        ),
      ),
    );
  }

  _noRealsYetWidget() {
    return Center(child: Text("No Reals Yet", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),);
  }

}
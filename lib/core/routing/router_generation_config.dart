import 'package:doctor_app/core/routing/routes.dart';
import 'package:go_router/go_router.dart';

class RouterGenerationConfig {
  static GoRouter goRouter = GoRouter(
    initialLocation: AppRoutes.splashScreen,
    routes: [
      GoRoute(
        path: AppRoutes.splashScreen,
        name: AppRoutes.splashScreen,
        // builder: (context, state) => const SplashView(),
      ),
      // GoRoute(
      // path: AppRoutes.editTransactionScreen,
      // name: AppRoutes.editTransactionScreen,
      // builder: (context, state) {
      //   final transaction = state.extra! as Transaction;
      //   return BlocProvider.value(
      //     value: sl<TransactionCubit>(),
      //     child: EditTransactionScreen(
      //       transaction: transaction,
      //     ),
      //   );
      // },
      //),
    ],
  );
}

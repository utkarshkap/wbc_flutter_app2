import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

import '../../models/order_history_model.dart';
import '../../models/order_model.dart';
import '../../repositories/order_repositories.dart';

part 'order_event.dart';

part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderInitial()) {
    on<CreateOrder>((event, emit) async {
      emit(OrderDataAdding());
      await Future.delayed(const Duration(seconds: 3), () async {
        final orderRepo = OrderRepository();

        final response = await orderRepo.setOrder(
            userId: event.userId,
            orderId: event.orderId,
            amount: event.amount,
            shipName: event.shipName,
            shipAddress: event.shipAddress,
            deliverytype: event.deliverytype,
            country: event.country,
            state: event.state,
            city: event.city,
            zipcode: event.zipcode,
            phone: event.phone,
            orderDate: event.orderDate,
            items: event.items);

        print('----order--data--=---$response');

        response.statusCode == 200
            ? emit(OrderDataAdded(response))
            : emit(OrderFailed());
      });
    });

    on<GetOrderHistory>((event, emit) async {
      emit(OrderHistoryDataAdding());
      await Future.delayed(const Duration(seconds: 3), () async {
        final orderRepo = OrderRepository();
        final response = await orderRepo.getOrder(event.userId);

        final data = orderHistoryFromJson(response.data!.body);

        print('OrderHistoryStatus-------${response.data!.statusCode}');

        print('getOrderHistory Response------$data');
        response.data!.statusCode == 200
            ? emit(OrderHistoryDataAdded(data))
            : emit(OrderHistoryFailed());
      });
    });
  }
}

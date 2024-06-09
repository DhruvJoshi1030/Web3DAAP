import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:web3_expense/models/transaction_model.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<DashboardInitialFetchEvent>(dashboardInitialFetchEvent);
  }
  List<TransactionModel> transactions = [];
  Web3Client? _web3Client;
  late ContractAbi _abiCode;
  late EthereumAddress _contractAdress;
  late EthPrivateKey _creds;
  late ContractFunction _deposit;
  late ContractFunction _withdraw;
  late ContractFunction _getBalance;
  late ContractFunction _getAlltransactioin;
  late DeployedContract _deployedContract;

  FutureOr<void> dashboardInitialFetchEvent(
      event, Emitter<DashboardState> emit) async {
    emit(DashboardLoadingState());
    final String rpcUrl = "http://127.0.0.1:7545";
    final String socketUrl = "ws://127.0.0.1:7545";
    final String privateKey =
        "0xafaa060bf927466a273e1d512068f4736a40e7cb021eb274451c7a0fcbddc526";
    _web3Client = Web3Client(rpcUrl, http.Client(), socketConnector: () {
      return IOWebSocketChannel.connect(socketUrl).cast<String>();
    });

    String abiFile = await rootBundle
        .loadString('build/contracts/ExpenseMnagerContract.json');
    var jsonDecoded = jsonDecode(abiFile);
    _abiCode = ContractAbi.fromJson(
        jsonEncode(jsonDecoded['abi']), 'ExpenseMnagerContract');
    _contractAdress =
        EthereumAddress.fromHex(jsonDecoded["networks"]["5777"]["address"]);
    _creds = EthPrivateKey.fromHex(privateKey);

    _deployedContract = DeployedContract(_abiCode, _contractAdress);
    _deposit = _deployedContract.function("depsit");
    _withdraw = _deployedContract.function("withdraw");
    _getBalance = _deployedContract.function("getBalance");
    _getAlltransactioin = _deployedContract.function("getAllTransaction");

    final data = await _web3Client!.call(
        contract: _deployedContract, function: _getAlltransactioin, params: []);
    log(data.toString() as num);
  }
}

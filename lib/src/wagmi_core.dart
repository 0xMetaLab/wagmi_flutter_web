import 'dart:js_interop';

import 'package:wagmi_flutter_web/src/actions/get_balance.dart';
import 'package:wagmi_flutter_web/src/actions/get_block_number.dart';
import 'package:wagmi_flutter_web/src/actions/get_gas_price.dart';
import 'package:wagmi_flutter_web/src/actions/get_token.dart';
import 'package:wagmi_flutter_web/src/actions/read_contract.dart';
import 'package:wagmi_flutter_web/src/actions/sign_message.dart';
import 'package:wagmi_flutter_web/src/actions/write_contract.dart';
import 'package:wagmi_flutter_web/src/js/wagmi.js.dart';
import 'package:wagmi_flutter_web/src/models/account.dart';
import 'package:wagmi_flutter_web/src/models/chain.dart';

class Core {
  static Account getAccount() {
    return window.wagmiCore.getAccount().toDart;
  }

  static int getChainId() {
    return window.wagmiCore.getChainId().toDartInt;
  }

  static List<Chain> getChains() {
    return window.wagmiCore.getChains().toDart as List<Chain>;
  }

  static Future<GetBlockNumberReturnType> getBlockNumber(
    GetBlockNumberParameters getBlockNumberParameters,
  ) async {
    final result = await window.wagmiCore
        .getBlockNumber(
          getBlockNumberParameters.toJS,
        )
        .toDart;
    return result.toDart;
  }

  static Future<GetGasPriceReturnType> getGasPrice(
    GetGasPriceParameters getGasPriceParameters,
  ) async {
    final result = await window.wagmiCore
        .getGasPrice(
          getGasPriceParameters.toJS,
        )
        .toDart;
    return result.toDart;
  }

  static Future<GetBalanceReturnType> getBalance(
    GetBalanceParameters getBalanceParameters,
  ) async {
    final result = await window.wagmiCore
        .getBalance(
          getBalanceParameters.toJS,
        )
        .toDart;
    return result.toDart;
  }

  static Future<GetTokenReturnType> getToken(
    GetTokenParameters getTokenParameters,
  ) async {
    final result = await window.wagmiCore
        .getToken(
          getTokenParameters.toJS,
        )
        .toDart;
    return result.toDart;
  }

  static Future<String> signMessage(
    SignMessageParameters signMessageParameters,
  ) async {
    final result = await window.wagmiCore
        .signMessage(
          signMessageParameters.toJS,
        )
        .toDart;
    return result.toDart;
  }

  // read contract
  static Future<JSBigInt> readContract(
    ReadContractParameters readContractParameters,
  ) async {
    final result = await window.wagmiCore
        .readContract(
          readContractParameters.toJS,
        )
        .toDart;
    return result;
  }

  static Future<WriteContractReturnType> writeContract(
    WriteContractParameters writeContractParameters,
  ) async {
    final result = await window.wagmiCore
        .writeContract(
          writeContractParameters.toJS,
        )
        .toDart;
    return result.toDart;
  }
}

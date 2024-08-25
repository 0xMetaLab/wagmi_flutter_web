import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wagmi_flutter_web/wagmi_flutter_web.dart' as wagmi;

void main() {
  runApp(const MaterialApp(title: 'Web3Modal Example', home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int chainId = 0;
  wagmi.GetBalanceReturnType? balance, tokenBalance;
  wagmi.Account? account;
  List<wagmi.Chain> chains = [];
  BigInt? blockNumber;
  BigInt? gasPrice;
  String? signedMessage;
  String? hashApproval;
  String? token;
  int? gasEstimation;
  int? transactionCount;
  final tokenAddressToSearch = '0x8a3d77e9d6968b780564936d15B09805827C21fa';
  final messageToSign = 'Hello World';
  double? tokenSupply; // hold the total supply of the given token
  String bitTokenAddress =
      '0x2237605711227D0254Ccb33CE70767871Cf1CCc3'; // contract address deployed on polygonAmoy network only
  String hash =
      '0x28c67e05c4f32710697629c996e33f94f251e733e373f80ea84d432926ca9260';

  String testTokenA1 = '0x4D8cb4Fa6Df53d47f0B7d76a05d4AC881B2f4101';
  String tempWallet = '0xfAd3b616BCD747A12A7c0a6203E7a481606B12E8';

  @override
  void initState() {
    Future(
      () async {
        await wagmi.init();

        wagmi.Web3Modal.init(
          'f642e3f39ba3e375f8f714f18354faa4',
          [
            wagmi.Chain.mainnet.name,
            wagmi.Chain.sepolia.name,
            wagmi.Chain.polygonAmoy.name
          ],
          true,
          true,
          wagmi.Web3ModalMetadata(
            name: 'Web3Modal',
            description: 'Web3Modal Example',
            // url must match your domain & subdomain
            url: 'https://web3modal.com',
            icons: ['https://avatars.githubusercontent.com/u/37784886'],
          ),
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Web3Modal')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ElevatedButton(
                onPressed: wagmi.Web3Modal.open,
                child: Text('Connect Wallet'),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    signedMessage = null;
                    account = wagmi.Core.getAccount();
                    chainId = wagmi.Core.getChainId();
                  });
                },
                child: const Text('Get Account info'),
              ),
              const SizedBox(
                height: 10,
              ),
              Text('account address: ${account?.address ?? 'unknown'}'),
              Text('account status:  ${account?.status ?? 'unknown'}'),
              Text('account chain ID: ${account?.chain?.id ?? 'unknown'}'),
              Text('Chain ID: $chainId'),
              ElevatedButton(
                onPressed: () {
                  chains = wagmi.Core.getChains();

                  showGetChainsMethodsResponse(context, chains);
                },
                child: const Text('Get chains'),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  final getBlockNumberParameters =
                      wagmi.GetBlockNumberParameters(
                    chainId: account!.chain!.id,
                    cacheTime: 4000,
                  );
                  final getBlockNumberReturnType =
                      await wagmi.Core.getBlockNumber(
                    getBlockNumberParameters,
                  );
                  setState(() {
                    blockNumber = getBlockNumberReturnType.blockNumber;
                  });
                },
                child: const Text('Get Block number'),
              ),
              if (blockNumber != null)
                Text(
                  'blockNumber : $blockNumber',
                ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  final getGasPriceParameters = wagmi.GetGasPriceParameters(
                    chainId: account!.chain!.id,
                  );
                  final getGasPriceReturnType =
                      await wagmi.Core.getGasPrice(getGasPriceParameters);
                  setState(() {
                    gasPrice = getGasPriceReturnType.gasPrice;
                  });
                },
                child: const Text('Get Gas Price'),
              ),
              if (gasPrice != null)
                Text(
                  'gasPrice : $gasPrice',
                ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  final balanceResult = await wagmi.Core.getBalance(
                    wagmi.GetBalanceParameters(
                      address: account?.address ?? '',
                      blockTag: 'latest',
                    ),
                  );
                  setState(() {
                    balance = balanceResult;
                  });
                },
                child: const Text('Get Balance'),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                (balance != null && balance!.value > BigInt.from(0))
                    ? 'balance : ${(balance!.value.toInt()) / pow(10, balance!.decimals)} ${balance?.symbol}'
                    : 'balance : ${balance?.value ?? 'unknown'} ${balance?.symbol}',
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  final balanceResult = await wagmi.Core.getBalance(
                    wagmi.GetBalanceParameters(
                      address: account?.address ?? '',
                      token: bitTokenAddress,
                    ),
                  );
                  setState(() {
                    tokenBalance = balanceResult;
                  });
                },
                child: const Text('Get BIT Token Balance'),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                (tokenBalance != null && tokenBalance!.value > BigInt.from(0))
                    ? 'balance : ${(tokenBalance!.value.toInt()) / pow(10, tokenBalance!.decimals)} ${tokenBalance?.symbol}'
                    : 'balance : ${tokenBalance?.value ?? 'unknown'} ${tokenBalance?.symbol}',
              ),
              const SizedBox(
                height: 5,
              ),
              ElevatedButton(
                onPressed: () async {
                  final getTokenParameters = wagmi.GetTokenParameters(
                    address: tokenAddressToSearch,
                    chainId: account!.chain!.id,
                  );
                  final getTokenReturnType =
                      await wagmi.Core.getToken(getTokenParameters);
                  setState(() {
                    token =
                        '${getTokenReturnType.name} ${getTokenReturnType.symbol}';
                  });
                },
                child: Text(
                  'Get Token info ($tokenAddressToSearch / ${account?.chain!.id})',
                ),
              ),
              if (token != null) Text('token: $token'),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  final transactionCountResult =
                      await wagmi.Core.getTransactionCount(
                    wagmi.GetTransactionCountParameters(
                      address: account?.address ?? '',
                      chainId: account!.chain!.id,
                      blockTag: 'latest',
                    ),
                  );
                  setState(() {
                    transactionCount = transactionCountResult;
                  });
                },
                child: const Text('Get Transaction Count'),
              ),
              const SizedBox(
                height: 5,
              ),
              if (transactionCount != null)
                Text('transactionCount : $transactionCount'),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  // read contract
                  final getTokenParameters = wagmi.ReadContractParameters(
                    abi: bitContractAbi,
                    address: bitTokenAddress,
                    functionName: 'totalSupply',
                  );
                  final readContractReturnType =
                      await wagmi.Core.readContract(getTokenParameters);
                  setState(() {
                    tokenSupply =
                        int.parse(readContractReturnType.toString()) / 1000000;
                  });
                },
                child: const Text('Get Token Supply From Contract'),
              ),
              const SizedBox(
                height: 7,
              ),
              if (tokenSupply != null)
                Text(
                  'Total token supply :  $tokenSupply',
                )
              else
                Container(),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  final signMessageParameters = wagmi.SignMessageParameters(
                    account: account!.address!,
                    message: messageToSign,
                  );
                  final signMessageReturnType =
                      await wagmi.Core.signMessage(signMessageParameters);
                  setState(() {
                    signedMessage = signMessageReturnType;
                  });
                },
                child: Text('Personal sign ($messageToSign)'),
              ),
              if (signedMessage != null)
                Column(
                  children: [
                    Text('message signed: $signedMessage'),
                  ],
                ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  final writeContractParameters = wagmi.WriteContractParameters(
                    abi: [
                      {
                        'inputs': [
                          {
                            'internalType': 'address',
                            'name': 'spender',
                            'type': 'address',
                          },
                          {
                            'internalType': 'uint256',
                            'name': 'amount',
                            'type': 'uint256',
                          }
                        ],
                        'name': 'approve',
                        'outputs': [
                          {
                            'internalType': 'bool',
                            'name': '',
                            'type': 'bool',
                          },
                        ],
                        'stateMutability': 'nonpayable',
                        'type': 'function',
                      },
                    ],
                    address: '0xCBBd3374090113732393DAE1433Bc14E5233d5d7',
                    account: account?.address,
                    functionName: 'approve',
                    gas: BigInt.from(1500000),
                    args: [
                      '0x08Bfc8BA9fD137Fb632F79548B150FE0Be493254',
                      // TODO: https://github.com/dart-lang/sdk/issues/56539
                      BigInt.parse('498500000000000'),
                    ],
                    chainId: 11155111,
                  );

                  final writeContractReturnType =
                      await wagmi.Core.writeContract(writeContractParameters);

                  setState(() {
                    hashApproval = writeContractReturnType.hash;
                  });
                },
                child: const Text('Call approve function'),
              ),
              if (hashApproval != null)
                Column(
                  children: [
                    Text('Hash approval: $hashApproval'),
                  ],
                ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  final getTransactionReceiptParameters =
                      wagmi.GetTransactionReceiptParameters(hash: hash);
                  final readContractReturnType =
                      await wagmi.Core.getTransactionReceipt(
                    getTransactionReceiptParameters,
                  );
                  showTransactionReceiptDialog(
                    context,
                    readContractReturnType,
                  );
                },
                child: const Text('Get Transaction Receipt'),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  final readContractsParameters = wagmi.ReadContractsParameters(
                    contracts: [
                      {
                        'abi': bitContractAbi,
                        'address': bitTokenAddress,
                        'functionName': 'totalSupply',
                      },
                      {
                        'abi': testA1ContractAbi,
                        'address': testTokenA1,
                        'functionName': 'balanceOf',
                        'args': [tempWallet],
                      },
                    ],
                  );
                  final result = await wagmi.Core.readContracts(
                    readContractsParameters,
                  );
                  showMultipleContractMethodsResponse(context, result);
                },
                child: const Text('Call Multiple Contracts'),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  final estimateGasParameters = wagmi.EstimateGasParameters(
                    to: '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2',
                    gasPrice: BigInt.parse('10000000000000000'),
                    account: account!.address,
                    data: '0xd0e30db0',
                    value: BigInt.parse('10000000000000000'),
                  );
                  final result =
                      await wagmi.Core.estimateGas(estimateGasParameters);
                  setState(() {
                    gasEstimation = result.toInt();
                  });
                },
                child: const Text('Estimate Gas'),
              ),
              const SizedBox(
                height: 7,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map> bitContractAbi = [
    {
      'inputs': [],
      'name': 'totalSupply',
      'outputs': [
        {'internalType': 'uint256', 'name': '', 'type': 'uint256'},
      ],
      'stateMutability': 'view',
      'type': 'function'
    }
  ];
  List<Map> testA1ContractAbi = [
    {
      'inputs': [
        {'internalType': 'address', 'name': 'account', 'type': 'address'},
      ],
      'name': 'balanceOf',
      'outputs': [
        {'internalType': 'uint256', 'name': '', 'type': 'uint256'},
      ],
      'stateMutability': 'view',
      'type': 'function',
    }
  ];

  // dialog to show transaction receipt
  void showTransactionReceiptDialog(
    BuildContext context,
    wagmi.GetTransactionReceiptReturnType transactionReceipt,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Transaction Receipt'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('blockHash: ${transactionReceipt.blockHash}'),
              // space
              const SizedBox(height: 8),
              Text('blockNumber: ${transactionReceipt.blockNumber}'),
              const SizedBox(height: 8),
              Text('contractAddress: ${transactionReceipt.contractAddress}'),
              const SizedBox(height: 8),
              Text(
                  'cumulativeGasUsed: ${transactionReceipt.cumulativeGasUsed}'),
              const SizedBox(height: 8),
              Text('from: ${transactionReceipt.from}'),
              const SizedBox(height: 8),
              Text('gasUsed: ${transactionReceipt.gasUsed}'),
              const SizedBox(height: 8),
              // Text('logs: ${transactionReceipt.logs}'),
              // Text('logsBloom: ${transactionReceipt.logsBloom}'),
              Text('status: ${transactionReceipt.status}'),
              const SizedBox(height: 8),
              Text('to: ${transactionReceipt.to}'), const SizedBox(height: 8),
              Text('transactionHash: ${transactionReceipt.transactionHash}'),
              const SizedBox(height: 8),
              Text('transactionIndex: ${transactionReceipt.transactionIndex}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // dialog to show transaction receipt
  void showMultipleContractMethodsResponse(
    BuildContext context,
    // list of multiple contract methods response
    List<Map<String, dynamic>> multipleContractMethodsResponse,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Read Multiple Contracts'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bit0 Contract',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              // space
              const SizedBox(height: 4),
              Text(
                  'Total Supply: ${BigInt.parse((multipleContractMethodsResponse[0]['result'].toString())) / BigInt.from(1000000)}'),
              // space
              const SizedBox(height: 8),
              Text('TestA1 Contract',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                  'Balance of wallet $tempWallet : ${BigInt.parse((multipleContractMethodsResponse[1]['result'].toString())) / BigInt.from(1000000)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void showGetChainsMethodsResponse(
    BuildContext context,
    List<wagmi.Chain> getChainsMethodsResponse,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Get Chains'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: getChainsMethodsResponse.length,
              itemBuilder: (context, index) {
                final chain = getChainsMethodsResponse[index];
                return ExpansionTile(
                  title: Text(chain.name),
                  children: [
                    ListTile(
                      title: const Text('ID'),
                      subtitle: Text(chain.id.toString()),
                    ),
                    ListTile(
                      title: const Text('Native Currency'),
                      subtitle: Text(chain.nativeCurrency?.name ?? 'Unknown'),
                    ),
                  ],
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

import { WagmiCore, Chains, Web3modal } from "https://cdn.jsdelivr.net/npm/cdn-wagmi@3.0.0/dist/cdn-wagmi.js"


const { reconnect, getAccount, getChainId, getToken, signMessage, getBalance, writeContract } = WagmiCore

class JSChain {
  static chainFromString(chainString) {
    switch (chainString) {
      case 'mainnet': return Chains.mainnet;
      case 'sepolia': return Chains.sepolia;
    }
  }
}

var _wagmiConfig = undefined;
function config() {
  if (_wagmiConfig === undefined) {
    throw new Error('Wagmi not initialized. Call `Web3Modal.init` first.');
  }
  return _wagmiConfig;
}

class JSWeb3Modal {
  _modalInstance;
  _modal() {
    if (this._modalInstance === undefined) {
      throw new Error('Wagmi not initialized. Call `Web3Modal.init` first.');
    }
    return this._modalInstance;
  }

  init(
    projectId,
    chains,
    enableAnalytics,
    enableOnRamp,
    metadata,
  ) {
    console.log(`chains : ${chains}`)
    const jsChains = chains.map((chainString) => JSChain.chainFromString(chainString))
    console.log(`jschains : ${jsChains.map((jsChain) => jsChain.name)}`)
    _wagmiConfig = Web3modal.defaultWagmiConfig({
      chains: jsChains,
      projectId: projectId,
      metadata: metadata,
    })

    this._modalInstance = Web3modal.createWeb3Modal({
      wagmiConfig: _wagmiConfig,
      projectId: projectId,
      enableAnalytics: enableAnalytics, // Optional - defaults to your Cloud configuration
      enableOnramp: enableOnRamp, // Optional - false as default
    })
  }

  open() {
    return this._modal().open()
  }

  close() {
    return this._modal().close()
  }
}



class JSWagmiCore {
  getAccount = function () {
    const account = getAccount(config());
    return account;
  }

  getChainId = function () {
    const chainId = getChainId(config());
    return chainId;
  }

  getBalance = async function (getBalanceParameters) {
    if (!getBalanceParameters.address || !/^0x[a-fA-F0-9]{40}$/.test(getBalanceParameters.address)) {
      console.error("Invalid address provided");
      return null;
    }

    try {
      return await getBalance(config(), getBalanceParameters);
    } catch (error) {
      console.error("Error fetching balance:", error);
      return null;
    }
  }

  getToken = async function (getTokenParameters) {
    try {
      return await getToken(config(), getTokenParameters);
    } catch (error) {
      console.error("Error fetching token info:", error);
      return null;
    }
  }

  signMessage = async function (message, accountAddress) {
    if (!message) {
      console.error("No message provided");
      return null;
    }
    if (!accountAddress || !/^0x[a-fA-F0-9]{40}$/.test(accountAddress)) {
      console.error("Invalid account address provided");
      return null;
    }
    try {
      const signedMessage = await signMessage(config(), {
        account: accountAddress,
        message: message,
      });

      return signedMessage;
    } catch (error) {
      console.error("Error message sign:", error);
      return null;
    }
  }
}

window.web3modal = new JSWeb3Modal()
window.wagmiCore = new JSWagmiCore()

document.dispatchEvent(new Event('wagmi_flutter_web_ready'))
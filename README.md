# ENEFITS iOS SDK

This guide is for anyone who wishes to integrate the Enefits Mobile SDK into an iOS native app.  
Before continuing, we highly recommend reviewing the General Usage guide to familiarize yourself with general SDK workflow concepts before continuing.

You will need to generate an API key with your Enefits account before continuing with integration.

To obtain an API Key, simply register at http://enefits.co, go to Developer in the account menu in the top right section.  
From there, generate an API Key and save this for all API requests as defined below.  

We only show this once so if you lose this API Key, you’ll have to re-generate from the Developer section.

##Run The Demo

* To run a live demo, visit https://github.com/Enefits/enefits-ios-nft-sdk/tree/main/EnefitsSample and provide your own API key where requested.

##Download The SDK

* The Enefits iOS SDK can be downloaded from --> https://github.com/Enefits/enefits-ios-nft-sdk/tree/main/EnefitsSDK.xcframework


##Installation

* Go to Targets -> General -> Frameworks, Libraries and Embedded Content and drag-drop the EnefitsSDK.xcframework here. Change Embed to Embed & Sign.

* EnefitsSDK.xcFramework will be added to the Frameworks folder in the Project Navigator

#SDK SETUP

##Initialize The SDK

* Import the SDK in the required controllers -> "import EnefitsSDK"

```
Enefits.shared.initializeSDK(name: YOUR_APP_NAME_HERE, apiKey: YOUR_API_KEY_HERE) { flag, message in
    /* Flag -> Bool
    true -> Success
    false -> failed
    */

    /* message -> String (from the Enefits SDK) */
}
```

##Connect Wallet

 Display a button or call-to-action (for example: Connect Wallet) which when pressed or clicked will prompt the user to connect a wallet.  
 After the user selects a wallet and initiates a session, the returned address will be available to the Enefits SDK to check NFTs and any offers the user is eligible for.

 * This function will open a view with a list of supported providers
 
 * Enefits SDK will fire the callback after successfully connecting with a blockchain account.

 ```
Enefits.shared.present(from: VIEWCONTROLLER, apiKeyString: YOUR_API_KEY_HERE, completionHandler:{ flag, message in
    if flag == false{ 
        /* Already connected or not initialized, Show the message from Enefits SDK */
    }else{
        /* Connecting with wallet */
    }
})
 ```
/* Get callback after wallet connected */

```
Enefits.shared.isConnectedWithWallet = { flag in
    if flag == true { /* Conected with wallet success */
        if let session =  Enefits.shared.walletConnect?.session{
            guard let walletString = session.walletInfo?.accounts.first else { return }
        }
    }else{
        /* Failed to connect with wallets */
    }
}
```

##Get All Enefits Offers

* This method will return all Offers that the user is eligible for based on the address they provided when they connected their wallet.
  
* Based on the response from this method and the existence of a specific id value that the Mobile App is looking for, your app logic will handle accordingly.

 ```
Enefits.shared.getOffers(apiKeyString :YOUR_API_KEY_HERE, completionHandler: { flag, message in
    if flag == false {
        /* Failed to get offers, show the message from Enefits SDK */
    }else{
        /* Got the offers list in the message */
    }
})
 ```

##Helper Functions

Use the functions provided below to create a tighter integration with the Enefits SDK and manage user connectivity states.

 ```
/**
 * Check if Enefits SDK has successfully initialised.
 *
 * @return boolean
 */

let isInitComplete = Enefits.shared.isInitComplete
 ```

 ```
/**
 * Check if Enefits SDK was able to connect to a blockchain account.
 *
 * @return boolean
 */
 
 let isAccountConnected = Enefits.shared.isAccountConnected
 ```


 ```
/**
 * Get the address of the connected account.
 *
 * @return [String: Any], String
 */

 
Enefits.shared.getConnectAccount(apiKeyString :YOUR_API_KEY_HERE, completionHandler: { account, blockchainInfo in
    /* account -> String returns the connected account */
    /* blockchainInfo -> [String: Any] returns the walletInformations */
})
 ```


 ```
/**
 * Get the blockchain info for the connected account.
 *
 * @return String
 */

  
Enefits.shared.getChainData(apiKeyString :apiKeyValue, completionHandler: { blockchainInfo in
    
})
 ```


 ```
/**
 * Disconnect from the blockchain account.
 */
 
Enefits.shared.disconnect(apiKeyString :YOUR_API_KEY_HERE, completionHandler: { flag, message in
    if flag == true {
        /* Disconnected */
    }else{
        /* No session found show the error message from SDK */
    }
})
 ```
    

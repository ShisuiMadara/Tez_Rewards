import { TezosToolkit } from "@taquito/taquito";

export class App
{
    private tezos : TezosToolkit;

    constructor (rpcUrl : string)
    {
        this.tezos = new TezosToolkit(rpcUrl);
    }

    public getBalance(address : string) : void 
    {
        this.tezos.rpc
            .getBalance(address)
            .then(balance => console.log(balance))
            .catch(e => console.log("Could not fetch balance !"));
    }

    public getContractEntrypoints(address : string) : void 
    {
        this.tezos.contract
            .at(address)
            .then(c => {
                let methods = c.parameterSchema.ExtractSignatures();
                console.log(JSON.stringify(methods, null, 2));
            })
            .catch(e => console.log(`Error getting entrypoints! ${e}`));
    }

    public async main()
    {

    }
}
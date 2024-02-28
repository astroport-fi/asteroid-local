# Asteroid Local Setup

## Links

- Frontend - http://localhost:4200/app
- Hasura Console / GraphQL playground - http://localhost:8080/console
- GraphQL API - http://localhost:8080/v1/graphql
- DB Explorer - http://localhost:8888/?pgsql=db&username=admin&db=meteors&ns=public
- Cosmos Hub RPC - http://localhost:16657
- Cosmos Hub REST - http://localhost:1316

## Accounts

| Address      | Mnemonic |
| ----------- | ----------- |
| cosmos1m9l358xunhhwds0568za49mzhvuxx9uxre5tud | banner spread envelope side kite person disagree path silver will brother under couch edit food venture squirrel civil budget number acquire point work mass |
| cosmos10h9stc5v6ntgeygf5xf945njqq5h32r53uquvw | veteran try aware erosion drink dance decade comic dawn museum release episode original list ability owner size tuition surface ceiling depth seminar capable only |

## Prerequisites

### General
- Docker - https://docs.docker.com/get-docker/
- Go - https://go.dev/doc/install

### Frontend (if you want to run frontend)
- Node.js - https://nodejs.org/

### Relayer (if you want to run relayer)
- Rust - https://www.rust-lang.org/tools/install

## Setup Cosmos Hub

1. Clone repo

    ```bash
    git clone --depth 1 --branch v14.1.0 https://github.com/cosmos/gaia
    ```

2. Install `gaiad`

    ```bash
    cd gaia && make install
    ```

## Setup DB & API and init Cosmos Hub

1. Clone repo

    ```bash
    git clone https://github.com/astroport-fi/asteroid-local
    ```

2. Init Cosmos Hub

    ```bash
    ./network/init-and-start-gaia.sh
    ```

    once initialized run

    ```bash
    ./network/start-gaia.sh
    ```

3. Create a docker network

    ```bash
    docker network create external-example
    ```

4. Run services with Docker

    ```bash
    docker compose up
    ```

## Setup Asteroid

Clone repo

```bash
git clone https://github.com/astroport-fi/asteroid-protocol
```

### Setup Indexer

1. `cd indexer`
2. Create `.env` file
    ```bash
    cp .env.template .env
    ```

3. Install [Atlas migration tool CLI](https://atlasgo.io/)

    ```curl
    curl -sSf https://atlasgo.sh | sh
    ```

4. Run migrations

    ```bash
    atlas migrate apply --env local
    ```

4. Open [DB Explorer](http://localhost:8888/?pgsql=db&username=admin&db=meteors&ns=public&sql=) and create status row for local Cosmos hub

    ```bash
    INSERT INTO "status" ("id", "chain_id", "last_processed_height", "base_token", "base_token_usd", "date_updated", "last_known_height") VALUES
    (1,	'gaialocal-1',	1,	'ATOM',	9.419,	NOW(), 1);
    ```

5. Run indexer

    ```
    make run
    ```

### Load Hasura API configuration

1. Install [Hasura CLI](https://hasura.io/docs/latest/hasura-cli/install-hasura-cli/) first
2. Apply Hasura Metadata

    ```bash
    hasura metadata apply
    ```


### Setup Frontend

```
npm install -g @angular/cli

cd frontend
yarn install
ng serve --configuration development
```

## Add Local Cosmos Hub to Keplr or Leap

Use `window.leap` in Leap case

```javascript
await window.keplr.experimentalSuggestChain({
    chainId: "gaialocal-1",
    chainName: "Local Cosmos Hub",
    rpc: "http://localhost:16657",
    rest: "http://localhost:1316",
    bip44: {
        coinType: 118,
    },
    bech32Config: {
        bech32PrefixAccAddr: "cosmos",
        bech32PrefixAccPub: "cosmos" + "pub",
        bech32PrefixValAddr: "cosmos" + "valoper",
        bech32PrefixValPub: "cosmos" + "valoperpub",
        bech32PrefixConsAddr: "cosmos" + "valcons",
        bech32PrefixConsPub: "cosmos" + "valconspub",
    },
    currencies: [ 
        {
            coinDenom: 'ATOM',
            coinMinimalDenom: 'uatom',
            coinDecimals: 6
        },
    ],
    feeCurrencies: [
        {
            coinDenom: 'ATOM',
            coinMinimalDenom: 'uatom',
            coinDecimals: 6,
            gasPriceStep: { low: 0.1, average: 0.2, high: 0.3 }
        }
    ],
    stakeCurrency: {
        coinDenom: 'ATOM',
        coinMinimalDenom: 'uatom',
        coinDecimals: 6
    },
    coinType: 118,
    features: ['stargate', 'ibc-transfer']
});
```

## Appendix

### Setup Neutron

1. Clone repo

    ```bash
    git clone --depth 1 --branch v2.0.0 https://github.com/neutron-org/neutron
    ```

2. Install `neutrond`

    ```bash
    cd neutron && make install
    ```

3. Init Neutron

    ```bash
    ./network/init-and-start-neutron.sh
    ```

    once initialized run

    ```bash
    ./network/start-neutron.sh
    ```

### Setup Relayer

1. Install Hermes

    ```instal
    cargo install ibc-relayer-cli --bin hermes --version 1.6.0 --locked
    ```

2. Run relayer

    ```bash
    ./network/hermes/start.sh
    ```

### Additional Resources

- https://docs.neutron.org/neutron/build-and-run/localnet/

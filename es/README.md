<h1 align="center">
  <br>
  <img src="https://user-images.githubusercontent.com/12957692/190872812-dd6f2133-4e67-476c-ba04-6b0aa63ecde3.png" height=100 width=100 />
  <br><br>
  Stake Together
  <br>
</h1>
<h4 align="center">Ganemos rewards colaborando con la descentralización de Ethereum</h4>

## Contributors

<img src="https://contrib.rocks/image?repo=nicobevilacqua/StakeTogether-BearBuildersHackathon"/>

## Frontend

#### ℹ️ El frontend está en la carpeta **planb**

## Pitch Deck

https://www.canva.com/design/DAFMc9Ykgzc/XCcbeQfYMIRCbQvqR4_Maw/view

## Stake ETH

Hacemos un stake de ETH en un crowfunding para correr un nodo validador y minteamos tokens como comprobante

![Stake](https://user-images.githubusercontent.com/12957692/190873601-6c7e343c-dc9b-4408-84e4-5b3e1308a5cf.jpg)

## Withdraw ETH

Podemos hacer un redeem del ETH antes de que comience el staking period, quemadon los tokens de comprobante y recibiendo el ETH correspondiente.

![Redeeem](https://user-images.githubusercontent.com/12957692/190873901-c5aa3266-099a-462e-9748-b08995ca212c.jpg)


## Staking Period

Una vez la última persona completa el faltante para los 32 ETH, se corre el validador y comienza el staking period

![staking period](https://user-images.githubusercontent.com/12957692/190874138-b8d7a35d-8f18-4053-9cf6-cea669b59840.jpg)

## Redeeem

Una vez pasado el staking period las personas pueden hacer claim de los rewards

![My Movie](https://user-images.githubusercontent.com/12957692/190874297-77a5fb2d-798f-4fe8-895c-c7a822a7b8dd.jpg)


## Getting started (frontend)

```
cd frontend
npm install
npm start
```


## Run locally

`NOTE: Make sure that you have foundry installed`

1. Run anvil node in a new terminal.
```sh
  $ anvil
```

2. Run `local.sh` and deploy contracts.
```sh
  $ ./local.sh
```

3. Run frontend from ``frontend``.
```sh
$ cd frontend
$ yarn
$ yarn start
```

4. Add localhost connection to metamask.

* Network name: **Localhost**
* New RPC URL: **http://localhost:8545/**
* Chain ID: **1337**
* Currency Symbol: **ETH**
* Block Explorer URL: **http://localhost:8545/**

<img width="400" style="margin: 10px auto;" src="./images/metamask.png" />

5. Switch network to localhost on metamask.


## Get some ETH locally
Call this script with your metamask wallet address
```sh
  WALLET=*|your wallet here|* AMOUNT=*|amount in eth|* forge script ./script/GetEth.s.sol --rpc-url http://127.0.0.1:8545 --private-key 0x2a871d0798f97d79848a013d4936a73bf4cc922c825d33c1cf7073dff6d409c6 --broadcast
```

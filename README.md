<h1 align="center">
  <br>
  LOGO
  <br><br>
  Adminpro - Backend
  <br>
</h1>
<h4 align="center">Stake Together</h4>


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
<script>
  import { login, chainId, wallet, changeNetwork, provider} from "$lib/eth.js";
	import getContract from "$lib/contract.js";
  import { formatUnits, formatEther, parseEther, parseUnits } from "ethers/lib/utils";
	
	let hooks = false;

	  let loaded = false;
  let userBalance;
  
  let ethmountVal = '';
	let outputStake;
  let minting, maxMint, invalid;
	let currentVault = 0;
	let progress = 0;
	let vaultBalance = 0;
	let vault, weth, manager;
let balance;
  $: if($wallet) {
    load();
  }

  async function load() {
		manager = window.m = await getContract('VaultManager');
		weth = window.w = await getContract('weth', 'ERC20');
    balance = await $provider.getBalance($wallet)
		loaded = true
		currentVault = Number(await manager.getVaultsLen()) - 1;
		vault = await getContract(await manager.vaults(currentVault), 'Vault');		
		vaultBalance = await weth.balanceOf(vault.address);
		progress = Number(vaultBalance.mul(10000).div(parseEther("32"))) / 100;

		userBalance = await vault.balanceOf($wallet);

		if(!hooks) {
			hooks = true;
			manager.on('FundsAdded', () => {
				load();
			})
		}
  }


	async function useMaxETHER() {
		// usa el maximo
		balance = await $provider.getBalance($wallet)
		ethmountVal = formatEther(balance);
		updateethmountVal()
	}

	function updateethmountVal() {
		outputStake = parseEther(String(ethmountVal || '0'))
		if (Number(formatEther(outputStake)) > Number(formatEther(balance))) {
			outputStake = balance;
			ethmountVal = formatEther(balance);
		}
	}



async function mint() {
	minting =  true;
	invalid = true;
	try {
		const tx = await manager['depositToVault()']({value: parseEther(String(ethmountVal))});
		await tx.wait(1);
		// lo hago aca rapido y despues con el init recargo los datos por las dudas
		balance = balance.sub(parseEther(String(ethmountVal)))
		userBalance = userBalance.add(parseEther(String(ethmountVal)))

		ethmountVal = formatEther("0");
	} catch(err) {
		console.error(err);
	}
	
	minting =  false;
	invalid = false;
	updateethmountVal();
	load();

}
</script>
<svelte:head>
	<title>Home</title>
	<meta name="description" content="Svelte demo app" />
</svelte:head>

<div class="container mx-auto">
	<div class="mx-auto my-10 p-6 max-w-lg bg-white rounded-lg border border-gray-200 shadow-md dark:bg-gray-800 dark:border-gray-700">
			
			<h5 class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white">Lets Stake Together</h5>
			
			<p class="mb-3 font-normal text-gray-700 dark:text-gray-400">
				Stakea tus eth para comprar un nodo validador de ETH 2.0.
			</p>
			
<hr />

<div class="flex justify-center flex-col mx-auto w-full text-center max-w-lg">
    <div class="border rounded-lg flex flex-row mx-auto mt-14">
      <a class="p-2 m-1 rounded-lg w-28 uppercase text-sm font-semibold text-black no-underline hover:no-underline bg-slate-300" href="./">Mint</a>
      <a class="p-2 m-1 rounded-lg w-28 uppercase text-sm font-semibold text-black no-underline hover:no-underline hover:bg-slate-100" href="./redeem">Redeem</a>
    </div>
    <div class="rounded-3xl bg-white shadow-sm w-full mt-10 mx-auto flex flex-col px-5 py-4 z-10">
      <h1 class="uppercase text-black text-3xl">Mint</h1>
      <div class="border rounded-lg p-2 flex flex-col">
        <div class="flex flex-row text-xs text-gray-700 justify-between items-center">
          {#if loaded}
            <div>ETH a stakear</div>
            <div>Balance: {formatEther(balance || '0')}</div>
          {:else}
            <div class="animate-pulse w-16 bg-slate-200 h-4"></div>
            <div class="animate-pulse w-20 bg-slate-200 h-4"></div>
          {/if}
        </div>
        <div class="flex flex-row text-gray-700 justify-between pt-1 items-center">
          <!-- {#if loaded} -->
            <input type="number" placeholder="0" min="0"
            max="{formatEther(balance || '0')}"
            disabled={!loaded}
            bind:value={ethmountVal} 
            on:input="{updateethmountVal}"
            step="0.01" 
            class="text-4xl outline-none w-72 font-mono" />
          <!-- {:else}
            <div class="h-10 w-full bg-slate-200 animate-pulse"></div>
          {/if} -->
          <button class="text-xs hover:border-gray-600 border-transparent border rounded px-1 mx-4 py-0 h-6 bg-slate-200"
          on:click|preventDefault={loaded ? useMaxETHER : undefined}>MAX</button>
          <!-- <div class="flex flex-row items-center"> -->
            <div class="text-xl font-semibold w-14">ETH</div>
          <!-- </div> -->
        </div>
      </div>
      <div class="text-left">
      </div>

      <span class="text-black text-3xl text-center fill-black mx-auto py-2">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" viewBox="0 0 384 512"><path d="M374.6 310.6l-160 160C208.4 476.9 200.2 480 192 480s-16.38-3.125-22.62-9.375l-160-160c-12.5-12.5-12.5-32.75 0-45.25s32.75-12.5 45.25 0L160 370.8V64c0-17.69 14.33-31.1 31.1-31.1S224 46.31 224 64v306.8l105.4-105.4c12.5-12.5 32.75-12.5 45.25 0S387.1 298.1 374.6 310.6z"/></svg>
      </span>
      <div class="border rounded-lg p-2 flex flex-col">
        <div class="flex flex-row text-xs text-gray-700 justify-between">
          <div>Output</div>
          {#if loaded}
            <div>Balance: {Number(formatEther(userBalance || '0')).toFixed(6)}</div>
          {:else}
            <div class="animate-pulse w-20 bg-slate-200 h-4"></div>
          {/if}
        </div>
        <div class="flex flex-row text-gray-700 justify-between pt-1">
          <input type="number" placeholder="0" min="0" value={Number(formatEther(outputStake || '0')).toFixed(8)} readonly class="text-4xl w-72 outline-none font-mono text-green-700" />
          <div class="flex flex-row">
            <div class="text-xl font-semibold w-14">vETH</div>
          </div>
        </div>
      </div>
      <div>
        {#if !$wallet}
          <button class="bg-blue-500 hover:bg-blue-600 text-2xl text-white w-full rounded-xl py-4 font-semibold mt-4"
          on:click|preventDefault={login}
          >Connect wallet</button>
        {:else if $chainId != 31337}
          <button class="bg-red-500 hover:bg-red-600 text-2xl text-white w-full rounded-xl py-4 font-semibold mt-4"
          on:click|preventDefault={changeNetwork}
          >Connect to Local</button>
        {:else}
          
          <button class="bg-blue-500 hover:bg-blue-600 text-2xl text-white w-full rounded-xl py-4 font-semibold mt-4"
          on:click|preventDefault={mint}
          disabled={invalid}
          class:cursor-wait={minting}>Mint</button>
        {/if}
      </div>
      
    </div>
    <div class="-mt-8 pt-10 shadow-lg max-w-lg w-[96%] rounded mx-auto">
      <div class="flex flex-col px-5 font-mono text-sm py-1">
				<div class="flex justify-between pb-0.5">
          <div class="text-gray-600">Current Vault</div>
          {#if loaded}
            <div class="text-black"># {currentVault}</div>
          {:else}
            <div class="animate-pulse w-14 bg-slate-200 h-4"></div>
          {/if}
        </div>

        <div class="flex justify-between pb-0.5">
          <div class="text-gray-600">Target Stake</div>
          <div class="text-black">32 ETH</div>
        </div>
        <div class="flex justify-between pb-0.5">
          <div class="text-gray-600">Expected APR</div>
          <div class="text-black">4.76%</div>
        </div>
				<div class="flex justify-between pb-0.5">
          <div class="text-gray-600">Stake Duration</div>
          <div class="text-black">6 Months</div>
        </div>
        <div class="flex justify-between pb-0.5">
          <div class="text-gray-600">Current stake</div>
          {#if loaded}
            <div class="text-black">{Number(formatEther(vaultBalance || '0')).toFixed(2)}<span class="pl-[3px]">ETH</span></div>
          {:else}
            <div class="animate-pulse w-14 bg-slate-200 h-4"></div>
          {/if}
        </div>
				<div class="flex justify-between py-0.5">
					<div class="w-full h-6 bg-gray-200 rounded-full dark:bg-gray-700">
						{#if loaded}
							<div class="bg-slate-500 h-6 text-base font-medium text-white text-center p-1 leading-none rounded-full" style="width: {progress}%">
								{#if progress > 10}
									{progress}%
								{/if}
							</div>
						{:else}
							<!-- <div class="animate-pulse w-14 bg-slate-200 h-4"></div>-->
						{/if}
					</div>
				</div>
			
			
			
      </div>
			
    </div>
  </div>






	</div>
	
</div>
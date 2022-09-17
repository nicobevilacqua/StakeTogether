<script>

    import { login, chainId, wallet, changeNetwork, provider} from "$lib/eth.js";
	import getContract from "$lib/contract.js";
  import { formatUnits, formatEther, parseEther, parseUnits } from "ethers/lib/utils";
	
	let hooks = false;

	let loaded = false;
  $: if($wallet) {
    load();
  }

  let manager, weth, vault;
  let currentVault, balance, vaultBalance;
  const vaults = [];

  async function load() {
    manager = await getContract('VaultManager');
		weth = await getContract('weth', 'ERC20');
    balance = await $provider.getBalance($wallet)
		loaded = true
		currentVault = Number(await manager.getVaultsLen()) - 1;
    // hay muchas formas mejores de hacer esto
    for(let i = 0; i < currentVault; i++) {
      const _contract = await getContract(await manager.vaults(i), 'Vault');
      vaults[i] = {
        contract: _contract,
        exitDate: await _contract.exitDate(),
        userBalance: await _contract.balanceOf($wallet),
        tokenId: await _contract.tokenId(),
        // totalEarns: await _contract.totalEarns()
      };		  
    }		
  }


async function exitStake(v) {
  await v.contract.exitStake();
}

function formatDate(d) {
  
  const dt = new Date(d *1000);
const padL = (nr, len = 2, chr = `0`) => `${nr}`.padStart(2, chr);

return `${
    padL(dt.getDate())}/${
    padL(dt.getMonth()+1)}/${
    dt.getFullYear()} ${
    padL(dt.getHours())}:${
    padL(dt.getMinutes())}:${
    padL(dt.getSeconds())}`
;
}

</script>
<div class="container mx-auto">
	<div class="mx-auto my-10 p-6 max-w-xl bg-white rounded-lg border border-gray-200 dark:bg-gray-800 dark:border-gray-700">
    <div class="overflow-x-auto relative sm:rounded-lg">
        <table class="w-full text-sm text-left text-gray-500 dark:text-gray-400">
            <thead class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
                <tr>
                    <th scope="col" class="py-3 px-2">
                        Pool id
                    </th>
                    <th scope="col" class="py-3 px-2">
                        End date
                    </th>
                    <th scope="col" class="py-3 px-2">
                        Your stake
                    </th>
                    <th scope="col" class="py-3 px-2">
                        Total Gain
                    </th>
                    <th scope="col" class="py-3 px-2">
                        Action
                    </th>
                </tr>
            </thead>
            <tbody>
              {#if !loaded}
                {#each [0,1,2,3,4,5,6] as i}
                  <tr class="bg-white border-b dark:bg-gray-900 dark:border-gray-700">
                      <th scope="row" class="py-4 px-2 font-medium text-gray-900 whitespace-nowrap dark:text-white">
                          <div class="animate-pulse w-14 bg-slate-200 h-4"></div>
                      </th>
                      <td class="py-4 px-2">
                          <div class="animate-pulse w-14 bg-slate-200 h-4"></div>
                      </td>
                      <td class="py-4 px-2">
                          <div class="animate-pulse w-14 bg-slate-200 h-4"></div>
                      </td>
                      <td class="py-4 px-2">
                          <div class="animate-pulse w-14 bg-slate-200 h-4"></div>
                      </td>
                      
                      <td class="py-4 px-2">
                          <div class="animate-pulse w-14 bg-slate-200 h-4"></div>
                      </td>
                  </tr>
                {/each}
              {:else if currentVault == 0}
                <tr class="bg-white border-b dark:bg-gray-900 dark:border-gray-700">
                  <td colspan="5">
                    <h1 class="mx-auto font-bold text-gray-800 mt-3  text-2xl text-center w-full">No hay vaults listas</h1>
                  </td>
                </tr>
              {:else}
                {#each vaults as v, i}
                  <tr class="bg-white border-b dark:bg-gray-900 dark:border-gray-700">
                      <th scope="row" class="py-4 px-2 font-medium text-gray-900 whitespace-nowrap dark:text-white">
                          #{i} token: {v.tokenId}
                      </th>
                      <td class="py-4 px-2">
                          {formatDate(Number(v.exitDate))}
                      </td>
                      <td class="py-4 px-2">
                          {Number(Number(formatEther(v.userBalance)).toFixed(6))} ETH
                      </td>
                      <td class="py-4 px-2">
                          Pending...
                      </td>
                      
                      <td class="py-4 px-2">
                          {#if Number(formatEther(v.userBalance)) == 0}
                            ----
                          {:else}
                            <button on:click={() => { exitStake(v) }} class="font-medium text-blue-600 dark:text-blue-500 hover:underline">Claim</button>
                          {/if}
                      </td>
                  </tr>
                {/each}
              {/if}
          </tbody>
        </table>
    </div>
  </div>
</div>
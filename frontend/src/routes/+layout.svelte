<script>
	import Header from '$lib/header/Header.svelte';
	import '../app.postcss';

	import { init, login, chainId, wallet, changeNetwork} from "$lib/eth.js";

  import { onMount } from 'svelte';
  onMount(() => {
    init();
  })
</script>

<Header />

<main>
	<slot />
</main>

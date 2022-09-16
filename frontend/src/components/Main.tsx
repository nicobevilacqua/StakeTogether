import * as React from 'react';
import Container from '@mui/material/Container';
import Grid from '@mui/material/Grid';
import { Typography } from '@mui/material';
import Card from './Card';

export default function Main() {
  return (
    <div className='main'>
      <Container maxWidth="lg">
        <Grid container spacing={2}>
          <Grid margin={'0 auto'} item xs={6}>
            <Typography fontSize={'24px'} textAlign={'center'}>Stake Ether</Typography>
            <Typography fontSize={'12px'} textAlign={'center'} margin={'4px 0 16px 0'} color={'#ffffffcc'}>
              Stake ETH and receive stETH while staking.
            </Typography>
            <Card/>
          </Grid>
        </Grid>
      </Container>
    </div>
  );
}
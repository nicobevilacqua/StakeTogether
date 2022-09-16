import styled from '@emotion/styled';
import { Button, Grid, InputAdornment, TextField, Typography } from '@mui/material';
import * as React from 'react';

const CssTextField = styled(TextField)({
  '& label.Mui-focused': {
    color: 'white',
  },
  '& .MuiInput-underline:after': {
    borderBottomColor: 'white',
  },
  '& .MuiOutlinedInput-root': {
    '& fieldset': {
      borderColor: 'white',
    },
    '&:hover fieldset': {
      borderColor: 'white',
    },
    '&.Mui-focused fieldset': {
      borderColor: 'white',
    },
  },
});


export default function Card() {
  return (
    <div className='card'>
      <Grid container spacing={2}>
          <Grid item xs={6}>
            <Typography className='text-grey' fontSize={'12px'}>Available to stake</Typography>
            <Typography fontSize={'21px'} fontWeight={'bold'}>0.00 ETH</Typography>
          </Grid>
          <Grid item xs={6}>
            <Typography textAlign={'right'}>
              <span className='address-cumb'>0x33AD2...M34kA3</span>
            </Typography>
          </Grid>
      </Grid>
      <Grid marginTop={'24px'} container spacing={2}>
          <Grid item xs={6}>
            <Typography className='text-grey' fontSize={'12px'}>Staked amount</Typography>
            <Typography fontSize={'21px'} fontWeight={'bold'}>0.0 stETH</Typography>
          </Grid>
          <Grid item xs={6}>
            <Typography className='text-grey' fontSize={'12px'}>APR</Typography>
            <Typography className='text-success' fontSize={'21px'} fontWeight={'bold'}>10.4%</Typography>
          </Grid>
      </Grid>
      <Grid marginTop={'24px'} container spacing={2}>
        <Grid className='input-amount' item xs={12}>
          <CssTextField
            label="Amount"
            id="outlined-start-adornment"
            sx={{ m: 1, width: '98%' }}
            type='number'
            InputProps={{
              startAdornment: <InputAdornment className='text-white' position="start">ETH</InputAdornment>,
            }}
          />
        </Grid>
      </Grid>
      <Grid marginTop={'24px'} container spacing={2}>
          <Grid item xs={12}>
            <Button fullWidth={true} variant="contained">SUBMIT</Button>
          </Grid>
      </Grid>
    </div>
  );
}
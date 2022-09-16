import * as React from 'react';
import Container from '@mui/material/Container';
import Grid from '@mui/material/Grid';
import Button from '@mui/material/Button';
import { Typography } from '@mui/material';
import BoltIcon from '@mui/icons-material/Bolt';
import GradeIcon from '@mui/icons-material/Grade';
import LaptopIcon from '@mui/icons-material/Laptop';
import Address from './Address';

export default function Header() {
  return (
    <div className='header'>
      <Container maxWidth="lg">
        <Grid container spacing={2}>
          <Grid item xs={8}>
            <Typography display={'inline-block'} marginTop={'7px'} marginRight={'64px'}>LOGO</Typography>
            <Button variant="text">
              <BoltIcon className='icon-header'/>
              Stake
            </Button>
            <div className='button-container'>
              <Button variant="text">
                <GradeIcon className='icon-header'/>
                Withdraw
              </Button>
            </div>
            <div className='button-container'>
              <Button variant="text">
                <LaptopIcon className='icon-header'/>
                Dashboard
              </Button>
            </div>
          </Grid>
          <Grid item xs={4}>
            <Address/>
          </Grid>
        </Grid>
      </Container>
    </div>
  );
}
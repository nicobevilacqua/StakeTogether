import * as React from 'react';
import Container from '@mui/material/Container';
import Grid from '@mui/material/Grid';
import Button from '@mui/material/Button';
import { Typography } from '@mui/material';
import BoltIcon from '@mui/icons-material/Bolt';
import GradeIcon from '@mui/icons-material/Grade';
import Address from './Address';

export default function Header() {
  return (
    <div className='header'>
      <Container maxWidth="lg">
        <Grid container spacing={2}>
          <Grid item xs={2}>
            <Typography marginTop={'7px'}>LOGO</Typography>
          </Grid>
          <Grid item xs={1}>
            <Button variant="text">
              <BoltIcon className='icon-header'/>
              Stake
            </Button>
          </Grid>
          <Grid item xs={1}>
            <div className='button-reward'>
              <Button className='button-reward' variant="text">
                <GradeIcon className='icon-header'/>
                Rewards
              </Button>
            </div>
          </Grid>
          <Grid item xs={5}>
          </Grid>
          <Grid item xs={3}>
            <Address/>
          </Grid>
        </Grid>
      </Container>
    </div>
  );
}
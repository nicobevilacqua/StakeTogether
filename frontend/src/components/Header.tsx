import * as React from 'react';
import Container from '@mui/material/Container';
import Grid from '@mui/material/Grid';
import Button from '@mui/material/Button';
import { ConnectButton } from '@rainbow-me/rainbowkit';
import { Typography } from '@mui/material';
import BoltIcon from '@mui/icons-material/Bolt';
import GradeIcon from '@mui/icons-material/Grade';
import LaptopIcon from '@mui/icons-material/Laptop';
import { useNavigate } from 'react-router-dom';

export default function Header() {
  const navigate = useNavigate();
  return (
    <div className="header">
      <Container maxWidth="lg">
        <Grid container spacing={2}>
          <Grid item xs={8}>
            <Typography display={'inline-block'} marginTop={'7px'} marginRight={'64px'}>
              LOGO
            </Typography>
            <div className={`button-container ${window.location.hash === '#/' && 'active'}`}>
              <Button onClick={() => navigate('/')} variant="text">
                <BoltIcon className="icon-header" />
                Stake
              </Button>
            </div>
            <div
              className={`button-container ${window.location.hash === '#/withdraw' && 'active'}`}
            >
              <Button onClick={() => navigate('/withdraw')} variant="text">
                <GradeIcon className="icon-header" />
                Withdraw
              </Button>
            </div>
            <div
              className={`button-container ${window.location.hash === '#/dashboard' && 'active'}`}
            >
              <Button onClick={() => navigate('/dashboard')} variant="text">
                <LaptopIcon className="icon-header" />
                Dashboard
              </Button>
            </div>
          </Grid>
          <Grid item xs={4}>
            <ConnectButton />
          </Grid>
        </Grid>
      </Container>
    </div>
  );
}

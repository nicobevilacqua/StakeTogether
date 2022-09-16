import { Typography } from '@mui/material';
import * as React from 'react';

export default function Address() {
  return (
    <div className='address'>
      <Typography>
        0.00 ETH
        <span className='address-cumb'>0x33AD2...M34kA3</span>
      </Typography>
    </div>
  );
}